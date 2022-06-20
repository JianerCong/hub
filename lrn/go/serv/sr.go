
package main

import(
	"fmt"
	"io"
	"os"
	"net"
	"log"
	"time"
)


func getListener() net.Listener{
	// use sudo go run sr.go #since we are listening to well-known ports < 1024
	l, err := net.Listen("tcp","127.0.0.1:80")
	if err != nil{
		fmt.Println("Failed to listen to a port")
		log.Fatal(err)
	}
	fmt.Println("Server is listening to", l.Addr().String())
	return l
}

func writeAddrToFile(l net.Listener){
	file, err := os.Create("addr.txt")
	if err != nil {
		fmt.Println("Error opening file")
		log.Fatal(err)
	}
	_ , err = file.WriteString(l.Addr().String() + "\n")
	if err != nil{
		fmt.Println("Error writing file")
		log.Fatal(err)
	}
}

func checkForError(err error, done<- chan struct{}) bool{
	// Two possibilities: true (connection error), false (server closed)

	// waiting for the done signal from main thread
	time.Sleep(1*time.Second)
	// test if it's because it's just done
	select {
	case <-done:{
		fmt.Println("Connection closed, bye bye 🐸")
		return true
	}
	default:{
		fmt.Println("😭 I find it hard to accept the connection.")
		return false
	}
	}
}

func handleConn(c net.Conn){
	defer func(){
		c.Close()
		// done <- struct {}{}
	}()
	b := make([]byte,1024)
	for {
		n,err := c.Read(b)
		if err != nil{
			if err != io.EOF{
				fmt.Println("😭Non-EOF error when reading bytes")
				return
			}
			fmt.Println("EOF encountered bye 🐸")
			// c.Close()
			// fmt.Println("Connection closed.")
			return
		}
		fmt.Println("received: ",string(b[:n]))
	}

}

func createServer(l net.Listener, done chan struct{}){
	defer func(){done <- struct {}{}}()
	var server_closed bool
	for {
		fmt.Println("I am waiting...(press 'q' to close me)")
		c, err := l.Accept()
		if err!= nil {server_closed = checkForError(err,done)
		}else{
			go handleConn(c)
		}

		if server_closed {return}

	}
}

func quiter(done chan<- struct{}){
	var b [2]byte
	for {
		// fmt.Print("Please enter an command (q to quit): ")
		_,err := os.Stdin.Read(b[:])
		if err != nil{
			fmt.Println("failed to read from input")
			return
		}
		if b[0] == 'q' {
			fmt.Println("Let's close the server")
			done <- struct{}{}
		}else{
			fmt.Println(b[0], " is not a valid command (q to quit)")
		}
	}

}

func main(){
	l := getListener()
	writeAddrToFile(l)
	done := make(chan struct{})
	go createServer(l, done)
	go quiter(done)

	<-done			// Should be sent by quiter
	l.Close()
	done <- struct{}{}
	fmt.Println("Server is closed.")

}
