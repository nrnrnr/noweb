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

gitversion.nw: ../gitversion ../../.git/refs/heads/master
	(echo "<<git version>>="; ../gitversion) > $@

noweave: noweave.nw gitversion.nw
	notangle -R$@ noweave.nw gitversion.nw > $@

notangle: notangle.nw gitversion.nw
	notangle -R$@ notangle.nw gitversion.nw > $@

noweb: noweb.nw gitversion.nw
	notangle -R$@ noweb.nw gitversion.nw > $@

noroff toroff tmac.w: roff.nw
	noweb -t roff.nw

clean:
	rm -f *.log *.blg *.dvi *.toc *.aux *.tex *~ *.nwt roff.mm
clobber: clean
	rm -f $(SRCS)
