# Adjust these two lines for your ANSI C compiler
CC=lcc -A
CFLAGS=-g

# BIN is where the commands (notangle, noweave, nountangle, noroots) land
# LIB is where the pieces of the pipes (nt, markup, unmarkup) are stored
# MAN is the root of your local man pages directory
# MANEXT is the extension for your commands' man pages (usually 1 or l)
# TEXINPUTS is the directory for TeX macro files
HOST=`cputype`
BIN=/u/nr/bin/$(HOST)
LIB=/u/nr/lib/$(HOST)
MAN=/u/nr/man
MANEXT=1
TEXINPUTS=/u/nr/lib/tex/inputs

# Stop editing.  No user-serviceable parts below.

TANGLEOBJS=notangle.o getline.o modules.o modtrees.o strsave.o \
	main.o errors.o columns.o
MARKUPOBJS=markmain.o strsave.o markup.o errors.o getline.o columns.o
FILES=columns.nw errors.nw getline.nw main.nw markmain.nw markup.nw \
	modtrees.nw modules.nw notangle.nw readme.nw strsave.nw
SRCS=columns.h errors.h getline.h markup.h modtrees.h \
	modules.h notangle.h strsave.h \
	columns.c errors.c getline.c main.c markmain.c markup.c \
	modtrees.c modules.c notangle.c readme.c strsave.c

NOTANGLE=notangle

.SUFFIXES: .nw .tex .dvi .h
.nw.tex: ;	noweave $*.nw >$*.tex
.nw.c: ;	$(NOTANGLE) -L $*.nw >$*.c
.nw.o: ;	$(NOTANGLE) -L $*.nw >$*.c
		$(CC) $(CFLAGS) -c $*.c
.nw.h: ;	$(NOTANGLE) -Rheader $*.nw >x$*.h
		-cmp -s x$*.h $*.h || cp x$*.h $*.h

all:	nt markup

nt:	$(TANGLEOBJS)
	$(CC) $(CFLAGS) -o nt $(TANGLEOBJS)

markup:	$(MARKUPOBJS)
	$(CC) $(CFLAGS) -o markup $(MARKUPOBJS)

install:	nt markup notangle.sh noweave.sh nountangle.sh noroots.sh
		sed 's@|LIBDIR|@$(LIB)@' notangle.sh > $(BIN)/notangle
		sed 's@|LIBDIR|@$(LIB)@' noweave.sh  > $(BIN)/noweave
		sed 's@|LIBDIR|@$(LIB)@' nountangle.sh  > $(BIN)/nountangle
		sed 's@|LIBDIR|@$(LIB)@' noroots.sh  > $(BIN)/noroots
		chmod +x $(BIN)/notangle $(BIN)/noweave $(BIN)/nountangle $(BIN)/noroots
		strip nt markup
		cp nt markup unmarkup $(LIB)
		chmod +x $(LIB)/unmarkup
		cp nwkernel.tex nwmac.tex noweb.sty $(TEXINPUTS)
		sed  -e 's@|LIBDIR|@$(LIB)@' -e 's@|TEXINPUTS|@$(TEXINPUTS)@' notangle.1 > $(MAN)/man$(MANEXT)/notangle.$(MANEXT)
		cd $(MAN)/man$(MANEXT); /bin/rm -f noweave.$(MANEXT) noweb.$(MANEXT) nountangle.$(MANEXT) noroots.$(MANEXT)
		cd $(MAN)/man$(MANEXT); ln notangle.$(MANEXT) noweave.$(MANEXT); ln notangle.$(MANEXT) noweb.$(MANEXT) ; ln notangle.$(MANEXT) nountangle.$(MANEXT) ; ln notangle.$(MANEXT) noroots.$(MANEXT)

clean: ;	rm -f *.makelog *.log *.blg *.dvi *.o *.toc *~ nt markup x*.h *.st *.stl
		rm -f primes.aux primes.tex primes.bbl

boot: ;		touch *.c *.h

veryclean:	clean
		rm -f $(SRCS)

bundle:		clean
		bundle README Makefile [a-z]* > ../nwbundle

columns.o:	columns.h
errors.o:	errors.h
getline.o:	getline.h errors.h columns.h
main.o:		notangle.h
markmain.o:	markup.h errors.h getline.h
markup.o:	markup.h strsave.h errors.h
modtrees.o:	strsave.h modules.h modtrees.h errors.h
modules.o:	modules.h modtrees.h errors.h columns.h strsave.h
notangle.o:	strsave.h getline.h modules.h modtrees.h errors.h
strsave.o:	strsave.h errors.h
