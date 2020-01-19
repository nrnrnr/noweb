PROG = correct-refs
DOCSRC = $(PROG).tex
PROGSRC = $(PROG).csh
SCRIPTS = list-anchors.awk awk-scripts.awk

all: $(DOCSRC) $(PROGSRC) $(SCRIPTS)

$(DOCSRC): $(PROG).nw
	noweave -delay -index $(PROG).nw > $@

$(PROGSRC): $(PROG).nw
	notangle -R$@ $(PROG).nw | cpif $@
	chmod +x $@

list-anchors.awk: $(PROG).nw
	notangle -R$@ $(PROG).nw | cpif $@

awk-scripts.awk: $(PROG).nw
	notangle -R$@ $(PROG).nw | cpif $@

install: $(PROGSRC) $(SCRIPTS)
	cp $(PROGSRC) $(DESTDIR)$(BIN)
	cp $(SCRIPTS) $(DESTDIR)$(LIB)

tidy:
	rm *~ *% *.bak *.log *.blg

clean: tidy
	rm *.ps *.dvi *.toc *.aux *.bbl *.dep $(PROG).shar

realclean: clean
	rm $(DOCSRC) $(PROGSRC) $(SCRIPTS)

shar:
	shar README Makefile $(PROG).nw > $(PROG).shar
