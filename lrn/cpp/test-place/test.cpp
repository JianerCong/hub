#include <iostream>
#include <boost/array.hpp>
using std::cout;

int main ()
{
  boost::array<int,4> a = {{10, 20, 30, 30}};
  cout << "a[0]=" << a[0];

  return 0;
}
// Output:
// a[0]=10
