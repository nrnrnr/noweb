SHELL=/bin/sh
LIB=/dev/null  # to be overridden
DIRS=davelove jonkrom leew norman

# don't do kostas; it requires gnu make (ugh)

all:
	for i in $(DIRS); do (cd $$i && $(MAKE) $@); done
install:
	for i in $(DIRS); do (cd $$i && $(MAKE) LIB=$(LIB) $@); done
source:
	for i in $(DIRS); do (cd $$i && $(MAKE) $@); done
clean:
	for i in $(DIRS); do (cd $$i && $(MAKE) $@); done
clobber: clean
