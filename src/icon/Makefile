SHELL=/bin/sh
LIB=/dev/null		# to be overridden
BIN=/dev/null		# to be overridden
ICONC=iconc -p -L/usr/X11R6/lib     # override to icont if no iconc on your system
ICONT=icont		# override to iconc if all filters should be compiled
CPIF=| cpif		# change to ">" to insure all sources always made

LIBEXECS=totex disambiguate noidx tohtml elide l2h docs2comments \
       autodefs.tex autodefs.icon autodefs.yacc autodefs.sml autodefs.pascal \
	autodefs.promela autodefs.lrtl autodefs.asdl autodefs.mmix xchunks pipedocs
LIBSPECIAL=autodefs.cee
BINEXECS=noindex sl2h htmltoc
EXECS=$(LIBEXECS) $(BINEXECS) $(LIBSPECIAL)
SRCS=totex.icn disambiguate.icn noidx.icn texdefs.icn icondefs.icn \
        yaccdefs.icn noindex.icn smldefs.icn tohtml.icn cdefs.icn elide.icn \
	l2h.icn sl2h.icn pascaldefs.icn promeladefs.icn lrtldefs.icn asdldefs.icn \
	mmixdefs.icn htmltoc.icn xchunks.icn

.SUFFIXES: .nw .icn .html .tex .dvi
.nw.icn:
	notangle -L'#line %-1L "%F"%N' $*.nw $(CPIF) $*.icn
.nw.html:
	noweave -filter l2h -autodefs icon -html -index $*.nw | htmltoc > $*.html
.nw.tex:
	noweave -delay -autodefs icon -index $*.nw > $*.tex
.tex.dvi:
	latex $*; while grep -s 'Rerun to get cross' $*.log; do latex $*; done

all: $(EXECS)
source: $(SRCS)
touch: $(SRCS)
	touch $(SRCS)

install: $(EXECS)
	cp $(LIBEXECS) $(LIB)
	cp $(BINEXECS) $(BIN)
	cp $(LIBSPECIAL) $(LIB)/autodefs.c

clean:
	/bin/rm -f *.tex *.dvi *.aux *.log *.blg *.bbl *~  *.toc *.html *.u1 *.u2 
	/bin/rm -f *.[ch] *.ps *.gz
	/bin/rm -f $(EXECS)
	/bin/rm -f sl2h

clobber: clean
	/bin/rm -f *.icn

texdefs.icn: texdefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' texdefs.nw defns.nw $(CPIF) texdefs.icn
icondefs.icn: icondefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' icondefs.nw defns.nw $(CPIF) icondefs.icn
yaccdefs.icn: yaccdefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' yaccdefs.nw defns.nw $(CPIF) yaccdefs.icn
smldefs.icn: smldefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' smldefs.nw defns.nw $(CPIF) smldefs.icn
cdefs.icn: cdefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' cdefs.nw defns.nw $(CPIF) cdefs.icn
pascaldefs.icn: pascaldefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' pascaldefs.nw defns.nw $(CPIF) pascaldefs.icn
promeladefs.icn: promeladefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' promeladefs.nw defns.nw $(CPIF) promeladefs.icn
lrtldefs.icn: lrtldefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' lrtldefs.nw defns.nw $(CPIF) lrtldefs.icn
asdldefs.icn: asdldefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' asdldefs.nw defns.nw $(CPIF) asdldefs.icn
mmixdefs.icn: mmixdefs.nw defns.nw
	notangle -L'#line %-1L "%F"%N' mmixdefs.nw defns.nw $(CPIF) mmixdefs.icn

autodefs.tex: texdefs.icn
	$(ICONT) -o autodefs.tex texdefs.icn

autodefs.icon: icondefs.icn
	$(ICONC) -o autodefs.icon icondefs.icn

autodefs.yacc: yaccdefs.icn
	$(ICONT) -o autodefs.yacc yaccdefs.icn

autodefs.sml: smldefs.icn
	$(ICONT) -o autodefs.sml smldefs.icn

autodefs.cee: cdefs.icn
	$(ICONT) -o autodefs.cee cdefs.icn

autodefs.pascal: pascaldefs.icn
	$(ICONT) -o autodefs.pascal pascaldefs.icn

autodefs.promela: promeladefs.icn
	$(ICONT) -o autodefs.promela promeladefs.icn

autodefs.lrtl: lrtldefs.icn
	$(ICONT) -o autodefs.lrtl lrtldefs.icn

autodefs.asdl: asdldefs.icn
	$(ICONT) -o autodefs.asdl asdldefs.icn

autodefs.mmix: mmixdefs.icn
	$(ICONT) -o autodefs.mmix mmixdefs.icn

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
	notangle -L'#line %-1L "%F"%N' -R'l2h.icn' l2h.nw $(CPIF) l2h.icn
l2h: l2h.icn
	$(ICONT) -o l2h l2h.icn   # no longer compiles with iconc

sl2h.icn: l2h.nw
	notangle -L'#line %-1L "%F"%N' -R'sl2h.icn' l2h.nw $(CPIF) sl2h.icn
sl2h: sl2h.icn
	$(ICONT) -o sl2h sl2h.icn   # no longer compiles with iconc

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
