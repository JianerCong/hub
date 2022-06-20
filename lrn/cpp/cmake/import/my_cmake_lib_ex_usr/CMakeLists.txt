cmake_minimum_required(VERSION 3.21)
project(MyCMakeUser VERSION 1.1)

set(my_cmake_lib_DIR "../my_cmake_lib_ex.build/my-install/lib/cmake/my_cmake_lib")
# require the f2 components
find_package(my_cmake_lib 1.2.3 COMPONENTS f2 my_cmake_lib)

add_executable(m m.cpp)
target_link_libraries(m PRIVATE my_cmake_lib::f2 my_cmake_lib::my_cmake_lib)
# set_property(TARGET m PROPERTY NO_SYSTEM_FROM_IMPORTED 1)

add_custom_target(run ALL m COMMENTS "Running 🐸")
