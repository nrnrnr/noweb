# Copyright 1995-2006 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.
#
# Don't edit this file; you should be editing the Makefiles in the
# src and contrib directories.

VERSION=2.12
SHELL=/bin/sh
CINAME=-Nv`echo $(VERSION) | tr . _`
CIMSG=-f -m'standard checkin preparing to export version $(VERSION)'

all:
	@echo "You have no business running 'make' here; please look at the README file"
	@exit 1
source:
	for i in src; do (cd $$i && $(MAKE) $@); done
www:
	for i in src/xdoc examples; do (cd $$i && $(MAKE) $@); done

clean:
	for i in src examples contrib; do (cd $$i && $(MAKE) $@); done
	rm -f nwsrcfilter *~ */*~
clobber: clean
	for i in src examples contrib; do (cd $$i && $(MAKE) $@); done

DATE:
	(./echo -n "Version $(VERSION) of "; date) > $@

versioncheck:
	@if [ -z "$(UPPERVERSION)" ]; then echo "run 'make versioncheck' in the parent directory, not here" 1>&2; exit 1; fi
	@if [ "$(VERSION)" = "$(UPPERVERSION)" ]; then echo "Version $(VERSION) OK in Makefile"; else echo "Version mismatch in Makefile: upper $(UPPERVERSION) lower $(VERSION)"; exit 1; fi
	@if [ "$(VERSION)" = "`awk '{print $$2}' DATE`" ]; then echo "Version $(VERSION) OK in DATE"; else ./echo -n "Version mismatch in DATE: "; cat DATE; exit 1; fi
	@if fgrep -s "This is version $(VERSION) of " README; then echo "Version $(VERSION) OK in README"; else echo "Version mismatch in README"; exit 1; fi
	@if fgrep -s "CHANGES FOR VERSION $(VERSION)" CHANGES; then echo "Version $(VERSION) OK in CHANGES"; else echo "Version mismatch in CHANGES"; exit 1; fi
	@if fgrep -s " for version $(VERSION) of" src/README; then echo "Version $(VERSION) OK in src/README"; else echo "Version mismatch in src/README"; exit 1; fi
	@if fgrep -s "version $(VERSION)" src/xdoc/notangle.txt; then echo "Version $(VERSION) OK in src/xdoc/notangle.txt"; else echo "Version mismatch in src/xdoc/notangle.txt"; exit 1; fi

nwsrcfilter: nwsrcfilter.icn
	icont $@

tarnames: clean source nwsrcfilter DATE
	find . -not -type d -not -name FAQ.old -print | ./nwsrcfilter

tar: clean source nwsrcfilter DATE emacscheck
	chmod +w src/Makefile
	rm -rf /tmp/noweb-$(VERSION)
	mkdir -p /tmp/noweb-$(VERSION)
	tar cvf - `find . ! -type d -not -name FAQ.old -print | ./nwsrcfilter` | (cd /tmp/noweb-$(VERSION) && tar xf - )
	(cd /tmp && tar cf - noweb-$(VERSION) ) | gzip -v > ../noweb-$(VERSION).tgz
	rm -f ../noweb.tgz
	(cd .. && ln -s noweb-$(VERSION).tgz noweb.tgz)
	chmod -w src/Makefile

ctan: clean source nwsrcfilter DATE emacscheck
	chmod +w src/Makefile
	(cd src && $(MAKE) boot)
	rm -f ../noweb-$(VERSION)-ctan.zip
	find ./* ! -type d -not -name FAQ.old -not -name '.git*' -print | ./nwsrcfilter | sed 's@^@noweb/@' | ( ln -s . noweb; zip ../noweb-$(VERSION)-ctan.zip -@; rm -f noweb )
	chmod -w src/Makefile

emacscheck:
	-echo "Checking to ensure distribution matches personal emacs mode" 1>&2
	diff src/elisp/noweb-mode.el $(HOME)/emacs/noweb-mode.el

checkin:
	(cd src && $(MAKE) "CINAME=$(CINAME)" "CIMSG=$(CIMSG)" $@)
