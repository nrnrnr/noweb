# Only works with Gnu make.

LIB=/opt/noweb/lib
ICONC=icont
# This is supposed to be the defns.nw file in the icon directory of the distribution.
defns=defns.nw
TANGLE=notangle
WEAVE=noweave -delay -filter icon.filter -index

.SUFFIXES: .nw .icn .tex .dvi


all: C.filter C++.filter icon.filter oot.filter math.filter\
     autodefs.oot autodefs.math

install:
	mv *.filter $(LIB)
	mv autodefs.* $(LIB)


# TeX files.
%.tex : %.nw
	$(WEAVE) $< > $@
pp.tex: pp.nw
	noweave -delay -autodefs icon -filter icon.filter -index pp.nw > pp.tex
%.dvi : %.tex
	latex $<
# Don't delete the intermediate .tex file.
.PRECIOUS : %.tex


# Icon files.
C.icn: pp.nw  C_translation_table
	$(TANGLE) -R"C" pp.nw > $@
C++.icn: pp.nw  C++_translation_table
	$(TANGLE) -R"C++" pp.nw > $@
icon.icn: pp.nw  icon_translation_table
	$(TANGLE) -R"Icon" pp.nw > $@
oot.icn: pp.nw  oot_translation_table
	$(TANGLE) -R"OOT" pp.nw > $@
math.icn: pp.nw  math_translation_table 
	$(TANGLE) -R"Mathematica" pp.nw > $@

ootdefs.icn: ootdefs.nw
	$(TANGLE) $< $(defns) > $@
mathdefs.icn: mathdefs.nw
	$(TANGLE) $< $(defns) > $@


# Executables: filters.
%.filter : %.icn
	$(ICONC) -o $@ $<

# Executables: autodefs.
autodefs.oot: ootdefs.icn
	$(ICONC) -o autodefs.oot ootdefs.icn
autodefs.math: mathdefs.icn
	$(ICONC) -o autodefs.math mathdefs.icn


# Cleaning: remove all files that can be recreated from noweb sources.
nowebs := $(wildcard *.nw)
rem := $(nowebs:.nw=.icn)
rem := $(rem) $(nowebs:.nw=.tex)
rem := $(rem) $(nowebs:.nw=.log)
rem := $(rem) $(nowebs:.nw=.aux)
rem := $(rem) $(nowebs:.nw=.toc)


# Also remove the Icon files for the filters.
clean:
	-rm -f $(rem) C.icn C++.icn icon.icn oot.icn math.icn *.filter autodefs.*



