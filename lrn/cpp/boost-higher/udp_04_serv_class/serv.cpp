#include <iostream>
#include "weakUdpServer.hpp"

int main(int argc, char* argv[]){
  try{
      {
        WeakUdpServer serv;
        std::cin.get();
      }
    }
  catch (std::exception& e){
      BOOST_LOG_TRIVIAL(error) << e.what();
  }
}
