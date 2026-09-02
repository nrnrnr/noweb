WWW=$(HOME)/www/noweb/examples
SHELL=/bin/sh
NOTANGLE=nountangle -m3
NOWEAVE=noweave

.SUFFIXES: .i3 .m3 .nw .tex .dvi .html
.nw.html:
	$(NOWEAVE) -filter l2h -filter btdefn -index -html $< > $@
.nw.tex:
	$(NOWEAVE) -index -filter btdefn $< > $@
.nw.i3:
	$(NOTANGLE) -Rinterface -L'<* LINE %L "%F" *>%N' $< > $@
.nw.m3:
	$(NOTANGLE) -L'<* LINE %L "%F" *>%N' $< > $@
.tex.dvi:
	latex '\scrollmode \input '"$*"; while grep -s 'Rerun to get cross-references right' $*.log; do latex '\scrollmode \input '"$*"; done

HTML=breakmodel.html compress.html dag.html graphs.html mipscoder.html primes.html \
	scanner.html test.html tree.html wc.html wcni.html


www: $(HTML)
	copy -v $(HTML) $(WWW)
	copy -v README.h $(WWW)/index.html

clean:
	rm -f *~ *.aux *.tex *.dvi *.log *.html *.toc *.pdf *.idx *.ilg *.ind *.out
	rm -rf _minted fib multilang embedded labeled noweb_lexer.py

clobber: clean

compress.html: compress.nw
	$(NOWEAVE) -filter l2h -index -autodefs c -html compress.nw > $@
compress.tex: compress.nw
	$(NOWEAVE) -index -autodefs c compress.nw > $@
dag.html: dag.nw
	$(NOWEAVE) -filter l2h -index -autodefs icon -html dag.nw > $@
dag.tex: dag.nw
	$(NOWEAVE) -index -autodefs icon dag.nw > $@
# fib.tex is highlighted with minted; fib-xref.tex is the classic
# rendering, in which identifier uses inside code are hyperlinked.
# Both need pdflatex -shell-escape (minted runs Pygments); see
# README.python.
fib.tex: fib.nw
	$(NOWEAVE) -delay -autolang -autodefs python3 -index -filter tominted fib.nw > $@
fib-xref.tex: fib.nw
	$(NOWEAVE) -delay -autolang -autodefs python3 -index fib.nw > $@
fib.pdf: fib.tex
	mkdir -p _minted
	pdflatex -shell-escape fib.tex
	pdflatex -shell-escape fib.tex
fib-xref.pdf: fib-xref.tex
	pdflatex -shell-escape fib-xref.tex
	pdflatex -shell-escape fib-xref.tex
# fib-linked.pdf keeps chunk references hyperlinked even inside the
# docstring, via the custom Pygments lexer.  Requires one-time setup:
# whitelist noweb_lexer.py by SHA-256 hash in ~/.latexminted_config
# (see README.python).
noweb_lexer.py: ../src/lib/noweb_lexer.py
	cp ../src/lib/noweb_lexer.py $@
fib-linked.tex: fib.nw
	$(NOWEAVE) -delay -autolang -autodefs python3 -index -filter 'tominted -lexer noweb_lexer.py' fib.nw > $@
fib-linked.pdf: fib-linked.tex noweb_lexer.py
	mkdir -p _minted
	pdflatex -shell-escape fib-linked.tex
	pdflatex -shell-escape fib-linked.tex
# The tangled Makefile would clobber this one, so fib tangles into
# its own subdirectory; -t8 keeps the tabs make needs.
fib/fib.py: fib.nw
	mkdir -p fib
	notangle -R'[[fib.py]]' fib.nw > $@
fib/Makefile: fib.nw
	mkdir -p fib
	notangle -t8 -R'[[Makefile]]' fib.nw > $@
fib-run: fib/fib.py fib/Makefile
	$(MAKE) -C fib test
	$(MAKE) -C fib run
# multilang.nw exercises all six new -autodefs filters (cpp, rust,
# haskell, java, sh, make).  -autolang discovers the languages and
# stacks the matching scanners itself, so one weave indexes all six
# with no -autodefs listed; the pipeline has no fixed slot ceiling.
# See multilang.nw's introduction.
multilang.tex: multilang.nw
	$(NOWEAVE) -delay -autolang -index -filter 'tominted -lexer noweb_lexer.py' multilang.nw > $@
