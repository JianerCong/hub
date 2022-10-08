go mod init
vi client.go
go mod edit -replace hi.com/greetings=../greetings
cat go.mod
go mod tidy
go run .
