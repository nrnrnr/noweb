PROG = correct-refs
DOCSRC = $(PROG).tex 
PROGSRC = $(PROG).csh 
SCRIPTS = list-anchors.awk awk-scripts.awk

all:    correct-refs.tex correct-refs.csh all-scripts

correct-refs.tex: correct-refs.nw
	noweave -delay -index $< > $@

correct-refs.csh: correct-refs.nw
	notangle -Rcorrect-refs.csh $< | cpif $@
	chmod +x $@

all-scripts: correct-refs.nw
	notangle -Rlist-anchors.awk $< | cpif list-anchors.awk
	notangle -Rawk-scripts.awk $< | cpif awk-scripts.awk
	touch all-scripts

install:
	cp correct-refs.csh $(HOME)/bin
	cp *.awk $(HOME)/lib

tidy:
	-rm *~ *% *.bak *.log *.blg

clean:  tidy
	-rm *.ps *.dvi *.toc *.aux *.bbl *.dep $(PROG).shar

realclean: clean
	-rm $(DOCSRC) $(PROGSRC) $(SCRIPTS)

shar:
	shar README Makefile $(PROG).nw > $(PROG).shar
