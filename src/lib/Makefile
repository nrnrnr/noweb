# Copyright 1993 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.

LIB=/dev/null
SHELL=/bin/sh
CINAME=
CIMSG=
RCSFILES=emptydefn toascii.nw autolang.nw unmarkup Makefile nwmtime pipedocs h2a btdefn

all: toascii autolang
	chmod +x unmarkup emptydefn nwmtime pipedocs h2a btdefn

install: all
	cp unmarkup emptydefn toascii autolang nwmtime btdefn $(LIB)
	for i in pipedocs h2a; do \
	  sed "s@|LIBDIR|@$(LIB)@g" $$i > $(LIB)/$$i && chmod +x $(LIB)/$$i; \
	done

uninstall:
	for i in unmarkup emptydefn toascii autolang nwmtime pipedocs h2a btdefn; do \
	  rm -f $(LIB)/$$i; \
	done

source: toascii autolang
touch: toascii autolang
	touch toascii autolang
boot:
	touch toascii autolang

toascii: toascii.nw
	notangle -R$@ toascii.nw > $@
	chmod +x $@

autolang: autolang.nw
	notangle -R$@ autolang.nw > $@
	chmod +x $@

clean:
	rm -f *.log *.blg *.dvi *.toc *.aux *.tex *~
clobber: clean
	rm -f toascii autolang
