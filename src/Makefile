# Copyright 1995-2018 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.
#
# Adjust these two lines for your ANSI C compiler
CC=gcc
CFLAGS=-ansi -pedantic -O -Wall -Werror
# If you have Icon, you should use the Icon versions of the noweb pipeline.
#LIBSRC=icon
LIBSRC=awk
# If you are lucky enough to have an Icon compiler icont, use ICONC=iconc
ICONC=icont
ICONT=icont
GITVERSION=`./gitversion`

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

# Stop editing.  No user-serviceable parts below.
SHELL=/bin/sh
CINAME=
CIMSG=
MANDIR=$(MAN)/man$(MANEXT)
MAN7DIR=$(MAN)/man$(MAN7EXT)
CATDIR=$(MAN)/cat$(MANEXT)
CAT7DIR=$(MAN)/cat$(MAN7EXT)
NORMALPAGES=cpif nodefs noroots noweb noindex nuweb2noweb notangle noroff sl2h htmltoc
NORMAL7PAGES=nowebstyle nowebfilters
LINKPAGES=noweave nountangle

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
	rmdir $(BIN) $(LIB) 2>/dev/null || true

install-shell:
	mkdir -p $(BIN) $(LIB)
	for i in noweb notangle $(WEAVE) nountangle nodefs noroots nuweb2noweb cpif htmltoc noroff; do \
	  sed "s@|LIBDIR|@$(LIB)@;s@|GITVERSION|@$(GITVERSION)@" shell/$$i > $(BIN)/$$i && chmod +x $(BIN)/$$i; \
	done
	for i in toroff; do \
	  sed "s@|LIBDIR|@$(LIB)@" shell/$$i > $(LIB)/$$i && chmod +x $(LIB)/$$i; \
	done
	cp shell/tmac.w $(LIB)

uninstall-shell:
	for i in noweb notangle $(WEAVE) nountangle nodefs noroots nuweb2noweb cpif htmltoc noroff; do \
	  rm -f $(BIN)/$$i; \
	done
	for i in toroff tmac.w; do \
	  rm -f $(LIB)/$$i; \
	done

install-code: install-shell
	mkdir -p $(BIN) $(LIB)
	for i in nt markup mnt finduses nwmktemp; do \
	  strip c/$$i; \
	  cp c/$$i $(LIB); \
	done
	(cd $(LIBSRC) && $(MAKE) "ICONT=$(ICONT)" "ICONC=$(ICONC)" LIB=$(LIB) BIN=$(BIN) install)
	(cd lib && $(MAKE) LIB=$(LIB) install)

uninstall-code: uninstall-shell
	for i in nt markup mnt finduses; do \
	  rm -f $(LIB)/$$i; \
	done
	(cd $(LIBSRC) && $(MAKE) "ICONT=$(ICONT)" "ICONC=$(ICONC)" LIB=$(LIB) BIN=$(BIN) uninstall)
	(cd lib && $(MAKE) LIB=$(LIB) uninstall)

# I do the shell directory before $(LIBSRC) so that the
# Icon version of htmltoc, if present, will overwrite the Perl version.

install-man:
	mkdir -p $(MANDIR) $(MAN7DIR)
	for i in $(NORMALPAGES); do \
	  sed "s@|LIBDIR|@$(LIB)@;s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/$$i.1 > $(MANDIR)/$$i.$(MANEXT); \
	done
	for i in $(NORMAL7PAGES); do \
	  sed "s@|LIBDIR|@$(LIB)@;s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/$$i.7 > $(MAN7DIR)/$$i.$(MAN7EXT); \
	done
	for i in $(LINKPAGES); do \
	  rm -f $(MANDIR)/$$i.$(MANEXT); \
	  (cd $(MANDIR) && ln notangle.$(MANEXT) $$i.$(MANEXT)); \
	done
uninstall-man:
	for i in $(NORMALPAGES) $(LINKPAGES); do \
	  rm -f $(MANDIR)/$$i.$(MANEXT); \
	done
	for i in $(NORMAL7PAGES); do \
	  rm -f $(MAN7DIR)/$$i.$(MAN7EXT); \
	done
	rmdir $(MANDIR) $(MAN7DIR) $(MAN) 2>/dev/null || true

# Slackware no longer uses preformatted compressed pages, just
# compressed pages.
install-gzipped-man:
	mkdir -p $(MANDIR) $(MAN7DIR)
	for i in $(NORMALPAGES); do \
	  sed "s@|LIBDIR|@$(LIB)@;s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/$$i.1 | gzip -9 > $(MANDIR)/$$i.$(MANEXT).gz; \
	done
	for i in $(NORMAL7PAGES); do \
	  sed "s@|LIBDIR|@$(LIB)@;s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/$$i.7 | gzip -9 > $(MAN7DIR)/$$i.$(MAN7EXT).gz; \
	done
	for i in $(LINKPAGES); do \
	  rm -f $(MANDIR)/$$i.$(MANEXT).gz; \
	  (cd $(MANDIR) && ln notangle.$(MANEXT).gz $$i.$(MANEXT).gz); \
	done

install-preformat-man:
	-echo "Warning: install-preformat-man is obsolete, even on Slackware systems" 1>&2
	mkdir -p $(CATDIR) $(CAT7DIR)
	for i in $(NORMALPAGES); do \
	  sed "s@|LIBDIR|@$(LIB)@;s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/$$i.txt | gzip > $(CATDIR)/$$i.$(MANEXT).gz; \
	done
	for i in $(NORMAL7PAGES); do \
	  sed "s@|LIBDIR|@$(LIB)@;s@|TEXINPUTS|@$(TEXINPUTS)@" xdoc/$$i.txt | gzip > $(CAT7DIR)/$$i.$(MAN7EXT).gz; \
	done
	for i in $(LINKPAGES); do \
	  rm -f $(CATDIR)/$$i.$(MANEXT).gz; \
	  (cd $(CATDIR) && ln notangle.$(MANEXT).gz $$i.$(MANEXT).gz); \
	done

install-tex:
	mkdir -p $(TEXINPUTS)
	for i in nwmac.tex noweb.sty; do \
	  sed "s@|GITVERSION|@$(GITVERSION)@" tex/$$i > $(TEXINPUTS)/$$i; \
	done
	-texhash || echo "Program texhash not found or failed"

uninstall-tex:
	for i in nwmac.tex noweb.sty; do \
	  rm -f $(TEXINPUTS)/$$i; \
	done

install-elisp:
	if [ "/dev/null" != "$(ELISP)" ]; then mkdir -p $(ELISP); fi
	cp elisp/noweb-mode.el $(ELISP)

uninstall-elisp:
	rm -f $(ELISP)/noweb-mode.el
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
