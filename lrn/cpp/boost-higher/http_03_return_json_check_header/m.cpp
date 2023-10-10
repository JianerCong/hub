#include <boost/asio.hpp>
using boost::asio::io_service;
using boost::asio::ip::tcp;
using boost::system::error_code;
using boost::asio::buffer;
#include <boost/format.hpp>
#include <boost/log/trivial.hpp>
using boost::format;

#include <string>
using std::string;
#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio/ip/tcp.hpp>
#include <boost/config.hpp>
#include <cstdlib>
#include <iostream>
#include <memory>
#include <string>
#include <thread>
#include <cstdio>

namespace beast = boost::beast;         // from <boost/beast.hpp>
namespace http = beast::http;           // from <boost/beast/http.hpp>
namespace asio = boost::asio;            // from <boost/asio.hpp>
using tcp = boost::asio::ip::tcp;       // from <boost/asio/ip/tcp.hpp>
using std::cout;

using http::request;
using http::response;


boost::asio::io_service ioc;
// Handles an HTTP server connection
void do_session(tcp::socket& socket);
int main(int argc, char* argv[]){
  try{
    // Check command line arguments.
    if (argc != 3)
      {
        std::cerr <<
          "Usage: weak-server <address> <port>\n" <<
          "Example:\n" <<
          "    weak-server 0.0.0.0 8080 .\n";
        return EXIT_FAILURE;}

    // 🦜 Now we only use tcp::v4(), ignoring user specifed address
    // asio::ip::address const address = asio::ip::make_address(argv[1]);
    auto const port = static_cast<unsigned short>(std::atoi(argv[2]));


    // The acceptor receives incoming connections
    tcp::acceptor acceptor{ioc};

    boost::asio::ip::tcp::endpoint endpoint(boost::asio::ip::tcp::v4(), port);
    acceptor.open(endpoint.protocol());

    acceptor.bind(endpoint);    // this throws exception if failed to bind port

    acceptor.listen();
    BOOST_LOG_TRIVIAL(debug) << format("🐸 acceptor start listening on port %d")
       % port;

    // The service run in one thread
    BOOST_LOG_TRIVIAL(debug) << format("Starting service thread");
    std::thread{[](){ioc.run();}}.detach();
    // Start the dispatcher in another thread

    std::thread{[&](){
      for(;;){
        BOOST_LOG_TRIVIAL(debug) << format("❄ Waiting for request");
        // This will receive the new connection
        tcp::socket socket{ioc};


        // Block until we get a connection
        acceptor.accept(socket);
        // Launch the session, transferring ownership of the socket
        std::thread{std::bind(&do_session, std::move(socket))}.detach();
      }
    }}.detach();

    BOOST_LOG_TRIVIAL(debug) << format("Press any key to quit: ");
    std::cin.get();
    BOOST_LOG_TRIVIAL(debug) << format("Server stoped");
    ioc.stop();
    // for(;;){
    //   BOOST_LOG_TRIVIAL(debug) << format("❄ Waiting for request");
    //   // This will receive the new connection
    //   tcp::socket socket{ioc};
    //   // Block until we get a connection
    //   acceptor.accept(socket);
    //   // Launch the session, transferring ownership of the socket
    //   std::thread{std::bind(&do_session, std::move(socket))}.detach();
    // }

  }
  catch (const std::exception& e){
    std::cerr << "Error: " << e.what() << std::endl;
    return EXIT_FAILURE;
  }
}


response<http::string_body>
handle_request(request<http::string_body>&& req);
void fail(beast::error_code ec, char const* what);
void do_session(tcp::socket& socket){


  // log the endpoint info
  boost::asio::ip::tcp::endpoint e1 = socket.remote_endpoint();
  boost::asio::ip::address a = e1.address();
  uint16_t p = e1.port();
  string s = a.to_string();

  BOOST_LOG_TRIVIAL(debug) << format("Got connection from %s:%d")
    % s % p;

  // --------------------------------------------------
  // the mode
  beast::error_code ec;
  // This buffer is required to persist across reads
  beast::flat_buffer buffer;

  // Keep reading request and handle the request until END OF STREAM or result
  // in not keep_alive
  for(;;){
    // Read a request
    request<http::string_body> req; // the request container
    http::read(socket, buffer, req, ec);
    if(ec == http::error::end_of_stream) break;
    if(ec) return fail(ec, "read");

    // Handle request
    response<http::string_body> res =
      handle_request(std::move(req));

    // Determine if we should close the connection
    bool keep_alive = res.keep_alive();

    // Send the response
    beast::http::write(socket, std::move(res), ec);
    if(ec) return fail(ec, "write");


    if(not keep_alive){
      printf("We should not keep alive\n");
      // This means we should close the connection, usually because
      // the response indicated the "Connection: close" semantic.
      break;
    }
  }
  // Send a TCP shutdown
  socket.shutdown(tcp::socket::shutdown_send, ec);
  // At this point the connection is closed gracefully
}
// Report a failure
void fail(beast::error_code ec, char const* what){
  std::cerr << what << ": " << ec.message() << "\n";
}


/**
 * @brief Here we actually dispatch the appropriate functions and handle the
 * request. We have entered the boost.beast world from the boost.asio world.
 */
response<http::string_body>
handle_request(request<http::string_body>&& req){
  // Returns a bad request response
  auto const bad_request =
    [&req](beast::string_view why){
      response<http::string_body> res{http::status::bad_request, req.version()};
      res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
      res.set(http::field::content_type, "text/html");
      res.keep_alive(req.keep_alive());
      res.body() = std::string(why);
      res.prepare_payload();
      return res;
    };

  // Returns a server error response
  // auto const server_error =
  // [&req](beast::string_view what){
  //     response<http::string_body> res{http::status::internal_server_error, req.version()};
  //     res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
  //     res.set(http::field::content_type, "text/html");
  //     res.keep_alive(req.keep_alive());
  //     res.body() = "An error occurred: '" + std::string(what) + "'";
  //     res.prepare_payload() res;
  // };

  // Make sure we can handle the method
  if( req.method() != http::verb::get &&
      req.method() != http::verb::post)
    return bad_request("Unknown HTTP-method");

  BOOST_LOG_TRIVIAL(debug) << format("Start handling");

  BOOST_LOG_TRIVIAL(debug) << format("Handling request\n\tmethod: %s\n\ttarget: %s\n\tcontent type: %s")
    % req.method_string() % req.target() % req[http::field::content_type];

  if (req.payload_size()){
    BOOST_LOG_TRIVIAL(debug) << format("payload_size:%d\n\tdata:%s")
      % req.payload_size().value() % req.body();
    // body should be string for http::string_body
  }


  // Respond to GET request
  // response<http::string_body> res{
  //   std::piecewise_construct,
  //   std::make_tuple(std::move(body)),
  //   std::make_tuple(http::status::ok, req.version())};
  response<http::string_body> res;
  res.body() =  "{\"x\" : \"aaa from server\"}";

  res.version(11);   // HTTP/1.1
  res.set(http::field::server, "Beast");
  res.result(http::status::ok);
  res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
  res.set(http::field::content_type, "application/json");
  res.keep_alive(req.keep_alive());

  res.prepare_payload();
  return res;
}

