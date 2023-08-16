#include <iostream>
#include "weakUdpServer.hpp"

#define ARGV_SHIFT()  { i_argc--; i_argv++; }
#include <boost/lexical_cast.hpp>
using boost::lexical_cast;
int main(int i_argc, const char* i_argv[]){

  ARGV_SHIFT(); // Skip executable name

  uint16_t port = 7777;
  if (i_argc > 0){
    port = lexical_cast<uint16_t>(i_argv[0]);
  }

  try{
      {
        WeakUdpServer serv{port};
        std::cin.get();
      }
    }
  catch (std::exception& e){
      BOOST_LOG_TRIVIAL(error) << e.what();
  }
}
