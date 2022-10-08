/**
 * @file mylib.h
 * @author Jianer Cong
 * @brief The header file for some simple utility functions.
 */

#ifdef _WIN32
#include "C:\Users\congj\AppData\Roaming\Templates\mylib-shared.h"
#else
#ifdef __arm__
#include "/home/pi/Templates/mylib-shared.h"
#else
#include "/home/me/Templates/mylib-shared.h"
#endif
#endif


