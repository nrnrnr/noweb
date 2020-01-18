# Copyright 1995-2018 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.
#
# Adjust these two lines for your ANSI C compiler
CC=gcc -ansi -pedantic -O -Wall -Werror
CFLAGS=
# If you have Icon, you should use the Icon versions of the noweb pipeline.
# Set LIBSRC=icon
LIBSRC=awk
# If you have no Icon compiler, but do have icont, make ICONC=icont
ICONC=iconc
ICONT=icont

# BIN is where the commands (notangle, noweave, nountangle, noroots) land
# LIB is where the pieces of the pipes (nt, markup, unmarkup) are stored
# MAN is the root of your local man pages directory
# MANEXT is the extension for your commands' man pages (usually 1 or l)
# MAN7EXT is the extension for the nowebstyle man page (usually 7)
# TEXINPUTS is the directory for TeX macro files
# ELISP is the directory for emacs lisp files, or /dev/null not to install
BIN=/usr/local/noweb
LIB=/usr/local/noweb/lib
MAN=/usr/local/noweb/man
MANEXT=1
MAN7EXT=7
TEXINPUTS=/usr/local/tex/inputs
ELISP=/dev/null

# change WEAVE if you want a different version of noweave to be installed
WEAVE=noweave

# Stop editing.	 No user-serviceable parts below.
SHELL=/bin/sh
CINAME=
CIMSG=
MANDIR=$(MAN)/man$(MANEXT)
MAN7DIR=$(MAN)/man$(MAN7EXT)
CATDIR=$(MAN)/cat$(MANEXT)
CAT7DIR=$(MAN)/cat$(MAN7EXT)
LIBNAME=$(LIB)
TEXNAME=$(TEXINPUTS)

all:
	cd c; make "CC=$(CC)" "CFLAGS=$(CFLAGS)" all
	for i in shell lib xdoc tex; do (cd $$i; make all); done
	cd $(LIBSRC); make "ICONT=$(ICONT)" "ICONC=$(ICONC)" all

FAQ: FAQ.html
	sleep 1; html2ascii FAQ.html > FAQ

FAQ.html: $(HOME)/www/noweb/FAQ.html
	rm -f FAQ.html
	/bin/cp $(HOME)/www/noweb/FAQ.html FAQ.html
	chmod -w FAQ.html

install: install-code install-man install-tex install-elisp
uninstall: uninstall-code uninstall-man uninstall-tex uninstall-elisp
	-rmdir $(BIN) $(LIB) 2>/dev/null || true

install-shell:
	mkdir -p $(BIN) $(LIB)
	sed "s@|LIBDIR|@$(LIBNAME)@" shell/noweb > $(BIN)/noweb
	chmod +x $(BIN)/noweb
	sed "s@|LIBDIR|@$(LIBNAME)@" shell/notangle > $(BIN)/notangle
	chmod +x $(BIN)/notangle
	sed "s@|LIBDIR|@$(LIBNAME)@" shell/$(WEAVE) > $(BIN)/$(WEAVE)
	chmod +x $(BIN)/$(WEAVE)
	sed "s@|LIBDIR|@$(LIBNAME)@" shell/nountangle > $(BIN)/nountangle
	chmod +x $(BIN)/nountangle
	sed "s@|LIBDIR|@$(LIBNAME)@" shell/nodefs > $(BIN)/nodefs
	chmod +x $(BIN)/nodefs
	sed "s@|LIBDIR|@$(LIBNAME)@" shell/noroots > $(BIN)/noroots
	chmod +x $(BIN)/noroots
	sed "s@|LIBDIR|@$(LIBNAME)@" shell/nuweb2noweb > $(BIN)/nuweb2noweb
	chmod +x $(BIN)/nuweb2noweb
	sed "s@|LIBDIR|@$(LIBNAME)@" shell/cpif > $(BIN)/cpif
	chmod +x $(BIN)/cpif
	sed "s@|LIBDIR|@$(LIBNAME)@" shell/htmltoc > $(BIN)/htmltoc
	chmod +x $(BIN)/htmltoc
	sed "s@|LIBDIR|@$(LIBNAME)@" shell/noroff > $(BIN)/noroff
	chmod +x $(BIN)/noroff
	sed "s@|LIBDIR|@$(LIBNAME)@" shell/toroff > $(LIB)/toroff
	chmod +x $(LIB)/toroff
	cp shell/tmac.w $(LIB)

