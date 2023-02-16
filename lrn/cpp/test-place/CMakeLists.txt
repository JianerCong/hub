cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(Hi VERSION 1.0)

# configure_file(HiConfig.h.in HiConfig.h)

# add the executable
add_executable(myexe test.cpp)

# cmake .. && cmake --build .
add_custom_target(run ALL myexe 1 COMMENT "Runing App 🐸")
