# Copyright 1991 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.
#
# Adjust these two lines for your ANSI C compiler
CC=gcc -ansi -pedantic -O -Wall -Werror
CFLAGS=

# after installation, make doc.dvi for literate version

FINDUSESOBJS=columns.o errors.o finduses.o match.o getline.o recognize.o
MNTOBJS=mnt.o getline.o match.o modules.o modtrees.o notangle.o \
	strsave.o errors.o columns.o
TANGLEOBJS=notangle.o getline.o match.o modules.o modtrees.o strsave.o \
	main.o errors.o columns.o
MARKUPOBJS=markmain.o strsave.o markup.o errors.o getline.o columns.o
FILES=markmain.nw markup.nw \
      main.nw notangle.nw match.nw mnt.nw modules.nw modtrees.nw \
      finduses.nw recognize.nw \
      getline.nw columns.nw errors.nw strsave.nw

SRCS=columns.h errors.h getline.h markup.h match.h modtrees.h \
	modules.h notangle.h recognize.h strsave.h \
	columns.c errors.c getline.c finduses.c main.c markmain.c markup.c match.c \
	mnt.c modtrees.c modules.c notangle.c nwmktemp.c recognize.c \
	strsave.c markup.ps

NOTANGLE=notangle
SHELL=/bin/sh
# set this for CPIF and then distribute tools with bad timestamps...
#CPIF=| cpif
CPIF=>

.SUFFIXES: .nw .tex .dvi .h
.nw.tex: ;	noweave $*.nw >$*.tex
.nw.c: ;	$(NOTANGLE) -L $*.nw >$*.c
.nw.o: ;	$(NOTANGLE) -L $*.nw >$*.c
		$(CC) $(CFLAGS) -c $*.c
.nw.h: ;	$(NOTANGLE) -Rheader $*.nw $(CPIF) $*.h

all: nt markup mnt finduses nwmktemp

nt: $(TANGLEOBJS)
	$(CC) $(CFLAGS) -o $@ $(TANGLEOBJS)

nwmktemp: nwmktemp.o
	$(CC) $(CFLAGS) -o $@ nwmktemp.o

finduses: $(FINDUSESOBJS)
	$(CC) $(CFLAGS) -o $@ $(FINDUSESOBJS)

markup: $(MARKUPOBJS)
	$(CC) $(CFLAGS) -o $@ $(MARKUPOBJS)

mnt: $(MNTOBJS)
	$(CC) $(CFLAGS) -o $@ $(MNTOBJS)

source: $(SRCS)
touch: $(SRCS)
	touch $(SRCS)

boot: ;	touch $(SRCS)

clean:
	rm -f nt markup mnt finduses fakepretty
	rm -f core *.makelog *.tex *.log *.blg *.dvi *.o *.toc *~
	rm -f *.atac *.trace *.html

clobber: clean
	rm -f $(SRCS) fakepretty.c pretty.[ch]

doc.tex: doc.nw
	cp doc.nw $@

allcode.tex: $(FILES)
	noweave -n -index $(FILES) > $@

doc.dvi: doc.tex allcode.tex
	latex doc; latex doc; latex doc

doc.ps: doc.dvi
	dvips doc

markup.ps: markmain.nw
	notangle -Rmarkup.dot markmain.nw | dot -Tps > $@

FPOBJS=fakepretty.o pretty.o errors.o getline.o match.o strsave.o columns.o

fakepretty.o: pretty.h

fakepretty: $(FPOBJS)
	$(CC) $(CFLAGS) -o $@ $(FPOBJS)


columns.o:       columns.h
errors.o:        errors.h
finduses.o:     errors.h match.h getline.h recognize.h
getline.o:      columns.h errors.h getline.h
main.o:         notangle.h errors.h columns.h modules.h modtrees.h
markmain.o:     errors.h markup.h getline.h columns.h
markup.o:       markup.h strsave.h errors.h
match.o:        match.h
mnt.o:          modules.h modtrees.h notangle.h errors.h columns.h strsave.h
modtrees.o:     strsave.h modules.h modtrees.h errors.h
modules.o:      modules.h modtrees.h errors.h columns.h strsave.h
notangle.o:     strsave.h getline.h modules.h modtrees.h errors.h match.h notangle.h
nwmktemp.o:
pretty.o:	getline.h match.h errors.h pretty.h strsave.h
recognize.o:
strsave.o:      strsave.h errors.h
