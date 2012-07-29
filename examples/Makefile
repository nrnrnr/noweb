WWW=$(HOME)/www/noweb/examples
SHELL=/bin/sh
NOTANGLE=nountangle -m3
NOWEAVE=noweave

.SUFFIXES: .i3 .m3 .nw .tex .dvi .html
.nw.html: ;	$(NOWEAVE) -filter l2h -filter btdefn -index -html $*.nw > $*.html
.nw.tex: ;	$(NOWEAVE) -index -filter btdefn $*.nw > $*.tex
.nw.i3:	;	$(NOTANGLE) -Rinterface -L'<* LINE %L "%F" *>%N' $*.nw > $*.i3
.nw.m3:	;	$(NOTANGLE) -L'<* LINE %L "%F" *>%N' $*.nw > $*.m3
.tex.dvi: ;	latex '\scrollmode \input '"$*"; while grep -s 'Rerun to get cross-references right' $*.log; do latex '\scrollmode \input '"$*"; done

HTML=breakmodel.html compress.html dag.html graphs.html mipscoder.html primes.html \
     scanner.html test.html tree.html wc.html wcni.html


www: $(HTML)
	copy -v $(HTML) $(WWW)
	copy -v README.h $(WWW)/index.html

clean:
	rm -f *~ *.aux *.tex *.dvi *.log *.html *.toc

clobber: clean

compress.html: compress.nw
	$(NOWEAVE) -filter l2h -index -autodefs c -html compress.nw > compress.html
compress.tex: compress.nw
	$(NOWEAVE) -index -autodefs c compress.nw > compress.tex
dag.html: dag.nw
	$(NOWEAVE) -filter l2h -index -autodefs icon -html dag.nw > dag.html
dag.tex: dag.nw
	$(NOWEAVE) -index -autodefs icon dag.nw > dag.tex
mipscoder.html: mipscoder.nw
	$(NOWEAVE) -filter l2h -index -autodefs sml -html mipscoder.nw > mipscoder.html
mipscoder.tex: mipscoder.nw
	$(NOWEAVE) -autodefs sml -index mipscoder.nw > mipscoder.tex
scanner.html: scanner.nw
	$(NOWEAVE) -filter l2h -index -autodefs c -autodefs yacc -html scanner.nw > scanner.html
scanner.tex: scanner.nw
	$(NOWEAVE) -index -autodefs c -autodefs yacc scanner.nw > scanner.tex
tree.html: tree.nw
	$(NOWEAVE) -filter l2h -index -autodefs icon -html tree.nw > tree.html
tree.tex: tree.nw
	$(NOWEAVE) -index -autodefs icon tree.nw > tree.tex
test.html: test.nw
	$(NOWEAVE) -filter l2h -html test.nw > test.html
test.tex: test.nw
	$(NOWEAVE) test.nw > test.tex
wc.html: wc.nw2html
	$(NOWEAVE) -autodefs c -filter btdefn -index -html -n wc.nw2html > wc.html
wcni.html: wc.nw2html
	$(NOWEAVE) -filter btdefn -x     -html -n wc.nw2html > wcni.html
wc.tex: wc.nw
	$(NOWEAVE) -autodefs c -filter btdefn -index wc.nw > wc.tex
