# Copyright 1991 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.
SHELL=/bin/sh

# Adjust these two lines for your ANSI C compiler
CC=gcc
CFLAGS=-ansi -pedantic -O -Wall -Werror

# after installation, make doc.dvi for literate version

TANGLEOBJS=notangle.o getline.o match.o modules.o modtrees.o strsave.o \
	main.o errors.o columns.o gitversion.o
MARKUPOBJS=markmain.o strsave.o markup.o errors.o getline.o columns.o gitversion.o
MNTOBJS=mnt.o getline.o match.o modules.o modtrees.o notangle.o \
	strsave.o errors.o columns.o gitversion.o
FINDUSESOBJS=columns.o errors.o finduses.o match.o getline.o recognize.o gitversion.o
NWMKTEMPOBJS=nwmktemp.o gitversion.o
FPOBJS=fakepretty.o pretty.o errors.o getline.o match.o strsave.o columns.o gitversion.o

FILES=markmain.nw markup.nw \
	main.nw notangle.nw match.nw mnt.nw modules.nw modtrees.nw \
	finduses.nw recognize.nw \
	getline.nw columns.nw errors.nw strsave.nw

SRCS=columns.h errors.h getline.h markup.h match.h modtrees.h \
	modules.h notangle.h recognize.h strsave.h \
	columns.c errors.c getline.c markup.c match.c modtrees.c \
	modules.c notangle.c recognize.c strsave.c \
	main.c markmain.c mnt.c finduses.c nwmktemp.c \
	markup.ps

NOTANGLE=notangle
# set this for CPIF and then distribute tools with bad timestamps...
#CPIF=| cpif
CPIF=>

.SUFFIXES: .nw .tex .dvi .h
.nw.tex:
	noweave $< > $@
.nw.c:
	$(NOTANGLE) -L $< > $@
.nw.h:
	$(NOTANGLE) -Rheader $< $(CPIF) $@

all: nt markup mnt finduses nwmktemp

nt: $(TANGLEOBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(TANGLEOBJS)

markup: $(MARKUPOBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(MARKUPOBJS)

mnt: $(MNTOBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(MNTOBJS)

finduses: $(FINDUSESOBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(FINDUSESOBJS)

nwmktemp: $(NWMKTEMPOBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(NWMKTEMPOBJS)

fakepretty: $(FPOBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(FPOBJS)

source: $(SRCS)
touch: $(SRCS)
	touch $(SRCS)

boot:
	touch $(SRCS)

clean:
	rm -f nt markup mnt finduses nwmktemp fakepretty
	rm -f core *.makelog *.tex *.log *.blg *.dvi *.o *.toc *~
	rm -f *.atac *.trace *.html

clobber: clean
	rm -f $(SRCS) fakepretty.c pretty.[ch] gitversion.c

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

gitversion.c: ../gitversion $(wildcard ../../.git/refs/heads/master)
	echo 'const char gitversion[] = "'"$$(../gitversion -prefix)"'";' > $@


columns.o:      columns.h
errors.o:       errors.h
fakepretty.o:   pretty.h
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
pretty.o:       getline.h match.h errors.h pretty.h strsave.h
recognize.o:
strsave.o:      strsave.h errors.h
