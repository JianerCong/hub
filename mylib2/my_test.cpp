#include "mylib2.h"
using namespace mylib2;
using namespace mylib2::my_test;

int main(int argc, char *argv[]){
  // tester::Test();
  // test::Test();

  bool verbose = true;
  test t(verbose);
  t.add(math::test_SolveQuadratic,"test_SolveQuadratic");
  t.show_tests();
  t.run();
  t.show_results();

  return 0;
  }
