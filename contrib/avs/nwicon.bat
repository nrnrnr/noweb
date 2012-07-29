@echo off
if %1.==. goto USAGE
if %2.==. goto USAGE
if %3.==. goto USAGE
if %4.==. goto USAGE
if not %5.==. goto USAGE

if exist ..\..\noweb\src\%0 goto DOIT
if exist ..\..\noweb\src\%0.bat goto DOIT
echo '..\..\noweb\src\%0' not found!
cd
echo Bad startup dir? Aborting.
echo Change to ./noweb/src and run the file installed by msdosfix.bat in there
echo (you cannot use the original in noweb\contrib\avs\nwicon.bat)
goto THEEND
:DOIT

rem This represents 'make iconlib', but only like this I could put it to work
cd icon
rem j:\djgpp\bin\make ICONC=e:\\\\b\\\\icont ICONT=e:\\\\b\\\\icont
%3 ICONC=%4 ICONT=%4
if errorlevel 1 goto THEEND
cp -p totex.exe ../lib
if errorlevel 1 goto THEEND
cp -p tohtml.exe ../lib
if errorlevel 1 goto THEEND
cp -p noidx.exe ../lib
if errorlevel 1 goto THEEND
cp -p noindex.exe ../shell
if errorlevel 1 goto THEEND
rem j:\djgpp\bin\make ICONC=e:\\\\b\\\\icont ICONT=e:\\\\b\\\\icont LIB=g:/usr/local/lib/noweb BIN=i:/b install
%3 ICONC=%4 ICONT=%4 LIB=%2 BIN=%1 install
if errorlevel 1 goto THEEND
cd ..
goto THEEND

:USAGE
if not %1.==. echo Wrong usage: %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
echo Usage: %0 BIN LIB DJGPPmakeBackslashPath 4BackslashedIconTranslatorPath
echo e.g. %0 i:/b g:/usr/local/lib/noweb j:\djgpp\bin\make.exe e:\\\\b\\\\icont.exe
echo If you are running this as part of another script abort with CTRL-C
pause
:THEEND
