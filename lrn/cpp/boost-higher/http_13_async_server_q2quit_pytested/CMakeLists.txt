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
  set(Boost_USE_STATIC_LIBS ON)
  set(Boost_DIR "/home/me/.local/boost_1_82_0/stage/lib/cmake/Boost-1.82.0/")
ENDIF()

find_package(Boost 1.75...1.82
  CONFIG REQUIRED COMPONENTS json unit_test_framework log
)

add_executable(myexe m.cpp)
target_link_libraries(myexe PUBLIC Boost::log Boost::json)
# Although beast and axio are all header-only, we need to link to at least one
# Boost-target in order to bring in the include dirs

# copy the py file to build dir
configure_file(test_one.py test_one.py)
# file(COPY test_one.py DESTINATION .)
add_custom_target(run ALL pytest -v COMMENT "Runing pytest 🐸")
# add_custom_target(run ALL
#   weak-server 0.0.0.0 7777
#   COMMENT "Runing App 🐸")
