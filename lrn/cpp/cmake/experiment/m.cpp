#include "f.h"
#include <iostream>

#define DEBUG
#ifdef DEBUG
#define P(...) printf(__VA_ARGS__)
#endif

int main(){
  P("🐸 f -> %d", f());
  return 0;
}
