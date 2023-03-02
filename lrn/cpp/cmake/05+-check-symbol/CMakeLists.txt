cmake_minimum_required(VERSION 3.10)
# set the project name and version
project(Hi VERSION 1.0)


include(CheckSymbolExists)

# Check for macro SEEK_SET
check_symbol_exists(SEEK_SET "stdio.h" HAVE_SEEK_SET)
# Check for function fopen
check_symbol_exists(fopen "stdio.h" HAVE_FOPEN)
check_symbol_exists(AAA "stdio.h" HAVE_AAA)

message(STATUS "🐸 HAVE_SEEK_SET: ${HAVE_SEEK_SET}")
message(STATUS "🐸 HAVE_FOPEN: ${HAVE_FOPEN}")
message(STATUS "🐸 HAVE_AAA: ${HAVE_AAA}")
# <mode> can be FATAL_ERROR, SEND_ERROR, WARNING, AUTHOR_WARNING, DEPRECATION,
# STATUS, DEBUG, VERBOSE

if (HAVE_FOPEN)
  message(STATUS "🐸 fopen yes")
endif()

# cmake .
