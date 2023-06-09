cmake_minimum_required(VERSION 3.21)
# set(CMAKE_CXX_COMPILER "g++")
project(hi VERSION 1.1)


set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(Boost REQUIRED COMPONENTS unit_test_framework log
  program_options
)


# message("hi")
# return()
# message("❌️ won't shown")

# add the executable
add_executable(main m.cpp)
target_link_libraries(main PUBLIC Boost::unit_test_framework
  Boost::program_options
)

enable_testing()
function(do_test target result)
  add_test(NAME test[${result}] COMMAND ${target} ${ARGN})
  # 🦜 : the trailing                ^^^^^^
  set_tests_properties(test[${result}]
    PROPERTIES PASS_REGULAR_EXPRESSION ${result}
  )
endfunction()

# do a bunch of result based tests
do_test(main "Compression level was not set" "")
do_test(main "Compression level was set to 1" --compression 1)
do_test(main "Allowed options" --help)

# add_custom_target(run ALL ctest -V COMMENT "Runing test 🐸")
add_custom_target(run ALL ctest COMMENT "Runing test 🐸")
