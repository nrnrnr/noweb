@echo off
if %1.==. goto USAGE
if %DJGPPMAKE%.==. goto NOENVVAR
goto DOIT

:NOENVVAR
echo Aborting, environment var DJGPPMAKE not set
goto THEEND
:USAGE
echo %0 DJGPPmakePath
echo ** Use backslash path in arg & slash path in DJGPPMAKE env var, e.g.
echo        set DJGPPMAKE=j:/djgpp/bin/make
echo        %0 j:\djgpp\bin\make
goto THEEND

:FAILURE0
echo Failed to patch src/c/finduses.c (probably the source lines to patch are
echo not any more at lines 44 and 65)
goto THEEND
:FAILURE2
echo Failed to patch src/c/finduses.c, reason unknown
goto THEEND

:DOIT
rem Requires DJGPP port of GNU gcc (gcc, make)
rem Beware of the Ms-Dos command line 128 chars limit!
rem MKS make won't do, use DJGPP make!

rem Use UNIX style pathnames in DJGPPMAKE path, otherwise DJGPP make chokes!
rem This is used for make to launch submakes assuming that you might have 2
rem   different makes in your path, the MKS make (which we don't want to use)
rem   and the DJGPP make (which we want to use)

rem Avoid using broken tmpfile() function from DJGPP 'libc.a'
if not exist c\finduses.old cp c/finduses.c c/finduses.old
if errorlevel 1 goto THEEND
echo Patching lines 44 and 65 of src/c/finduses.c (DJGPP tmpfile() broken!)
sed '44s/FILE \*tmp = tmpfile()/char *tmpName;FILE*tmp=fopen(tmpName=tempnam(".",NULL),"w+")/' c/finduses.old>c\finduses.tmp
diff c/finduses.old c/finduses.tmp
if errorlevel 2 goto FAILURE2
if errorlevel 1 goto STEP2
if errorlevel 0 goto FAILURE0
:STEP2
sed '65s/add_use_markers(tmp, stdout);/add_use_markers(tmp, stdout); remove(tmpName);/' c/finduses.tmp > c\finduses.new
diff c/finduses.tmp c/finduses.new
if errorlevel 2 goto FAILURE2
if errorlevel 1 goto STEP3
if errorlevel 0 goto FAILURE0
:STEP3
rm c/finduses.tmp
if errorlevel 1 goto THEEND
cmp -s c/finduses.c c/finduses.new
if errorlevel 1 goto DIFFERENT
rm c/finduses.new
goto THEMAKE
:DIFFERENT
mv c/finduses.new c/finduses.c

:THEMAKE
rem Use Ms-Dos style pathnames here, otherwise command.com chokes!
@echo on
%1 CC=gcc CFLAGS=-DTEMPNAM
:THEEND