cmake_minimum_required(VERSION 3.10)

include("cmake/HunterGate.cmake")
HunterGate(
    URL "https://github.com/cpp-pm/hunter/archive/v0.23.297.tar.gz"
    SHA1 "3319fe6a3b08090df7df98dee75134d68e2ef5a3"
)

project(Foo)

hunter_add_package(Boost COMPONENTS regex system filesystem)

# set the project name and version
project(Hi VERSION 1.0)

# add the executable
add_executable(Hi hi.cpp PUBLIC Boost::regex)
