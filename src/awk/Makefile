# Copyright 1993 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.

LIB=/dev/null  # must be overridden
BIN=/dev/null  # must be overridden
SHELL=/bin/sh

LIBEXECS=totex noidx tohtml
BINEXECS=noindex 
EXECS=$(BINEXECS) $(LIBEXECS)

all:	$(EXECS)
	chmod +x $(EXECS)
sources: $(EXECS)
touch: $(EXECS)
	touch $(EXECS)

install: all
	cp $(LIBEXECS) $(LIB)
	cp $(BINEXECS) $(BIN)

source: $(EXECS)

totex: totex.nw
	notangle -Rtotex totex.nw > totex

noidx: noidx.nw
	notangle noidx.nw > noidx

tohtml: tohtml.nw
	notangle tohtml.nw > tohtml

noindex: noindex.nw 
	notangle -Rnoindex noindex.nw > noindex

clean: ;	rm -f *.log *.blg *.dvi *.toc *.aux *.tex *~ *.html
clobber: clean
	rm -f totex noidx tohtml noindex
