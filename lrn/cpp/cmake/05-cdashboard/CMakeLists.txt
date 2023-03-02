cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(Hi VERSION 1.0)

# add the executable
add_executable(Hi hi.cpp)

include(CTest)

add_test(NAME Runs COMMAND Hi)

# does the usage message work?
add_test(NAME Usage COMMAND Hi)
set_tests_properties(Usage
  PROPERTIES PASS_REGULAR_EXPRESSION "a*"
)

# cd bin
# rm * -rf && cmake .. && cmake --build . && ctest -VV -D Experimental
# firefox http://my.cdash.org/submit.php?project=CMakeTutorial
