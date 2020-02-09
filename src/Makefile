# Copyright 1995-2018 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.
#
# Adjust these two lines for your ANSI C compiler
CC=gcc
CFLAGS=-ansi -pedantic -O -Wall -Werror
# If you have Icon, you should use the Icon versions of the noweb pipeline.
# Set LIBSRC=icon
LIBSRC=awk
ICONT=icont

# BIN is where the commands (notangle, noweave, nountangle, noroots) land
# LIB is where the pieces of the pipes (nt, markup, unmarkup) are stored
# MAN is the root of your local man pages directory
# MANEXT is the extension for your commands' man pages (usually 1 or l)
# MAN7EXT is the extension for the nowebstyle man page (usually 7)
# TEXINPUTS is the directory for TeX macro files
# ELISP is the directory for emacs lisp files, or blank to not install
PREFIX=/usr/local
BIN=$(PREFIX)/bin
LIB=$(PREFIX)/libexec/noweb
MAN=$(PREFIX)/share/man
MANEXT=1
MAN7EXT=7
TEXINPUTS=$(PREFIX)/tex/inputs
ELISP=

# change WEAVE if you want a different version of noweave to be installed
WEAVE=noweave

# Stop editing.	 No user-serviceable parts below.
SHELL=/bin/sh
MANDIR=$(MAN)/man$(MANEXT)
MAN7DIR=$(MAN)/man$(MAN7EXT)

all:
	(cd c && $(MAKE) "CC=$(CC)" "CFLAGS=$(CFLAGS)" $@)
	for i in shell lib xdoc tex; do (cd $$i && $(MAKE) $@); done
	(cd $(LIBSRC) && $(MAKE) "ICONT=$(ICONT)" $@)

FAQ: FAQ.html
	sleep 1; html2ascii FAQ.html > $@

FAQ.html: $(HOME)/www/noweb/FAQ.html
	rm -f $@
	cp $(HOME)/www/noweb/FAQ.html $@
	chmod -w $@

install: install-code install-man install-tex install-elisp
uninstall: uninstall-code uninstall-man uninstall-tex uninstall-elisp
	-rmdir $(DESTDIR)$(BIN) $(DESTDIR)$(LIB) 2>/dev/null || true

install-shell:
	mkdir -p $(DESTDIR)$(BIN) $(DESTDIR)$(LIB)
	sed "s@|LIBDIR|@$(LIB)@" shell/noweb > $(DESTDIR)$(BIN)/noweb
	chmod +x $(DESTDIR)$(BIN)/noweb
	sed "s@|LIBDIR|@$(LIB)@" shell/notangle > $(DESTDIR)$(BIN)/notangle
	chmod +x $(DESTDIR)$(BIN)/notangle
	sed "s@|LIBDIR|@$(LIB)@" shell/$(WEAVE) > $(DESTDIR)$(BIN)/$(WEAVE)
	chmod +x $(DESTDIR)$(BIN)/$(WEAVE)
	sed "s@|LIBDIR|@$(LIB)@" shell/nountangle > $(DESTDIR)$(BIN)/nountangle
	chmod +x $(DESTDIR)$(BIN)/nountangle
	sed "s@|LIBDIR|@$(LIB)@" shell/nodefs > $(DESTDIR)$(BIN)/nodefs
	chmod +x $(DESTDIR)$(BIN)/nodefs
	sed "s@|LIBDIR|@$(LIB)@" shell/noroots > $(DESTDIR)$(BIN)/noroots
	chmod +x $(DESTDIR)$(BIN)/noroots
	sed "s@|LIBDIR|@$(LIB)@" shell/nuweb2noweb > $(DESTDIR)$(BIN)/nuweb2noweb
	chmod +x $(DESTDIR)$(BIN)/nuweb2noweb
	sed "s@|LIBDIR|@$(LIB)@" shell/cpif > $(DESTDIR)$(BIN)/cpif
	chmod +x $(DESTDIR)$(BIN)/cpif
	sed "s@|LIBDIR|@$(LIB)@" shell/htmltoc > $(DESTDIR)$(BIN)/htmltoc
	chmod +x $(DESTDIR)$(BIN)/htmltoc
	sed "s@|LIBDIR|@$(LIB)@" shell/noroff > $(DESTDIR)$(BIN)/noroff
	chmod +x $(DESTDIR)$(BIN)/noroff
	sed "s@|LIBDIR|@$(LIB)@" shell/toroff > $(DESTDIR)$(LIB)/toroff
	chmod +x $(DESTDIR)$(LIB)/toroff
	cp shell/tmac.w $(DESTDIR)$(LIB)

uninstall-shell:
	rm -f $(DESTDIR)$(BIN)/noweb
	rm -f $(DESTDIR)$(BIN)/notangle
	rm -f $(DESTDIR)$(BIN)/$(WEAVE)
	rm -f $(DESTDIR)$(BIN)/nountangle
	rm -f $(DESTDIR)$(BIN)/nodefs
	rm -f $(DESTDIR)$(BIN)/noroots
	rm -f $(DESTDIR)$(BIN)/nuweb2noweb
	rm -f $(DESTDIR)$(BIN)/cpif
	rm -f $(DESTDIR)$(BIN)/htmltoc
	rm -f $(DESTDIR)$(BIN)/noroff
	rm -f $(DESTDIR)$(LIB)/toroff
	rm -f $(DESTDIR)$(LIB)/tmac.w

