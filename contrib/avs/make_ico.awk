# edits noweb/src/icon/makefile for Ms-Dos + PC386 + Icon 386 9.0 + DJGPP + MKS 4.2
# tested with noweb 2.7a

BEGIN { print "# generated MsDos makefile, original in makefile.old" }

/SHELL=/ { $0 = "# " $0 } # disable SHELL def

/BINEXECS=/ { # add .exe extension
  s = "";
  for (k = 1; k <= NF; ++k)
     s = s sprintf("%s.exe ", $k);
  $0 = s
}

function splitLineTooLong() { # appends to strings s1 & s2 (does not initialize them)
   for (k = 1; k <= NF; ++k) 
      if (match($k, "\\."))
         s1 = s1 $k " ";
      else
         s2 = s2 $k ".exe ";
 }
/LIBEXECS=/ { # split in 2 parts (to avoid 128 chars command.com overflow) and add .exe if no extension is provided
   s1 = ""; s2 = ""; 
   if ($NF == "\\") { # tackles problem of a '\' meaning continue in next line
      $NF = ""; 
      NF = NF - 1;
      splitLineTooLong();
      getline;  # read next line due to '\' continuation char
   }
   splitLineTooLong();
   printf("LIBEXECS2=%s\n", s1);
   $0 = s2;
}

/^EXECS=/ { $0 = $0 " $(LIBEXECS2)" }  # because now LIBEXECS is split into LIBEXECS and LIBEXECS2

/cp \$\(LIBEXECS\)/ { printf("\tcp $(LIBEXECS2) $(LIB)\n"); } # the new LIBEXECS2 also need to be copied

/\/bin\/rm/ { $1 = "\trm" } # rm might not be at "/bin/rm", remember to add the tab \t

/\$\(ICON.\) -o/ { 
    if (!match($3, "\\."))  { # if no extension add .exe
       sub(/[a-z0-9]+/, "&.exe", $3);
       $1 = "\t" $1 " -I"   # add -I  option to icon translator (see Icon 386 9.0 Ms-Dos docs)
     }
  }

/^[a-z0-9]+: [a-z0-9]+\.icn/ && NF == 2 { sub(/[a-z0-9]+/, "&.exe", $1) } # add .exe 

{ print $0 } # prints the line (which might have been changed)
