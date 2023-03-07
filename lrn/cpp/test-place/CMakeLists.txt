cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(Hi VERSION 1.0)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(rocksdb CONFIG REQUIRED)
add_executable(myexe test.cpp)

target_link_libraries(myexe PUBLIC rocksdb)

# cmake .. && cmake --build .
add_custom_target(run ALL myexe COMMENT "Runing App 🐸")
