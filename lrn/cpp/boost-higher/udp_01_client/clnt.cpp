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

namespace asio = boost::asio;            // from <boost/asio.hpp>
using boost::asio::ip::udp;

int main(int argc, char* argv[])
{
  try
    {
      boost::asio::io_context io_context;

      udp::resolver resolver(io_context);
      udp::endpoint receiver_endpoint =
        *resolver.resolve(udp::v4(), "localhost", "7777").begin();

      udp::socket socket(io_context);
      socket.open(udp::v4());

      string msg = "aaa";
      boost::system::error_code ignored_error;
      socket.send_to(boost::asio::buffer(msg), receiver_endpoint, 0 /*msg flag*/ ,
                     ignored_error); // send a request

      // boost::array<char, 128> recv_buf;
      // udp::endpoint sender_endpoint;
      // size_t len = socket.receive_from(boost::asio::buffer(recv_buf), sender_endpoint);

      // std::cout.write(recv_buf.data(), len);
    }
  catch (std::exception& e)
    {
      BOOST_LOG_TRIVIAL(error) << e.what();
    }

  return 0;
}
