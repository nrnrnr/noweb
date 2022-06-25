#line 9 "mnt.nw"
static char rcsid[] = "$Id: mnt.nw,v 1.22 2008/10/06 01:03:05 nr Exp nr $";
static char rcsname[] = "$Name: v2_12 $";
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <ctype.h>
#include "modules.h"
#include "modtrees.h"
#include "notangle.h"
#include "errors.h"
#include "columns.h"
#include "strsave.h"

#line 54 "mnt.nw"
void add_uses_to_usecounts(Module mp);
void emit_if_unused_and_conforming(Module mp);
#line 90 "mnt.nw"
static void emitfile(char *modname);

#line 26 "mnt.nw"
#define Clocformat "#line %L \"%F\"%N"
static char *locformat = Clocformat;

int main(int argc, char **argv) {
    int i;

    tabsize = 0;  /* default for nt is not to use tabs */

    progname = argv[0];
    finalstage = 1;
    
#line 48 "mnt.nw"
read_defs(stdin);
apply_each_module(remove_final_newline);
#line 37 "mnt.nw"
    for (i=1; i<argc; i++) 
      switch (*argv[i]) {
        case '-': 
#line 149 "mnt.nw"
    switch (*++argv[i]) {
        case 'a':
            if (strcmp(argv[i], "all"))
                errormsg(Warning, "Ignoring unknown option -%s", argv[i]);
            else {
#line 51 "mnt.nw"
apply_each_module(add_uses_to_usecounts);
apply_each_module(emit_if_unused_and_conforming);
#line 153 "mnt.nw"
                                                    }
            break;
        case 't': /* set tab size or turn off */
            if (isdigit(argv[i][1]))
                tabsize = atoi(argv[i]+1);
            else if (argv[i][1]==0)
                tabsize = 0;            /* no tabs */
            else 
                errormsg(Error, "%s: ill-formed option %s\n", argv[0], argv[i]);
            break;          
        case 'L': /* have a #line number format */
            locformat = argv[i] + 1;
            if (!*locformat) locformat = Clocformat;
            break;
        default:
            errormsg(Warning, "Ignoring unknown option -%s", argv[i]);
     }
#line 39 "mnt.nw"
                                                                   break;
        default:  emitfile(argv[i]);                               break;
      }
    nowebexit(NULL);
    (void)(rcsid); (void)(rcsname); /* slay warnings */
    return errorlevel;              /* slay warning */
}
#line 57 "mnt.nw"
void add_uses_to_usecounts(Module mp) {
    Module used;
    struct modpart *p;
    for (p=mp->head; p!=NULL; p=p->next)
        if (p->ptype == MODULE) {
            used = lookup(p->contents);
            if (used != NULL)
                used->usecount++;
        }
}
#line 73 "mnt.nw"
void emit_if_unused_and_conforming(Module mp) {
    char *index;
    if (mp->usecount == 0 && strpbrk(mp->name, " \n\t\v\r\f") == NULL) {
        if (index = strpbrk(mp->name, "[](){}!$&<>*?;|^`'\\\""),
            index == NULL || (index[0] == '*' && index[1] == 0)) {
	    if (index == mp->name)
	        errormsg(Error, "<<*>> is not a good chunk name for noweb; "
	                        "use notangle instead");
	    else
	        emitfile(mp->name);
        } else {
            errormsg(Error, "<<%s>> cannot be an output chunk; "
                            "it contains a metacharacter", mp->name);
        }
    }
}
#line 92 "mnt.nw"
static void emitfile(char *modname) { 
  Module root = lookup(modname);
  FILE *fp = tmpfile();
  char *lfmt, *filename;
  
#line 110 "mnt.nw"
{ int n = strlen(modname) - 1;
  if (n >= 0 && modname[n] == '*') {
    lfmt = locformat;
    filename = strsave(modname);
    filename[n] = 0;
  } else {
    lfmt = "";
    filename = modname;
  }
}
#line 97 "mnt.nw"
  
#line 144 "mnt.nw"
if (root == NULL) {
  errormsg(Error, "Chunk <<%s>> is undefined", filename);
  return;
}
#line 98 "mnt.nw"
  if (fp == NULL) errormsg(Fatal, "Calling tmpfile() failed");
  
#line 121 "mnt.nw"
resetloc();
(void) expand(root, 0, 0, 0, lfmt, fp);
putc('\n', fp);
#line 100 "mnt.nw"
  rewind(fp);
  
#line 126 "mnt.nw"
{ FILE *dest = fopen(filename, "r");
  if (dest != NULL) {
    int x, y;
    do { 
      x = getc(fp);
      y = getc(dest);
    } while (x == y && x != EOF);
    fclose(dest);
    if (x == y) {
      fclose(fp);
      return;
    }
  }
}
#line 102 "mnt.nw"
  remove(filename);
  fclose(fp);
  fp = fopen(filename, "w");
  if (fp == NULL) {
#line 141 "mnt.nw"
errormsg(Error, "Can't open output file %s", filename);
return;
#line 105 "mnt.nw"
                                                                 }
  
#line 121 "mnt.nw"
resetloc();
(void) expand(root, 0, 0, 0, lfmt, fp);
putc('\n', fp);
#line 107 "mnt.nw"
  fclose(fp);
}
