cmake_minimum_required(VERSION 3.21)
project(t VERSION 1.1)
add_executable(te t.cpp)

enable_testing()

# does the application run (has 0 return value)
add_test(NAME Runs COMMAND te 2)

# does the usage message work?
# whether the output contains certain string?
add_test(NAME Usage COMMAND te)
set_tests_properties(Usage
  PROPERTIES PASS_REGULAR_EXPRESSION "Usage :.*number"
  )


# define a function to simplify adding tests
function(do_test target arg result)
  add_test(NAME Comp${arg} COMMAND ${target} ${arg})
  set_tests_properties(Comp${arg}
    PROPERTIES PASS_REGULAR_EXPRESSION ${result}
    )
endfunction()


# do a bunch of result based tests
do_test(te 2 "So twice is 4")
do_test(te 5 "So twice is 10")
do_test(te 5.5 "So twice is 11")

# Do
# mkdir bin
# cd bin
# cmake ..
# cmake --build .
# ctest -N                        #show what tests to run(no run)
# ctest                           #run all tests
# ctest -V                        #run all (verbosely)
# ctest -R Runs                   #run the test match(regex) "Run"
