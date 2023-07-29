cmake_minimum_required(VERSION 3.10)
# set the project name and version
project(Hi VERSION 1.0)

include(CheckCXXSourceCompiles)
check_cxx_source_compiles("
  #include <cmath>
  int main() {
    std::aaa(1.0);
    return 0;
  }
" HAVE_aaa)

check_cxx_source_compiles("
  #include <cmath>
  int main() {
    std::exp(1.0);
    return 0;
  }
" HAVE_EXP)

message(STATUS "🐸 have_aaa: ${HAVE_aaa}")
message(STATUS "🐸 have_exp: ${HAVE_EXP}")

add_executable(M hi.cpp)

if(HAVE_EXP)
  target_compile_definitions(M PRIVATE "HAVE_EXP")
endif()

# run the M target with arguments "1" (ALL means always build this target)
add_custom_target(run ALL M 1 COMMENT "Runing App 🐸")
