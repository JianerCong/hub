cmake_minimum_required(VERSION 3.16)
project(try_import VERSION 1.1)

# my_source_maker is an already compiled exe that can generate a
# my_generated.cpp
add_executable(my_source_maker IMPORTED)
message("Current source dir is ${current_source_dir}")
set_property(TARGET my_source_maker
  PROPERTY
  IMPORTED_LOCATION "../my_bin/create_file.exe" )

add_custom_command(OUTPUT my_generated.cpp
  COMMAND my_source_maker)

# Add the binery dir to the
add_executable(my_generated_exe my_generated.cpp)
# This target needs the generated file my_generated.cpp
target_include_directories(my_generated_exe PUBLIC
  "${PROJECT_BINARY_DIR}"       #where the my_generated.cpp is created
  )

add_custom_target(run ALL my_generated_exe
  COMMENT "Running apps 🐸")