install-code: install-shell
	mkdir -p $(DESTDIR)$(BIN) $(DESTDIR)$(LIB)
	strip c/nt c/markup c/mnt c/finduses c/nwmktemp
	cp c/nt c/markup c/mnt c/finduses c/nwmktemp $(DESTDIR)$(LIB)
	(cd $(LIBSRC) && $(MAKE) ICONT=$(ICONT) LIB=$(LIB) BIN=$(BIN) install)
	(cd lib && $(MAKE) LIB=$(LIB) install)

uninstall-code: uninstall-shell
	for i in nt markup mnt finduses nwmktemp; do rm -f $(DESTDIR)$(LIB)/$$i; done
	(cd $(LIBSRC) && $(MAKE) ICONT=$(ICONT) LIB=$(LIB) BIN=$(BIN) uninstall)
	(cd lib && $(MAKE) LIB=$(LIB) uninstall)
install-man:
	mkdir -p $(DESTDIR)$(MANDIR) $(DESTDIR)$(MAN7DIR)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/cpif.1 > $(DESTDIR)$(MANDIR)/cpif.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/nodefs.1 > $(DESTDIR)$(MANDIR)/nodefs.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/noroots.1 > $(DESTDIR)$(MANDIR)/noroots.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/noweb.1 > $(DESTDIR)$(MANDIR)/noweb.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/noindex.1 > $(DESTDIR)$(MANDIR)/noindex.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/nuweb2noweb.1 > $(DESTDIR)$(MANDIR)/nuweb2noweb.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/notangle.1 > $(DESTDIR)$(MANDIR)/notangle.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/noroff.1 > $(DESTDIR)$(MANDIR)/noroff.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/sl2h.1 > $(DESTDIR)$(MANDIR)/sl2h.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/htmltoc.1 > $(DESTDIR)$(MANDIR)/htmltoc.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/nowebstyle.7 > $(DESTDIR)$(MAN7DIR)/nowebstyle.$(MAN7EXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/nowebfilters.7 > $(DESTDIR)$(MAN7DIR)/nowebfilters.$(MAN7EXT)
	rm -f $(DESTDIR)$(MANDIR)/noweave.$(MANEXT)
	(cd $(DESTDIR)$(MANDIR) && ln -s notangle.$(MANEXT) noweave.$(MANEXT))
	rm -f $(DESTDIR)$(MANDIR)/nountangle.$(MANEXT)
	(cd $(DESTDIR)$(MANDIR) && ln -s notangle.$(MANEXT) nountangle.$(MANEXT))
uninstall-man:
	rm -f $(DESTDIR)$(MANDIR)/cpif.$(MANEXT)
	rm -f $(DESTDIR)$(MANDIR)/nodefs.$(MANEXT)
	rm -f $(DESTDIR)$(MANDIR)/noroots.$(MANEXT)
	rm -f $(DESTDIR)$(MANDIR)/noweb.$(MANEXT)
	rm -f $(DESTDIR)$(MANDIR)/noindex.$(MANEXT)
	rm -f $(DESTDIR)$(MANDIR)/nuweb2noweb.$(MANEXT)
	rm -f $(DESTDIR)$(MANDIR)/notangle.$(MANEXT)
	rm -f $(DESTDIR)$(MANDIR)/noroff.$(MANEXT)
	rm -f $(DESTDIR)$(MANDIR)/sl2h.$(MANEXT)
	rm -f $(DESTDIR)$(MANDIR)/htmltoc.$(MANEXT)
	rm -f $(DESTDIR)$(MAN7DIR)/nowebstyle.$(MAN7EXT)
	rm -f $(DESTDIR)$(MAN7DIR)/nowebfilters.$(MAN7EXT)
	rm -f $(DESTDIR)$(MANDIR)/noweave.$(MANEXT)
	rm -f $(DESTDIR)$(MANDIR)/nountangle.$(MANEXT)
	-rmdir $(DESTDIR)$(MANDIR) $(DESTDIR)$(MAN7DIR) $(DESTDIR)$(MAN) 2>/dev/null || true
install-tex:
	mkdir -p $(DESTDIR)$(TEXINPUTS)
	cp tex/nwmac.tex tex/noweb.sty $(DESTDIR)$(TEXINPUTS)
	-texhash || echo "Program texhash not found or failed"

uninstall-tex:
	for i in nwmac.tex noweb.sty; do rm -f $(DESTDIR)$(TEXINPUTS)/$$i; done

install-elisp:
	if [ -n "$(ELISP)" ]; then mkdir -p $(DESTDIR)$(ELISP); cp elisp/noweb-mode.el $(DESTDIR)$(ELISP); fi

uninstall-elisp:
	if [ -n "$(ELISP)" ]; then rm -f $(DESTDIR)$(ELISP)/noweb-mode.el; fi
source: FAQ
	for i in c shell lib xdoc icon awk tex; do (cd $$i && $(MAKE) CPIF=">" $@); done
touch:
	touch FAQ
	for i in c shell lib xdoc icon awk tex; do (cd $$i && $(MAKE) $@); done
clobber: clean
	rm -f FAQ
	for i in c shell lib xdoc icon awk tex; do (cd $$i && $(MAKE) $@); done
clean:
	rm -f *~ */*~
	for i in c shell lib xdoc icon awk tex; do (cd $$i && $(MAKE) $@); done

Makefile: Makefile.nw
	chmod +w $@
	notangle -R'script' Makefile.nw | sh > $@
	chmod -w $@

