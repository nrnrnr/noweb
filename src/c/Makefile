# Copyright 1991 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.
#
# Adjust these two lines for your ANSI C compiler
CC=gcc
CFLAGS=

TANGLEOBJS=notangle.o getline.o modules.o modtrees.o strsave.o \
	main.o errors.o columns.o
MARKUPOBJS=markmain.o strsave.o markup.o errors.o getline.o columns.o
FILES=columns.nw errors.nw getline.nw main.nw markmain.nw markup.nw \
	modtrees.nw modules.nw notangle.nw readme.nw strsave.nw
SHELLS=notangle.sh nountangle.sh noweave.sh noroots.sh unmarkup
SRCS=columns.h errors.h getline.h markup.h modtrees.h \
	modules.h notangle.h strsave.h \
	columns.c errors.c getline.c main.c markmain.c markup.c \
	modtrees.c modules.c notangle.c readme.c strsave.c
NAME='name of RCS version'

NOTANGLE=notangle

.SUFFIXES: .nw .tex .dvi .h
.nw.tex: ;	noweave $*.nw >$*.tex
.nw.c: ;	$(NOTANGLE) -L $*.nw >$*.c
.nw.o: ;	$(NOTANGLE) -L $*.nw >$*.c
		$(CC) $(CFLAGS) -c $*.c
.nw.h: ;	$(NOTANGLE) -Rheader $*.nw | cpif $*.h

all:	nt markup

nt:	$(TANGLEOBJS)
	$(CC) $(CFLAGS) -o nt $(TANGLEOBJS)

markup:	$(MARKUPOBJS)
	$(CC) $(CFLAGS) -o markup $(MARKUPOBJS)

clean: ;	rm -f *.makelog *.log *.blg *.dvi *.o *.toc *~ nt markup *.st *.lt

boot: ;		touch *.c *.h

veryclean:	clean
		rm -f $(SRCS)

checkin:	$(FILES) 
		ci -n'$(NAME)' -l -f -m'checked in as version named $(NAME)' $(FILES)

columns.o:	columns.h
errors.o:	errors.h
getline.o:	getline.h errors.h columns.h
main.o:		notangle.h
markmain.o:	markup.h errors.h getline.h columns.h
markup.o:	markup.h strsave.h errors.h
modtrees.o:	strsave.h modules.h modtrees.h errors.h
modules.o:	modules.h modtrees.h errors.h columns.h strsave.h
notangle.o:	strsave.h getline.h modules.h modtrees.h errors.h
strsave.o:	strsave.h errors.h
