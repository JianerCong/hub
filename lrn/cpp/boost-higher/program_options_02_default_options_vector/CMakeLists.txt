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
set(x 0)                        #a counter
function(do_test target result)
  math(EXPR y "${x} + 1" OUTPUT_FORMAT DECIMAL)
  set(x ${y} PARENT_SCOPE)

  add_test(NAME test[${y}] COMMAND ${target} ${ARGN})
  # 🦜 : the trailing                ^^^^^^
  set_tests_properties(test[${y}]
    PROPERTIES PASS_REGULAR_EXPRESSION ${result}
  )
endfunction()

# do a bunch of result based tests
do_test(main "Optimization level is 10" )    #default value
do_test(main "Optimization level is 11" --optimization 11)
do_test(main "Listen port is 0" ) #default value
do_test(main "Listen port is 1001" --listen) #implicit value
do_test(main "Listen port is 6789" --listen 6789)
do_test(main "Verbosity enabled. Level is 1" -v) #implicit value
do_test(main "Verbosity enabled. Level is 1" --verbose) #implicit value
do_test(main "Verbosity enabled. Level is 10" -v 10)
do_test(main "Verbosity enabled. Level is 10" --verbose 10 )
do_test(main "Usage: m \\[options\\]" --help)
do_test(main "Include paths are: d1 d2 d3"
  --include-path d1
  --include-path d2
  --include-path d3)
do_test(main "Include paths are: d1 d2 d3"
  -Id1 -Id2 -Id3)
do_test(main "Input files are: f1 f2 f3"
  -Id1 -Id2 -Id3 f1 f2 f3)      #input file as positional argument

add_custom_target(run ALL ctest -V COMMENT "Runing test 🐸")
# add_custom_target(run ALL ctest COMMENT "Runing test 🐸")
