# Copyright 1993 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.

LIB=/dev/null  # must be overridden
BIN=/dev/null  # must be overridden
SHELL=/bin/sh

LIBEXECSBARE=noidx tohtml
LIBEXECSDEP=totex
LIBEXECS=$(LIBEXECSBARE) $(LIBEXECSDEP)
BINEXECS=noindex
EXECS=$(BINEXECS) $(LIBEXECS)

all: $(EXECS)
sources: $(EXECS)
touch: $(EXECS)
	touch $(EXECS)
boot:
	touch $(EXECS)

install: all
	cp $(LIBEXECSBARE) $(LIB)
	for i in $(LIBEXECSDEP); do \
	  sed "s@|LIBDIR|@$(LIB)@" $$i > $(LIB)/$$i && chmod +x $(LIB)/$$i; \
	done
	cp $(BINEXECS) $(BIN)

uninstall:
	for i in $(LIBEXECS); do rm -f $(LIB)/$$i; done
	for i in $(BINEXECS); do rm -f $(BIN)/$$i; done

source: $(EXECS)

totex: totex.nw
	notangle -R$@ totex.nw > $@
	chmod +x $@

noidx: noidx.nw
	notangle noidx.nw > $@
	chmod +x $@

tohtml: tohtml.nw
	notangle tohtml.nw > $@
	chmod +x $@

noindex: noindex.nw
	notangle -R$@ noindex.nw > $@
	chmod +x $@

clean:
	rm -f *.log *.blg *.dvi *.toc *.aux *.tex *~ *.html
clobber: clean
	rm -f totex noidx tohtml noindex
