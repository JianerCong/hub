f := 周报$(shell date +%Y-%m-%d).pdf

all: pdf rename

rename:
	bash -c 'cp m.pdf $(f)'

rename_win:
	bash -c 'cp mwin.pdf $(f)'

pdf:
	xelatex m
	xelatex m > /dev/null
	rm *.aux *.log

clean:
	rm *.pdf *.out
# Local Variables:
# mode: makefile
# End:
