package main

// the client program
import(
	"fmt"
	"os"
	"strings"
	"net"
	"log"
	"io"
)

func getAddr1(b []byte) int {
	fmt.Print("Enter the address to dial: ")
	n , err :=os.Stdin.Read(b[:])
	if err != nil {
		fmt.Println("Failed to read from stdin")
		log.Fatal(err)
	}
	return n
}

func getAddr2(b []byte) int{
	file , err := os.Open("addr.txt")
	if err != nil{
		log.Fatal(err)
		fmt.Println("Can't open file")
	}
	var n int
	n , err = file.Read(b[:])
	if err != nil{
		if err != io.EOF{
			fmt.Println("Can't read address 😭")
			log.Fatal(err)
		}
		fmt.Println("EOF reached 🐸")
	}
	fmt.Println("File read")
	return n
}

func getAddrString() string{
	b := make([]byte,252)
	n := getAddr2(b)

	s := string(b[:n])
	s = strings.TrimSpace(s)
	return s
}

func getConn() net.Conn{
	s := getAddrString()
	fmt.Println("Dialing to [" + s + "]")
	conn, err := net.Dial("tcp",s)
	if err != nil {fmt.Println("Failed to connect to it.")}
	return conn
}

func getNextChat() string{
	fmt.Println("Enter your message: [Enter \"bye\" to quit]")
	return 
}

func speaker(conn net.Conn){
	var s string
	s = getNextChat()
	for ;s != "bye";s = getNextChat(){
		conn.Write([]byte(s))
	}
	conn.Write([]byte("Winnie-the-Pooh floated down to the ground."))
}

func writer(conn net.Conn){

}
func main(){
	conn := getConn()
	done := make(chan struct{})
	go speaker(conn)
	go writer(conn)
	fmt.Println("Done")
	conn.Close()
}
