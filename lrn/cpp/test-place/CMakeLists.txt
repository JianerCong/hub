cmake_minimum_required(VERSION 3.20)
# set the project name and version
project(Hi VERSION 1.0)


# Version 1.82 is too high for findBoost
# set(BOOST_ROOT "C:\\Program Files\\boost_1_82_0")
# set(BOOST_ROOT "C:\\Users\\congj\\MyProgramFiles\\boost_1_82_0")

set(Boost_DIR "C:\\Users\\congj\\MyProgramFiles\\boost_1_82_0\\stage\\lib\\cmake\\Boost-1.82.0")
# The above dir contains the BoostConfig.cmake
find_package(Boost REQUIRED COMPONENTS log log_setup)
# find_package(Boost CONFIG REQUIRED COMPONENTS log)

add_executable(myexe test.cpp)
target_link_libraries(myexe PUBLIC Boost::log Boost::log_setup)

# cmake .. && cmake --build .
add_custom_target(run ALL myexe 1 COMMENT "Running App ❄")
