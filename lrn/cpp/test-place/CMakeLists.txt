cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(Hi VERSION 1.0)

find_package(Boost CONFIG REQUIRED
  unit_test_framework)
# add the executable

add_executable(myexe test.cpp)
target_link_libraries(myexe PUBLIC
  Boost::unit_test_framework)

# cmake .. && cmake --build .
add_custom_target(run ALL myexe --random --log_level=all COMMENT "Runing App 🐸")
