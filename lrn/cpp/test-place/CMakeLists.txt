cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(Hi VERSION 1.0)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(myexe test.cpp)

# cmake .. && cmake --build .
add_custom_target(run ALL myexe COMMENT "Runing App 🐸")
