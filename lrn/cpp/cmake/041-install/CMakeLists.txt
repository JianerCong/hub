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
  )

# run the M target with arguments "1" (ALL means always build this target)
add_custom_target(run ALL M 1 COMMENT "Runing App 🐸")


# Installs
#  Put .h into include, .so into lib, .exe into bin
# The relative path are appended to CMAKE_INSTALL_PREFIX
# This variable defaults to /usr/local on UNIX and c:/Program Files/${PROJECT_NAME} on Windows.

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}/install"
    CACHE PATH "${PROJECT_SOURCE_DIR}/cache" FORCE)
endif()

add_custom_target(my_report ALL echo 🐸 The install prefix is ${CMAKE_INSTALL_PREFIX})
install(TARGETS mylib DESTINATION lib)
install(FILES mylib/mylib.h DESTINATION include)
# When installing FILES, the File names given as relative paths are interpreted
# with respect to the current source directory.

install(TARGETS M DESTINATION bin)
install(FILES "${PROJECT_BINARY_DIR}/mConfig.h"
  DESTINATION include
  )

# Go and run
# cd bin &&  cmake .. && cmake --build . && cmake --install . && cd ../install
# tree
# Then we see the installed files
