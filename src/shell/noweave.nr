#!/bin/sh
#
# Copyright 1991, 1992, 1993 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.
# options: -l == use LaTeX  -x == generate LaTeX cross-reference goo

LIB=|LIBDIR|
latex=0 tex=1 xref=0
args=
markopts=

for i do
	case $i in
	-l) latex=1 ; tex=0 ;;
        -n) latex=0 ; tex=0 ;;
        -x) xref=1 ; if [ $tex -eq 1 ]; then tex=0 ; latex=1; fi ;;
        -t*) markopts="$markopts $i" ;;
        -*) echo "$0: Unrecognized argument `$i'" 1>&2 ; exit ;;
        *)  arg="$arg $i" ;;
	esac
done

if [ $tex -eq 1 ]; then echo -n \\ ; echo input nwmac; fi
if [ $latex -eq 1 ]; then
    echo -n \\; echo "documentstyle[noweb]{article}"; 
    for i in oddsidemargin evensidemargin; do
        echo -n \\; echo -n "advance" ; echo -n \\ ; echo "$i -0.4in"
    done
    echo -n \\ ; echo 'begin{document}'
fi

if [ $xref -eq 0 ]; then
  $LIB/markup $markopts $arg 
else
  $LIB/markup $markopts $arg | $LIB/noxref
fi | nawk '
BEGIN		{ code=0 ; quoting=0 }
/^@begin code/ 	{ code=1 ; printf "\\begincode{%s}\n", substr($0, 13) }
/^@begin docs/ 	{          printf "\\begindocs{%s}\n", substr($0, 13) }
/^@end code/   	{ code=0 ; printf "\\endcode\n" }
/^@end docs/   	{          printf "\\enddocs\n" }
/^@text / 	{ line = substr($0, 7)
    		  if (code || quoting) {
      		    gsub("\\\\", "\\\\", line)
      		    gsub("{", "\\{", line) ; gsub("}", "\\}", line)
    		  }
    		  printf "%s", line
		}
/^@nl$/   	{ printf "\n" }
/^@defn / 	{ gsub("\\[\\[", "\\code{}") ; gsub("\\]\\]", "\\edoc{}")
    		  printf "\\moddef{%s}\\%sendmoddef", substr($0, 7), defns[substr($0, 7)]
                  defns[substr($0, 7)] = "plus"
		}
/^@use / 	{ gsub("\\[\\[", "\\code{}") ; gsub("\\]\\]", "\\edoc{}")
   		  printf "\\LA{}%s\\RA{}", substr($0, 6)
		}
/^@quote$/ 	{ quoting = 1 ; printf "\\code{}" }
/^@endquote$/ 	{ quoting = 0 ; printf "\\edoc{}" }
/^@file / 	{ printf "\\filename{%s}\n", substr($0, 7) }
/^@literal / 	{ printf "%s", substr($0, 10) }'
status=$?
if [ $tex -eq 1 ]; then echo -n \\ ; echo bye; fi
if [ $latex -eq 1 ]; then echo -n \\; echo 'end{document}' ; fi
exit $status
