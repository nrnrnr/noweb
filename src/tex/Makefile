SHELL=/bin/sh
NAME="name of version checked in"
CIMSG="message for version checked in"
RCSFILES=support.nw Makefile

all: nwmac.tex noweb.sty
source: nwmac.tex noweb.sty
touch: nwmac.tex noweb.sty
	touch nwmac.tex noweb.sty

checkin:
	ci -l $(CINAME) $(CIMSG) $(RCSFILES)

nwmac.tex: support.nw
	notangle -Rnwmac.tex support.nw > nwmac.tex

noweb.sty: support.nw
	notangle -Rnoweb.sty support.nw > noweb.sty

support.tex: support.nw
	noweave -delay -x support.nw > support.tex

clean: 
	/bin/rm -f *~ *.dvi *.aux *.log *.blg *.bbl *.toc
	/bin/rm -f support.tex