uninstall-shell:
	rm -f $(BIN)/noweb
	rm -f $(BIN)/notangle
	rm -f $(BIN)/$(WEAVE)
	rm -f $(BIN)/nountangle
	rm -f $(BIN)/nodefs
	rm -f $(BIN)/noroots
	rm -f $(BIN)/nuweb2noweb
	rm -f $(BIN)/cpif
	rm -f $(BIN)/htmltoc
	rm -f $(BIN)/noroff
	rm -f $(LIB)/toroff
	rm -f $(LIB)/tmac.w

install-code: install-shell
	mkdir -p $(BIN) $(LIB)
	strip c/nt c/markup c/mnt c/finduses c/nwmktemp
	cp c/nt c/markup c/mnt c/finduses c/nwmktemp $(LIB)
	cd $(LIBSRC); make ICONT=$(ICONT) ICONC=$(ICONC) LIB=$(LIB) BIN=$(BIN) install
	cd lib; make LIB=$(LIB) install

uninstall-code: uninstall-shell
	rm -f $(LIB)/nt $(LIB)/markup $(LIB)/mnt $(LIB)/finduses
	cd $(LIBSRC); make ICONT=$(ICONT) ICONC=$(ICONC) LIB=$(LIB) BIN=$(BIN) uninstall
	cd lib; make LIB=$(LIB) uninstall
install-man:
	mkdir -p $(MAN) $(MANDIR) $(MAN7DIR)
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/cpif.1 > $(MANDIR)/cpif.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/nodefs.1 > $(MANDIR)/nodefs.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/noroots.1 > $(MANDIR)/noroots.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/noweb.1 > $(MANDIR)/noweb.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/noindex.1 > $(MANDIR)/noindex.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/nuweb2noweb.1 > $(MANDIR)/nuweb2noweb.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/notangle.1 > $(MANDIR)/notangle.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/noroff.1 > $(MANDIR)/noroff.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/sl2h.1 > $(MANDIR)/sl2h.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/htmltoc.1 > $(MANDIR)/htmltoc.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/nowebstyle.7 > $(MAN7DIR)/nowebstyle.$(MAN7EXT)
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/nowebfilters.7 > $(MAN7DIR)/nowebfilters.$(MAN7EXT)
	rm -f $(MANDIR)/noweave.$(MANEXT)
	(cd $(MANDIR); ln notangle.$(MANEXT) noweave.$(MANEXT))
	rm -f $(MANDIR)/nountangle.$(MANEXT)
	(cd $(MANDIR); ln notangle.$(MANEXT) nountangle.$(MANEXT))
uninstall-man:
	rm -f $(MANDIR)/cpif.$(MANEXT)
	rm -f $(MANDIR)/nodefs.$(MANEXT)
	rm -f $(MANDIR)/noroots.$(MANEXT)
	rm -f $(MANDIR)/noweb.$(MANEXT)
	rm -f $(MANDIR)/noindex.$(MANEXT)
	rm -f $(MANDIR)/nuweb2noweb.$(MANEXT)
	rm -f $(MANDIR)/notangle.$(MANEXT)
	rm -f $(MANDIR)/noroff.$(MANEXT)
	rm -f $(MANDIR)/sl2h.$(MANEXT)
	rm -f $(MANDIR)/htmltoc.$(MANEXT)
	rm -f $(MAN7DIR)/nowebstyle.$(MAN7EXT)
	rm -f $(MAN7DIR)/nowebfilters.$(MAN7EXT)
	rm -f $(MANDIR)/noweave.$(MANEXT)
	rm -f $(MANDIR)/nountangle.$(MANEXT)
	-rmdir $(MANDIR) $(MAN7DIR) $(MAN) 2>/dev/null || true
