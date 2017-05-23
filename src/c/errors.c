#line 17 "errors.nw"
static char rcsid[] = "$Id: errors.nw,v 2.26 2008/10/06 01:03:05 nr Exp nr $";
static char rcsname[] = "$Name: v2_12 $";
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "errors.h"

#line 34 "errors.nw"
enum errorlevel errorlevel = Normal;
int finalstage = 0;
char *progname = NULL;
#line 44 "errors.nw"
void nowebexit(char *msg) {
  if (!finalstage && errorlevel > Normal)
    printf("@fatal %s %s\n", progname != NULL ? progname : "a-noweb-filter",
	   msg != NULL ? msg : "an unspecified error occurred");
  exit(errorlevel);
  (void)rcsid; /* avoid a warning */
  (void)rcsname; /* avoid a warning */
}
#line 60 "errors.nw"
void errormsg(enum errorlevel level, char *s,...) {     
    va_list args;                       /* see K&R, page 174 */
    va_start(args,s);
    
#line 81 "errors.nw"
if (level > errorlevel)
    errorlevel = level;
vfprintf(stderr, s, args);
fprintf(stderr,"\n");
#line 64 "errors.nw"
    va_end(args);
    if (level >= Fatal)
        nowebexit(s);
}
#line 71 "errors.nw"
void errorat(char *filename, int lineno, enum errorlevel level, char *s, ...) {     
    va_list args;                       /* see K&R, page 174 */
    va_start(args,s);
    fprintf(stderr, "%s:%d: ", filename, lineno);
    
#line 81 "errors.nw"
if (level > errorlevel)
    errorlevel = level;
vfprintf(stderr, s, args);
fprintf(stderr,"\n");
#line 76 "errors.nw"
    va_end(args);
    if (level >= Fatal)
        nowebexit(s);
}
