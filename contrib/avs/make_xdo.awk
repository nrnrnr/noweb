# edits noweb/src/xdoc/makefile for Ms-Dos + PC386 + Icon 386 9.0 + DJGPP + MKS 4.2
# tested with noweb 2.7a

BEGIN { print "# generated MsDos makefile, original in makefile.old"; }

/SHELL\=/ { $0 = "# " $0 } # disable SHELL def

/WWW=/ { $0 = "WWW=../.." } # Put World Wide Web files in noweb because the dir $(HOME)/www/noweb might not exist

/\/bin\/rm/ { sub(/\/bin\/rm/, "rm") } # rm might not be at "/bin/rm"

/\.ps\.gz/ { sub(/\.ps\.gz/, ".pgz"); } # MsDos limitation, use extension .pgz instead of .ps.gz 

{ print $0 } # prints the line (which might have been changed)
