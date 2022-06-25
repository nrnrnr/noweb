SHELL=/bin/sh
LIB=/dev/null  # to be overridden
BIN=/dev/null  # to be overridden
ICONC=icont    # change to iconc if lucky enough to have it
ICONT=icont    # override to iconc if all filters should be compiled
CPIF=| cpif    # change to ">" to insure all sources always made

LIBEXECS=totex disambiguate noidx tohtml elide l2h docs2comments \
	autodefs.tex autodefs.icon autodefs.yacc autodefs.sml autodefs.pascal \
	autodefs.promela autodefs.lrtl autodefs.asdl autodefs.mmix xchunks pipedocs
LIBSPECIAL=autodefs.cee
BINEXECS=noindex sl2h htmltoc
EXECS=$(LIBEXECS) $(BINEXECS) $(LIBSPECIAL) pdcached
SRCS=totex.icn disambiguate.icn noidx.icn texdefs.icn icondefs.icn \
	yaccdefs.icn noindex.icn smldefs.icn tohtml.icn cdefs.icn elide.icn \
	l2h.icn sl2h.icn pascaldefs.icn promeladefs.icn lrtldefs.icn asdldefs.icn \
	mmixdefs.icn htmltoc.icn xchunks.icn docs2comments.icn pipedocs.icn pdcached.icn

.SUFFIXES: .nw .icn .html .tex .dvi
.nw.icn:
	notangle -L'#line %-1L "%F"%N' $< $(CPIF) $@
.nw.html:
	noweave -filter l2h -autodefs icon -html -index $< | htmltoc > $@
.nw.tex:
	noweave -delay -autodefs icon -index $< > $@
.tex.dvi:
	latex $*; while grep -s 'Rerun to get cross' $*.log; do latex $*; done

all: $(EXECS)
source: $(SRCS)
touch: $(SRCS)
	touch $(SRCS)

boot:
	touch $(SRCS)

install: $(EXECS)
	cp $(LIBEXECS) $(LIB)
	cp $(BINEXECS) $(BIN)
	cp $(LIBSPECIAL) $(LIB)/autodefs.c

uninstall:
	for i in $(LIBEXECS); do rm -f $(LIB)/$$i; done
	for i in $(BINEXECS); do rm -f $(BIN)/$$i; done
	rm -f $(LIB)/autodefs.c

clean:
	rm -f *.tex *.dvi *.aux *.log *.blg *.bbl *~ *.toc *.html *.u1 *.u2
	rm -f *.[ch] *.ps *.gz
	rm -f $(EXECS)
	rm -f sl2h

clobber: clean
	rm -f *.icn

texdefs.icn: texdefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' texdefs.nw defns.nw $(CPIF) $@
icondefs.icn: icondefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' icondefs.nw defns.nw $(CPIF) $@
yaccdefs.icn: yaccdefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' yaccdefs.nw defns.nw $(CPIF) $@
smldefs.icn: smldefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' smldefs.nw defns.nw $(CPIF) $@
cdefs.icn: cdefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' cdefs.nw defns.nw $(CPIF) $@
pascaldefs.icn: pascaldefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' pascaldefs.nw defns.nw $(CPIF) $@
promeladefs.icn: promeladefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' promeladefs.nw defns.nw $(CPIF) $@
lrtldefs.icn: lrtldefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' lrtldefs.nw defns.nw $(CPIF) $@
asdldefs.icn: asdldefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' asdldefs.nw defns.nw $(CPIF) $@
mmixdefs.icn: mmixdefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' mmixdefs.nw defns.nw $(CPIF) $@

autodefs.tex: texdefs.icn
	$(ICONT) -o $@ texdefs.icn

autodefs.icon: icondefs.icn
	$(ICONC) -o $@ icondefs.icn

autodefs.yacc: yaccdefs.icn
	$(ICONT) -o $@ yaccdefs.icn

autodefs.sml: smldefs.icn
	$(ICONT) -o $@ smldefs.icn

autodefs.cee: cdefs.icn
	$(ICONT) -o $@ cdefs.icn

autodefs.pascal: pascaldefs.icn
	$(ICONT) -o $@ pascaldefs.icn

autodefs.promela: promeladefs.icn
	$(ICONT) -o $@ promeladefs.icn

autodefs.lrtl: lrtldefs.icn
	$(ICONT) -o $@ lrtldefs.icn

autodefs.asdl: asdldefs.icn
	$(ICONT) -o $@ asdldefs.icn

autodefs.mmix: mmixdefs.icn
	$(ICONT) -o $@ mmixdefs.icn

totex: totex.icn
	$(ICONC) totex.icn

totexnr: totexnr.icn
	$(ICONT) totexnr.icn

tohtml: tohtml.icn
	$(ICONC) tohtml.icn

docs2comments: docs2comments.icn
	$(ICONT) docs2comments.icn  # no longer compiles with iconc

xchunks: xchunks.icn
	$(ICONT) xchunks.icn

l2h.icn: l2h.nw
	notangle -L'#line %-1L "%F"%N' -R$@ l2h.nw $(CPIF) $@
l2h: l2h.icn
	$(ICONT) -o $@ l2h.icn   # no longer compiles with iconc

sl2h.icn: l2h.nw
	notangle -L'#line %-1L "%F"%N' -R$@ l2h.nw $(CPIF) $@
sl2h: sl2h.icn
	$(ICONT) -o $@ sl2h.icn   # no longer compiles with iconc

noindex: noindex.icn
	$(ICONT) noindex.icn

noidx: noidx.icn
	$(ICONT) noidx.icn  # no longer compiles with iconc

elide: elide.icn
	$(ICONT) elide.icn

pipedocs: pipedocs.icn
	$(ICONT) pipedocs.icn

pdcached: pdcached.icn
	$(ICONT) pdcached.icn

disambiguate: disambiguate.icn
	$(ICONT) disambiguate.icn

htmltoc: htmltoc.icn
	$(ICONT) htmltoc.icn
