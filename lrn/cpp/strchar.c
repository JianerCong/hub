/**
 * @file strchar.c
 * @author Jianer Cong
 * @brief using strchar
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]){
  char s[30];
  char f;
  /* char *s = "abcdef"; */
  /* char f = 'b'; */
  char *r;
  printf("Enter a word: ");
  scanf("%s",s);

  /* Eat line */
  while (getchar() != '\n')
    continue;

  printf("Enter a char : ");
  scanf("%c",&f);

  if (r = strchr(s,f))
    printf("The the %c-substring in \"%s\" is %s\n",f,s,r);
  else
    printf("%c doesn't exits in %s\n", f, s);

  return 0;
  }
