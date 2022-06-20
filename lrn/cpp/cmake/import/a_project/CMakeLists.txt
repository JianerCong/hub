cmake_minimum_required(VERSION 3.15)
project(MathFunctions)

# make cache variables for install destinations
include(GNUInstallDirs)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Create the library
add_library(MathFunctions STATIC MathFunctions.cxx)

# We need to tell cmake we need to use different include_dir depending on if we
# are
# 1. building the library
# 2. using it from an installed location

#By default, cmake use the current_source_dir which is invalid when this is
#exported to other project.

#The following generator expression specifies that
# if (we are building the source): include the current_source_dir
# else: when installed, include the ~include~ directory

target_include_directories(MathFunctions
  PUBLIC
  "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>"
  "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
)

# Set install dir to the current folder
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/install"
    CACHE PATH "${PROJECT_BINARY_DIR}/cache" FORCE)
endif()

add_custom_target(my_report ALL echo 🐸 The install_lib_dir is ${CMAKE_INSTALL_LIBDIR})
add_custom_target(my_report2 ALL echo 🐸 The install_include_dir is ${CMAKE_INSTALL_INCLUDEDIR})

#We use an install(targets) to install the library
install(TARGETS MathFunctions
  EXPORT MathFunctionsTargets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )

# Install the header file
install(FILES MathFunctions.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Install the target export details to <bin_dir>/install
install(EXPORT MathFunctionsTargets
  FILE MathFunctionsTargets.cmake #⇒ MathFunctionsTargets.cmake : the description file
  NAMESPACE MathFunctions::       #The exported target name will have this prefix
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/MathFunctions
  )


