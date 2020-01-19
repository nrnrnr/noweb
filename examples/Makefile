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
	$(NOWEAVE) -filter l2h -index -autodefs c -html compress.nw > $@
compress.tex: compress.nw
	$(NOWEAVE) -index -autodefs c compress.nw > $@
dag.html: dag.nw
	$(NOWEAVE) -filter l2h -index -autodefs icon -html dag.nw > $@
dag.tex: dag.nw
	$(NOWEAVE) -index -autodefs icon dag.nw > $@
mipscoder.html: mipscoder.nw
	$(NOWEAVE) -filter l2h -index -autodefs sml -html mipscoder.nw > $@
mipscoder.tex: mipscoder.nw
	$(NOWEAVE) -autodefs sml -index mipscoder.nw > $@
scanner.html: scanner.nw
	$(NOWEAVE) -filter l2h -index -autodefs c -autodefs yacc -html scanner.nw > $@
scanner.tex: scanner.nw
	$(NOWEAVE) -index -autodefs c -autodefs yacc scanner.nw > $@
tree.html: tree.nw
	$(NOWEAVE) -filter l2h -index -autodefs icon -html tree.nw > $@
tree.tex: tree.nw
	$(NOWEAVE) -index -autodefs icon tree.nw > $@
test.html: test.nw
	$(NOWEAVE) -filter l2h -html test.nw > $@
test.tex: test.nw
	$(NOWEAVE) test.nw > $@
wc.html: wc.nw2html
	$(NOWEAVE) -autodefs c -filter btdefn -index -html -n wc.nw2html > $@
wcni.html: wc.nw2html
	$(NOWEAVE) -filter btdefn -x     -html -n wc.nw2html > $@
wc.tex: wc.nw
	$(NOWEAVE) -autodefs c -filter btdefn -index wc.nw > $@
