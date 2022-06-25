#line 17 "errors.nw"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "errors.h"

#line 32 "errors.nw"
enum errorlevel errorlevel = Normal;
int finalstage = 0;
char *progname = NULL;
#line 42 "errors.nw"
void nowebexit(char *msg) {
  if (!finalstage && errorlevel > Normal)
    printf("@fatal %s %s\n", progname != NULL ? progname : "a-noweb-filter",
	   msg != NULL ? msg : "an unspecified error occurred");
  exit(errorlevel);
}
#line 56 "errors.nw"
void errormsg(enum errorlevel level, char *s,...) {     
    va_list args;                       /* see K&R, page 174 */
    va_start(args,s);
    
#line 77 "errors.nw"
if (level > errorlevel)
    errorlevel = level;
vfprintf(stderr, s, args);
fprintf(stderr,"\n");
#line 60 "errors.nw"
    va_end(args);
    if (level >= Fatal)
        nowebexit(s);
}
#line 67 "errors.nw"
void errorat(char *filename, int lineno, enum errorlevel level, char *s, ...) {     
    va_list args;                       /* see K&R, page 174 */
    va_start(args,s);
    fprintf(stderr, "%s:%d: ", filename, lineno);
    
#line 77 "errors.nw"
if (level > errorlevel)
    errorlevel = level;
vfprintf(stderr, s, args);
fprintf(stderr,"\n");
#line 72 "errors.nw"
    va_end(args);
    if (level >= Fatal)
        nowebexit(s);
}
