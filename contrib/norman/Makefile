LIB=/dev/null	# to be overridden
DIRS=numarkup

all: ;	for i in $(DIRS); do (cd $$i; make ICONC=$(ICONC) ICONT=$(ICONT) all); done
install: ;	for i in $(DIRS); do (cd $$i; make LIB=$(LIB) BIN=$(BIN) install); done
source: ;	for i in $(DIRS); do (cd $$i; make source); done
clean: ;	for i in $(DIRS); do (cd $$i; make clean); done
iconlib:	# cheap hack for slackmake
	true

