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

int main(int ac, char* av[])
{
    try {

        program_options::options_description desc("Allowed options");
        desc.add_options()
            ("help", "produce help message")
            ("compression", program_options::value<double>(), "set compression level")
        ;

        // stores the data in kv map
        program_options::variables_map vm;
        program_options::store(program_options::parse_command_line(ac, av, desc), vm);
        program_options::notify(vm);

        if (vm.count("help")) {
            cout << desc << "\n";
            return 0;
        }

        if (vm.count("compression")) {
            cout << "Compression level was set to "
                 << vm["compression"].as<double>() << ".\n";
        } else {
            cout << "Compression level was not set.\n";
        }
    }
    catch(exception& e) {
        cerr << "error: " << e.what() << "\n";
        return 1;
    }
    catch(...) {
        cerr << "Exception of unknown type!\n";
    }

    return 0;
}
