# Copyright 1993 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.

LIB=/dev/null
SHELL=/bin/sh
NAME="name of version checked in"
CIMSG="message for version checked in"
RCSFILES=emptydefn toascii.nw unmarkup Makefile

all: toascii
	chmod +x unmarkup emptydefn toascii

install: all
	cp unmarkup emptydefn toascii $(LIB)

checkin:
	ci -l -n'$(NAME) -m'$(CIMSG)' $(RCSFILES)

source: toascii
touch: toascii
	touch toascii

toascii: toascii.nw
	notangle -Rtoascii toascii.nw > toascii

clean: ;	rm -f *.log *.blg *.dvi *.toc *.aux *.tex *~
veryclean: clean
	rm -f toascii
