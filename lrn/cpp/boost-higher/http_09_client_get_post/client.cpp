#include <boost/log/trivial.hpp>
#include <optional>
using std::optional;

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

/**
 * @brief Get based on Boost
 */
http::response<http::string_body> bst_get(string host, string target, string port){
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

/**
 * @brief get for dummy
 * @param h Host, such as "localhost"
 * @param t Target, such as "/"
 * @param p Port, such as 8080
 * @return the body if everything went well.
 */
optional<string> get(string h, string t, int p){
  auto r = bst_get(h,t,std::to_string(p));
  if (r.result_int() != 200){
    BOOST_LOG_TRIVIAL(error) << format("❌️ Response got code %d (!=200)，Headers:\n")
      % r.result_int();
    for (auto it = r.cbegin(); it != r.cend(); it++ ){
      BOOST_LOG_TRIVIAL(debug) << format("\t [%s]\t: [%s]")
        % it->name_string() %it->value();
    }
    BOOST_LOG_TRIVIAL(error) << format("Body:\n[%s]")
      % r.body();
    return {};
  }
  return r.body();
}

/**
 * @brief Post based on Boost
 */
http::response<http::string_body> bst_post(string host, string target, string port, string body){
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

  // Set up an HTTP POST request message
  http::request<http::string_body> req{http::verb::post, target, 11 /*version*/};
  req.set(http::field::host, host);
  req.set(http::field::user_agent, BOOST_BEAST_VERSION_STRING);


  req.body() = body;            // add the body
  req.prepare_payload(); // set content-length based on the body
  // 🦜 : No need to prepare payload for GET


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

/**
 * @brief post for dummy
 * @param h Host, such as "localhost"
 * @param t Target, such as "/"
 * @param p Port, such as 8080
 * @param b body, such as "{\"a\":123}"
 * @return the body if everything went well.
 */
optional<string> post(string h, string t, int p, string b){
  auto r = bst_post(h,t,std::to_string(p),b);
  if (r.result_int() != 200){
    BOOST_LOG_TRIVIAL(error) << format("❌️ Response got code %d (!=200)，Headers:\n")
      % r.result_int();
    for (auto it = r.cbegin(); it != r.cend(); it++ ){
      BOOST_LOG_TRIVIAL(debug) << format("\t [%s]\t: [%s]")
        % it->name_string() %it->value();
    }
    BOOST_LOG_TRIVIAL(error) << format("Body:\n[%s]")
      % r.body();
    return {};
  }
  return r.body();
}
