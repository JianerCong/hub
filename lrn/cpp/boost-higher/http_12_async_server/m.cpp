//
// Copyright (c) 2016-2019 Vinnie Falco (vinnie dot falco at gmail dot com)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//
// Official repository: https://github.com/boostorg/beast
//

//------------------------------------------------------------------------------
//
// Example: HTTP server, asynchronous
//
//------------------------------------------------------------------------------

#include <boost/log/trivial.hpp>

#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio/dispatch.hpp>
#include <boost/asio/strand.hpp>
#include <boost/config.hpp>
#include <algorithm>
#include <cstdlib>
#include <functional>
#include <iostream>
#include <memory>
#include <string>
#include <thread>
#include <vector>

namespace beast = boost::beast;         // from <boost/beast.hpp>
namespace http = beast::http;           // from <boost/beast/http.hpp>
namespace net = boost::asio;            // from <boost/asio.hpp>
using tcp = boost::asio::ip::tcp;       // from <boost/asio/ip/tcp.hpp>

// Return a response for the given request.
//
// The concrete type of the response message (which depends on the
// request), is type-erased in message_generator.
template <class Body, class Allocator>
http::message_generator
handle_request(
               http::request<Body, http::basic_fields<Allocator>>&& req){

  // Returns a bad request response --------------------------------------------------

  auto const bad_request =
    [&req](beast::string_view why)
    {
      http::response<http::string_body> res{http::status::bad_request, req.version()};
      res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
      res.set(http::field::content_type, "text/html");
      res.keep_alive(req.keep_alive());
      res.body() = std::string(why);
      res.prepare_payload();
      return res;
    };

  // Returns a not found response --------------------------------------------------
  // auto const not_found =
  // [&req](beast::string_view target)
  // {
  //     http::response<http::string_body> res{http::status::not_found, req.version()};
  //     res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
  //     res.set(http::field::content_type, "text/html");
  //     res.keep_alive(req.keep_alive());
  //     res.body() = "The resource '" + std::string(target) + "' was not found.";
  //     res.prepare_payload();
  //     return res;
  // };

  // Returns a server error response --------------------------------------------------
  // auto const server_error =
  // [&req](beast::string_view what)
  // {
  //     http::response<http::string_body> res{http::status::internal_server_error, req.version()};
  //     res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
  //     res.set(http::field::content_type, "text/html");
  //     res.keep_alive(req.keep_alive());
  //     res.body() = "An error occurred: '" + std::string(what) + "'";
  //     res.prepare_payload();
  //     return res;
  // };

  // Make sure we can handle the method
  if( req.method() != http::verb::get && req.method() != http::verb::post)
    return bad_request("Unknown HTTP-method");


  std::string t = req.target();
  BOOST_LOG_TRIVIAL(debug) <<  "Got request, target = " << t;

  // make Response --------------------------------------------------
  boost::beast::http::response<http::string_body> res;

  res.body() = "result for " + t;
  res.version(11);   // HTTP/1.1
  res.set(http::field::server, "Beast");
  res.result(http::status::ok);
  res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
  res.set(http::field::content_type, "application/json");
  res.keep_alive(req.keep_alive());

  res.prepare_payload();
  return res;
}

//------------------------------------------------------------------------------

// Report a failure
void fail(beast::error_code ec, char const* what)
{
  std::cerr << what << ": " << ec.message() << "\n";
}

// Handles an HTTP server connection
class session : public std::enable_shared_from_this<session>
{
  beast::tcp_stream stream_;
  beast::flat_buffer buffer_;
  http::request<http::string_body> req_;

public:
  // Take ownership of the stream
  session(tcp::socket&& socket)
    : stream_(std::move(socket)){
    BOOST_LOG_TRIVIAL(debug) <<  "Session started";
}

  // Start the asynchronous operation
  void run(){
    // We need to be executing within a strand to perform async operations
    // on the I/O objects in this session. Although not strictly necessary
    // for single-threaded contexts, this example code is written to be
    // thread-safe by default.
    net::dispatch(stream_.get_executor(),
                  beast::bind_front_handler(
                                            &session::do_read,
                                            shared_from_this()));
  }

  void do_read(){
    // Make the request empty before reading,
    // otherwise the operation behavior is undefined.
    req_ = {};

    // Set the timeout.
    stream_.expires_after(std::chrono::seconds(30));

    // Read a request
    http::async_read(stream_, buffer_, req_,
                     beast::bind_front_handler(
                                               &session::on_read,
                                               shared_from_this()));
  }

