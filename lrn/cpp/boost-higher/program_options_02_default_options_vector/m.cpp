// Copyright Vladimir Prus 2002-2004.
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE_1_0.txt
// or copy at http://www.boost.org/LICENSE_1_0.txt)

/* The simplest usage of the library.
 */

#include <boost/program_options.hpp>
namespace program_options = boost::program_options;

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
  int opt;
  int portnum;
  program_options::options_description desc("Allowed options");
  desc.add_options()
    ("help", "produce help message")
    ("optimization", program_options::value<int>(&opt)->default_value(10),
     "optimization level")
    ("verbose,v", program_options::value<int>()->implicit_value(1),
     "enable verbosity (optionally specify level)")
    ("listen,l", program_options::value<int>(&portnum)->implicit_value(1001)
     ->default_value(0,"no"),
     "listen on a port.")
    ("include-path,I", program_options::value< vector<string> >(),
     "include path")
    ("input-file", program_options::value< vector<string> >(), "input file")
    ;

  program_options::positional_options_description p;
  p.add("input-file", -1);

  program_options::variables_map vm;
  program_options::store(program_options::command_line_parser(argc, argv).
                         options(desc).positional(p).run(), vm);
  program_options::notify(vm);

  if (vm.count("help")) {
    cout << "Usage: m [options]\n";
    cout << desc;
    return 0;
  }

  if (vm.count("include-path"))
    {
      cout << "Include paths are: "
           << vm["include-path"].as< vector<string> >() << "\n";
    }

  if (vm.count("input-file"))
    {
      cout << "Input files are: "
           << vm["input-file"].as< vector<string> >() << "\n";
    }

  if (vm.count("verbose")) {
    cout << "Verbosity enabled. Level is " << vm["verbose"].as<int>()
         << "\n";
  }

  cout << "Optimization level is " << opt << "\n";

  cout << "Listen port is " << portnum << "\n";
  return 0;
}
