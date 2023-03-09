cmake_minimum_required(VERSION 3.10)
# set the project name and version
project(Hi VERSION 1.0)

# find_package(Boost CONFIG REQUIRED)
# add the executable

add_executable(myexe test.cpp)

# cmake .. && cmake --build .
add_custom_target(run ALL myexe 1 COMMENT "Runing App 🐸")
