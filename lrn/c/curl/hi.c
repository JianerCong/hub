#include <stdio.h>
#include <curl.h>

int main(int argc, char *argv[]){
  curl_global_init(CURL_GLOBAL_ALL);
  printf("Let's cURL 🐸\n");
  curl_global_cleanup();
  return 0;
  }
