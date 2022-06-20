package main

import(
	"fmt"
	"encoding/json"
	"io/ioutil"
	)


type Pokemon struct {
	Name string `json:"name"`
	Type string `json:"type"`
	Lbs float64 `json:"lbs"`
	}

func main(){
	// While you could use ioutil.ReadAll to copy the entire contents of an io.Reader into a byte slice so it can be read by json.Unmarshal, this is inefficient.
	var pms []Pokemon
	contents, err := ioutil.ReadFile("testdata/sample.json")
	err = json.Unmarshal([]byte(contents),&pms)
	if err != nil {
		return
	}
	fmt.Println("The structure is ",pms)
	}

