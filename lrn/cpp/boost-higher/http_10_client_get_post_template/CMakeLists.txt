cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(Hi VERSION 1.0)

IF (WIN32)
  # set stuff for windows
  set(Boost_DIR "C:\\Users\\congj\\repo\\boost_1_82_0\\stage\\lib\\cmake\\Boost-1.82.0")
  message("🐸 Setting Boost_DIR: ${Boost_DIR}")
else()
  # set stuff for other systems
  set(Boost_USE_STATIC_LIBS ON)
  set(Boost_DIR "/home/me/.local/boost_1_82_0/stage/lib/cmake/Boost-1.82.0/")
ENDIF()

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

# copy the files
configure_file(test_one.py test_one.py)
configure_file(m.py m.py)

# cmake .. && cmake --build .
# add_custom_target(run ALL pytest -v COMMENT "Runing App 🐸 ")
add_custom_target(run ALL myexe  COMMENT "Runing App 🐸 ")

