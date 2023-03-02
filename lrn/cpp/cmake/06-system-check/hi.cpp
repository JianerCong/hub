#include <iostream>

int main(int argc, char *argv[]){

#if defined(HAVE_EXP)
  std::cout << " exp is defined" << std::endl;
#else
  std::cout << " exp is not defined" << std::endl;
#endif

  return 0;
}
