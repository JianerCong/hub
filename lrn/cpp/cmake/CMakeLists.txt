cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(Hi VERSION 1.0)
# add the executable
add_executable(Hi hi.cpp)

add_custom_target(run ALL Hi COMMENT "Runing App 🐸")
