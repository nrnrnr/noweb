LIB=/dev/null	# to be overridden
DIRS=numarkup

all: ;	for i in $(DIRS); do (cd $$i && $(MAKE) ICONC=$(ICONC) ICONT=$(ICONT) all); done
install: ;	for i in $(DIRS); do (cd $$i && $(MAKE) LIB=$(LIB) BIN=$(BIN) install); done
source: ;	for i in $(DIRS); do (cd $$i && $(MAKE) source); done
clean: ;	for i in $(DIRS); do (cd $$i && $(MAKE) clean); done
iconlib:	# cheap hack for slackmake
	true
