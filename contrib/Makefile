SHELL=/bin/sh
LIB=/dev/null	# to be overridden
ICONC=icont	# to be overridden
DIRS=davelove jonkrom leew norman

# don't do kostas; it requires gnu make (ugh)

all: ;	for i in $(DIRS); do (cd $$i; make ICONC=$(ICONC) all); done
install: ;	for i in $(DIRS); do (cd $$i; make LIB=$(LIB) BIN=$(BIN) install); done
source: ;	for i in $(DIRS); do (cd $$i; make source); done
clean: ;	for i in $(DIRS); do (cd $$i; make clean); done
clobber: clean

