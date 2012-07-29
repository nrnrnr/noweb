**** NOTE: this is the superb document 'jrtex12a' from John Refling. I just
**** fixed a couple of bugs and added a few comments (for my own use). The 
**** changes are marked with '****'. The biggest problem was that his setup
**** didn't contemplate installing emTeX in another drive than C, nor did it
**** contemplate putting the fonts generated on demand on yet another drive
**** (handy if one wants emTeX to be in a READONLY drive) 
****
**** If you only have a 386 without coprocessor be careful with some 
**** delete instructions (which assume you have a 387 or a 486DX)
****
**** Known problems: 
****   If running under the MKS Toolkit shell, font generation on demand may
****   fail. I don't have this problem any more (don't know what fixed it, 
****   the new version of emTeX?) but I had it in the past. Just do the font 
****   generation under 'command.com' and then go back to the Korn shell
****                                   avs@daimi.aau.dk (18-Mar-95)

How I installed emtex, latex2e, mf, dvips, on a 386 w/ postscript or hplaser
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   John Refling,  University of California
                jprefling@lbl.gov [DO NOT SEND REQUESTS HERE]
                    date: 13 January 1995,  Version: 12a

Archivists
~~~~~~~~~~
This file should be stored on your machine with a basename of 'jrtex12a'.
in a place related to tex.  A one line description of this guide might be:
"Describes install of emtex, latex2e, hplj & PS on PC"

How to get latest
~~~~~~~~~~~~~~~~~
This will be available at simtel mirrors such as wuarchive.wustl.edu
and oak.oakland.edu in/or near the /pub/msdos/tex directory, and perhaps
CTAN machines, like ftp.shsu.edu.   A similar file which describes an older
version of emtex installation (pre latex-2e) has basename jrhelp11.

What is this
~~~~~~~~~~~~
This is a short account of my experiences installing emtex on a few different
computers, with a few different printers.

Hardware you NEED to follow this guide
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a 386 or greater computer with reasonable (4MB) ram about 35 meg free space
    peak for the install (for easy installation, although you can get by with
    much less if you are willing to really work at it), reduced to ~10 MB
    disk space permanently (less w/o postscript support and the docs),
    plus fonts (about 5 MB max).

a reasonable dos version (best if you can recall and edit commands)

a laser printer (postscript or pcl hplaserjet or hplaserjet iv, are tested).

