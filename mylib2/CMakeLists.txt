cmake_minimum_required(VERSION 3.15)
project(m)

set(pkg mylib2)
set(src ${pkg}.cpp test.cpp tester.cpp)
include("../scripts/myfuncs.cmake")
my_add_package(${pkg} 1.2.4 "${src}")
# The test

add_executable(test.exe my_test.cpp)
target_link_libraries(test.exe ${pkg})
add_custom_target(run_test ALL
  test.exe COMMENTS "Running test")


# cd ../my_cmake_lib.build
# clear && rm -rf * && cmake ../my_cmake_lib
# cmake --build . && cmake --install . --prefix my-install

