// Copyright Vladimir Prus 2002-2004.
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE_1_0.txt
// or copy at http://www.boost.org/LICENSE_1_0.txt)

/* The simplest usage of the library.
 */

#include <boost/program_options.hpp>
namespace program_options = boost::program_options;
#include <string>


#include <filesystem>
#include <fstream>
#include <iostream>
#include <iterator>
using std::filesystem::current_path;
using namespace std;
// A helper function to simplify the main part.
template<class T>
ostream& operator<<(ostream& os, const vector<T>& v)
{
  copy(v.begin(), v.end(), ostream_iterator<T>(os, " "));
  return os;
}

int main(int argc, char* argv[])
{
  using program_options::options_description;
  try{
    int x;
    string config_file;

    cout << "🐸 Current path: " << current_path() << endl;
    options_description o1("Generic options");
    o1.add_options()
      ("help,h", "produce help message")
      ("config,c", program_options::value<string>(&config_file)->default_value("m.cfg"),
       "name of a file of a configuration.")
      ;

    // 1. --------------------------------------------------
    // The variable map
    program_options::variables_map m;
    // 2. --------------------------------------------------
    // Read from cmdline
    program_options::store(program_options::command_line_parser(argc, argv).
                           options(o1).run(), m);
    program_options::notify(m);

    // 4. --------------------------------------------------
    // Check the values
    if (m.count("help")){
      cout << O3 << "\n";
      return 0;
    }
    if (m.count("y-list")){
      cout << "y = " << m["y-list"].as<vector<string>>() << endl;
    }

    if (m.count("z-list")){
      cout << "z = " << m["z-list"].as<vector<string>>()<< endl;
    }

    cout << "x = " << x << endl;
  }
  catch(exception& e){
    cout << e.what() << "\n";
    return 1;
  }
}
