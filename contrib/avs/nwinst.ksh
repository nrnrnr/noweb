export SHELL=${SHELL:=$ROOTDIR/bin/sh.exe}
if [ -z "$1" ]
then
   echo "Usage: $0 BIN LIB MAN TEXINPUTS"
   echo  "-- Installs noweb using icon"
   exit 1
fi

make CC="gcc" CFLAGS=-DTEMPNAM BIN=$1 LIB=$2 MAN=$3 TEXINPUTS=$4 LIBSRC=icon install
