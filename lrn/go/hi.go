package main

import (
	// "bufio"
	"fmt"
	"os"
)

// Use the following interface
// type Reader interface {
// 	Read(p []byte) (n int, err error)
// }

// type Writer interface {
// 	Write(p []byte) (n int, err error)
// }
// type Closer interface {
//         Close() error
// }

// type Seeker interface {
//         Seek(offset int64, whence int) (int64, error)
// }

func main() {
	// f, err := os.Open("hi.txt") //read only file

	f, err := os.OpenFile("hi.txt", os.O_RDWR | os.O_CREATE, 0666)
	//                                                 ^^^^--oct mod
	// os.FileMode(0777).String() // => rwxrwxrwx
	if err != nil {fmt.Println("Error opening file");return}
	defer f.Close()

	_, err = f.WriteString("So, that's it.")
	if err != nil {fmt.Println("Error writing to file ", f.Name());return}
	_, err = f.Seek(0,0)	// back to 0 + origin (represented as the second param)
	if err != nil {fmt.Println("Error seeking ", f.Name());return}
	b := make([]byte,252)
	_, err = f.Read(b)
	if err != nil {fmt.Println("Error reading", f.Name());return}
	fmt.Println("Content read: ", string(b[:]))
}
// We got the following file specifiler
// const (
// 	O_RDONLY int = syscall.O_RDONLY // 只读模式打开文件
// 	O_WRONLY int = syscall.O_WRONLY // 只写模式打开文件
// 	O_RDWR int = syscall.O_RDWR // 读写模式打开文件
// 	O_APPEND int = syscall.O_APPEND // 写操作时将数据附加到文件尾部
// 	O_CREATE int = syscall.O_CREAT // 如果不存在将创建一个新文件
// 	O_EXCL int = syscall.O_EXCL // 和O_CREATE配合使用，文件必须不存在
// 	O_SYNC int = syscall.O_SYNC // 打开文件用于同步I/O
// 	O_TRUNC int = syscall.O_TRUNC // 如果可能，打开时清空文件
// )