What you get
~~~~~~~~~~~~
emtex system (tex, latex2e, mf, screen previewer, postscript support)
dynamically generated fonts if you wish (that's right, I don't generate them
   until I use `em)
The emtex system is a great tex / latex system.

A note on the version numbers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The base name of this document is jrtex which takes 5 characters out of 8
possible.  The next two digits correspond to the betatest version of emtex,
currently 12. Unfortunately, other pieces of the emtex package change without
notice and so it is hard to pin a version number on the entire package, which
I could carry over to this document, plus I might have revisions.  The final
character in this help file's name will serve as a minor revision indicator.

Even so, there might be minor discrepancies between what you see here
and what is on the net.  Perhaps one of the best ways to check for
revisions on the net would be to check the file's size and/or it's date.
However, I just don't see any good way to build this info into the name
of this document.  I have included the file size of files obtained from
the net.  When the size indicated is different from the size you received,
you need to be cautious... most likely a new version has been added to the
distribution, and you need to take that into account.  Sometimes in the
betatest subdirectory there are multiple versions of the same thing... use
the latest... even if I don't in this document!

How to do it
~~~~~~~~~~~~
Print out a copy of this file, and follow along with it.  CROSS OFF STEPS
WHEN COMPLETED.  You need to be able to transfer files from the internet
to your PC.  You also need pkunzip, and know how to use it.   If you use
unzip, the options are slightly different.

What you don't get
~~~~~~~~~~~~~~~~~~
This worked for me, but I can't guarantee it for you.  You take all
responsibility for implementing this.  You are assumed to know enough
about what is going on to not do something dangerous even if it says to
do so here.  Besides, someone could have changed this before you got it.
ALSO, I DON'T COVER MIGRATION FROM THE 2.09 VERSION OF LATEX TO THE NEW
2E VERSION.  I ASSUME A NEW INSTALLATION!  Also, this is only how I did
it! and is not an official guideline, or recommendation.  It is possible
that something in here may guide you contrary to some of the published
or yet to be published standards.  This is provided in the hope that it
may be useful, in the event that you are having trouble with your
installation.  THAT'S IT.  You have been warned!

Introduction
~~~~~~~~~~~~
The emtex distribution was a little confusing to me at first, since I am
used to obtaining one compressed distribution archive file and working with
that.  When a new version is distributed, one goes back to the ftp site and
gets the compressed file with the next higher version number.

With emtex, things are spread across directories, not only in terms of package
components, but also in terms of revision levels.  The most serious drawback
of this method is that it is difficult to determine the revision level of
programs, or where a particular revision level is.  The simpliest way to
install it is just to install ALL of the archives in order, and let
them overwrite [hopefully] older versions.  Then, you will have the latest
versions, and you delete what you don't want.

1. OBTAIN THE DISTRIBUTION AND EXTRACT IT AND ARCHIVE IT FOR LATER
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a.  cd \

b.  use ftp to connect to a distribution machine, ftp.dante.de,
    ftp.shsu.edu, wuarchive.wustl.edu, etc, and get to the emtex directory
    something like /tex-archive/systems/msdos/emtex.  We wish to grab all the
    files in the disk1, disk2, disk3, disk4, disk5, betatest subdirs. 
    MAKE SURE YOU SET BINARY MODE BEFORE THE TRANSFER OF BINARY FILES.
    One way to do it all is as follows (assuming that the remote ftp server
    has on-the-fly compression):

    ftp ftp.shsu.edu
**** ftp.dante.de is too slow, ftp.tex.ac.uk is good (12 KB/s)
    cd /tex-archive/systems/msdos
    bin
    hash
    get emtex.zip                                                 [15,173,126]
**** get emtex.tar.gz  [11,859,740]

    This will recursively get everything.  Last time I tried it, it ended up
    being a 14,992,564 byte file, and took 60 minutes via ftp.

    Then, get the latex2e stuff:

    cd /tex-archive/macros/latex
    get base.zip                                                     [771,461]
    cd packages
    get tools.zip                                                    [221,517]
**** get graphics.tar.gz       [80,020]
****  'graphics' has epsfig (allows including Encapsulated PostScript files in LaTeX docs)
    quit

c.  Then on the pc:

    mkdir \emtmp
    cd \emtmp
    pkunzip \emtex.zip                                [or unzip -j \emtex.zip]
    cd \

    You will need 15 + 15 = 30 MB disk space for this process.  Read the
    readme.tst and note the date in the upper right-hand corner.  For my
    installation it was 12-Dec-94.  After success, you may delete \emtex.zip
    and get 15 MB disk space back. Then goto step d.
**** version of 03-Feb-95 (includes web.zip with weave, tangle and pooltype)

    If this does not work [because you don't have enough temporary disk space
    for the one huge file, or if the ftp server  can't compress into one huge
    file], you have to get all the files individually.  The ones we are most
    interested in are listed in item 5 below with their locations in [].

d.  Do the following in order [if you use unzip, do not use the -d]:

    pkunzip -d \emtmp\tex1.zip                                 [disk1, 375854]
    pkunzip -d \emtmp\tex2.zip                                 [disk1, 268240]
    pkunzip -d \emtmp\latex1.zip                               [disk2, 248823]
    pkunzip -d \emtmp\latex2.zip                               [disk2, 238131]
    pkunzip -d \emtmp\blatex.zip                               [disk2, 231677]
    pkunzip -d \emtmp\makeindx.zip                             [disk2,  52717]
    pkunzip -d \emtmp\bmf1.zip                                 [disk3, 266527]
    pkunzip -d \emtmp\bmf2.zip                                 [disk5, 271791]
    pkunzip -d \emtmp\texcad.zip                               [disk3, 120547]
    pkunzip -d \emtmp\mf1.zip                                  [disk4, 249916]
    pkunzip -d \emtmp\mf2.zip                                  [disk4, 344463]
    pkunzip -d \emtmp\mf3.zip                                  [disk4, 278545]
    pkunzip -d \emtmp\mfware1.zip                              [disk4, 327215]
    pkunzip -d \emtmp\mfware2.zip                              [disk5, 140361]
    pkunzip -d \emtmp\btex1.zip                                [disk5, 265159]
    pkunzip -d \emtmp\btex2.zip                                [disk5, 274600]
    pkunzip -d \emtmp\misc_mf.zip                              [disk5,  36349]
    pkunzip -d -o \emtmp\mfb5.zip                          [betatest, 1044415]
    pkunzip -d -o \emtmp\mfjob11n.zip                            [betatest, ?]
    pkunzip -d -o \emtmp\texb12.zip                        [betatest, 1120943]
    pkunzip -d -o \emtmp\bibtexb1.zip                       [betatest, 167593]
    pkunzip -d -o \emtmp\fontl12a.zip                        [betatest, 88321]
    pkunzip -d -o \emtmp\dvid15g1.zip                      [betatest, 1213323]
    pkunzip -d -o \emtmp\dvid15g2.zip                       [betatest, 727077]

    Answer yes to any overwrites.

    move \emtmp\readme.tst \emtex\doc
    move \emtmp\readme.eng \emtex\doc\english

    Extracting these files generates another 18 MB of files.  If this is
    successful, you may now delete everything in \emtmp, as well as \emtex.zip.

    If you run out of space in the process, you may delete each .zip you
    have extracted successfully.  After extracting ALL the .zips, you may
    delete \emtex.zip.

e.  Get rid of stuff (I save only the 386 stuff):
    cd \emtex
    del *.cmd                                                     [os/2 stuff]
    del bmf*.*                                                        [big mf]
    del blatex.bat                                                 [big latex]
    del btex*.*                                                      [big tex]
    del mf.exe                                                      [small mf]
    del mf186.exe                                                   [small mf]
    del mf286.exe                                                   [small mf]
    del tex.exe                                                    [small tex]
    del tex186.exe                                                 [small tex]
    del tex286.exe                                                 [small tex]
    del texp.exe                                                  [os/2 stuff]
    del texfmts                                                    [small tex]
    rmdir texfmts                                                  [small tex]
    del mfbases                                                    [small tex]
    rmdir mfbases                                                  [small tex]
****
    del remove                                                   [intnl files]
    rmdir remove                                                 [intnl files]
**** Might not be a good idea to remove, tells from where a given file came
    del mfp*.*                                                    [os/2 stuff]
    del dvipm*.*                                                  [os/2 stuff]
    del mfjob1.ovl                                               [small mfjob]
    del mfjob2.ovl                                               [small mfjob]
    del ask.exe
    del bibtex.exe                                                [small bibt]
****
    del book
    rmdir book
**** book has subdirs (skip these steps, german subdir will be deleted below)

    IF YOU REALLY ARE GOING TO USE A DOT MATRIX PRINTER, YOU MIGHT KEEP THESE:
    del dvidot*.*                                                 [dot matrix]
    del gh.*
    del prtfx*.*
    del prtitoh.*
    del prtlq*.*
    del prtp6*.*
    del prtsty.bat
    del pcx*.*
    del prtaiw.bat
    del makedot.exe

    I DON'T HAVE LIMITED MEMORY, SO DELETE
    del vs.bat                                               [ltd memory vers]
    del dviscrs.exe                                          [ltd memory vers]

    OLD FORMATS FOR FONTS, IF YOU ARE STARTING NEW, YOU DON'T WANT THEM:
    del chtopx.exe
    del gftopxl.exe
    del gftype.exe
    del pktopx.exe
    del pxtoch.exe
    del pxtopk.exe

    I HAVE A COPROCESSOR SO DON'T NEED THE COPROCESSOR-LESS VERSIONS
    del dviscr.exe
    del dvihplj.exe

    I DON'T HAVE A VIKING DISPLAY
    del dvivik.exe

    SAVE SOME MORE SPACE since I regenerate the bases & formats later
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cd \emtex\bmfbases
    del *.cmd
    del *.log
    del *.bas
    edit bas.bat and change "bmf" to "\emtex\mf386" in all cases (2)
**** use only 'mf386' (i.e. ?:/emtex will be in the PATH)

    cd \emtex\btexfmts
    del *.cmd
    del *.log
    del *.fmt
    edit fmt.bat and change "btex" to "\emtex\tex386" in all cases (2)
    edit slifmt.bat and change "btex" to "\emtex\tex386" in all cases (1)
**** use only 'tex386' (i.e. ?:/emtex will be in the PATH)

    I delete some dot-matrix printer configuration files.  Actually, all I
    keep in the \emtex\data\ subdirectory is:
    dvidrv.err fax.cnf fontlist lj.cnf ljh.cnf newfonts.sub oldfonts.sub

    I choose to get rid of a few of the doc files in German to save space:
    del \emtex\doc\german
    rmdir \emtex\doc\german
    del \emtex\book\german
    rmdir \emtex\book\german

    and get rid of some more o/s-2 stuff:
    del \emtex\help
    rmdir \emtex\help

f.  FINALLY, ARCHIVE IT:
    cd \
    pkzip -rP em941212 \emtex\*.*               [941212 = date in readme.tst]
    copy em941212.zip [your archive place]
    copy base.zip [your archive place]
    copy tools.zip [your archive place]

    These should fit on two 3" floppies.  This is what I use to archive the
    distribution.  The em941212.zip will have to be split across the disks.  I
    picked 941212 as the version number since that is the date in the readme.tst
    file.  When the date changes, change the number.

g.  This will give you the following software and versions:

    bibtex32.exe      0.99c [3c-beta1, have to dig thru exe to find vers]
    dvidrv            ?
    dvihplj           1.5g
****     dvihplj7           1.5g
    dviscr            1.5g
****    dviscr            1.5a
    emx.exe           0.8h (rev 16)  [have to dig thru exe to find vers]
****     emx.exe           0.8h (rev 18)
    fontlib           1.2a
    gftodvi.exe       3.0 [1g]
    gftopk.exe        3.2 [1j]
****    gftopk.exe        2.3 [1j]
    makeindx.exe      2.11
    maketcp.exe       1.1c
    mf386.exe         2.71 [3c-beta5]
    mfjob.exe         1.1n
    mft.exe           2.0 [1e]
    pktogf.exe        1.0 [1c]
    pktype.exe        2.3 [1c]
    tex386.exe        3.1415 [3c-beta12]
    texcad.exe        2.8


2. RESTORING THE ARCHIVE
~~~~~~~~~~~~~~~~~~~~~~~~
If you are continuing from above skip to the next section.  If you are
restoring em941212 from the archive you made earlier, do that now, and:

pkunzip -d em941212.zip

3. COMPLETING THE INSTALLATION OF LATEX2e
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Make sure that the following is in \config.sys: (the numbers can be larger)

shell=command.com /e:1024 /p
buffers=20
files=20

if tex complains that it can't open an output file, increase the files.

Edit \autoexec.bat and append the following to the path statement:
;\emtex 

also add the following lines

set texinput=c:\emtex\texinput!
set dvidrvfonts=c:\texfonts
set dviscr=-s2
set mfjobopt=-3

You may insert the contents of \emtex\set-tex.bat into your autoexec.bat,
although it is not necessary, since the default paths are hard coded into 
the .exe files.  However, if you change any paths later, you will have to
edit \emtex\set-tex.bat to reflect them, and execute \emtex\set-tex.bat
each time you boot, or automatic subdirectory searching will not work. 
Make sure that the ! follows the `texinput' as in the first line above.
Also, the last two are not in set-tex.bat, so you have to add them anyway.

You should add the following line to your autoexec.bat, with appropriate
number for the lpt port.  This prevents prthplj & prthpljh from aborting when
you take too long to refill the printer's paper:
mode lpt1 retry=r

create \emtex\tex.bat in path:
tex386 &plain %1 %2 %3 %4 %5 %6 %7 %8 %9

create \emtex\latex.bat in path:
tex386 &latex %1 %2 %3 %4 %5 %6 %7 %8 %9

create \emtex\slitex.bat in path:
tex386 &splain %1 %2 %3 %4 %5 %6 %7 %8 %9

or add them to a ced-like alias file.  If you don't know what that is, don't
ask.  You will now type tex, latex, slitex followed by the filename to
process a document.  If the extension on the filename is .tex, it is optional.

reboot now!

EXTRACT LATEX2E
~~~~~~~~~~~~~~~
cd \
pkunzip -d \base
cd \base
\emtex\tex386 /i unpack.ins

replace any existing files in the following (to override them):
move *.ltx \emtex\btexfmts
move ltxcheck.tex \emtex\texinput
move testpage.tex \emtex\texinput
move docstrip.tex \emtex\texinput
move *.cls \emtex\texinput
move *.clo \emtex\texinput
move *.sty \emtex\texinput
move *.fd \emtex\texinput
move *.def \emtex\texinput
move *.cfg \emtex\texinput

mkdir \emtex\makeindx
move *.ist \emtex\makeindx

mkdir \emtex\doc\base
move *.tex \emtex\doc\base                          [save and read these docs]
move *.txt \emtex\doc\base                          [save and read these docs]
**** move *.err \emtex\doc\base            [LaTeX companion & LaTeX book errata]

mkdir \emtex\texinput\local
**** For local files, will be used by automatic 1 subdir level search ('!')

cd \
del base.zip
del base
rmdir base

BUILD THE CM BASES
~~~~~~~~~~~~~~~~~~
cd \emtex\bmfbases
bas

BUILD THE TEX AND LATEX2e FORMATS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd \emtex\btexfmts
fmt
slifmt
del lplain.*                   [this is the old 2.09 format replaced later on]
\emtex\tex386 /i latex.ltx              [this is the new latex 2e format file]

cd \
latex ltxcheck                                              [all should be ok]
**** Complains about missing AMS fonts (this was to be expected)


EXTRACT THE MAINZ TOOLS
~~~~~~~~~~~~~~~~~~~~~~~
cd \
pkunzip -d \tools
cd tools
latex tools.ins
del temp.tex
mkdir \emtex\texinput\tools
move *.sty \emtex\texinput\tools
move *.tex \emtex\texinput\tools
**** move *.txt \emtex\doc\tools

mkdir \emtex\doc\tools
move *.dtx \emtex\doc\tools                [these are all the docs for tools]

cd \
del tools.zip
del tools
rmdir tools

TESTING THE LATEX INSTALLATION
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mkdir \test
cd \test

Make a small file called cm.tex containing:

\documentclass{article}
\begin{document}
Hello world...........$\sum$
\end{document}

and latex it by typing `latex cm'.  It should not complain.


4. VIEWING THE RESULTS
~~~~~~~~~~~~~~~~~~~~~~
By latexing the above test document we have only used brief font info that
is stored in the TFM files (in \emtex\tfm).  You cannot print or view the
results until you put fonts on your computer and/or printer.  The only
exception to this is postscript printers or viewers which have their fonts
built in.  More on that later.

If you have a postscipt printer, you may use its internal fonts, or you may
download fonts (e.g. CM [computer modern]), or do a combination of the two).
You may also choose to use a postscript previewer for screen previewing (e.g.
ghostscript).  OR, you may choose to use the CM fonts that come with latex for
screen previewing and use a dvi previewer (e.g. dviscr).

If you have a reasonably recent HP pcl laser printer (any of the laser jets
excluding the laser jet 1 [the laser jet 1+ is ok, although limited memory)
or a laser printer that emulates an HP laser printer, you will want to use
the CM fonts.

The new HPLJ IV has its own scaleable fonts, so perhaps you will be able to
use those internal fonts much like with postscript printers.  You would need
the TFM files describing the fonts inside the printer.  I haven't done much
work with the HP LJ IV so it is possible this has already been done.  I don't
discuss it here.

Moving on in the choices, if you choose to use CM for either printing or
display, then you need to obtain the actual fonts.  You can either get
them from the net, generate them all at once, or generate them on demand
and the save them for future use.  I do the latter.  On a 486-33 MHz
it only takes a minute or so to generate a font in a particular size.
All these options are described next.

Pick one, and skip to a), b), c), d), e), or f) below.
**** Best choice is step c), generate fonts on demand

a. CM fonts from the net, for screen viewing & 300 dpi hplj printing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mkdir \texfonts
   cd \texfonts
   ftp ftp.shsu.edu                                            [or other site]
   cd tex-archive/systems/msdos/emtex-fonts
   bin
   hash
   get lj_fonts.zip                                  [this will be about 5 MB]
   quit

   pkunzip lj_fonts *.fli                         [or unzip -j lj_fonts *.fli]

   Archive lj_fonts.zip somewhere for future use.

   To display the document on your screen, use v <filename>.  v.bat is a batch
   file in \emtex which calls dviscr.  If you have a math coprocessor and
   deleted dviscr.exe and kept dviscr7.exe, edit v.bat to call dviscr7.exe
   instead of dviscr.exe.  Example:

   cd \test
   v test

   I add a /pt to \emtex\data\lj.cnf to prevent all the .dlg files. 

   You can also put the one line contents of v.bat into a ced-like program.  If
   you don't know what that is, skip it. 

   Read the documentation on dvi viewers in \emtex\doc\english\dvidrv.doc

b. CM fonts from the net, for screen viewing & 600 dpi hplj IV printing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   I haven't tried this, since I couldn't find the .fli files for the HPLJ 4 on
   the net.  They would be rather large (up to 4x larger than the 300dpi---twice
   in each dimension, 2 dimensions).  If you do find them, edit
   \emtex\v.bat to use @ljh.cnf and follow along similarly to the previous
   section for 300dpi fonts, but edit \emtex\ljh.cnf, instead.

   Or, You may want to dynamically generate the fonts (below)...


c. Dynamically generating the CM fonts on demand, 300 dpi for hplj & screen
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   This is how I do it.  Append the following line to \emtex\data\lj.cnf
   /fb

   I also add a /pt to the file to prevent all the .dlg files.

   You may wish to comment out the /pl line with a %, since you will not be
   using the font libraries, as was done in 4a.

   Make sure that `set mfjobopt=-3' is in your autoexec.bat, or that it is
   set before trying to generate the fonts.  This tells mfjob to use mf386.exe
   instead of mf.exe.

   cd \test
   v test

   should generate 2 fonts and then display the dvi file on your screen.  The
   next time you do `v test' the fonts will already be generated.  v.bat is a
   batch file in \emtex which calls dviscr.  If you have a math coprocessor,
   edit v.bat to call dviscr7.exe.  You can also put the one line contents of
   v.bat into a ced-like line.  The fonts go to \texfonts\pixel.lj\300dpi.


d. Dynamically generating the CM fonts on demand, 600 dpi for hplj IV & screen
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   Append the following lines to \emtex\data\ljh.cnf
   /fb

   & comment out the /pl line with a %.  Also edit v.bat to use ljh.cfg instead
   of lj.cnf.    v.bat is a batch file in \emtex which calls dviscr.  If you
   have a math coprocessor, edit v.bat to call dviscr7.exe.  I also add a /pt
   to the config file to prevent all the .dlg files.

   Make sure that `set mfjobopt=-3' is in your autoexec.bat, or that it is
   set before trying to generate the fonts.  This tells mfjob to use mf386.exe
   instead of mf.exe.

   cd \test
   v test

   should generate 2 fonts and display the dvi file on your screen.  The fonts
   go to \texfonts\pixel.ljh\600dpi.  Next time, it won't have to generate
   these fonts.

e. Locally generating all 300dpi fonts for HP
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   cd \emtex\mfjob
   mfjob all                                              [wait several hours]
   cd \
   del \newfonts\tfm
   rmdir \newfonts\tfm
   del \newfonts\log
   rmdir \newfonts\log
   move newfonts texfonts

f. Locally generating all 600dpi fonts for HP IV
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   cd \emtex\mfjob
   edit modes.mfj and change `def m=[lj]' to `def m=[ljh]' at end
   mfjob all                                              [wait several hours]
   cd \
   del \newfonts\tfm
   rmdir \newfonts\tfm
   del \newfonts\log
   rmdir \newfonts\log
   move newfonts texfonts


5. Printing using CM fonts and HPLJ or HPLJ IV
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
use prthplj.bat and prthpljh.bat respectively.  You may want to edit
them and change the output file /po=lpt1:, etc.  If you have a math coproc,
edit prthplj.bat and prthpljh.bat to call dvihplj7.exe.  If you are using
the HPLJ IV, add /og=600 to \emtex\prthpljh.bat on the same line.

These routines use the same fonts and config files as the screen previewer,
so once the fonts are generated by the screen viewer, they are generated for
the printer too. 

IF you have an hp printer you are now done with the installation.

6. PSNFSS & DVIPS for postscript printers (skip if you don't have a PS printer)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a. Using CM fonts only, and not the internal PS fonts of your printer

   if all you want to do is to use the CM fonts (and not the fonts in your
   postscript printer), you may stop here.  However this is kind of a waste
   because the extra money you paid for the postscript printer gives you a
   lot of advanced features and fonts.  However, with those features comes
   more installation difficulties, ie, the rest of this document.  So no
   one would blame you for stopping here.

   If you want to stop here and generate CM fonts and download them to the
   printer as a bit-map each time you print, do the following:

   cd \
   ftp wuarchive.wustl.edu
**** 4.8 KB/s
   cd /mirrors/msdos/postscript
**** cd /systems/ibmpc/simtel/msdos/postscrp
   bin
   hash
   get dvips554.zip                                 [592,893 bytes, or latest]
   quit

   pkzip -d \dvips554.zip *.tfm               [delete the .tfm's from the zip]
   pkzip -d \dvips554.zip *.vf                 [delete the .vf's from the zip]
   pkunzip -d \dvips554.zip

   cd \emtex\texinput\dvips
   del times.sty
   del palatino.sty
   del bookman.sty
   del chancery.sty
   del avantgar.sty
   del lucida.sty
   del ncs.sty
   del psfonts.sty
   del psgreek.sty

   The above represent old style files incompatible with latex2e and psnfss2e.

   mkdir \emtex\doc\dvips
   move dvi*.tex \emtex\doc\dvips

   The fonts for the Apple Laserwriters are the same as for the HP LJ, since
   the engines are the same [write black].  Choosing dvihplj or dvips formats
   the bit maps properly in each printer's language.  This is where the
   difference is.  Thus CM fonts obtained in 4a, 4b, 4e, or 4f are suitable
   for dvips.  Follow those instructions if you haven't already for the
   screen fonts.  If you have already obtained or generated or set up
   dynamic (on the fly generation of fonts) for the screen you are already
   to go:
**** The problem is that the Dvips config files assume drive C unless
**** told otherwise (dvips won't find 'tex.pro', see page 37 Dvips manual)
**** Assuming emTeX in drive D, fonts in drive E:
**** set texconfig=d:\emtex\ps
**** set emtexdir=d:\emtex
**** set dvipsheader=d:\emtex\ps
**** set texfonts=e:\texfonts
**** set texpks=e:\texfonts\pixel.lj\%bdpi\%f.pk
**** (put these in a batch file, remember to use '%%' to mean '%' in the
****  texpks value)

   cd \test
   dvips cm
   copy cm.ps lpt1:                            [or where ever your printer is]

   You may need an iteration of `mfjob dvips' to generate fonts.  You may
   stop here.  Delete dvips.mfj after doing mfjob.


b. Using the internal PS fonts of your printer, and CM for occasional math

   IF you wish to take advantage of the native fonts in
   your postscript printer, continue on.

   Do the steps in a) above.

   To use use native fonts, you will
   insert one command \usepackage{font} in your latex document after the
   \documentclass{} command.  font=one of times, palatino, helvet, avant,
   newcent, or bookman.  To get these psnfss2e packages:

   cd \
   ftp ftp.shsu.edu                                            [or other site]
   cd tex-archive/macros/latex/packages
   bin
   hash
   get psnfss.zip                                                    [724,648]
   quit

   pkunzip -d \psnfss.zip
   cd \psnfss
   latex psfonts.ins                                            [installation]
**** answer y to "do you have the 36 common PS fonts or do you intend to install them"
   mkdir \emtex\texinput\ps
   move *.sty \emtex\texinput\ps
   mkdir \emtex\doc\ps
   move psnfss2e.tex \emtex\doc\ps
   move psfonts.dtx \emtex\dec\ps
   cd \
   del \psnfss
   rmdir \psnfss

   get the latex2e tfm, vf, fd and other associated files for adobe ps fonts:

   ftp ftp.shsu.edu                                            [or other site]
   cd tex-archive/fonts/metrics
   bin
   hash
   get adobe.zip                                             [1,895,291 bytes]
   quit

   cd \
   pkunzip -d \adobe.zip

   edit \emtex\ps\config.ps and uncomment (delete the *) & change the line:
   T c:\emtex\tfm;c:\emtex\tfm\ps;c:\emtex\tfm\local
**** Change all the following paths (V, P, L, S, H) also because they assume drive C

   there are 6 packages (times, palatino, helvet, avant, newcent, bookman) which
   you use to select the primary postscript fonts for your document.  These in
   turn call upon the following 7 native postscipt fonts in the printer:
   Helvetica, AvantGarde, Times, Palatino, NewCenturySchoolbook, Bookman, and
   Courier.  Your printer and screen previewer should have these to work properly
   with the 6 packages (they are part of the standard 35 fonts).  This info came
   from Table 1 of psnfess2e.tex (page 4).  The file adobe.zip that you just 
   obtained contains fd, tfm, and vf data for these and many other postscript
   fonts.  I will only cover the 7 fonts used by the 6 packages.

   move \adobe\helvetic\fd\*.fd \emtex\texinput\ps
   move \adobe\avantgar\fd\*.fd \emtex\texinput\ps
**** md emtex\tfm\ps
**** This requires adding this path to the environment var TEXTFM
   move \adobe\times\fd\*.fd \emtex\texinput\ps
   move \adobe\palatino\fd\*.fd \emtex\texinput\ps
   move \adobe\newcentu\fd\*.fd \emtex\texinput\ps
   move \adobe\bookman\fd\*.fd \emtex\texinput\ps
   move \adobe\courier\fd\*.fd \emtex\texinput\ps

   mkdir \texfonts\vf
   move \adobe\helvetic\vf\*.vf \texfonts\vf
   move \adobe\avantgar\vf\*.vf \texfonts\vf
   move \adobe\times\vf\*.vf \texfonts\vf
   move \adobe\palatino\vf\*.vf \texfonts\vf
   move \adobe\newcentu\vf\*.vf \texfonts\vf
   move \adobe\bookman\vf\*.vf \texfonts\vf
   move \adobe\courier\vf\*.vf \texfonts\vf

   move \adobe\helvetic\tfm\*.tfm \emtex\tfm\ps
   move \adobe\avantgar\tfm\*.tfm \emtex\tfm\ps
   move \adobe\times\tfm\*.tfm \emtex\tfm\ps
   move \adobe\palatino\tfm\*.tfm \emtex\tfm\ps
   move \adobe\newcentu\tfm\*.tfm \emtex\tfm\ps
   move \adobe\bookman\tfm\*.tfm \emtex\tfm\ps
   move \adobe\courier\tfm\*.tfm \emtex\tfm\ps

   move \adobe\helvetic\phv.map \emtex\ps
   move \adobe\avantgar\pag.map \emtex\ps
   move \adobe\times\ptm.map \emtex\ps
   move \adobe\palatino\ppl.map \emtex\ps
   move \adobe\newcentu\pnc.map \emtex\ps
   move \adobe\bookman\pbk.map \emtex\ps
   move \adobe\courier\pcr.map \emtex\ps

   cd \
   del adobe.zip
   del adobe
   rmdir adobe

   cd \emtex\ps
   del psfonts.map
   ren *.map *.x
   copy phv.x + pag.x + ptm.x + ppl.x + pnc.x + pbk.x + pcr.x psfonts.map
   del *.x

   cd \test and create a file called ps.tex
   \documentclass{article}
   \usepackage{times}
   \begin{document}
   Hello world...........$\sum$
   \end{document}

   dvips ps

   this should work.  The math needs to use the old CM fonts, a small subset
   of which may need to be generated on the fly or downloaded.  dvips should
   have created an instruction file for mfjob to create the missing math
   fonts.  If all is well, run

   mfjob dvips
   dvips ps
   copy ps.ps to lpt1:                      [or whatever is your printer port]

   and you should have the complete document.  I create everything on demand,
   when dvips complains, using mfjob dvips as above.

   cd \
   del adobe
   rmdir adobe

   Note, as I mentioned before, you can't view postscript on your screen.
   The missing fonts appear as boxes on the screen, but print fine on a
   postscript printer.

   You can look at the document on the screen using ghostscript or another
   postscript previewer, which allows you to look at any included post-
   script figures too, but involves a few more hours of install time (if you've
   gotten this far then you can handle anything!).

   Check out gs386.exe on wuarchive.wustl.edu.


7. CUSTOM FONTS
~~~~~~~~~~~~~~~
to use a custom font, say APL, get the .mf file off the net, and
put it in a \emtex\mfinput\local subdirectory.  As an example, use cmapl10.mf
from the CTAN archive in /tex-archive/fonts/apl:

cd \emtex\mfinput\local
mf386 \mode=hplaser; \nonstopmode; mag=1.0; input cmapl10

move cmapl10.tfm \emtex\tfm\local

to look at it, for example, do:

tex testfont
and reply:
cmapl10
\table
\end

then
v testfont

and let it generate the fonts and look at them!  To use them in a document,
read the texbook.

you can print out the result on an hp printer:
dvihplj testfont

you can print out the result on an hp IV printer:
dvihpljh testfont

you can print out the result on a postscipt printer:
dvips testfont

(c) 1995 John P. Refling, All rights reserved.


                                 # - # - #




                                 printing
                                   /|\
/-                               /  |  \
|                              /    |    \
|                            /      |      \
|printer                hp /        | hpIV   \ ps
|                        /          |          \
|                      /            |            \
\-                   /              |              \
                   /                |                \
/-               /                 / \               / \
|font      CM  /              CM /     \ HP     CM /     \ PS /w CM
|-           /                 /        ?        /         \
           /                 /                 /             \
       prthplj           prthpljh          dvips1           dvips2
         300               600              300               300
/-        |\               /|                |\               /|
|         |  \ LIB   OTF /  |                |  \ LIB   OTF /  |
|     OTF |    \       /    | LIB        OTF |    \       /    |
|         |      \   /      |                |      \   /      |
|source   |        \        |                |        \        |
|         |      /   \      |                |      /   \      |
|         |    /       \    |                |    /       \    |
|         |  /           \  |                |  /           \  |
\-        |/               \|                |/               \|

        4c,4d       download=4a or 4b   6a+(4c or 4d)  download=6b+(4a or 4b)
                     genall=4e or 4f                    genall=6b+(4e or 4f)


Type of printer
~~~~~~~~~~~~~~~
hp   = PCL (hplaserjet 1+ through BUT not including the HP Laserjet IV)
hpIV = PJL (hplaserjet IV, w/o postscript)
ps   = any postscript printer (including hplaserjet IV w/postscript)

Choice of font
~~~~~~~~~~~~~~
CM = Computer Modern fonts, freely available, and included with emtex
     (either generated locally with metafont, or downloaded off the net,
     see source of CM font below)
HP = scaleable fonts inside the HP laserjet IV printer
PS = scaleable postscript fonts inside a postscript printer, however, when
     you are using math, it will revert to CM for the math fonts.  See source
     of CM fonts below.

Source of CM fonts (for CM or CM for postscript math)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OTF = On the fly font generation (initially slower, small space rqmt)
LIB = downloaded libraries of all the fonts (faster, large space rqmt ~5 MB)



What to use
~~~~~~~~~~~
prthplj = from emtex
prthpljh = from emtex
dvips1 = with OTF CM generation from MakeTeXPK, or PK libraries
dvips2 = mostly internal postscript fonts, but some of OTF CM generation
         for fonts missing from postscript.
?      = no solution that I am aware of, but I didn't look very hard

(c) 1995 John P. Refling.  All rights reserved.

**** All lines below this one represent my setup, they are not from John Refling:
**** (they are not all marked with '****' to avoid cluttering)

****           Encapsulated PostScript support:
To be able to use the epsfig package expand 'graphics.tar.gz' somewhere,
read the '00readme.txt' and then run: 
('?' is your drive letter, .tgz because .tar.gz is invalid in Ms-Dos)

gzip -dc graphics.tgz | tar xvf -
latex graphics.ins
md ?:\emtex\texinputs\graphics
copy *.def ?:\emtex\texinputs\graphics
copy *.sty ?:\emtex\texinputs\graphics
copy 00readme.txt ?:\emtex\texinputs\graphics
echo  \ExecuteOptions{dvips} > ?:\emtex\texinputs\graphics\color.cfg
echo  \ExecuteOptions{dvips} > ?:\emtex\texinputs\graphics\graphics.cfg

****          I put this in my 'autoexec.bat':

rem emTeX, don't change, just update DVIDRVFONTS, EMTEXDRIVE, PATH and edit the
rem file '?:\emtex\ps\config.ps' and fix its T, V, P, L, S, H paths
set DVIDRVFONTS=G:\texfonts
set EMTEXDRIVE=H
echo Calling %EMTEXDRIVE%:\emtex\set-tex.bat
if exist %EMTEXDRIVE%:\emtex\set-tex.bat goto SETTEX
echo File not found!
pause
:SETTEX
call %EMTEXDRIVE%:\emtex\set-tex.bat
SET MFINPUT=%MFINPUT%;g:\usr\local\lib\tex\mfinput

****         And I put this in the 'set-tex.bat' file in the emtex dir:

rem emTeX env vars setup, see also jrtex12a.txt.
rem If changing location update:
rem a) env vars 'EMTEXDRIVE' (emTeX drive) and 'DVIDRVFONTS' (TeX fonts path)
rem b) edit the file 'emtex\ps\config.ps' and fix the paths T, V, P, L, S, H
if %DVIDRVFONTS%.==. goto NOENVVAR
if %emtexdrive%.==. goto NOENVVAR
rem Append `!' to a directory name to get one-level subdirectory search
rem Append `!!' to a directory name to let emTeX search all subdirectories
SET TEXINPUT=%emtexdrive%:\EMTEX\TEXINPUT!
SET TEXFMT=%emtexdrive%:\EMTEX\TEXFMTS
SET BTEXFMT=%emtexdrive%:\EMTEX\BTEXFMTS
SET TEXTFM=%emtexdrive%:\EMTEX\TFM;%emtexdrive%:\EMTEX\TFM\PS
SET MFINPUT=%emtexdrive%:\EMTEX\MFINPUT
SET MFBAS=%emtexdrive%:\EMTEX\MFBASES
SET BMFBAS=%emtexdrive%:\EMTEX\BMFBASES
SET MFJOB=%emtexdrive%:\EMTEX\MFJOB
SET BIBINPUT=%emtexdrive%:\EMTEX\BIBINPUT
SET DVIDRVINPUT=%emtexdrive%:\MYTEX;%emtexdrive%:\EMTEX\DOC
rem SET DVIDRVGRAPH=C:\MYTEX;%emtexdrive%:\EMTEX\DOC\GR$r
SET DVIDRVGRAPH=%emtexdrive%:\EMTEX\DOC\GR$r
set dviscr=-s2
set mfjobopt=-3
rem DVIPS 5.54 (also possible to only use TEXCONFIG and to set rest in cfg file)
set texconfig=%emtexdrive%:\emtex\ps
set emtexdir=%emtexdrive%:\emtex
set dvipsheaders=%emtexdrive%:\emtex\ps
set texfonts=%emtexdrive%:\emtex\tfm;%emtexdrive%:\emtex\tfm\ps
set texpks=%DVIDRVFONTS%\pixel.lj\%%bdpi\%%f.pk
goto THEEND
:NOENVVAR
echo %0: ERROR, env vars DVIDRVFONTS and EMTEXDRIVE not set!
pause
:THEEND

**** GhostScript (PostScript level 2 interpreter/previewer)
**** The current version is 3.12 (Oct-94)
**** ftp.funet.fi:/pub/gnu/ghostscript3/aladdin
There are several Dos/Win binaries: 
   1) gs.exe was compiled for the following devices:
        vga ega svga16 vesa atiw tseng tvga deskjet
        djet500 laserjet ljetplus ljet2p ljet3 ljet4 cdeskjet cdjcolor
        cdjmono cdj550 pj pjxl bj10e bj200 epson eps9high
        ibmpro gifmono gif8 pcxmono pcxgray pcx16 pcx256 pcx24b
   2) gs386.exe was compiled for the following devices:
        vga ega svga16 atiw tseng tvga deskjet djet500
        laserjet ljetplus ljet2p ljet3 ljet4 cdeskjet cdjcolor cdjmono
        cdj550 paintjet pjetxl epson eps9high ibmpro bj10e bj200
        gifmono gif8 tiffg3 faxg3 pcxmono pcxgray pcx16 pcx256
        pcx24b pbm pbmraw pgm pgmraw ppm ppmraw bitcmyk
  3) don't know what gswin.exe was compiled for (use the PostScript command 
     'devicenames ==' to find out, using the option '-h' won't work here)
  4) gswin32s.exe was compiled (not by Aladdin) for the following devices:
       	mswin mswinprn deskjet djet500 laserjet ljetplus ljet2p
       	ljet3 ljet4 cdeskjet cdjcolor cdjmono cdj550 paintjet pjetxl epson 
       	eps9high ibmpro st800 bj10e bj200 gifmono gif8 tiffg3
       	tiffg4 bmpmono bmp16 bmp256 bmp16m pcxmono 
       	pcx16 pcx256 pbm pbmraw pgm pgmraw ppm ppmraw
If you need something that is not in here you will have to compile GhostScript
yourself (if the device code already exists just add it to the makefile,
otherwise you'll have to write it yourself, there is documentation on how to do
that) or if your printer is supported by Windows to use gswin?.exe with the
device 'mswinprn')

**** end of this file
