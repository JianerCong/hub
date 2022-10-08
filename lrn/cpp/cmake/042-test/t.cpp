#include <iostream>
using std::cout;
using std::endl;

int main(int argc, char *argv[]){
  if (argc < 2){
    cout << "Usage : " << argv[0] << " <number>" << endl;
    return 1;
  }
  const double x = std::stod(argv[1]);
  cout << "So twice is " << x * 2 << endl;
  return 0;
  }
