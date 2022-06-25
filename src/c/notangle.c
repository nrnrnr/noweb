#line 18 "notangle.nw"
static char rcsid[] = "$Id: notangle.nw,v 2.25 2008/10/06 01:03:05 nr Exp nr $";
static char rcsname[] = "$Name: v2_12 $";
#define MAX_MODNAME 255
#line 23 "notangle.nw"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "strsave.h"
#include "getline.h"
#include "modules.h"
#include "modtrees.h"
#include "errors.h"
#include "match.h"
#include "notangle.h"

#line 163 "notangle.nw"
static void warn_dots(char *modname);          /* warn about names ending in ... */

#line 182 "notangle.nw"
void insist(char *line, char *keyword, char *msg);

#line 37 "notangle.nw"
void emit_module_named (FILE *out, char *rootname, char *locformat) {
    Module root = NULL; /* ptr to root module */

    root = lookup(rootname);
    
#line 167 "notangle.nw"
if (root==NULL) {
    errormsg(Fatal, "The root module <<%s>> was not defined.", rootname);
    return;
}
#line 42 "notangle.nw"
    (void) expand(root,0,0,0,locformat,out);
    putc('\n',out);                     /* make output end with newline */
    (void)rcsid; /* avoid a warning */
    (void)rcsname; /* avoid a warning */
}
#line 58 "notangle.nw"
void read_defs(FILE *in) {
    char modname[MAX_MODNAME+1] = ""; /* name of module currently being read, 
                                         [[""]] if no module is being read */ 
    Module modptr = NULL;       /* ptr to current module, or NULL */
    char *line = NULL;          /* buffer for input */
    Location loc;

    while ((line = getline_nw(in)) != NULL) {
        if (is_keyword(line, "fatal")) exit(1);
        
#line 103 "notangle.nw"
if (is_keyword(line, "nl") || is_index(line, "nl")) {
    loc.lineno++;
#line 115 "notangle.nw"
} else if (is_keyword(line,"file")) {
    
#line 128 "notangle.nw"
{ char temp[MAX_MODNAME+1];
  if (strlen(line) >= MAX_MODNAME + strlen("@file "))
    overflow("file name size");
  strcpy(temp,line+strlen("@file "));
  temp[strlen(temp)-1]='\0';
  loc.filename = strsave(temp);
}
#line 117 "notangle.nw"
    loc.lineno = 1;
} else if (is_keyword(line, "line")) {
    
#line 136 "notangle.nw"
{ char temp[MAX_MODNAME+1];
  if (strlen(line) >= MAX_MODNAME + strlen("@line "))
    overflow("file name size");
  strcpy(temp,line+strlen("@line "));
  temp[strlen(temp)-1]='\0';
  
#line 145 "notangle.nw"
{ char *p;
  for (p = temp; *p; p++)
    if (!isdigit(*p)) 
      errormsg(Error, "non-numeric line number in `@line %s'", temp);
}
#line 142 "notangle.nw"
  loc.lineno = atoi(temp);
}
#line 120 "notangle.nw"
    loc.lineno--;
#line 106 "notangle.nw"
} 
if (!is_begin(line, "code"))
    continue;
#line 68 "notangle.nw"
        
#line 99 "notangle.nw"
do { line = getline_nw(in);
} while (line != NULL && !is_keyword(line,"defn") && !is_keyword(line,"text"));
#line 69 "notangle.nw"
        insist(line,"defn","code chunk had no definition line");
        
#line 125 "notangle.nw"
strcpy(modname,line+strlen("@defn "));
modname[strlen(modname)-1]='\0';
#line 71 "notangle.nw"
        warn_dots(modname);       /* names ending in ... aren't like web */
        modptr = insert(modname); /* find or add module in table */

        line = getline_nw(in);
        insist(line,"nl","definition line not followed by newline");
        loc.lineno++;
        line = getline_nw(in);
        while (line != NULL && !is_end(line,"code")) {
            if (is_keyword(line,"nl")) {
                addnewline(modptr);
                loc.lineno++;
            } else if (is_keyword(line,"text")) {
                addstring(modptr,line+1+4+1,loc);
            } else if (is_keyword(line,"use")) {
                warn_dots(line+1+3+5);
                addmodule(modptr,line+1+3+1);
            } else if (is_index(line, "nl")) {
                loc.lineno++;
            
#line 115 "notangle.nw"
} else if (is_keyword(line,"file")) {
    
#line 128 "notangle.nw"
{ char temp[MAX_MODNAME+1];
  if (strlen(line) >= MAX_MODNAME + strlen("@file "))
    overflow("file name size");
  strcpy(temp,line+strlen("@file "));
  temp[strlen(temp)-1]='\0';
  loc.filename = strsave(temp);
}
#line 117 "notangle.nw"
    loc.lineno = 1;
} else if (is_keyword(line, "line")) {
    
#line 136 "notangle.nw"
{ char temp[MAX_MODNAME+1];
  if (strlen(line) >= MAX_MODNAME + strlen("@line "))
    overflow("file name size");
  strcpy(temp,line+strlen("@line "));
  temp[strlen(temp)-1]='\0';
  
#line 145 "notangle.nw"
{ char *p;
  for (p = temp; *p; p++)
    if (!isdigit(*p)) 
      errormsg(Error, "non-numeric line number in `@line %s'", temp);
}
#line 142 "notangle.nw"
  loc.lineno = atoi(temp);
}
#line 120 "notangle.nw"
    loc.lineno--;
#line 90 "notangle.nw"
            } else if (!is_keyword(line, "index"))
                
#line 184 "notangle.nw"
errorat(loc.filename, loc.lineno, Error, "botched code chunk `%s'", line);
#line 92 "notangle.nw"
            line = getline_nw(in);
        }
        
#line 178 "notangle.nw"
if (line==NULL) {
    impossible("End of file occurred in mid-module");
}
#line 95 "notangle.nw"
    }
}
#line 156 "notangle.nw"
static
void warn_dots(char *modname) {
  if (!strcmp(modname+strlen(modname)-3,"...")) 
    errormsg(Warning, "Module name <<%s>> isn't completed as in web", 
             modname);
}
#line 172 "notangle.nw"
void insist(char *line, char *keyword, char *msg) {
  
#line 178 "notangle.nw"
if (line==NULL) {
    impossible("End of file occurred in mid-module");
}
#line 174 "notangle.nw"
  if (!is_keyword(line,keyword))
    impossible(msg);
}
