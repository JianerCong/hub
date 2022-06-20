package main

import(
	"fmt"
	"io"
	"os"
	"net"
	"log"
	"time"
)


func listen_for_quit(done chan struct{}){
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

func read_string_from_conn(c net.Conn) (string, error){
	b := make([]byte,1024)
	n,err := c.Read(b)
	if err != nil{
		if err != io.EOF{
			fmt.Println("😭Non-EOF error when reading bytes")
			log.Fatal(err)
		}
		fmt.Println("EOF encountered bye 🐸")
	}
	return string(b[:n]), err
}

func handle_conn(k int, c net.Conn){
	// For each connection, we keep reading bytes until EOF
	defer func(){
		c.Close()
	}()

	var err error
	var s string
	// Read string + display : until EOF
	for {
		s, err = read_string_from_conn(c)
		if err != io.EOF{
			fmt.Println("received: ",s)
		}else{
			break
		}
	}
}

func create_listener_and_write_address() net.Listener{
	// Create listener and save the address to addr.txt;
	l, err := net.Listen("tcp","127.0.0.1:80")
	if err != nil{
		fmt.Println("Failed to listen to a port")
		log.Fatal(err)
	}
	fmt.Println("Server is listening to", l.Addr().String())
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
	return l
}

func check_if_need_to_quit(err error, done chan struct{}) error{
		// Two possibilities: That the server is closed,
		// or failed to accept a connection.
		// Waiting the done signal from main thread
		time.Sleep(time.Second)
		// test if it's because it's just done
		select {
		case <-done:{
			fmt.Println("Connection closed, bye bye 🐸")
			return nil
		}
		default:{
			fmt.Println("😭 I find it hard to accept the connection.")
			fmt.Print(err)
			return err
		}
		}
		return err
}

func create_server(l net.Listener ,done chan struct{} ){
	defer func(){done <- struct {}{}}()
	// client_number := 0
	n := 0			// client number
	// max_client_number := 2
	fmt.Println("I am waiting...(press 'q' to close me)")
	for {
		c, err := l.Accept()
		if err != nil{
			err = check_if_need_to_quit(err, done)
			if err == nil{
				return
			}
		}
		n++
		go handle_conn(n, c)
	}
}

func main(){
	// use sudo go run sr.go #since we are listening to well-known ports < 1024
	l := create_listener_and_write_address()
	done := make(chan struct{})
	go create_server(l, done)
	go listen_for_quit(done)
	<-done
	l.Close()
	//Notice the server to close, if the done is signaled by the
	//listen_for_quit
	done <- struct{}{}
	fmt.Println("Server is closed.")

}
