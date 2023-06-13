#include "weakHttpServer.hpp"
#include <memory>
using std::unique_ptr;

int main(int argc, char* argv[]){
  try{

    // // 🦜 Now we only use tcp::v4(), ignoring user specifed address
    // // asio::ip::address const address = asio::ip::make_address(argv[1]);
    // auto const port = static_cast<unsigned short>(std::atoi(argv[2]));
    // {

    //   // --------------------------------------------------
    //   // The handlers

    //   // <! the function dispatch map, each entry accepts (string address, uint16_t
    //   // port, string body). the key is the target such as "\hi", "\"
    //   unordered_map<string,
    //                 function<tuple<bool,string>
    //                          (string, uint16_t, string)
    //                          >
    //                 > postLisnMap{
    //     {"/aaa", [](string ,uint16_t,string){return make_tuple(true,"\"aaa from POST too\"");}},
    //       {"/bbb", [](string a,uint16_t p, string d){return make_tuple(true,
    //     (format("\"bbb too %s:%d, recieved data: %s\"") % a % p % d).str()
    //     );}}
    // };

    //   unordered_map<string,
    //                 function<tuple<bool,string>
    //                          (string, uint16_t)
    //                          >
    //                 > getLisnMap{
    //   {"/aaa", [](string,uint16_t){return make_tuple(true,"\"aaa too\"");}},
    //     {"/bbb", [](string a,uint16_t p){return make_tuple(true,
    //     (format("\"bbb too %s:%d\"") % a % p).str()
    //     );}}
    // };


    WeakHttpServer serv{};
    BOOST_LOG_TRIVIAL(debug) << format("Press any key to quit: ");
    std::cin.get();
  } // here the server is closed

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
