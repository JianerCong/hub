cmake_minimum_required(VERSION 3.10)
# set the project name and version
project(Hi VERSION 1.0)

# find_package(Boost CONFIG REQUIRED)
# add the executable

find_package(Boost CONFIG REQUIRED log)
# boost library by their canonical name:: "date_time" for "libboost_date_time"
# ls /lib/x86_64-linux-gnu/libboost_*.a
# add the executable

add_executable(myexe test.cpp)
target_link_libraries(myexe PUBLIC Boost::log)

# cmake .. && cmake --build .
add_custom_target(run ALL myexe 1 COMMENT "Runing App 🐸")
