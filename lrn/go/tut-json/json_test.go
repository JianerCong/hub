package json_test

import (
	"fmt"
	"encoding/json"
)

func Example_struct2json() {
	type Book struct {
    Name string
    Author string
	}

	book := Book{"aaa", "A1"}
	res, err := json.Marshal(book)

	if err != nil {fmt.Println(err)}

	fmt.Println(string(res))
	// Output:
	// {"Name":"aaa","Author":"A1"}

}

func Example_json2struct() {
	type Game struct {
    Name string
    Rating float64
	}
	codString := `{"Name": "aaa", "Rating": 1.1}`

	var cod Game

	err := json.Unmarshal([]byte(codString), &cod)

	if err != nil {fmt.Println(err)}

	fmt.Printf("%+v\n", cod)
	// Output:
	// {Name:aaa Rating:1.1}
}

func Example_jsonArray2structSlice() {
	type Software struct {
    Name string
    Developer string
	}
	softwaresJson := `[{"Name": "s1","Developer": "d1"},{"Name": "s2","Developer": "d2"},{"Name": "s3","Developer": "d3"}]`

	var softwares []Software

	err := json.Unmarshal([]byte(softwaresJson), &softwares)

	if err != nil {
		fmt.Println(err)
	}

	fmt.Printf("%v\n", softwares)
	// Output:
	// [{s1 d1} {s2 d2} {s3 d3}]
}

func Example_slice2jsonArray() {
	type App struct {
    Name string
	}
	apps := []App{
		{Name: "a1"},
		{Name: "a2"},
		{Name: "a3"},
	}

	appsJson, err := json.Marshal(apps)

	if err != nil {
		fmt.Println(err)
	}

	fmt.Println(string(appsJson))

	// Output:
	// [{"Name":"a1"},{"Name":"a2"},{"Name":"a3"}]
}

func Example_customAttributes() {
	type Book struct {
    Name string `json:"title"`
    Author string `json:"author"`
	}

	book := Book{"aaa", "A1"}
	res, err := json.Marshal(book)

	if err != nil {fmt.Println(err)}

	fmt.Println(string(res))
	// Output:
	// {"title":"aaa","author":"A1"}
}

func Example_unstructuredJSON2map() {
	unstructuredJson := `{"os": {"Windows": "Windows OS","Mac": "OSX","Linux": "Ubuntu"},"compilers": "gcc"}`
	var result map[string]interface{}

	json.Unmarshal([]byte(unstructuredJson), &result)
	os := result["os"]
	fmt.Println(os)

	// cast interface into underlying map
	m := os.(map[string]interface{})
	fmt.Println(m["Windows"])

	// Output:
	// map[Linux:Ubuntu Mac:OSX Windows:Windows OS]
	// Windows OS
}

func Example_nestedStruct2JSON() {
	type Address struct {
    Street string
    City string
	}

	type Person struct {
    Name string
    Address Address
	}
	p := Person{
		Name: "aaa",
		Address: Address{
			"a1",
			"a2",
		},
	}

	str, err := json.Marshal(p)

	if err != nil {
		fmt.Println(err)
	}

	fmt.Println(string(str))

	// Output:
	// {"Name":"aaa","Address":{"Street":"a1","City":"a2"}}
}

