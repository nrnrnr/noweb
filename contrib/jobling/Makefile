PROG=correct-refs
SCRIPTS=list-anchors.awk awk-scripts.awk

all: correct-refs.tex correct-refs.csh $(SCRIPTS)

correct-refs.tex: correct-refs.nw
	noweave -delay -index correct-refs.nw > $@

correct-refs.csh: correct-refs.nw
	notangle -R$@ correct-refs.nw | cpif $@
	chmod +x $@

list-anchors.awk: correct-refs.nw
	notangle -R$@ correct-refs.nw | cpif $@

awk-scripts.awk: correct-refs.nw
	notangle -R$@ correct-refs.nw | cpif $@

install: correct-refs.csh $(SCRIPTS)
	cp correct-refs.csh $(HOME)/bin
	cp $(SCRIPTS) $(HOME)/lib

tidy:
	-rm *~ *% *.bak *.log *.blg

clean: tidy
	-rm *.ps *.dvi *.toc *.aux *.bbl *.dep $(PROG).shar

realclean: clean
	-rm correct-refs.tex correct-refs.csh $(SCRIPTS)

shar:
	shar README Makefile $(PROG).nw > $(PROG).shar
