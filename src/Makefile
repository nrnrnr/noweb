CC=lcc -A
CFLAGS=
TANGLEOBJS=notangle.o getline.o modules.o modtrees.o strsave.o \
	markup.o main.o errors.o columns.o
MARKUPOBJS=markmain.o strsave.o markup.o errors.o getline.o
FILES=columns.nw errors.nw getline.nw main.nw markmain.nw markup.nw \
	modtrees.nw modules.nw notangle.nw readme.nw strsave.nw
SRCS=columns.h errors.h getline.h markup.h modtrees.h \
	modules.h notangle.h strsave.h \
	columns.c errors.c getline.c main.c markmain.c markup.c \
	modtrees.c modules.c notangle.c readme.c strsave.c
BIN=/tilde/ramsey/bin
LIB=/tilde/ramsey/lib
MAN=/tilde/ramsey/man
TEXINPUTS=/tilde/ramsey/lib/tex/macros

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

install:	nt markup notangle.sh noweave.sh
		sed 's@+LIBDIR+@$(LIB)@' notangle.sh > $(BIN)/notangle
		sed 's@+LIBDIR+@$(LIB)@' noweave.sh  > $(BIN)/noweave
		sed 's@+LIBDIR+@$(LIB)@' luddite.sh  > $(BIN)/luddite
		chmod +x $(BIN)/notangle $(BIN)/noweave $(BIN)/luddite
		strip nt markup
		cp nt markup $(LIB)
		cp nwkernel.tex nwmac.tex lnwmac.tex $(TEXINPUTS)
		sed  -e 's@+LIBDIR+@$(LIB)@' -e 's@+TEXINPUTS+@$(TEXINPUTS)@' notangle.1 > $(MAN)/man1/notangle.1
		cd $(MAN)/man1; ln notangle.1 noweave.1 ; ln notangle.1 noweb.1 ; ln notangle.1 luddite.1
		
clean: ;	rm -f *.makelog *.log *.dvi *.o *.toc *~ nt markup x*.h

boot: ;		touch *.c *.h

veryclean:	clean
		rm -f $(SRCS)

bundle:		clean
		bundle README Makefile [a-z]* > ../nwbundle

columns.o:	columns.h
errors.o:	errors.h
getline.o:	getline.h errors.h columns.h
main.o:		notangle.h
markup.o:	markup.h strsave.h errors.h
modtrees.o:	strsave.h modules.h modtrees.h errors.h
modules.o:	modules.h modtrees.h markup.h errors.h columns.h
notangle.o:	markup.h strsave.h getline.h modules.h modtrees.h errors.h
strsave.o:	strsave.h errors.h
