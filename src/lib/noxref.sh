#!/bin/sh
nawk 'BEGIN { defns[0] = 0 ; uses[0] = 0 ; dcounts[0] = 0 ; firstdef[0] = 0; 
              ucounts[0] = 0 ; idtable[0] = 0 ; keycounts[0] = 0 ; firstdefnout[0] = 0;
              filetable[0] = 0 }
{ lines[nextline++] = $0 }
/^@defn / { logname("DEFN", defns, dcounts, substr($0, 7)) }
/^@use /  { logname("USE", uses, ucounts, substr($0, 6)) }
/^@file / { curfile = modid(substr($0, 7)) }

function logname(which, tbl, counts, name, id) {
  counts[name] = counts[name] + 1
  id = which curfile "-" modid(name) "-" counts[name]
  tbl[name] = tbl[name] id " "
  lines[nextline++] = "@literal \\label{" id "}"
  if (which == "DEFN" && firstdef[name] == "") firstdef[name] = id
}

function modid(name, key) {
  if (idtable[name] == "") {
    key = name
    gsub(/[\[\]\\{} -]/, "*", key)
    if (length(key) > 6) key = substr(key,1,3) substr(key, length(key)-2, 3)
    keycounts[key] = keycounts[key] + 1
    idtable[name] = key "-" keycounts[key]
  }
  return idtable[name]
}

END {
  for (i=0; i < nextline; i++) {
    name = substr(lines[i], 2)
    name = substr(name, 1, index(name, " ")-1)
    arg = substr(lines[i], length(name)+3)
    if (name == "defn") {
      thischunk = arg
      printf "@defn %s~{\\footnotesize\\rm\\pageref{%s}}\n", arg, firstdef[arg]
    } else if (name == "use") {
      if (firstdef[arg] != "") 
        printf "@use %s~{\\footnotesize\\rm\\pageref{%s}}\n", arg, firstdef[arg]
      else
        printf "@use %s~{\\footnotesize\\rm (never defined)}\n", arg
    } else if (name == "end") {
        if (substr(arg, 1, 4) == "code" && firstdefnout[thischunk] == 0) {
          firstdefnout[thischunk] = 1
          n = split(defns[thischunk], a)
          if (n > 1) {
            printf "@literal \\alsodefined{"
            for (j = 2; j <= n; j++) 
              printf "\\\\{%s}", a[j]
            printf "}\n@nl\n"
          }
	  if (uses[thischunk] != "") {
  	    printf "@literal \\used{"
            n = split(uses[thischunk], a)
            for (j = 1; j <= n; j++) 
              printf "\\\\{%s}", a[j]
            printf "}\n@nl\n"
          } else 
              printf "@literal \\notused\n@nl\n"
        }
        print lines[i]
    } else
        print lines[i]
  }
}'
