#line 50 "modules.nw"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "modules.h"
#include "modtrees.h"
#include "errors.h"
#include "columns.h"
#include "strsave.h"

#line 108 "modules.nw"
static struct modpart *
newmodpart(int type, char *s, Location *loc);   /* create a new module part */

static
void append(Module mp, struct modpart *p);
#line 225 "modules.nw"
static int seekcycle(Module mp, Parent parent);
#line 130 "modules.nw"
static char *lastfilename = 0;
static int lastlineno = -1;
#line 41 "modules.nw"
Module newmodule (char *modname) {
    Module p = (Module) malloc (sizeof (struct module));
    checkptr(p);
    p->name = strsave(modname);
    p->usecount = 0;
    p->head = p->tail = NULL;
    return p;
}
#line 72 "modules.nw"
void add_part (Module mp, char *s, Parttype type, Location *loc) {
    struct modpart *p = newmodpart(type,s,loc);
    append (mp,p);
}
#line 77 "modules.nw"
static struct modpart *
newmodpart(int type, char *s, Location *loc) {
    struct modpart *p = (struct modpart *) malloc (sizeof (struct modpart));
    checkptr(p);
    p->ptype = type;
    if (s) {
        p->contents = strsave(s);
        
#line 102 "modules.nw"
{ int k = strlen(p->contents)-1;
  if (p->contents[k] == '\n') p->contents[k] = '\0';
  else impossible("input line doesn't end with newline");
}
#line 85 "modules.nw"
    }
    if (loc) p->loc = *loc;
    p->next = NULL;
    return p;
}
#line 91 "modules.nw"
static
void append(Module mp, struct modpart *p) {
    /* append p to mp's list of modparts */
    if (mp->head == NULL) {
        mp->head = mp->tail = p;
    } else {
        mp->tail->next = p;
        mp->tail = p;
    }
}
#line 135 "modules.nw"
void resetloc(void) {
  lastfilename = 0;
  lastlineno = -1;
}
#line 143 "modules.nw"
int expand (Module mp, int indent, int partial_distance, Parent parent,  
            char *locformat, FILE *out) {
    struct modpart *p;
    Module newmod;
    int error=Normal;
    struct parent thismodule; /* the value only matters when we're expanding a module */

    
#line 217 "modules.nw"
thismodule.this = mp;
thismodule.parent = parent;
#line 151 "modules.nw"
    
#line 220 "modules.nw"
if (seekcycle(mp, parent)) {
    errormsg(Error, "<<%s>>", mp->name);
    return Error;
}

#line 153 "modules.nw"
    for (p=mp->head; p!=NULL; p=p->next) {
        switch (p->ptype) {
            case STRING:  
#line 174 "modules.nw"
if (*(p->contents) != '\0') {
    if (*locformat) {
        if (printloc(out,locformat,p->loc,partial_distance) && (p != mp->head))
              indent_for(partial_distance, out);
    } else if (partial_distance == 0) {
        indent_for(indent, out);
        partial_distance = indent;
    }
    fprintf(out,"%s",p->contents);
    partial_distance = limitcolumn(p->contents, partial_distance);
}
#line 155 "modules.nw"
                                            ;  break;
            case MODULE:  
#line 199 "modules.nw"
newmod = lookup(p->contents);
if (newmod==NULL) {
    errormsg (Error, "undefined chunk name: <<%s>>", p->contents);
    error=Error;
} else {
    int retcode;
    if (*locformat == 0 && partial_distance == 0) {
        indent_for(indent, out);
        partial_distance = indent;
    }
    retcode = expand (newmod, partial_distance, partial_distance,
                      &thismodule, locformat, out);
    if (retcode > error) error = retcode;
}
partial_distance = limitcolumn(p->contents, partial_distance + 2) + 2; 
                                /* account for surrounding brackets */
#line 156 "modules.nw"
                                             ; break;
            case NEWLINE: 
#line 186 "modules.nw"
partial_distance = 0;
putc('\n', out);
lastlineno++;
#line 157 "modules.nw"
                                             ; break;
            default: impossible("bad part type");
        }
    }
    return error;
}
#line 227 "modules.nw"
static int seekcycle(Module mp, Parent parent) {
    if (parent == NULL) {
        return 0;
    } else if (parent->this == mp || seekcycle(mp, parent->parent)) {
        if (parent->this == mp)
            fprintf(stderr, "Cyclic code chunks: ");
        fprintf(stderr, "<<%s>> -> ", parent->this->name);
        return 1;
    } else {
        return 0;
    }
}
#line 249 "modules.nw"
int printloc(FILE *fp, char *fmt, Location loc, int partial) {
    char *p;
    if (*fmt
    && (loc.filename!=lastfilename || lastlineno != loc.lineno)) {
        if (partial) putc('\n',fp);
        
#line 261 "modules.nw"
for (p = fmt; *p; p++) {
    if (*p == '%') {
        switch (*++p) {
            case '%': putc('%', fp);                             break;
            case 'N': putc('\n', fp);                            break;
            case 'F': fprintf(fp, "%s", loc.filename);           break;
            case 'L': fprintf(fp, "%d", loc.lineno);             break;
            case '-': case '+': 
                        if (isdigit(p[1]) && p[2] == 'L') {
                          fprintf(fp, "%d", *p == '+' ? loc.lineno + (p[1] - '0')
                                                      : loc.lineno - (p[1] - '0'));
                          p += 2;
                        } else
                          
#line 281 "modules.nw"
{ static int complained = 0;
  if (!complained) {
    errormsg(Error,"Bad format sequence ``%%%c'' in -L%s",*p,fmt);
    complained = 1;
  }
}
#line 275 "modules.nw"
                      break;            
            default:  
#line 281 "modules.nw"
{ static int complained = 0;
  if (!complained) {
    errormsg(Error,"Bad format sequence ``%%%c'' in -L%s",*p,fmt);
    complained = 1;
  }
}
#line 276 "modules.nw"
                                                                break;
        }
    } else putc(*p, fp);
}
#line 255 "modules.nw"
        lastfilename = loc.filename;
        lastlineno = loc.lineno;
        return 1;
    } else return 0;
}
#line 307 "modules.nw"
void remove_final_newline (Module mp) {
        /* remove trailing newline that must be in module */
    if (mp->tail==NULL) /* module has no text */
        return;
    if (mp->tail->ptype != NEWLINE)
        /* do nothing --- this is possible with nuweb front end
              formerly: impossible("Module doesn't end with newline"); */
        ;
    else if (mp->tail == mp->head)
            mp->head = mp->tail = NULL;
    else {
        struct modpart *p = mp->head;
        while (p->next != mp->tail) p = p->next;
        p->next = NULL;
    }
}
