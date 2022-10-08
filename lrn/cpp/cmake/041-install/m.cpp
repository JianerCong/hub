#include <iostream>
#include <string>
#include <cmath>

#include "mConfig.h"
using std::cout;
using std::endl;


#ifdef USE_MYLIB
# include "mylib.h"
#endif



int main(int argc, char *argv[]){
  if (argc <2){
    cout << argv[0] << " Version " << hi_VERSION_MAJOR << "."
         << hi_VERSION_MINOR << endl;
    cout << "Usage: " << argv[0] << " 1" << endl;
    return 1;
  }

#ifdef USE_MYLIB
  int x = get_one();
#else
  int x = 2;
#endif

  cout << "2 - 1 is " << x << endl;
  return 0;
}
