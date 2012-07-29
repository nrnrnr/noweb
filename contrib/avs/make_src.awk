# edits noweb/src/makefile for Ms-Dos + PC386 + Icon 386 9.0 + DJGPP + MKS 4.2
# tested with noweb 2.7a

BEGIN { print "# generated MsDos makefile, original in makefile.old" }

/SHELL\=/ { $0 = "# " $0 } # disable SHELL def

/for i in shell lib xdoc tex;/ {  # new fix for noweb 2.7a (not needed in 2.7)
  $0 = "\tcd shell\n\tmake all\n\tcd ..\n\tcd lib\n\tmake all\n\tcd ..\n\tcd xdoc\n\tmake all\n\tcd ..\n\tcd tex\n\tmake all\n\tcd ..\n"
}

/cd ([a-z]+)|(\$\(LIBSRC\)); make/ { # fix problems with quotes and 'cd' and explode into 3 lines
    if ($NF == "all") {
      for (k = 1; k <= NF; ++k) gsub("\"", "", $k); # remove quotes
	sub(/;/, "", $2); # remove semicolon
	s = ""; for (k = 4; k <= NF; ++k) s = s " " $k; # group 'Make' args in a single string (for the sprintf)
	$0 = sprintf("cd %s\n\t$(DJGPPMAKE) %s\n\tcd ..", $2, s);
    } else
      if ($NF == "install")
	sub("^[^;]+", " \"&\"", $2); # add quotes (which need a shell) to force use of shell internal 'cd' instead of bin/cd.exe
   $0 = "\t" $0;
}    

/\/dev\/null/ { sub(/\/dev\/null/, "NUL") } # Ms-Dos uses NUL to mean /dev/null 

/strip/ {
  sub(/strip/, "# strip");    # remove the strip, MKS strip would ruin the binaries 
  $0 = $0 "\n\tcd \"c\";  coff2exe nt markup mnt finduses"; # and in next line add the coff2exe command (see DJGPP docs)
}

/chmod \+x/ { $0 = "\t# " $0 } # disable chmod (not necessary and sometimes tries to 'chmod +x foo' instead of 'chmod +x foo.ksh')

/cp / {  # add an eventual extension (.exe or .ksh) when copying
  if  (match($2, "^c/")) {
    $1 = "\t" $1;
    for (k = 2; k < NF; ++k) # NB: 1st & last field not processed
      $k = $k ".exe";
  } else {
    if ($NF == "$(LIB)") { # add .ksh and split in several lines
      s = "";
      for (k = 2; k < NF; ++k) {
        baseName = substr($k, 1 + match($k, "/"));
        s = s sprintf("\tcp %s %s/%s.ksh", $k, $NF, baseName);
        if (k != NF-1) 
	  s = s "\n";
      }
      $0 = s;
    }
  }
}

/install: install-code install-man install-tex/ { $3 = "install-preformat-man" } # MKS has no NROFF

/sed / { # all files processed by sed require something to be fixed for MsDos
  if (match($0, "\$\(BIN\)"))
    $NF = $NF ".ksh" # add .ksh extension
  else {
    if (match($0, "gzip")) {  # remove gzip of man pages, MKS supports compressed man pages but in .dbz not in .gz format
      sub("\| gzip", ""); # remove call to gzip
      sub("\.gz$", "", $NF); # remove .gz extension
    } else
	$0 = "#" $0; # Disable because MKS does not support NROFF
  }
  $0 = "\t" $0;
}

/; ln / { # no links in MsDos
    sub(/; ln /, "; cp -p "); # replace link (ln) with copy (cp)
    gsub(/\.gz/, "");  # gzip compressed man pages not used
}

{ print $0 } # prints the line (which might have been changed)
