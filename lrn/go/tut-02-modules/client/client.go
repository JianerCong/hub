package main
import (
	"fmt"
	"log"

	"hi.com/greetings"
)

func main() {
	log.SetPrefix("[client] ")
	log.SetFlags(0)

// 	msg, err := greetings.Hello("aaa")
// 	if err != nil {
// 		log.Fatal(err)
// }
// 	fmt.Println("Greeting recived: [", msg, "]")

	// for many greetings
	names := []string{"aa", "bb", "cc"}
	msg, err := greetings.Hellos(names)
	if err != nil{log.Fatal(err)}
	fmt.Println(msg)
}
