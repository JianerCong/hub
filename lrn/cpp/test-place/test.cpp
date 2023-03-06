#include <iostream>
#include <format>
// #include <fmt/format.h>

using std::cout;
using std::string;
// using fmt::format;

int main(){
  string s{"aaa"};
  int g{123};

  cout << format("aaa={},123={}\n",s,g);
}
