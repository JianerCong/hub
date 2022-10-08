package greetings
import (
	"fmt"
	"errors"
	"math/rand"
	"time"
)

func Hellos(names []string) (map[string] string , error) {
	msgs := make(map[string]string)
	for _, name := range names {
		msg, err := Hello(name)
		if err != nil {
			return nil, err
}
		msgs[name] = msg
	}
	return msgs, nil
}

func Hello(name string) (string, error) {
	if name == "" {
		return "", errors.New("empty name")
	}
	msg := fmt.Sprintf(randomFormat(), name)
	// use the following to make the test fail
	// msg := fmt.Sprint(randomFormat())
	return msg, nil
}

func init() {
	rand.Seed(time.Now().UnixNano())
}

func randomFormat() string {
	formats := [] string {
		"Hi, %v",
			"Ha, %v",
			"yi, %v",
		}
	return formats[rand.Intn(len(formats))]
}
