#line 6 "strsave.nw"
static char rcsid[] = "$Id: strsave.nw,v 2.21 2008/10/06 01:03:05 nr Exp nr $";
static char rcsname[] = "$Name: v2_12 $";
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "strsave.h"
#include "errors.h"

char *strsave (char *s) {
    char *t = malloc (strlen(s)+1);
    checkptr(t);
    strcpy(t,s);
    (void)rcsid; /* avoid a warning */
    (void)rcsname; /* avoid a warning */
    return t;
}
