cmake_minimum_required(VERSION 3.10)

# set the project name
project(Tutorial VERSION 2.0)

# Cmake will generate TutorialConfig.h for you.
configure_file(TutorialConfig.h.in TutorialConfig.h)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)      #optional
set(CMAKE_CXX_STANDARD_REQUIRED True) #optional


# add the executable
add_executable(Tutorial tutorial.cxx)


# Since the configured file will be written into the binary tree, we must add
# that directory to the list of paths to search for include files.
# This line should be at the end of file
target_include_directories(Tutorial PUBLIC #optional if no configure file
  "${PROJECT_BINARY_DIR}"
  )

# cd /out
# cmake ..
# cmake --build .
