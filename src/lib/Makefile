# Copyright 1993 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.

LIB=/dev/null
SHELL=/bin/sh
CINAME=
CIMSG=
RCSFILES=emptydefn toascii.nw unmarkup Makefile nwmtime pipedocs h2a btdefn

all: toascii
	chmod +x unmarkup emptydefn toascii nwmtime pipedocs h2a btdefn

install: all
	cp unmarkup emptydefn nwmtime btdefn $(LIB)
	sed 's@|LIBDIR|@$(LIB)@g' pipedocs > $(LIB)/pipedocs
	sed 's@|LIBDIR|@$(LIB)@g' toascii > $(LIB)/toascii
	sed 's@|LIBDIR|@$(LIB)@g' h2a > $(LIB)/h2a
	chmod +x $(LIB)/pipedocs $(LIB)/toascii $(LIB)/h2a

uninstall:
	for i in unmarkup emptydefn toascii nwmtime h2a btdefn; do rm -f $(LIB)/$$i; done
	rm -f $(LIB)/pipedocs

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