install-gzipped-man:
	mkdir -p $(MAN) $(MANDIR) $(MAN7DIR)
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/cpif.1  | gzip -9 > $(MANDIR)/cpif.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/nodefs.1  | gzip -9 > $(MANDIR)/nodefs.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/noroots.1  | gzip -9 > $(MANDIR)/noroots.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/noweb.1  | gzip -9 > $(MANDIR)/noweb.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/noindex.1  | gzip -9 > $(MANDIR)/noindex.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/nuweb2noweb.1  | gzip -9 > $(MANDIR)/nuweb2noweb.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/notangle.1  | gzip -9 > $(MANDIR)/notangle.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/noroff.1  | gzip -9 > $(MANDIR)/noroff.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/sl2h.1  | gzip -9 > $(MANDIR)/sl2h.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/htmltoc.1  | gzip -9 > $(MANDIR)/htmltoc.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/nowebstyle.7  | gzip -9 > $(MAN7DIR)/nowebstyle.$(MAN7EXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/nowebfilters.7  | gzip -9 > $(MAN7DIR)/nowebfilters.$(MAN7EXT).gz
	rm -f $(MANDIR)/noweave.$(MANEXT).gz
	(cd $(MANDIR); ln notangle.$(MANEXT).gz noweave.$(MANEXT).gz)
	rm -f $(MANDIR)/nountangle.$(MANEXT).gz
	(cd $(MANDIR); ln notangle.$(MANEXT).gz nountangle.$(MANEXT).gz)
install-preformat-man:
	-echo "Warning: install-preformat-man is obsolete, even on Slackware systems" 1>&2
	mkdir -p $(MAN) $(CATDIR) $(CAT7DIR)
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/cpif.txt  | gzip > $(CATDIR)/cpif.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/nodefs.txt  | gzip > $(CATDIR)/nodefs.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/noroots.txt  | gzip > $(CATDIR)/noroots.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/noweb.txt  | gzip > $(CATDIR)/noweb.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/noindex.txt  | gzip > $(CATDIR)/noindex.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/nuweb2noweb.txt  | gzip > $(CATDIR)/nuweb2noweb.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/notangle.txt  | gzip > $(CATDIR)/notangle.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/noroff.txt  | gzip > $(CATDIR)/noroff.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/sl2h.txt  | gzip > $(CATDIR)/sl2h.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/htmltoc.txt  | gzip > $(CATDIR)/htmltoc.$(MANEXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/nowebstyle.txt  | gzip > $(CAT7DIR)/nowebstyle.$(MAN7EXT).gz
	sed -e "s@|LIBDIR|@$(LIBNAME)@" -e "s@|TEXINPUTS|@$(TEXNAME)@" xdoc/nowebfilters.txt  | gzip > $(CAT7DIR)/nowebfilters.$(MAN7EXT).gz
	rm -f $(CATDIR)/noweave.$(MANEXT).gz
	(cd $(CATDIR); ln notangle.$(MANEXT).gz noweave.$(MANEXT).gz)
	rm -f $(CATDIR)/nountangle.$(MANEXT).gz
	(cd $(CATDIR); ln notangle.$(MANEXT).gz nountangle.$(MANEXT).gz)
install-tex:
	mkdir -p $(TEXINPUTS)
	cp tex/nwmac.tex tex/noweb.sty $(TEXINPUTS)
	-texhash || echo "Program texhash not found or failed"

uninstall-tex:
	rm -f $(TEXINPUTS)/nwmac.tex $(TEXINPUTS)/noweb.sty || true

install-elisp:
	if [ "/dev/null" != "$(ELISP)" ]; then mkdir -p $(ELISP); fi
	cp elisp/noweb-mode.el $(ELISP)

uninstall-elisp:
	rm -f $(ELISP)/noweb-mode.el || true
checkin:
	for i in lib tex xdoc; do (cd $$i; make "CINAME=$(CINAME)" "CIMSG=$(CIMSG)" checkin); done
	for i in c icon awk; do (cd $$i; ci -l $(CINAME) $(CIMSG) *.nw Makefile); done
	(cd elisp; ci -l $(CINAME) $(CIMSG) *.el)
	ci -l $(CINAME) $(CIMSG) Makefile.nw INSTALL INSTALL.DOS README FAQ COPYRIGHT nwmake *.nw

source: FAQ
	for i in c shell lib xdoc icon awk tex; do (cd $$i; make CPIF=">" source); done
	sleep 1
	for i in c shell lib xdoc icon awk tex; do (cd $$i; make touch); done
touch:
	touch FAQ
	for i in c shell lib xdoc icon awk tex; do (cd $$i; make touch); done
boot:
	for i in c shell lib xdoc icon awk tex; do (cd $$i; make boot); done
clean:
	for i in c shell lib xdoc icon awk tex; do (cd $$i; make clean); done
	rm -f nwsrcfilter *~ */*~

clobber: clean
	for i in c shell lib xdoc icon awk tex; do (cd $$i; make clobber); done

Makefile: Makefile.nw
	chmod +w Makefile
	notangle -R'script' Makefile.nw | sh > Makefile
	chmod -w Makefile

