cmake_minimum_required(VERSION 3.21)
project(hi VERSION 1.1)

# Define an option. Turn this on before configure_file
option(USE_MYLIB "Use the function in mylib" ON)
# Or Use: cmake build .. -DUSE_MYLIB=OFF
# to turn it off


# Create the mConfig.h file from m.h.in
configure_file(m.h.in mConfig.h)


if(USE_MYLIB)
  add_subdirectory(mylib)         #add the ./mylib to the path
  list(APPEND EXTRA_LIBS mylib)
  list(APPEND EXTRA_INCLUDES "${PROJECT_SOURCE_DIR}/mylib")
endif()


# add an executable
add_executable(M m.cpp)

target_link_libraries(M PUBLIC ${EXTRA_LIBS})


## 教程虽让我们这么做，但是好像在m.cpp之中并不需要m.h..
## 但是，我们还是需要这个，因为mConfig.h在这个之中。
target_include_directories(M PUBLIC
  "${PROJECT_BINARY_DIR}"       #where the m.h, mConfig.h is created
  ${EXTRA_INCLUDES}
  )

# run the M target with arguments "1" (ALL means always build this target)
add_custom_target(run ALL M 1 COMMENT "Runing App 🐸")
