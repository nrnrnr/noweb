SHELL=/bin/sh

all: nwmac.tex noweb.sty
source: nwmac.tex noweb.sty
touch: nwmac.tex noweb.sty
	touch nwmac.tex noweb.sty
boot:
	touch nwmac.tex noweb.sty

nwmac.tex: support.nw
	notangle -R$@ support.nw > $@

noweb.sty: support.nw
	notangle -R$@ support.nw > $@

support.tex: support.nw
	noweave -delay -x support.nw > $@

clean:
	/bin/rm -f *~ *.dvi *.aux *.log *.blg *.bbl *.toc
	/bin/rm -f support.tex
clobber: clean
