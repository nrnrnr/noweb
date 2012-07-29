LIB=/dev/null	# to be overridden
CC = cc
CFLAGS = -O

TARGET = numarkup
OBJS = main.o pass1.o latex.o input.o scraps.o names.o arena.o global.o

.SUFFIXES: .nw
.nw.c: ;	notangle -R"$@"'*' -L $< | cpif $@
.nw.h: ;	notangle -R"$@" $< | cpif $@

all: 
	noweb -t numarkup.nw
	make $(TARGET)

install:
	noweb -t numarkup.nw
	make $(TARGET)
	strip $(TARGET)
	cp $(TARGET) $(LIB)

source: main.c pass1.c latex.c input.c scraps.c names.c arena.c global.c

clean:
	rm -f *.o *.c *.h *.tex *.log *.dvi *~ *.blg $(TARGET) *.html *~

$(OBJS): global.h

$(TARGET): $(OBJS)
	$(CC) -o $(TARGET) $(OBJS)

numarkup.html: numarkup.nw
	noweave -filter l2h -html -index numarkup.nw > numarkup.html

numarkup.tex: numarkup.nw
	noweb -o numarkup.nw

