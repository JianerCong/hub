#include "mylib2.h"
using namespace mylib2::my_test;
using mylib2::Rule;

test::test(bool v){
  examer = new tester(v);
}

test::~test(){
  delete examer;
}

void test::add(to_be_test f, string n = "TEST"){
  fs.push_back(row(f,n));
}

void test::show_tests(){
  Rule("Test(s) to be run:");
  for (row &r : fs){
    printf("\t %s\n", r.name.c_str());
  }
}

void test::run(){
  Rule("Running tests:");
  for (row &r : fs){
    test_that(r);
  }
}

void test::test_that(row &r){
  string msg = "OK";
  printf("\tTesting %s:\n",r.name.c_str());
  try {
    r.func(*examer);
  }catch (my_error e){
    msg = e.what();
  }catch (std::domain_error e2){
    msg = string("Unhandled domain error: ") + e2.what();
  }catch (std::exception e1){
    msg = string("Unhandled Exception: ") + e1.what();
  }
  r.msg = msg;
}

void test::show_results(){
  Rule("Test results:");
  for (row &r : fs){
    string msg = (r.msg == "OK" ? S_GREEN : S_RED)+
      r.msg + S_NOR;
    printf("%20s : %s\n",r.name.c_str(), msg.c_str());
  }
}

void f1(tester &tr){
  tr.log("I am f1");
}

void f2(tester &tr){
  tr.log("I am bad f2");
  tr.fatal("f2 throws error");
}

void test::Test(){
  bool verbose = true;
  test t(verbose);
  t.add([](tester &tr){tr.log("I am λ");});
  t.add(f1,"f1");
  t.add(f2,"f2");
  t.show_tests();
  t.run();
  t.show_results();
}
