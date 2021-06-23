# Copyright 1993 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.
SHELL=/bin/sh

EXEC=noweave noweb notangle noroff toroff
SRCS=$(EXEC) tmac.w

all: $(SRCS)

source: $(SRCS)
touch:
	touch $(SRCS)
clobber: clean
	rm -f $(SRCS)

noweave: noweave.nw
	notangle -R$@ noweave.nw > $@

notangle: notangle.nw
	notangle -R$@ notangle.nw > $@

noweb: noweb.nw
	notangle -R$@ noweb.nw > $@

noroff toroff tmac.w: roff.nw
	noweb -t roff.nw

clean:
	rm -f *.log *.blg *.dvi *.toc *.aux *.tex *~ *.nwt roff.mm
