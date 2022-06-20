all:
	cc -c cipher_decode.c					#⇒ cipher_decode.o
	cc -c cipher_encode.c					#⇒ cipher_encode.o
	ar -crs libcipher.a cipher_encode.o cipher_decode.o
# ⇒ libcipher.a
# c: (create) r (add with replace) s (index the table)
# use ar -t libcipher.a to see

clean:
	rm *.a *.o

# Local Variables:
# mode: makefile
# End:
