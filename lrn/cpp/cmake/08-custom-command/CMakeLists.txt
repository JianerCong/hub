cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(Hi VERSION 1.0)

# specify the C++ standard
add_library(my_compiler_flags INTERFACE)
target_compile_features(my_compiler_flags INTERFACE cxx_std_11)

add_subdirectory(mylib)

# add the executable
add_executable(Hi hi.cpp)
target_link_libraries(Hi PUBLIC mylib my_compiler_flags)

# add the binary tree to the search path for include files
# so that we will find TutorialConfig.h
target_include_directories(Hi PUBLIC
  "${PROJECT_BINARY_DIR}"
)

# run
add_custom_target(run ALL Hi COMMENT "Runing App 🐸")
