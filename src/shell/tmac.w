.de ENDOFDOCUMENT
..
.de BEGINNINGOFDOCUMENT
..
.de RESETLETTER                     \" reset letter at top of page
.nr SECTIONLETTER 0 1               \" count code sections on same page
.af SECTIONLETTER a                 \" ... formatted as lower-case alpha
..
.wh 1u RESETLETTER                  \" trap just below top of page
.de BEGINDOCCHUNK
..
.de ENDDOCCHUNK
.br
..
.de BEGINCODECHUNK
.sp 0.4v
.nr OLDft \\n(.f
.ft P
.nr PREVft \\n(.f
.nr OLDps \\n(.s
.ps
.nr PREVps \\n(.s
.nr OLDvs \\n(.v
.vs
.nr PREVvs \\n(.v
.nr OLDfi \\n(.u
.nr OLDad \\n(.j
.nr OLDin \\n(.in
.ft CW
.ps \\n(.s*4/5
.vs \\n(.vu*4u/5u
.in +0.5i
.real_ta 0.5i 1i 1.5i 2i 2.5i 3i 3.5i 4i
.fi
.di CODECHUNK
..
.de ENDCODECHUNK
.br                        \" flush last line of code
.di                        \" end diversion
.if \\n(dn>\\n(.t .bp      \" force form feed if too big
.nf                        \" no fill mode -- already formatted
.in -0.5i                  \" don't re-indent when re-reading text
.CODECHUNK                 \" output body of diversion
.tm ###TAG### \\$1 \\n[%]\\n+[SECTIONLETTER] \" write tag info
.rm CODECHUNK              \" reset diversion for next code chunk
.ft \\n[PREVft]
.ft \\n[OLDft]
.ps \\n[PREVps]
.ps \\n[OLDps]
.vs \\n[PREVvs]u
.vs \\n[OLDvs]u
.if \\n[OLDfi] .fi
.ad \\n[OLDad]
.in \\n[OLDin]u
.real_ta
..
.rn ta real_ta
.de ta
.ds ta_saved \\$1 \\$2 \\$3 \\$4 \\$5 \\$6 \\$7 \\$8 \\$9
.real_ta \\$1 \\$2 \\$3 \\$4 \\$5 \\$6 \\$7 \\$8 \\$9
..
.de LINETRAP
.dt \\n[TRAPplace]u    \"cancel current trap
'ad r                  \" right-adjust continuation lines
..
.de NEWLINE
.dt \\n[TRAPplace]u    \" cancel current trap
\&                     \" end continued word
.br                    \" flush output
.nr TRAPplace \\n(.du+1u       \" location of next trap
.dt \\n[TRAPplace]u LINETRAP   \" plant trap at next line
.ad l                          \" left-adjust first line
..
.de BEGINQUOTEDCODE
.nr SAVEft \\n(.f
.ft P
.nr SAVEftP \\n(.f
.ft CW
..
.de ENDQUOTEDCODE
.ft \\n[SAVEftP]
.ft \\n[SAVEft]
..
.ds o< <\h'-0.1m'<
.ds c> >\h'-0.1m'>
.de DEFINITION
.ti -0.5i
\\fR\\(sc\\$1	\\*(o<\\$2 \\$3\\*(c>\\$4\\fP
.nr TRAPplace \\n(.du+1u       \" location of next trap
.dt \\n[TRAPplace]u LINETRAP   \" plant trap at next line
.ad l                          \" left-adjust first line
..
.de USE
\\fR\\*(o<\\$1 \\$2\\*(c>\\fP\c   \" section name and original number
..
.ds BEGINCONVQUOTE \f[CW]
.ds ENDCONVQUOTE   \fP
.de XREFDEFS
This definition continued in
..
.de XREFUSES
This code used in
..
.de XREFNOTUSED
This code is not used in this document.
.br
..
.de INDEXDEF
Defines:
.br
..
.de DEFITEM
.ti +1m
\\*[BEGINCONVQUOTE]\\$1\\*[ENDCONVQUOTE],
.if \\n[NLIST]>0 used in
..
.de INDEXUSE
Uses
..
.nr NLIST 0 1 \" initialize list index to 0 with auto-increment 1
.de ADDLIST
.ds LIST\\n+[NLIST] \\$1
..
.de PRINTITEM
.nr PLIST \\$1
.nr PLISTPLUS \\n[PLIST]+1
.if \\n[NLIST]-\\n[PLIST]<0 not used in this document.
.if \\n[NLIST]-\\n[PLIST]=0 \\*[LIST\\n[PLIST]].
.if \\n[NLIST]-\\n[PLIST]=1 \
        \\*[LIST\\n[PLIST]] and \\*[LIST\\n[PLISTPLUS]].
.if \\n[NLIST]-\\n[PLIST]>1 \{ \\*[LIST\\n[PLIST]],
.                        PRINTITEM 1+\\n[PLIST] \}
..
.de PRINTLIST
.PRINTITEM 1
.br
.nr NLIST 0 1 \" re-initialize for next list
..
.de STARTXREF
.ps \\n(.s*4/5
.vs \\n(.vu*4u/5u
.ft \\n[OLDft]
.ad \\n[OLDad]
.dt \\n[TRAPplace]u
.sp 0.4v
..
.ds BEGINDEFN  \fI
.ds ENDDEFN    \fP
.de CLISTBEGIN
.in +0.25i
..
.de CITEM
.ti -0.25i
.ie '\\$3'' \\*(o<\\$1 \\$2\\*(c> Not used in this document.
.el         \\*(o<\\$1 \\$2\\*(c> \\$3
.br
..
.de CLISTEND
.in -0.25i
..
.de ILISTBEGIN
.in +0.25i
..
.de IITEM
.ti -0.25i
\\f[CW]\\$1\\fP: \\$2
.br
..
.de ILISTEND
.in -0.25i
..
