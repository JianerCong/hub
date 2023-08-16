#include <boost/format.hpp>
#include <boost/log/trivial.hpp>
using boost::format;

#include <boost/array.hpp>
#include <boost/asio.hpp>
using boost::asio::io_service;
using boost::asio::ip::tcp;
using boost::system::error_code;
using boost::asio::buffer;

#include <string>
using std::string;
#include <string_view>
using std::string_view;


namespace asio = boost::asio;            // from <boost/asio.hpp>
using boost::asio::ip::udp;
#include <atomic>

/**
 * @brief A naive Udp server.
 *
 * 🐢 : This Udp server doesn't send any response. It's expected to dispatch handlers
 * for the incoming datagram. The datagram is expected to have the following form:
 *
 *     <target>:<data>
 *
 * where <target> should be something like "/aaa" and <data> is passed to the
 * handler.
 *
 * If the target is not listened, then nothing will happen. (🐢 : Okay, probably
 * log the complain a little, but won't do anything useful.)
 */
#include <memory>
using std::unique_ptr;
using std::make_unique;

class WeakUdpServer{
public:
  boost::asio::io_context ioc;
  std::atomic_flag closed = ATOMIC_FLAG_INIT; // false
  unique_ptr<udp::socket> socket;
  WeakUdpServer(uint16_t port=7777){
    this->socket = make_unique<udp::socket>(this->ioc, udp::endpoint(udp::v4(), 7777));
    std::thread{std::bind(&WeakUdpServer::do_session, this)}.detach();
  }

  /*

    🦜 : It looks like there are something magical that wreak havoc when passing
    around socket. So unique_ptr<> should just help
   */

  void do_session(){
    BOOST_LOG_TRIVIAL(debug) << format("🐸 Server started");
    while (not this->closed.test()){
      /*
        🦜 : How do we know the request_size?
      */
      while (not this->closed.test() and this->socket->available() == 0){} // blk until we get some

      if (this->socket->available() == 0)
        break; // server closed

      std::size_t bytes_readable = this->socket->available();

      BOOST_LOG_TRIVIAL(debug) << format("Got %d byte") % bytes_readable;
      std::vector<char> data(bytes_readable); // allocate the data

      udp::endpoint remote_endpoint;
      boost::system::error_code ignored_error;
      this->socket->receive_from(boost::asio::buffer(data), remote_endpoint,0,ignored_error);
      BOOST_LOG_TRIVIAL(debug) << format("Recieved >>%s<< from %s:%d") %
        string_view(data.data(),data.size()) % remote_endpoint.address().to_string()
        % remote_endpoint.port(); // see the data
    }
    BOOST_LOG_TRIVIAL(debug) << format("\t server thread ended.");
  }

  ~WeakUdpServer(){
    this->closed.test_and_set();
    BOOST_LOG_TRIVIAL(debug) << format("👋 Udp Server Closed");
  }
};
