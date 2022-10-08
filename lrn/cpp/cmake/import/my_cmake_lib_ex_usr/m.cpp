#include "f2.h"
#include "my_cmake_lib.h"

#include <cstdio>
int main(int argc, char *argv[]){
  printf("I will call the f2() in my_cmake_lib:\n\t");
  my_cmake_lib::f2();
  printf("Yep\n");
  printf("I will also call the f1() in my_cmake_lib:\n\t");
  my_cmake_lib::f1();
  printf("Yep\n");
  return 0;
  }
