WWW=$(HOME)/www/noweb/examples
SHELL=/bin/sh
NOTANGLE=nountangle -m3
NOWEAVE=noweave

.SUFFIXES: .i3 .m3 .nw .tex .dvi .html
.nw.html: ;	$(NOWEAVE) -filter btdefn -index -html $*.nw > $*.html
.nw.tex: ;	$(NOWEAVE) -index -filter btdefn $*.nw > $*.tex
.nw.i3:	;	$(NOTANGLE) -Rinterface -L'<* LINE %L "%F" *>%N' $*.nw > $*.i3
.nw.m3:	;	$(NOTANGLE) -L'<* LINE %L "%F" *>%N' $*.nw > $*.m3
.tex.dvi: ;	latex '\scrollmode \input '"$*"; while grep -s 'Rerun to get cross-references right' $*.log; do latex '\scrollmode \input '"$*"; done

HTML=breakmodel.html compress.html dag.html graphs.html mipscoder.html primes.html \
     scanner.html test.html tree.html wc.html wcni.html
DVI=compress.dvi dag.dvi mipscoder.dvi scanner.dvi tree.dvi test.dvi wc.dvi


texonly: $(DVI)

www: $(HTML)
	copy -v $(HTML) $(WWW)
	copy -v README.h $(WWW)/index.html

clean:
	rm -f *~ *.aux *.tex *.dvi *.log *.html *.toc

clobber: clean

compress.html: compress.nw
	$(NOWEAVE) -index -html compress.nw > compress.html
compress.tex: compress.nw
	$(NOWEAVE) -index compress.nw > compress.tex
dag.html: dag.nw
	$(NOWEAVE) -index -html dag.nw > dag.html
dag.tex: dag.nw
	$(NOWEAVE) -index dag.nw > dag.tex
mipscoder.html: mipscoder.nw
	$(NOWEAVE) -index -html mipscoder.nw > mipscoder.html
mipscoder.tex: mipscoder.nw
	$(NOWEAVE) -index mipscoder.nw > mipscoder.tex
scanner.html: scanner.nw
	$(NOWEAVE) -index -html scanner.nw > scanner.html
scanner.tex: scanner.nw
	$(NOWEAVE) -index scanner.nw > scanner.tex
tree.html: tree.nw
	$(NOWEAVE) -index -html tree.nw > tree.html
tree.tex: tree.nw
	$(NOWEAVE) -index tree.nw > tree.tex
test.html: test.nw
	$(NOWEAVE) -html test.nw > test.html
test.tex: test.nw
	$(NOWEAVE) test.nw > test.tex
wc.html: wc.nw2html
	$(NOWEAVE) -filter btdefn -index -html -n wc.nw2html > wc.html
wcni.html: wc.nw2html
	$(NOWEAVE) -filter btdefn -x     -html -n wc.nw2html > wcni.html
wc.tex: wc.nw
	$(NOWEAVE) -filter btdefn -index wc.nw > wc.tex
