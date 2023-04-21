cmake_minimum_required(VERSION 3.20)
project(Hi)
add_executable(m f.cpp m.cpp f.h)
add_custom_target(run ALL m COMMENT "Runing App 🐸")
