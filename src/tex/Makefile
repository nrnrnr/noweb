SHELL=/bin/sh
SRCS=nwmac.tex noweb.sty

all: $(SRCS)

source: $(SRCS)
touch:
	touch $(SRCS)
clobber: clean
	rm -f $(SRCS)

nwmac.tex: support.nw
	notangle -R$@ support.nw > $@

noweb.sty: support.nw
	notangle -R$@ support.nw > $@

support.tex: support.nw
	noweave -delay -x support.nw > $@

clean:
	rm -f *~ *.dvi *.aux *.log *.blg *.bbl *.toc
	rm -f support.tex
