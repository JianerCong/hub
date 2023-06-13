#include "weakHttpServer.hpp"
#include <memory>
using std::unique_ptr;

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


    {
      unique_ptr<WeakHttpServer> serv{new WeakHttpServer()};
        BOOST_LOG_TRIVIAL(debug) << format("Press any key to quit: ");
      std::cin.get();
    } // here the server is closed

  }
  catch (const std::exception& e){
    std::cerr << "Error: " << e.what() << std::endl;
    return EXIT_FAILURE;
  }
}




/*
  Example

  curl http://localhost:7777/aaa
  ⇒ "aaa too" 
  curl http://localhost:7777/bbb
  ⇒ "bbb too 127.0.0.1:35656" 
  curl http://localhost:7777/aaa -d "123"
  ⇒ "aaa from POST too" 
  curl http://localhost:7777/bbb -d "123"
  ⇒ "bbb too 127.0.0.1:45732, recieved data: 123" 

*/
