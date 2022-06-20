#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include <tchar.h>

#define BUF_SIZE 256

int make_named_buffer(const TCHAR name[], const int msg );
int _tmain()
{
  const TCHAR* nam = TEXT("MyShare");
  const int msg = 2;

  return make_named_buffer(nam,msg);
}

int make_named_buffer(const TCHAR name[], const int msg ){

  HANDLE f;
  LPCTSTR s;
   f = CreateFileMapping(
                 INVALID_HANDLE_VALUE,    // use paging file
                 NULL,                    // default security
                 PAGE_READWRITE,          // read/write access
                 0,                       // maximum object size (high-order DWORD)
                 BUF_SIZE,                // maximum object size (low-order DWORD)
                 name);                 // name of mapping object

   if (f == NULL)
   {
      _tprintf(TEXT("Could not create file mapping object (%d).\n"),
             GetLastError());
      return 1;
   }

   s = (LPTSTR) MapViewOfFile(f,   // handle to map object
                        FILE_MAP_ALL_ACCESS, // read/write permission
                        0,
                        0,
                        BUF_SIZE);

   if (s == NULL)
   {
      _tprintf(TEXT("Could not map view of file (%d).\n"),
             GetLastError());
       CloseHandle(f);
      return 1;
   }


   CopyMemory((PVOID)s, &msg, sizeof(int));
   printf("Named buffer created : ");
   _tprintf(name);
   printf("\nEnter any char to quit ");
    _getch();

   UnmapViewOfFile(s);

   CloseHandle(f);
   return 0;
}
