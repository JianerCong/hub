cmake_minimum_required(VERSION 3.21)
project(hi VERSION 1.1)
include("../a_project.build/install/lib/cmake/MathFunctions/MathFunctionsTargets.cmake")
# Make sure you have used
# cmake --install .
# in the a_project.build

add_executable(m.exe m.cpp)
target_link_libraries(m.exe PRIVATE MathFunctions::MathFunctions)
add_custom_target(run ALL m.exe COMMENTS "Running apps")
