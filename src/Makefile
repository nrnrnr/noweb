# Copyright 1993 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.
#
# Adjust these two lines for your ANSI C compiler
CC=gcc
CFLAGS=

# BIN is where the commands (notangle, noweave, nountangle, noroots) land
# LIB is where the pieces of the pipes (nt, markup, unmarkup) are stored
# MAN is the root of your local man pages directory
# MANEXT is the extension for your commands' man pages (usually 1 or l)
# TEXINPUTS is the directory for TeX macro files
BIN=/usr/public/pkg/noweb/bin
LIB=/usr/public/pkg/noweb/lib
MAN=/usr/public/pkg/noweb/man
MANEXT=1
TEXINPUTS=/usr/local/lib/tex/macros

# change WEAVE if you want a different version of noweave to be installed
WEAVE=noweave		

# Stop editing.  No user-serviceable parts below.

NAME=version
CIMSG=checked in with name $(NAME)

install:
	(cd src; make "CC=$(CC)" "CFLAGS=$(CFLAGS)" nt markup)
	strip src/nt src/markup
	cd lib; /bin/test -r noxref || cp noxref.sh noxref
	cp src/nt src/markup lib/unmarkup lib/noxref $(LIB)
	chmod +x $(LIB)/unmarkup $(LIB)/noxref
	cp tex/nwkernel.tex tex/nwmac.tex tex/noweb.sty $(TEXINPUTS)
	cp doc/cpif.1 $(MAN)/man$(MANEXT)/cpif.$(MANEXT)
	sed  -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" doc/notangle.1 > $(MAN)/man$(MANEXT)/notangle.$(MANEXT)
	cd $(MAN)/man$(MANEXT); /bin/rm -f noweave.$(MANEXT) noweb.$(MANEXT) nountangle.$(MANEXT) noroots.$(MANEXT)
	cd $(MAN)/man$(MANEXT); ln notangle.$(MANEXT) noweave.$(MANEXT); ln notangle.$(MANEXT) noweb.$(MANEXT) ; ln notangle.$(MANEXT) nountangle.$(MANEXT) ; ln notangle.$(MANEXT) noroots.$(MANEXT)
	sed "s@|LIBDIR|@$(LIB)@" bin/notangle    > $(BIN)/notangle
	sed "s@|LIBDIR|@$(LIB)@" bin/$(WEAVE)    > $(BIN)/noweave
	sed "s@|LIBDIR|@$(LIB)@" bin/nountangle  > $(BIN)/nountangle
	sed "s@|LIBDIR|@$(LIB)@" bin/noroots     > $(BIN)/noroots
	sed "s@|LIBDIR|@$(LIB)@" bin/cpif        > $(BIN)/cpif
	chmod +x $(BIN)/notangle $(BIN)/noweave $(BIN)/nountangle $(BIN)/noroots
	chmod +x $(BIN)/cpif

checkin:
	for i in bin icon lib tex; do (cd $$i; ci -n'$(NAME)' -l -r -m'$(CIMSG)' *); done
	cd doc; ci -n'$(NAME)' -l -r -m'$(CIMSG)' *.1 *.tex
	cd src; ci -n'$(NAME)' -l -r -m'$(CIMSG)' *.nw Makefile
	ci -n'$(NAME)' -l -r -m'$(CIMSG)' Makefile INSTALL README COPYRIGHT nwmake

clean:
	cd src; make clean
	rm -f doc/*.dvi doc/*.log doc/*.blg
	rm -f examples/*.tex examples/*.dvi examples/*.log examples/*.aux
	rm -f *~ */*~ lib/noxref

shar:
	rm -f lib/noxref
	(bundle `find . -print | fgrep -v /RCS | sed -e '/~$$/d' -e 's@^\./@@' -e '/^.$$/d'` ; echo 'touch src/*.[ch] ; chmod +x nwmake') | compress > ../noweb.shar.Z
