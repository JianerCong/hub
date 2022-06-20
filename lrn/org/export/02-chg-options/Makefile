tex=pdflatex
all:
	$(tex) m
	# bibtex m > /dev/null
	$(tex) m > /dev/null
	rm *.aux *.log *.out *.toc
	echo done

clean:
	rm *.pdf *.bbl *.blg
