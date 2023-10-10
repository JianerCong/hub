#include <boost/format.hpp>
#include <boost/log/trivial.hpp>
using boost::format;
#include <iostream>

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

int main(int argc, char* argv[])
{
  try
    {
      boost::asio::io_context ioc;
      udp::socket socket(ioc, udp::endpoint(udp::v4(), 7777));


      std::atomic_flag closed = ATOMIC_FLAG_INIT; // false

      auto f = [&closed, &socket](){
        BOOST_LOG_TRIVIAL(debug) << format("🐸 Server started");
        while (not closed.test()){
          /*
            🦜 : How do we know the request_size?
          */
          while (not closed.test() and socket.available() == 0){} // blk until we get some

          if (socket.available() == 0)
            break; // server closed

          std::size_t bytes_readable = socket.available();

          BOOST_LOG_TRIVIAL(debug) << format("Got %d byte") % bytes_readable;
          std::vector<char> data(bytes_readable); // allocate the data

          udp::endpoint remote_endpoint;
          boost::system::error_code ignored_error;
          socket.receive_from(boost::asio::buffer(data), remote_endpoint,0,ignored_error);
          BOOST_LOG_TRIVIAL(debug) << format("Recieved >>%s<< from %s:%d") %
            string_view(data.data(),data.size()) % remote_endpoint.address().to_string()
            % remote_endpoint.port(); // see the data
        }
        BOOST_LOG_TRIVIAL(debug) << format("\t server thread ended.");
      };

      // Start the server thread thread
      std::thread{f}.detach();

      std::cin.get();

      closed.test_and_set();
    }
  catch (std::exception& e)
    {
      BOOST_LOG_TRIVIAL(error) << e.what();
    }

  BOOST_LOG_TRIVIAL(debug) << format("👋 Server closed");

  return 0;
}
