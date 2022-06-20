#include "mylib2.h"
using namespace mylib2::my_test;
using namespace mylib2;

void tester::rule(string msg = ""){
  log("\n" + msg + " " +
      string(50 - msg.length(),'-'));
};

void tester::log(string msg){
  if (verbose){
    puts((prefix + msg).c_str());
  }
};

tester::~tester(){
  printf("tester is gone 🐸\n");
}

void tester::fatal(string msg){
  throw my_error(msg);
}

string tester::get_comment_header(string msg){
  return "For [" + msg + "]: ";
}

void tester::expect_near(double x, double y,
                         string comment=""){
  string msg = get_comment_header(comment)
    + mylib2::Sprintf("Should be %g, it is %g.", x, y);
  log(msg);
  double r = abs((x - y)/x);
  if (r > 0.01){
    fatal(S_RED + msg + mylib2::Sprintf(":  abs(x-y)/x = %g > 1%",r) + S_NOR);
  }
}

template<typename T>
void tester::expect_error(std::function<void(void)> f,
                  string comment){
  bool caught = false;
  string msg = Sprintf("For [%s]: expect error [%s] ",
                       comment.c_str(),
                       typeid(T).name());
  try {
    printf("Trying to call the function:\n");
    f();
  }catch(T e){
    caught = true;
    cout << msg + ": OK caught 🐸" << endl;
  }

  if (!caught)
    fatal(msg + "Failed to get any exception.");
}

void tester::Test(){
  {

    // printf("Testing tester");
    tester t(true);
    // printf("print a rule please:\n");
    // t.rule();
    // printf("say lala lalala\n");
    // t.log("lala lalala");

    try {
      // t.expect_near(1, 1, "test_t");
      // t.expect_near((10/3) * 3, 10, "test: 10 / 3 * 3 == 10?");
      // t.expect_near(1.1, 2.2, "near_test1");
      mylib2::Rule("Test expect_error");
      t.expect_error<int>([](void){printf("I am a λ that throw 2\n");throw (int) 2;},
                          "the should-pass expect_error test");
      t.expect_error<int>([](void){printf("I am a λ that dosn't throw stuff\n");return 2;},
                          "the no-pass expect_error test");

    } catch (my_error e){
      printf("Error caught: %s\n", e.what());
    }
  }
  printf("Test finished\n");
}

// Compile these template definitions
template void tester::expect_error<domain_error> (std::function<void(void)> f,
                                    string comment);
