// A simple program that write to a file
// "double x = 111;"
#include <fstream>
#include <iostream>

int main(int argc, char* argv[])
{
  // make sure we have enough arguments
  if (argc < 2) {
    return 1;
  }

  // write to filename in argv[1]
  std::ofstream fout(argv[1], std::ios_base::out);
  const bool fileOpen = fout.is_open();

  if (fileOpen) {
    fout << "double x = 111;" << std::endl;
    fout.close();
  }

  return fileOpen ? 0 : 1; // return 0 if wrote the file
}
