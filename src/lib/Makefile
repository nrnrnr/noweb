# Copyright 1993 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.

LIB=/dev/null
SHELL=/bin/sh
CINAME=
CIMSG=
RCSFILES=emptydefn toascii.nw autolang.nw tominted.nw unmarkup Makefile nwmtime pipedocs h2a btdefn

all: toascii autolang tominted noweb_lexer.py
	chmod +x unmarkup emptydefn nwmtime pipedocs h2a btdefn

install: all
	cp unmarkup emptydefn toascii autolang tominted noweb_lexer.py nwmtime btdefn $(LIB)
	for i in pipedocs h2a; do \
	  sed "s@|LIBDIR|@$(LIB)@g" $$i > $(LIB)/$$i && chmod +x $(LIB)/$$i; \
	done

uninstall:
	for i in unmarkup emptydefn toascii autolang tominted noweb_lexer.py nwmtime pipedocs h2a btdefn; do \
	  rm -f $(LIB)/$$i; \
	done

source: toascii autolang tominted noweb_lexer.py
touch: toascii autolang tominted noweb_lexer.py
	touch toascii autolang tominted noweb_lexer.py
boot:
	touch toascii autolang tominted noweb_lexer.py

toascii: toascii.nw
	notangle -R$@ toascii.nw > $@
	chmod +x $@

autolang: autolang.nw
	notangle -R$@ autolang.nw > $@
	chmod +x $@

# tominted shares autolang's language inference: its chunks come from
# autolang.nw, so both files are tangled together.
tominted: tominted.nw autolang.nw
	notangle -R$@ autolang.nw tominted.nw > $@
	chmod +x $@

noweb_lexer.py: tominted.nw
	notangle -R'[[noweb_lexer.py]]' tominted.nw > $@

clean:
	rm -f *.log *.blg *.dvi *.toc *.aux *.tex *~
clobber: clean
	rm -f toascii autolang tominted noweb_lexer.py
