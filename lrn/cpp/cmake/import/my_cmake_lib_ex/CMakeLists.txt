cmake_minimum_required(VERSION 3.15)
project(myComponents)

include("../../../../../scripts/myfuncs.cmake")

set(pkg my_cmake_lib)
set(mod f2)
my_init_pkg_config_install_dir(${pkg})

add_subdirectory(f2)
# set version
set(version 1.2.3)

# Export the my_cmake_lib component
add_library(${pkg} STATIC ${pkg}.cpp)
my_add_dual_include(${pkg})
my_package_this_target(${pkg} ${pkg})

# Finish up
my_write_version_file(${pkg} ${version})
my_create_and_install_config_file(${pkg})

# To add components, modify the _supported_components list in the
# ./Config.cmake.in


# cd ../my_cmake_lib.build
# clear && rm -rf * && cmake ../my_cmake_lib
# cmake --build . && cmake --install . --prefix my-install

