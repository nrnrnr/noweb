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
MANDIR=$(MAN)/man$(MANEXT)
MAN7DIR=$(MAN)/man$(MAN7EXT)

all:
	(cd c && $(MAKE) "CC=$(CC)" "CFLAGS=$(CFLAGS)" $@)
	for i in shell lib xdoc tex; do (cd $$i && $(MAKE) $@); done
	(cd $(LIBSRC) && $(MAKE) "ICONT=$(ICONT)" "ICONC=$(ICONC)" $@)

FAQ: FAQ.html
	sleep 1; html2ascii FAQ.html > $@

FAQ.html: $(HOME)/www/noweb/FAQ.html
	rm -f $@
	cp $(HOME)/www/noweb/FAQ.html $@
	chmod -w $@

install: install-code install-man install-tex install-elisp
uninstall: uninstall-code uninstall-man uninstall-tex uninstall-elisp
	-rmdir $(BIN) $(LIB) 2>/dev/null || true

install-shell:
	mkdir -p $(BIN) $(LIB)
	sed "s@|LIBDIR|@$(LIB)@" shell/noweb > $(BIN)/noweb
	chmod +x $(BIN)/noweb
	sed "s@|LIBDIR|@$(LIB)@" shell/notangle > $(BIN)/notangle
	chmod +x $(BIN)/notangle
	sed "s@|LIBDIR|@$(LIB)@" shell/$(WEAVE) > $(BIN)/$(WEAVE)
	chmod +x $(BIN)/$(WEAVE)
	sed "s@|LIBDIR|@$(LIB)@" shell/nountangle > $(BIN)/nountangle
	chmod +x $(BIN)/nountangle
	sed "s@|LIBDIR|@$(LIB)@" shell/nodefs > $(BIN)/nodefs
	chmod +x $(BIN)/nodefs
	sed "s@|LIBDIR|@$(LIB)@" shell/noroots > $(BIN)/noroots
	chmod +x $(BIN)/noroots
	sed "s@|LIBDIR|@$(LIB)@" shell/nuweb2noweb > $(BIN)/nuweb2noweb
	chmod +x $(BIN)/nuweb2noweb
	sed "s@|LIBDIR|@$(LIB)@" shell/cpif > $(BIN)/cpif
	chmod +x $(BIN)/cpif
	sed "s@|LIBDIR|@$(LIB)@" shell/htmltoc > $(BIN)/htmltoc
	chmod +x $(BIN)/htmltoc
	sed "s@|LIBDIR|@$(LIB)@" shell/noroff > $(BIN)/noroff
	chmod +x $(BIN)/noroff
	sed "s@|LIBDIR|@$(LIB)@" shell/toroff > $(LIB)/toroff
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
	(cd $(LIBSRC) && $(MAKE) ICONT=$(ICONT) ICONC=$(ICONC) LIB=$(LIB) BIN=$(BIN) install)
	(cd lib && $(MAKE) LIB=$(LIB) install)

uninstall-code: uninstall-shell
	rm -f $(LIB)/nt $(LIB)/markup $(LIB)/mnt $(LIB)/finduses
	(cd $(LIBSRC) && $(MAKE) ICONT=$(ICONT) ICONC=$(ICONC) LIB=$(LIB) BIN=$(BIN) uninstall)
	(cd lib && $(MAKE) LIB=$(LIB) uninstall)
install-man:
	mkdir -p $(MANDIR) $(MAN7DIR)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/cpif.1 > $(MANDIR)/cpif.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/nodefs.1 > $(MANDIR)/nodefs.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/noroots.1 > $(MANDIR)/noroots.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/noweb.1 > $(MANDIR)/noweb.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/noindex.1 > $(MANDIR)/noindex.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/nuweb2noweb.1 > $(MANDIR)/nuweb2noweb.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/notangle.1 > $(MANDIR)/notangle.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/noroff.1 > $(MANDIR)/noroff.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/sl2h.1 > $(MANDIR)/sl2h.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/htmltoc.1 > $(MANDIR)/htmltoc.$(MANEXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/nowebstyle.7 > $(MAN7DIR)/nowebstyle.$(MAN7EXT)
	sed -e "s@|LIBDIR|@$(LIB)@" -e "s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/nowebfilters.7 > $(MAN7DIR)/nowebfilters.$(MAN7EXT)
	rm -f $(MANDIR)/noweave.$(MANEXT)
	(cd $(MANDIR) && ln notangle.$(MANEXT) noweave.$(MANEXT))
	rm -f $(MANDIR)/nountangle.$(MANEXT)
	(cd $(MANDIR) && ln notangle.$(MANEXT) nountangle.$(MANEXT))
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
source: FAQ
	for i in c shell lib xdoc icon awk tex; do (cd $$i && $(MAKE) CPIF=">" $@); done
	sleep 1
	for i in c shell lib xdoc icon awk tex; do (cd $$i && $(MAKE) touch); done
touch:
	touch FAQ
	for i in c shell lib xdoc icon awk tex; do (cd $$i && $(MAKE) $@); done
boot:
	for i in c shell lib xdoc icon awk tex; do (cd $$i && $(MAKE) $@); done
clean:
	for i in c shell lib xdoc icon awk tex; do (cd $$i && $(MAKE) $@); done
	rm -f nwsrcfilter *~ */*~

clobber: clean
	for i in c shell lib xdoc icon awk tex; do (cd $$i && $(MAKE) $@); done

Makefile: Makefile.nw
	chmod +w $@
	notangle -R'script' Makefile.nw | sh > $@
	chmod -w $@

