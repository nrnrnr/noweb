if [ -z "$1" -o -z "$2" ] 
then
  echo Usage $0 BIN TMP >&2
  echo Fixes "'BIN/cpif.ksh'" for use with MKS Toolkit "(see 'man  mks42bug', cmp entry)" >&2
  echo "Fixes 'BIN/noweb.ksh' for use with MKS toolkit (the PATH problem, see howto386.txt)" >&2
  echo TMP is for later use by cpif.ksh i.e. at run-time >&2
  echo "Changes only line 8 (if it has 'PATH='), line 20 (if it has 'new=') and line 28 (if it has '-eq0')" >&2
  exit 1
fi

cat $1/cpif.ksh | sed -e '8s/\(PATH=.*\)/#\1/' -e '20s@\(new=.*\)@new='$2'/$$@' -e '28s/-eq0.*/	-eq0|-ne1|*2|*3)	cp $new $i/' > $2/cpif.tmp
mv $2/cpif.tmp $1/cpif.ksh

cat $1/noweb.ksh | sed '21,26s/PATH="$PATH:$LIB"//' > $2/noweb.tmp
mv $2/noweb.tmp $1/noweb.ksh