# Copyright 1993 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.
SHELL=/bin/sh
LIB=/usr/public/pkg/noweb/lib

EXEC=noweave noweb notangle noroff toroff
SRCS=$(EXEC) tmac.w
RCSFILES=noweave.nw notangle.nw noweb.nw noroff.nw noroots nocount Makefile
CINAME=
CIMSG=

all:	$(SRCS)
source: $(SRCS)
touch:	$(SRCS)
	touch $(SRCS)

checkin:
	ci -l $(CINAME) $(CIMSG) $(RCSFILES)

noweave: noweave.nw
	notangle -Rnoweave noweave.nw > noweave

notangle: notangle.nw
	notangle -Rnotangle notangle.nw > notangle

noweb: noweb.nw 
	notangle -Rnoweb noweb.nw > noweb

noroff toroff tmac.w: roff.nw
	noweb -t roff.nw

clean: ;	rm -f *.log *.blg *.dvi *.toc *.aux *.tex *~
clobber: clean ;	rm -f $(SRCS)
