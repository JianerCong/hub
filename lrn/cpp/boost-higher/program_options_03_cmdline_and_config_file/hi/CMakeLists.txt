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

# The default config file
set(f ${CMAKE_CURRENT_BINARY_DIR}/m.cfg)
message("🐸 Config file written to ${f}")
file(WRITE ${f} "
# comment
x-value = 1
y-list = y1 y2 y3
")


# Another config file
set(f1 ${CMAKE_CURRENT_BINARY_DIR}/another.cfg)
message("🐸 Config file written to ${f1}")
file(WRITE ${f1} "
# comment
x-value = 10
y-list = y10 y20 y30
")

do_test(main "Allowed options" --help)
do_test(main "Allowed options" -h)
do_test(main "x = 1")
do_test(main "y = y1 y2 y3(.*)x = 1")
# change config file
do_test(main "y = y10 y20 y30(.*)x = 10" --config ${f1})
do_test(main "y = y10 y20 y30(.*)x = 10" -c ${f1})
# positional argument (at the bottom)
do_test(main "y = y1 y2 y3(.*)z = z1 z2 z3(.*)x = 1" z1 z2 z3)

# cmdline overwites config for scaler
do_test(main "x = 2" -x 2)
do_test(main "x = 2" --x-value 2)
# cmdline merge config for vector
do_test(main "y = y10 y20 y1 y2 y3" --y-list y10 --y-list y20)
do_test(main "y = y10 y20 y1 y2 y3" -y y10 -y y20)


add_custom_target(run ALL ctest -V COMMENT "Runing test 🐸")
# add_custom_target(run ALL ctest COMMENT "Runing test 🐸")
