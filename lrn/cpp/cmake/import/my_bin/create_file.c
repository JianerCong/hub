#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
#include "C:\Users\congj\AppData\Roaming\Templates\mylib.h"
#else
#ifdef __arm__
#include "/home/pi/Templates/mylib.h"
#else
#include "/home/me/Templates/mylib.h"
#endif
#endif

void check_file(FILE *fp);
void my_rewind(FILE *fp);
void show_contents(FILE *fp);

int main(int argc, char *argv[]){
  const char* fname = "my_generated.cpp";
  FILE *fp = fopen(fname, "w+"); /* trancate file before write */
  check_file(fp);
  fprintf(fp, "#include<iostream>\n"
          "//Generated at %s\n"
          "int main(){\n"
          "\tstd::cout << \"I am the generated one 🐸.\"\n"
          "\t          << std::endl;\n"
          "return 0;"
          "}", time_str());
  printf("[%s] Contents written:\n", time_str());
  my_rewind(fp);                   /* can also use rewind() */
  show_contents(fp);
  fclose(fp);
  return 0;
  }

void check_file(FILE *fp){
  if (fp == NULL){
    printf("Failed to open file.\n");
    exit(1);
  }
}

void my_rewind(FILE *fp){
  long offset = 0;
  int origin = SEEK_SET;        /* the begining of the file */
  fseek(fp, offset, origin);
  printf("Current file position: %ld\n",
         ftell(fp)
         );
}

void show_contents(FILE *fp){
  int max = 500;
  printf("Showing contents: \n\n");
  for (int c = 0;((c = fgetc(fp)) != EOF) && max > 0;
       max--){
    fprintf(stdout, "%c", (char) c);
  }
  puts("");
  if (max > 0 && !feof(fp)){
    fprintf(stderr, "Error reading at max = %d\n", max);
  }
}
