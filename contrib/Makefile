SHELL=/bin/sh
LIB=/dev/null	# to be overridden
ICONT=icont	# to be overridden
DIRS=davelove jonkrom leew norman

# don't do kostas; it requires gnu make (ugh)

all: ;	for i in $(DIRS); do (cd $$i && $(MAKE) ICONT=$(ICONT) $@); done
install: ;	for i in $(DIRS); do (cd $$i && $(MAKE) LIB=$(LIB) BIN=$(BIN) $@); done
source: ;	for i in $(DIRS); do (cd $$i && $(MAKE) $@); done
clean: ;	for i in $(DIRS); do (cd $$i && $(MAKE) $@); done
clobber: clean
