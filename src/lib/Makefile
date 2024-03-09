# Copyright 1993 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.

LIB=/dev/null
SHELL=/bin/sh
CINAME=
CIMSG=
RCSFILES=emptydefn toascii.nw unmarkup Makefile nwmtime pipedocs h2a btdefn

all: toascii
	chmod +x unmarkup emptydefn nwmtime pipedocs h2a btdefn

install: all
	cp unmarkup emptydefn toascii nwmtime btdefn $(LIB)
	for i in pipedocs h2a; do \
	  sed "s@|LIBDIR|@$(LIB)@g" $$i > $(LIB)/$$i && chmod +x $(LIB)/$$i; \
	done

uninstall:
	for i in unmarkup emptydefn toascii nwmtime pipedocs h2a btdefn; do \
	  rm -f $(LIB)/$$i; \
	done

source: toascii
touch: toascii
	touch toascii
boot:
	touch toascii

toascii: toascii.nw
	notangle -R$@ toascii.nw > $@
	chmod +x $@

clean:
	rm -f *.log *.blg *.dvi *.toc *.aux *.tex *~
clobber: clean
	rm -f toascii
