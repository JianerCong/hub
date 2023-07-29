cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(Hi VERSION 1.0)

# add the executable
add_executable(Hi hi.cpp)

# This module will include any runtime libraries that are needed by the project
# for the current platform
include(InstallRequiredSystemLibraries)

# set some CPack variable
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/License.txt")
set(CPACK_PACKAGE_VERSION_MAJOR "${Hi_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${Hi_VERSION_MINOR}")
set(CPACK_SOURCE_GENERATOR "TGZ")

include(CPack)

# cd bin && cmake .. && cmake --build  . && cpack
# or use other generators
# cpack -G ZIP -C Debug
