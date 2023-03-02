// CPP program to illustrate
// std::find
// CPP program to illustrate
// std::find
#include<bits/stdc++.h>

int main ()
{
	std::vector<int> vec { 10, 20, 30, 30, 40 };
	// Element to be searched
	int ser = 30;

	// std::find function call
	std::vector<int>::iterator it =  std::find (vec.begin(), vec.end(), ser);
	if (it != vec.end())
    {
      std::cout << "Element " << ser <<" found at position : " ;
      std::cout << it - vec.begin() << " (counting from zero) \n" ;
    }
	else
		std::cout << "Element not found.\n\n";

	return 0;
}
// Output: 
// Original vector : 10 20 30 40
// Element 30 found at position : 2 (counting from zero)
