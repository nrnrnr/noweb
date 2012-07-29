# You should only edit the line ' myargs=...', see below

echo Builds and installs Noweb 2.7 from source code 
echo "Full documentation in 'howto386.txt'"
echo Assumptions:
echo "1- There is free environment space (between 30 and 40 bytes)"
echo "2- DJGPP is installed (gcc, go32, coff2exe, make)"
echo "3- MKS Toolkit 4.2 (or above?) for Dos is installed"
echo "4- The MKS Toolkit Make is the 1st make in your PATH env var"
echo "5- Icon 9.0 translator binaries are installed"
echo "6- You have enough free Ram (around 600000 bytes)"
echo "7- Your paths are not too long to break some script"
echo "   (i.e. 128 bytes Dos command line limit)"
echo "8- To fully use Noweb, LaTeX2e already is or WILL be installed"
echo "9- You are running a not too old Dos version (e.g. 'call batchfile')"

# Edit the 'myArgs=...' line to adapt for your environment:
# Use always FULLPATHS, i.e. with DRIVE LETTER
# Use only slashes '/' in pathnames, backslashes won't work
# BIN is where the noweb binaries will be installed
# LIB is where the noweb support files will be installed
# MAN is where to put the man pages (MANPATH env var or Mks ROOTDIR/etc)
# DJGPPmake is the fullpath to Gnu make (does not have to be in your PATH)
# TMP is a temporary directory to be used by Noweb at run-time
# ICON is the fullpath to icont (the Icon translator)
# (in both DJGPPmake and ICON the '.exe' is not necessary, 
# remove it if you have problems with names too long)

theArgs="BIN  LIB                    MAN    TEXINPUTS                DJGPPmake             TMP    ICON"
 myArgs="i:/b g:/usr/local/lib/noweb g:/man h:/emtex/texinputs/local j:/djgpp/bin/make.exe d:/tmp e:/b/icont.exe"

echo "generate $theArgs"
echo "generate $myArgs"
read f?"Check if the line above is OK for your machine, continue (y/n)? "
if [ "$f" = "y" -o "$f" = "Y" -o "$f" = "yes" -o "$f" = "YES" ]
then
	./generate.ksh $myArgs
fi
