// Copyright Vladimir Prus 2002-2004.
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE_1_0.txt
// or copy at http://www.boost.org/LICENSE_1_0.txt)

/* The simplest usage of the library.
 */

#include <boost/program_options.hpp>
namespace program_options = boost::program_options;
#include <string>

#include <fstream>
#include <iostream>
#include <iterator>
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

    options_description o1("Generic options");
    o1.add_options()
      ("help,h", "produce help message")
      ("config,c", program_options::value<string>(&config_file)->default_value("m.cfg"),
       "name of a file of a configuration.")
      ;

    // Declare a group of options that will be allowed both on command line and
    // in config file
    options_description o2("Configuration");
    o2.add_options()
      ("x-value,x",program_options::value<int>(&x)->default_value(10),
       "value of x")
      ("y-list,y",program_options::value<vector<string>>() ->composing(),
       "list of y");

    options_description o3("Hidden options");
    o3.add_options()
      ("z-list",program_options::value< vector<string> >(),
       "list of z"
       );

    // 🦜 : options can be "added"
    options_description O1,O2,O3("Allowed options");


    // cmdline options
    O1.add(o1).add(o2).add(o3);

    // config file options
    O2.add(o2).add(o3);

    // Visible options
    O3.add(o1).add(o2);

    program_options::positional_options_description p;
    p.add("z-list",-1);

    // 1. --------------------------------------------------
    // The variable map
    program_options::variables_map m;

    // 2. --------------------------------------------------
    // Read from cmdline
    program_options::store(program_options::command_line_parser(argc, argv).
          options(O1).positional(p).run(), m);
    program_options::notify(m);

    // 3. --------------------------------------------------
    // Read from config file
    ifstream ifs(config_file.c_str());
    if (!ifs){
      cout << "can not open config file: " << config_file << "\n";
      return 0;
    }else{
      program_options::store(program_options::parse_config_file(ifs, O2), m);
      program_options::notify(m);
    }

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
