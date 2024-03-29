WWW=$(HOME)/www/noweb
SHELL=/bin/sh
.SUFFIXES: .1 .7 .txt .ps
.1.txt:
	nroff -man $< > $@
.1.ps:
	psroff -t -man $< > $@
.7.txt:
	nroff -man $< > $@
.7.ps:
	psroff -t -man $< > $@

MANPAGES=notangle.1   cpif.1   noweb.1   nodefs.1   noroots.1   noindex.1   \
	nowebstyle.7   nowebfilters.7   nuweb2noweb.1   sl2h.1   htmltoc.1   \
	noroff.1
TXTPAGES=notangle.txt cpif.txt noweb.txt nodefs.txt noroots.txt noindex.txt \
	nowebstyle.txt nowebfilters.txt nuweb2noweb.txt sl2h.txt htmltoc.txt \
	noroff.txt
SRCS=$(MANPAGES) $(TXTPAGES)

NAME="name of version checked in"
CIMSG="message for version checked in"
RCSFILES=*.nw *.tex Makefile
DOVERSION=./doversion

all: $(SRCS)
source: $(SRCS)
touch: $(SRCS)
	touch $(SRCS)
boot:
	touch $(SRCS)

www: $(WWW)/onepage.ps $(WWW)/guide.ps $(WWW)/guide.html

$(WWW)/onepage.ps: onepage.ps
	cp onepage.ps $(WWW)

$(WWW)/guide.ps: guide.ps
	cp guide.ps $(WWW)

$(WWW)/guide.html: guide.html
	cp guide.html $(WWW)

notangle.1: manpage.nw ../shell/noweave.nw docdate.nw
	notangle -t8 -R$@ manpage.nw ../shell/noweave.nw docdate.nw | $(DOVERSION) > $@

nowebstyle.7: manpage.nw ../tex/support.nw docdate.nw
	notangle -t8 -R$@ manpage.nw ../tex/support.nw docdate.nw | $(DOVERSION) > $@

nowebfilters.7: nowebfilters.nw docdate.nw
	notangle -t8 nowebfilters.nw docdate.nw | $(DOVERSION) > $@

noweb.1: manpage.nw docdate.nw
	notangle -t8 -R$@ manpage.nw docdate.nw | $(DOVERSION) > $@

nodefs.1: nodefs.nw docdate.nw
	notangle -t8 nodefs.nw docdate.nw | $(DOVERSION) > $@

noroots.1: noroots.nw docdate.nw
	notangle -t8 noroots.nw docdate.nw | $(DOVERSION) > $@

noindex.1: noindex.nw docdate.nw
	notangle -t8 noindex.nw docdate.nw | $(DOVERSION) > $@

sl2h.1: sl2h.nw docdate.nw
	notangle -t8 sl2h.nw docdate.nw | $(DOVERSION) > $@

htmltoc.1: htmltoc.nw docdate.nw
	notangle -t8 htmltoc.nw docdate.nw | $(DOVERSION) > $@

cpif.1: manpage.nw docdate.nw
	notangle -t8 -R$@ manpage.nw docdate.nw | $(DOVERSION) > $@

nuweb2noweb.1: manpage.nw docdate.nw
	notangle -t8 -R$@ manpage.nw docdate.nw | $(DOVERSION) > $@

noroff.1: noroff.nw docdate.nw
	notangle -t8 noroff.nw docdate.nw | $(DOVERSION) > $@

wc.tex: ../../examples/wc.nw
	(cd ../../examples && noweave -n -index wc.nw) > $@

techrep.dvi: techrep.tex wc.tex
	latex '\scrollmode \input '"techrep"
	while grep -s 'Rerun to get cross-references right' techrep.log; do latex '\scrollmode \input '"techrep"; done

onepage.dvi: onepage.tex
	latex '\scrollmode \input '"onepage"
	while grep -s 'Rerun to get cross-references right' onepage.log; do latex '\scrollmode \input '"onepage"; done

onepage.ps: onepage.dvi
	dvips -P cmz -o $@ onepage

guide.dvi: guide.tex
	latex '\scrollmode \input '"guide"
	while grep -s 'Rerun to get cross-references right' guide.log; do latex '\scrollmode \input '"guide"; done

guide.ps: guide.dvi
	dvips -P cmz -o $@ guide

guide.uu: guide.ps
	gzip < guide.ps > guide.ps.gz
	uuencode guide.ps.gz < guide.ps.gz > $@

guide.html: guide.dvi
	sl2h guide.tex | htmltoc > $@

clean:
	rm -f *.dvi *.log *.blg *~ wc.tex *.ps *.gz *.uu *.html
clobber: clean
	rm -f *.1 *.7 *.txt
