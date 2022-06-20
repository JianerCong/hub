#include "my_cmake_lib.h"
#include <cstdio>
int main(int argc, char *argv[]){
  printf("I will call the f1() in my_cmake_lib:\n\t");
  my_cmake_lib::f1();
  printf("Yep\n");
  return 0;
  }
