using System;
using System.Runtime.InteropServices;
using System.ComponentModel;

namespace cs
{
    class Program
    {
        static unsafe void Main(){
            using (SharedMem sm = new SharedMem ("MyShare", true,256))
            {
                void* root = sm.Root.ToPointer();
                int* data = (int*) root;
                Console.WriteLine($"data read: {*data}");
            }
        }
    }

    public sealed class SharedMem : IDisposable
    {
        // Here we're using enums because they're safer than constants

        enum FileProtection : uint      // constants from winnt.h
            {
                ReadOnly = 2,
                ReadWrite = 4
            }

        enum FileRights : uint          // constants from WinBASE.h
            {
                Read = 4,
                Write = 2,
                ReadWrite = Read + Write
            }

        static readonly IntPtr NoFileHandle = new IntPtr (-1);

        [DllImport ("kernel32.dll", SetLastError = true)]
        static extern IntPtr CreateFileMapping (IntPtr hFile,
                                                int lpAttributes,
                                                FileProtection flProtect,
                                                uint dwMaximumSizeHigh,
                                                uint dwMaximumSizeLow,
                                                string lpName);

        [DllImport ("kernel32.dll", SetLastError=true)]
        static extern IntPtr OpenFileMapping (FileRights dwDesiredAccess,
                                              bool bInheritHandle,
                                              string lpName);

        [DllImport ("kernel32.dll", SetLastError = true)]
        static extern IntPtr MapViewOfFile (IntPtr hFileMappingObject,
                                            FileRights dwDesiredAccess,
                                            uint dwFileOffsetHigh,
                                            uint dwFileOffsetLow,
                                            uint dwNumberOfBytesToMap);

        [DllImport ("Kernel32.dll", SetLastError = true)]
        static extern bool UnmapViewOfFile (IntPtr map);

        [DllImport ("kernel32.dll", SetLastError = true)]
        static extern int CloseHandle (IntPtr hObject);

        IntPtr fileHandle, fileMap;

        public IntPtr Root => fileMap;

        public SharedMem (string name, bool existing, uint sizeInBytes)
        {
            if (existing)
                fileHandle = OpenFileMapping (FileRights.ReadWrite, false, name);
            else
                fileHandle = CreateFileMapping (NoFileHandle, 0,
                                                FileProtection.ReadWrite,
                                                0, sizeInBytes, name);
            if (fileHandle == IntPtr.Zero)
                throw new Win32Exception();

            // Obtain a read/write map for the entire file
            fileMap = MapViewOfFile (fileHandle, FileRights.ReadWrite, 0, 0, 0);

            if (fileMap == IntPtr.Zero)
                throw new Win32Exception();
        }

        public void Dispose()
        {
            if (fileMap != IntPtr.Zero) UnmapViewOfFile (fileMap);
            if (fileHandle != IntPtr.Zero) CloseHandle (fileHandle);
            fileMap = fileHandle = IntPtr.Zero;
        }
    }
}
