# How to use interface to include the source dir of a lib
# Check out the mylib/CMakeLists.txt
cmake_minimum_required(VERSION 3.21)
project(hi VERSION 1.1)

# Define an option
option(USE_MYLIB "Use the function in mylib" ON)
# Use: cmake build .. -DUSE_MYLIB=OFF
# to turn it off


if(USE_MYLIB)
  add_subdirectory(mylib)         #add the ./mylib to the path
  list(APPEND EXTRA_LIBS mylib)
endif()


# add an executable
add_executable(M m.cpp)
# Create the mConfig.h file from m.h.in
configure_file(m.h.in mConfig.h)
target_link_libraries(M PUBLIC ${EXTRA_LIBS})

target_include_directories(M PUBLIC
  "${PROJECT_BINARY_DIR}"       #where the m.h is created
  # compared to tut02, we can safely remove the EXTRA_INCLUDES variable
  )

# run the M target with arguments "1" (ALL means always build this target)
add_custom_target(run ALL M 1 COMMENT "Runing App 🐸")
