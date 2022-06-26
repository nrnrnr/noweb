LIB=/dev/null  # to be overridden
DIRS=numarkup

all:
	for i in $(DIRS); do (cd $$i && $(MAKE) $@); done
install:
	for i in $(DIRS); do (cd $$i && $(MAKE) LIB=$(LIB) $@); done
source:
	for i in $(DIRS); do (cd $$i && $(MAKE) $@); done
clean:
	for i in $(DIRS); do (cd $$i && $(MAKE) $@); done
iconlib:  # cheap hack for slackmake
	true
