# Copyright 1993 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.
SHELL=/bin/sh
LIB=/usr/public/pkg/noweb/lib

EXEC=noweave noweb notangle noroff toroff
SRCS=$(EXEC) tmac.w
RCSFILES=noweave.nw notangle.nw noweb.nw noroff.nw noroots nocount Makefile
CINAME=
CIMSG=

all: $(SRCS)
source: $(SRCS)
touch: $(SRCS)
	touch $(SRCS)
boot:
	touch $(SRCS)

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
clobber: clean
	rm -f $(SRCS)
