#line 24 "markup.nw"
static char rcsid[] = "$Id: markup.nw,v 2.24 2008/10/06 01:03:05 nr Exp nr $";
static char rcsname[] = "$Name: v2_12 $";
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <assert.h>
#include "markup.h"
#include "strsave.h"
#include "errors.h"

#line 64 "markup.nw"
char at_sign = '@';             /* should be the only place '@' is mentioned */
#line 89 "markup.nw"
static char def_marker[] = " %def ";
#define def_length (6)

#line 74 "markup.nw"
int starts_doc(char *line) {
    
#line 39 "markup.nw"
(void)(rcsid); (void)(rcsname);
#line 76 "markup.nw"
    return (*line==at_sign && (line[1]=='\0' || isspace(line[1])));
}

char *first_doc_line(char *line) {
    if (line[1]!='\0' && line[1] !='\n') return line+2;
    else return line+1;
}
#line 92 "markup.nw"
int is_def(char *line) {
    int answer;
    static int complained;
    
#line 105 "markup.nw"
{ static int checked = 0;
  if (!checked) {
    assert(strlen(def_marker) == def_length);
    checked = 1;
  }
}
#line 96 "markup.nw"
    answer = (*line==at_sign && !strncmp(line+1, def_marker, def_length));
    
#line 115 "markup.nw"
if (answer && !complained) {
    complained = 1;
/*
    fprintf(stderr, "Warning: @ %%def is deprecated.  Use `-filter autodefs.xxx'\n"
	            "         or `-filter btdefn'\n");
*/
}
#line 98 "markup.nw"
    return answer;
}

char *remove_def_marker(char *line) {
    return line+1+def_length;
}
#line 145 "markup.nw"
char *mod_start(char *s, int mark) {
    return find_escaped(s,"<<","@<<", mark);
}
char *mod_end(char *s, int mark) {
    return find_escaped(s,">>","@>>", mark);
}
#line 164 "markup.nw"
int starts_code (char *line, char *filename, int lineno) {
    char *tail;
    if (mod_start(line,0) != line+2) return 0;
    tail = mod_end(line+2,0);
    if (tail == NULL || *tail++ != '=') return 0;
    while (isspace(*tail)) tail++;
    return (*tail == '\0');
}

void getmodname(char *dest, int size, char *source) {
    /* excess characters in the module name are ignored */
    char *p = strsave(source);
    char *q = mod_start(p,1);

    if (q==NULL) 
#line 185 "markup.nw"
{
    free(p);
    impossible
        ("I couldn't manage to extract a module name, but I'm sure I saw one");
}
#line 179 "markup.nw"
    if (mod_end(q,1)==NULL) 
#line 185 "markup.nw"
{
    free(p);
    impossible
        ("I couldn't manage to extract a module name, but I'm sure I saw one");
}
#line 180 "markup.nw"
    strncpy(dest,q,size-1);
    dest[size-1] = '\0';
    free(p);
}
#line 208 "markup.nw"
char *find_escaped(register char *s, char *search, char *escape, int mark) {
    register char first = *search;
    register char first_escape = (escape != NULL ? *escape : '\0');
    int searchlen = strlen(search);
    int escapelen = (escape != NULL ? strlen(escape) : 0);

    do {
        while (*s && *s != first && *s != first_escape) s++;
        if (!*s) break;
        if (first_escape && !strncmp(s,escape,escapelen)) {
                s += escapelen;
                continue;
        }
        if (!strncmp(s,search,searchlen)) break;
        s++;
    } while (*s != '\0');
    /* here either s is empty or it points to the first unescaped [[search]] */
    if (*s == '\0') return NULL;
    if (mark) *s = '\0';
    return s+searchlen;
}
