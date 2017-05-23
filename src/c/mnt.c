#line 9 "mnt.nw"
static char rcsid[] = "$Id: mnt.nw,v 1.22 2008/10/06 01:03:05 nr Exp nr $";
static char rcsname[] = "$Name: v2_12 $";
static struct keepalive { char *s; struct keepalive *p; } keepalive[] =
  { {rcsid, keepalive}, {rcsname, keepalive} }; /* avoid warnings */
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

#line 27 "mnt.nw"
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
#line 38 "mnt.nw"
    for (i=1; i<argc; i++) 
      switch (*argv[i]) {
        case '-': 
#line 155 "mnt.nw"
    switch (*++argv[i]) {
        case 'a':
            if (strcmp(argv[i], "all"))
                errormsg(Warning, "Ignoring unknown option -%s", argv[i]);
            else {
#line 51 "mnt.nw"
apply_each_module(add_uses_to_usecounts);
apply_each_module(emit_if_unused_and_conforming);
#line 159 "mnt.nw"
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
#line 40 "mnt.nw"
                                                                   break;
        default:  emitfile(argv[i]);                               break;
      }
    nowebexit(NULL);
    return errorlevel;          /* slay warning */
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
  char tempname[] = "nowebXXXXXX";
  FILE *fp = tmpfile();
  char *lfmt, *filename;
  
#line 111 "mnt.nw"
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
#line 98 "mnt.nw"
  
#line 150 "mnt.nw"
if (root == NULL) {
  errormsg(Error, "Chunk <<%s>> is undefined", filename);
  return;
}
#line 99 "mnt.nw"
  if (fp == NULL) errormsg(Fatal, "Can't open temporary file %s", tempname);
  
#line 122 "mnt.nw"
resetloc();
(void) expand(root, 0, 0, 0, lfmt, fp);
putc('\n', fp);
fclose(fp);
#line 101 "mnt.nw"
  
#line 128 "mnt.nw"
{ FILE *dest, *tmp;
  dest = fopen(filename, "r");
  if (dest != NULL) {
    int x, y;
    tmp = fopen(tempname, "r");
    assert(tmp);
    do { 
      x = getc(tmp);
      y = getc(dest);
    } while (x == y && x != EOF);
    fclose(tmp);
    fclose(dest);
    if (x == y) {
      remove(tempname);
      return;
    }
  }
}
#line 102 "mnt.nw"
  remove(filename);
  if (rename(tempname, filename) != 0) { /* different file systems? (may have to copy) */
    FILE *fp = fopen(filename, "w");
    if (fp == NULL) {remove(tempname); 
#line 147 "mnt.nw"
errormsg(Error, "Can't open output file %s", filename);
return;
#line 105 "mnt.nw"
                                                                                     }
    
#line 122 "mnt.nw"
resetloc();
(void) expand(root, 0, 0, 0, lfmt, fp);
putc('\n', fp);
fclose(fp);
#line 107 "mnt.nw"
    remove(tempname);
  }
}
