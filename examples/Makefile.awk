WWW=$(HOME)/www/noweb/examples
SHELL=/bin/sh
NOTANGLE=nountangle -m3
NOWEAVE=noweave

.SUFFIXES: .i3 .m3 .nw .tex .dvi .html
.nw.html:
	$(NOWEAVE) -filter btdefn -index -html $< > $@
.nw.tex:
	$(NOWEAVE) -index -filter btdefn $< > $@
.nw.i3:
	$(NOTANGLE) -Rinterface -L'<* LINE %L "%F" *>%N' $< > $@
.nw.m3:
	$(NOTANGLE) -L'<* LINE %L "%F" *>%N' $< > $@
.tex.dvi:
	latex '\scrollmode \input '"$*"; while grep -s 'Rerun to get cross-references right' $*.log; do latex '\scrollmode \input '"$*"; done

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
	$(NOWEAVE) -index -html compress.nw > $@
compress.tex: compress.nw
	$(NOWEAVE) -index compress.nw > $@
dag.html: dag.nw
	$(NOWEAVE) -index -html dag.nw > $@
dag.tex: dag.nw
	$(NOWEAVE) -index dag.nw > $@
mipscoder.html: mipscoder.nw
	$(NOWEAVE) -index -html mipscoder.nw > $@
mipscoder.tex: mipscoder.nw
	$(NOWEAVE) -index mipscoder.nw > $@
scanner.html: scanner.nw
	$(NOWEAVE) -index -html scanner.nw > $@
scanner.tex: scanner.nw
	$(NOWEAVE) -index scanner.nw > $@
tree.html: tree.nw
	$(NOWEAVE) -index -html tree.nw > $@
tree.tex: tree.nw
	$(NOWEAVE) -index tree.nw > $@
test.html: test.nw
	$(NOWEAVE) -html test.nw > $@
test.tex: test.nw
	$(NOWEAVE) test.nw > $@
wc.html: wc.nw2html
	$(NOWEAVE) -filter btdefn -index -html -n wc.nw2html > $@
wcni.html: wc.nw2html
	$(NOWEAVE) -filter btdefn -x     -html -n wc.nw2html > $@
wc.tex: wc.nw
	$(NOWEAVE) -filter btdefn -index wc.nw > $@
