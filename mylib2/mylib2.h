#pragma once
/**
 * @file mylib2.h
 * @author Jianer Cong
 * @brief Some c++ utility functions and definitions
 */

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <list>
#include <stdarg.h>
#include <stdexcept>
#include <string>
#include <tuple>
#include <functional>           // for std::function
#include <ctime>

#define S_RED     "\x1b[31m"
#define S_GREEN   "\x1b[32m"
#define S_YELLOW  "\x1b[33m"
#define S_BLUE    "\x1b[34m"
#define S_MAGENTA "\x1b[35m"
#define S_CYAN    "\x1b[36m"
#define S_NOR "\x1b[0m"

namespace mylib2{
  using std::cout;
  using std::endl;
  using std::list;
  using std::runtime_error;
  using std::string;
  using std::domain_error;
  using std::tuple;

  string Sprintf(const char* fmt,...);
  void Rule(string title = "--", int sublevel = 0, int len = 50);
  string Strftime(string fmt="[%B-%d-%Y %T]");

  namespace my_test{
    // tester is internal. As a user, use the my_test::test class
    class tester {
    public:
      tester(bool v):verbose(v){};
      virtual ~tester();
      void rule(string msg);
      void log(string msg);
      void fatal(string msg);
      void expect_near(double x, double y, string comment);
      template<typename T>
      void expect_error(std::function<void(void)> f,string comment);
      static void Test();
    private:
      const string prefix = "\t";
      bool verbose;
      string get_comment_header(string msg);
    };

    typedef void (*to_be_test) (tester &t);
    class my_error : runtime_error{
    public:
      // Inherit base class constructor
      using runtime_error::runtime_error;
      using runtime_error::what;
    };
    class test {
      struct row{
        to_be_test func;
        string name;
        string msg;
        row(to_be_test f, string n){func = f; name = n;};
      };
      list<row> fs;
      tester *examer;
      void test_that(row &r);
    public:
      test(bool verbose);
      virtual ~test();
      void add(to_be_test f, string n);
      void run();
      void show_tests();
      void show_results();
      static void Test();
    };
  }

  namespace math{
    tuple<double,double> SolveQuadratic(double a,
                                        double b,
                                        double c); // throw std::domain_error
    void test_SolveQuadratic(my_test::tester &tr);
  }

}

using std::array;
using std::ostream;
template<typename T>
ostream& operator<<(ostream& os, const array<T,2>& a){
  for (auto i : a){
    os << i << "\t";
  }
  return os;
};
