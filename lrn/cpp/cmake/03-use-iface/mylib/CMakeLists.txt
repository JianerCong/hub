add_library(mylib get_one.cpp)
# Anyone linking to mylib, must include the current_source_dir
target_include_directories(mylib
  INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
  )
