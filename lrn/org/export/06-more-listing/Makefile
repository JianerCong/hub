tex=xelatex
f=-shell-escape
all:
	$(tex) $(f) m
	$(tex) $(f) m > /dev/null
	rm *.aux *.log *.out *.toc
	echo done

clean:
	rm *.pdf *.bbl *.blg


# Local Variables:
# mode: makefile
# End:
