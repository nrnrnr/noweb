LIB=/dev/null	# override for installation
SHELL=/bin/sh
all: noxref.krom
	chmod +x noxref.krom

install: all
	cp noxref.krom $(LIB)

source: noxref.krom

noxref.krom: noxref.nw
	notangle -Rnoxref noxref.nw > $@

clean:
	rm -f *.tex *.dvi *.ilg *.idx *.aux *.log *.blg *.bbl *~ *.ind noxref.krom
