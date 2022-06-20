o = libmytwof.so
p = /opt/myjunk/lib

all:
	cc -c f1.c
	cc -c f2.c
	cc -o $(o) -shared f1.o f2.o
	sudo mv $(o) $(p)
	cc -c m.c
	cc -o m.exe m.o -Wl,-rpath=$(p) -Wl,-L$(p) -Wl,--library=:$(o)
# -Wl,-rpath add that to exe's runtime library search path
# All param passed to ld should be prefixed with -Wl,
clean:
	rm -rf m.exe f1.o f2.o m.o
	sudo rm $(p)/$(o)

# Local Variables:
# mode: makefile
# End:
