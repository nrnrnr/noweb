LIB=/dev/null	# to be overridden by install

.SUFFIXES: .nw .icn
.nw.icn: ;	notangle -L'#line %-1L "%F"%N' $*.nw | cpif $*.icn

all: d2tex
source: d2tex
install:
	cp d2tex $(LIB)/dijkstra.filter

# TeX files.
hospital.tex: hospital.nw d2tex
	noweave -delay -filter ./d2tex hospital.nw > hospital.tex
clean:
	/bin/rm -f hospital.tex *.dvi *.aux *.log *.blg *.bbl *~ 
