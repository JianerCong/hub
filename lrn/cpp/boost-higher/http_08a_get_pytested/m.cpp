#include <boost/log/trivial.hpp>

#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio/connect.hpp>
#include <boost/asio/ip/tcp.hpp>
#include <cstdlib>
#include <iostream>
#include <string>
#include <boost/format.hpp>
using boost::format;


using std::string;

namespace beast = boost::beast;     // from <boost/beast.hpp>
namespace http = beast::http;       // from <boost/beast/http.hpp>


http::response<http::string_body> get(string host, string target, string port){
  namespace net = boost::asio;        // from <boost/asio.hpp>
  using tcp = net::ip::tcp;           // from <boost/asio/ip/tcp.hpp>

  // The io_context is required for all I/O
  net::io_context ioc;
  // These objects perform our I/O
  tcp::resolver resolver(ioc);
  beast::tcp_stream stream(ioc);
  // Look up the domain name
  auto const results = resolver.resolve(host, port);
  // Make the connection on the IP address we get from a lookup
  stream.connect(results);

  // Set up an HTTP GET request message
  http::request<http::string_body> req{http::verb::get, target, 11 /*version*/};
  req.set(http::field::host, host);
  req.set(http::field::user_agent, BOOST_BEAST_VERSION_STRING);

  // Send the HTTP request to the remote host
  http::write(stream, req);

  // This buffer is used for reading and must be persisted
  beast::flat_buffer buffer;

  // Declare a container to hold the response
  http::response<http::string_body> res;

  // Receive the HTTP response
  http::read(stream, buffer, res);

  // Gracefully close the socket
  beast::error_code ec;
  stream.socket().shutdown(tcp::socket::shutdown_both, ec);
  // not_connected happens sometimes
  // so don't bother reporting it.
  //
  if(ec && ec != beast::errc::not_connected)
    throw beast::system_error{ec};

  BOOST_LOG_TRIVIAL(info) << format("❄ Connection closed gracefully.");
  return res;
}

int main(){
  try{
    auto r = get("localhost","/","8080");
    string s = r.body();
    BOOST_LOG_TRIVIAL(info) << format("Got: %s") % s;

    r = get("localhost","/json","8080");
    s = r.body();
    BOOST_LOG_TRIVIAL(info) << format("Got: %s") % s;

  }catch(std::exception const& e){
    std::cerr << "Error: " << e.what() << std::endl;
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
