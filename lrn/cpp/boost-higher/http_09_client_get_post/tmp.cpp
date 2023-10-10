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
