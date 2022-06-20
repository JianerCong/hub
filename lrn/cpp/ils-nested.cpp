/**
 * @file ils-nested.cpp
 * @author Jianer Cong
 * @brief Try nested initializer list.
 */


#include <iostream>
#include <vector>

using std::vector;
using std::cout;
using std::endl;


typedef vector<vector<int>> vv;


int main(int argc, char *argv[]){
  vv v = {{1,2},{3,4}};
  for (auto x : v){
    for (auto a : x)
      cout << a << " ";
    cout << endl;
  }
  cout << endl;
  return 0;
  }
