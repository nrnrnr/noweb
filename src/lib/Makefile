# Copyright 1993 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.

LIB=/dev/null
SHELL=/bin/sh

all: toascii
	chmod +x unmarkup emptydefn toascii nwmtime pipedocs h2a btdefn

install: all
	cp unmarkup emptydefn nwmtime btdefn $(DESTDIR)$(LIB)
	sed 's@|LIBDIR|@$(LIB)@g' pipedocs > $(DESTDIR)$(LIB)/pipedocs
	sed 's@|LIBDIR|@$(LIB)@g' toascii > $(DESTDIR)$(LIB)/toascii
	sed 's@|LIBDIR|@$(LIB)@g' h2a > $(DESTDIR)$(LIB)/h2a
	chmod +x $(DESTDIR)$(LIB)/pipedocs $(DESTDIR)$(LIB)/toascii $(DESTDIR)$(LIB)/h2a

uninstall:
	for i in unmarkup emptydefn toascii nwmtime pipedocs h2a btdefn; do rm -f $(DESTDIR)$(LIB)/$$i; done

source: toascii
touch: toascii
	touch toascii
boot:
	touch toascii

toascii: toascii.nw
	notangle -R$@ toascii.nw > $@

clean:
	rm -f *.log *.blg *.dvi *.toc *.aux *.tex *~
clobber: clean
	rm -f toascii
