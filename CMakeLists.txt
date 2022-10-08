cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(PROJECT_NAME VERSION 1.0)


# configure a header file to pass some of the CMake settings
# to the source code
configure_file(PROJECT_NAMEConfig.h.in PROJECT_NAMEConfig.h)

# add the executable
add_executable(PROJECT_NAME m.cpp)



# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)



# add the binary tree to the search path for include files
# so that we will find PROJECT_NAMEConfig.h
target_include_directories(PROJECT_NAME PUBLIC
                           "${PROJECT_BINARY_DIR}"
                           )
