md hi
cd hi
# now in ./hi
go mod init hi.com/hi
go get golang.org/x/example
vi hi.go
go run
# now in ./ -----------------------------

# create a go.work file for a workspace containing the modules in ./hi
go work init ./hi
go run hi.com/hi


# --------------------------------------------------
# clone a local copy of stringutil
git clone https://go.googlesource.com/example
# add this to the workspace
go work use ./example
emacs ./example/stringutil/toupper.go &