  void on_read(beast::error_code ec, std::size_t bytes_transferred){
    boost::ignore_unused(bytes_transferred);

    // This means they closed the connection
    if(ec == http::error::end_of_stream)
      return do_close();

    if(ec)
      return fail(ec, "read");

    // Send the response
    send_response(handle_request(std::move(req_)));
  }

  void send_response(http::message_generator&& msg){
    bool keep_alive = msg.keep_alive();

    // Write the response
    beast::async_write(
                       stream_,
                       std::move(msg),
                       beast::bind_front_handler(&session::on_write, shared_from_this(), keep_alive));
  }

  void on_write(
                bool keep_alive,
                beast::error_code ec,
                std::size_t bytes_transferred) {
    boost::ignore_unused(bytes_transferred);

    if(ec)
      return fail(ec, "write");

    if(! keep_alive){
      // This means we should close the connection, usually because
      // the response indicated the "Connection: close" semantic.
      return do_close();
    }

    // Read another request
    do_read();
  }

  void do_close() {
    // Send a TCP shutdown
    beast::error_code ec;
    stream_.socket().shutdown(tcp::socket::shutdown_send, ec);

    // At this point the connection is closed gracefully
  }
};

//------------------------------------------------------------------------------

// Accepts incoming connections and launches the sessions
class listener : public std::enable_shared_from_this<listener>
{
  net::io_context& ioc_;
  tcp::acceptor acceptor_;
public:
  listener(net::io_context& ioc, tcp::endpoint endpoint) : ioc_(ioc)
    , acceptor_(net::make_strand(ioc)){
    BOOST_LOG_TRIVIAL(debug) <<  "listener started";
    beast::error_code ec;

    // Open the acceptor
    acceptor_.open(endpoint.protocol(), ec);
    if(ec){
      fail(ec, "open");
      return;
    }

    // Allow address reuse
    acceptor_.set_option(net::socket_base::reuse_address(true), ec);
    if(ec){
      fail(ec, "set_option");
      return;
    }

    // Bind to the server address
    acceptor_.bind(endpoint, ec);
    if(ec){
      fail(ec, "bind");
      return;
    }

    // Start listening for connections
    acceptor_.listen(net::socket_base::max_listen_connections, ec);
    if(ec){
      fail(ec, "listen");
      return;
    }
  }

  // Start accepting incoming connections
  void
  run(){do_accept();}
private:
  void
  do_accept(){
    // The new connection gets its own strand
    acceptor_.async_accept(net::make_strand(ioc_),
                           beast::bind_front_handler(&listener::on_accept, shared_from_this())
                           );
  }

  void on_accept(beast::error_code ec, tcp::socket socket) {
    if(ec){
      fail(ec, "accept");
      return; // To avoid infinite loop
    }else{
      // Create the session and run it
      std::make_shared<session>(std::move(socket))->run();
    }

    // Accept another connection
    do_accept();
  }
};

//------------------------------------------------------------------------------

int main(int argc, char* argv[])
{
  // Check command line arguments.

  // if (argc != 5)
  // {
  //     std::cerr <<
  //         "Usage: http-server-async <address> <port> <doc_root> <threads>\n" <<
  //         "Example:\n" <<
  //         "    http-server-async 0.0.0.0 8080 . 1\n";
  //     return EXIT_FAILURE;
  // }
  // auto const address = net::ip::make_address(argv[1]);
  // auto const port = static_cast<unsigned short>(std::atoi(argv[2]));
  // auto const doc_root = std::make_shared<std::string>(argv[3]);
  // auto const threads = std::max<int>(1, std::atoi(argv[4]));

  auto const address = net::ip::make_address("0.0.0.0");
  unsigned short port = 7777;
  auto const threads = 1;

  // The io_context is required for all I/O
  net::io_context ioc{threads};

  // Create and launch a listening port
  std::make_shared<listener>(ioc, tcp::endpoint{address, port})->run();

  // Run the I/O service on the requested number of threads
  std::vector<std::thread> v;
  v.reserve(threads - 1);
  for(auto i = threads - 1; i > 0; --i)
    v.emplace_back([&ioc] {ioc.run();});
  ioc.run();

  return EXIT_SUCCESS;
}
