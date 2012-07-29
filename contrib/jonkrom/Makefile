LIB=/dev/null	# override for installation
SHELL=/bin/sh
all: noxref.krom
	chmod +x noxref.krom

install:
	cp noxref.krom $(LIB)

source: noxref.krom

noxref.krom: noxref.nw
	notangle -Rnoxref noxref.nw > noxref.krom

clean:
	/bin/rm -f *.tex *.dvi *.ilg *.idx *.aux *.log *.blg *.bbl *~ *.ind noxref.krom
