cmake_minimum_required(VERSION 3.21)
# set(CMAKE_CXX_COMPILER "g++")
project(hi VERSION 1.1)

# set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_BUILD_TYPE Release)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
IF (WIN32)
  # set stuff for windows
  set(Boost_DIR "C:\\Users\\congj\\repo\\boost_1_82_0\\stage\\lib\\cmake\\Boost-1.82.0")
  message("🐸 Setting Boost_DIR: ${Boost_DIR}")
ELSE()
  # set stuff for other systems
ENDIF()
find_package(Boost REQUIRED COMPONENTS unit_test_framework log program_options)

add_executable(clnt clnt.cpp)
target_link_libraries(clnt PUBLIC Boost::log)
configure_file(serv.py serv.py)
# Although beast and axio are all header-only, we need to link to at least one
# Boost-target in order to bring in the include dirs

# add_custom_target(run ALL
#   weak-server 0.0.0.0 7777
#   COMMENT "Runing App 🐸")