multilang.pdf: multilang.tex noweb_lexer.py
	mkdir -p _minted
	pdflatex -shell-escape multilang.tex
	pdflatex -shell-escape multilang.tex
# Tangle every implementation into its own subdirectory (the tangled
# Makefile would otherwise clobber this one); -t8 keeps make's tabs.
multilang-tangle: multilang.nw
	mkdir -p multilang
	notangle -R'[[gcd.cpp]]'  multilang.nw > multilang/gcd.cpp
	notangle -R'[[gcd.rs]]'   multilang.nw > multilang/gcd.rs
	notangle -R'[[Gcd.hs]]'   multilang.nw > multilang/Gcd.hs
	notangle -R'[[Gcd.java]]' multilang.nw > multilang/Gcd.java
	notangle -R'[[gcd.sh]]'   multilang.nw > multilang/gcd.sh
	notangle -t8 -R'[[Makefile]]' multilang.nw > multilang/Makefile
# embedded.nw shows autolang labeling chunks by lexical context: a
# shebang, a python3 -c argument, two here-document bodies, and a make
# recipe.  One highlighted, indexed weave stacks python3/sh/make.
embedded.tex: embedded.nw
	$(NOWEAVE) -delay -autolang -autodefs python3 -autodefs sh -autodefs make -index -filter 'tominted -lexer noweb_lexer.py' embedded.nw > $@
embedded.pdf: embedded.tex noweb_lexer.py
	mkdir -p _minted
	pdflatex -shell-escape embedded.tex
	pdflatex -shell-escape embedded.tex
# Tangle the script and its helpers into their own subdirectory (the
# tangled Makefile would otherwise clobber this one); -t8 keeps tabs.
embedded-tangle: embedded.nw
	mkdir -p embedded
	notangle -R'[[summarize]]' embedded.nw > embedded/summarize
	notangle -t8 -R'[[Makefile]]' embedded.nw > embedded/Makefile
# labeled.nw shows -langrule classifying chunks whose names are not
# filenames: a "test" chunk labeled python and a "check" chunk labeled
# bash, both embedding the same greet.py.  One highlighted, indexed
# weave applies both rules and stacks python3/sh.
labeled.tex: labeled.nw
	$(NOWEAVE) -delay -autolang -langrule 'test \[\[.*\.py\]\]=python' -langrule 'check \[\[.*\.py\]\]=bash' -autodefs python3 -autodefs sh -index -filter 'tominted -lexer noweb_lexer.py' labeled.nw > $@
labeled.pdf: labeled.tex noweb_lexer.py
	mkdir -p _minted
	pdflatex -shell-escape labeled.tex
	pdflatex -shell-escape labeled.tex
# Tangle the module, its test and its smoke check into a subdirectory.
labeled-tangle: labeled.nw
	mkdir -p labeled
	notangle -R'[[greet.py]]' labeled.nw > labeled/greet.py
	notangle -R'test [[greet.py]]' labeled.nw > labeled/test_greet.py
	notangle -R'check [[greet.py]]' labeled.nw > labeled/check-greet.sh
mipscoder.html: mipscoder.nw
	$(NOWEAVE) -filter l2h -index -autodefs sml -html mipscoder.nw > $@
mipscoder.tex: mipscoder.nw
	$(NOWEAVE) -autodefs sml -index mipscoder.nw > $@
scanner.html: scanner.nw
	$(NOWEAVE) -filter l2h -index -autodefs c -autodefs yacc -html scanner.nw > $@
scanner.tex: scanner.nw
	$(NOWEAVE) -index -autodefs c -autodefs yacc scanner.nw > $@
tree.html: tree.nw
	$(NOWEAVE) -filter l2h -index -autodefs icon -html tree.nw > $@
tree.tex: tree.nw
	$(NOWEAVE) -index -autodefs icon tree.nw > $@
test.html: test.nw
	$(NOWEAVE) -filter l2h -html test.nw > $@
test.tex: test.nw
	$(NOWEAVE) test.nw > $@
wc.html: wc.nw2html
	$(NOWEAVE) -autodefs c -filter btdefn -index -html -n wc.nw2html > $@
wcni.html: wc.nw2html
	$(NOWEAVE) -filter btdefn -x     -html -n wc.nw2html > $@
wc.tex: wc.nw
	$(NOWEAVE) -autodefs c -filter btdefn -index wc.nw > $@
