#include <fstream>
#include <filesystem>
using std::ofstream;
namespace filesystem = std::filesystem;

int main (){
  filesystem::path p{filesystem::current_path() / "hi.log"};
  if (filesystem::exists(p)) filesystem::remove(p);

  // write "abc" to hi.txt
  (ofstream(p) << "abc").flush();
}
