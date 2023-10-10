cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(Hi VERSION 1.0)

IF (WIN32)
  # set stuff for windows
  set(Boost_DIR "C:\\Users\\congj\\repo\\boost_1_82_0\\stage\\lib\\cmake\\Boost-1.82.0")
  message("🐸 Setting Boost_DIR: ${Boost_DIR}")
ENDIF()


if (MSVC)
  # warning level 4
  add_compile_options(/utf-8)
else()
  # additional warnings
  # add_compile_options(-Wall -Wextra -Wpedantic)
endif()

find_package(Boost CONFIG REQUIRED
  unit_test_framework log locale log_setup)
# add the executable

add_executable(myexe m.cpp)
target_link_libraries(myexe PUBLIC
  Boost::unit_test_framework
  Boost::log
  Boost::log_setup
  Boost::locale
)

# cmake .. && cmake --build .
add_custom_target(run ALL
  myexe localhost 8080 / COMMENT "Runing App 🐸 ")

