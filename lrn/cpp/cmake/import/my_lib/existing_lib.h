#pragma once

#ifdef _WIN32
#include "C:\Users\congj\AppData\Roaming\Templates\mylib.h"
#else
#ifdef __arm__
#include "/home/pi/Templates/mylib.h"
#else
#include "/home/me/Templates/mylib.h"
#endif
#endif

void a_existing_function();
