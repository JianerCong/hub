cmake_minimum_required(VERSION 3.15)
project(m)


set(pkg my_cmake_lib)
include("../../../../../scripts/myfuncs.cmake")
my_init_pkg_config_install_dir(${pkg})

add_library(${pkg} STATIC ${pkg}.cpp)
my_add_dual_include(${pkg})


my_create_and_install_config_file(${pkg})
my_package_this_pkg(${pkg})

# include(write_version.cmake)
# write_my_version(my_cmake_lib 1.2.3)
my_write_version_file(${pkg} 1.2.3)

# export(EXPORT ${pkg}Targets
#   FILE "${CMAKE_CURRENT_BINARY_DIR}/cmake/${pkg}Targets.cmake"
#   NAMESPACE ${pkg}::
#   )


# cd ../my_cmake_lib.build
# clear && rm -rf * && cmake ../my_cmake_lib
# cmake --build . && cmake --install . --prefix my-install

