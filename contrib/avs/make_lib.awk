# edits noweb/src/lib/makefile for Ms-Dos + PC386 + Icon 386 9.0 + DJGPP + MKS 4.2
# tested with noweb 2.7a

BEGIN { print "# generated MsDos makefile, original in makefile.old"; }

/SHELL\=/ { $0 = "# " $0 } # disable SHELL def

/cp unmarkup emptydefn toascii \$/ {  # add an extension .ksh) when copying
   $0 = "\tcp unmarkup $(LIB)/unmarkup.ksh\n\tcp emptydefn $(LIB)/emptydefn.ksh\n\tcp toascii $(LIB)/toascii.ksh"
}

{ print $0 } # prints the line (which might have been changed)
