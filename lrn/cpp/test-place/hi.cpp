#include <iostream>
#include <string>
#include <vector>

using std::vector;
using std::cout;
using std::endl;
using std::string;

int main(){
  string s{"hi"};
  vector<string> fields{"h1","h2","h3"};
  for (auto s1 : fields){
    cout << s1 << endl;
  }
  cout << s << endl;
}
