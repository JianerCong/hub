cmake_minimum_required(VERSION 3.21)
project(MyCMakeUser VERSION 1.1)

# Do one of the following two to include the dir that install the my_cmake_libConfig.cmake
# set(CMAKE_PREFIX_PAth "../my_cmake_lib.build/my-install/lib/cmake/my_cmake_lib")
set(my_cmake_lib_DIR "../my_cmake_lib.build/my-install/lib/cmake/my_cmake_lib")

# So the version can be 1.2.2, 1.2.3 but not 1.2.4.
# If you change to 1.2.4, you recieve :

# The following configuration files were considered but not accepted:
# /home/me/Templates/lrn/cpp/cmake/import/my_cmake_lib_usr/../my_cmake_lib.build/my-install/lib/cmake/my_cmake_lib/my_cmake_libConfig.cmake,version: 1.2.3


find_package(my_cmake_lib 1.2.3)
add_executable(m m.cpp)
target_link_libraries(m PRIVATE my_cmake_lib::my_cmake_lib)

add_custom_target(run ALL m COMMENTS "Running 🐸")
