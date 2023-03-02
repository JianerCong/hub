
# use c++ to produce a header file
set(MY_OUTPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/x.h)
add_executable(MakeTable MakeTable.cxx)
add_custom_command(
  OUTPUT ${MY_OUTPUT_FILE}
  COMMAND MakeTable ${MY_OUTPUT_FILE}
  DEPENDS MakeTable
)

# Making the generated header file a source, so that this target depends on it.
add_library(mylib get_one.cpp ${MY_OUTPUT_FILE})

# state that anybody linking to us needs to include the current source dir
# to find MathFunctions.h, while we don't.
target_include_directories(mylib
  INTERFACE ${CMAKE_CURRENT_SOURCE_DIR} #client should include this dir
  PRIVATE   ${CMAKE_CURRENT_BINARY_DIR} #should include the bin dir for the generated file
)
