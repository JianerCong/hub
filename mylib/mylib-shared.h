/**
 * @file mylib-shared.h
 * @author Jianer Cong
 * @brief Some function and definitions shared by C and C++
 */

#pragma once

#include <time.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#define S_RED     "\x1b[31m"
#define S_GREEN   "\x1b[32m"
#define S_YELLOW  "\x1b[33m"
#define S_BLUE    "\x1b[34m"
#define S_MAGENTA "\x1b[35m"
#define S_CYAN    "\x1b[36m"
#define S_NOR "\x1b[0m"

const char* time_str();
const char* time_str(){
  static char msg[50];
  strftime(msg, sizeof msg, "%T %D %A", localtime(&(time_t){time(NULL)}));
  return msg;
}

/* Some definition that can be used to output colored text
   Example:
   printf(S_RED "I am red" S_NOR "I am normal\n");
*/

