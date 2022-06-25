#line 17 "getline.nw"
static char rcsid[] = "$Id: getline.nw,v 2.24 2008/10/06 01:03:05 nr Exp nr $";
static char rcsname[] = "$Name: v2_12 $";
#define START_SIZE 128                  /* initial buffer size */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "columns.h"
#include "errors.h"
#include "getline.h"

static char *buf1 = NULL, *buf2 = NULL; /* lines without, with tabs expanded */
static int buf_size = START_SIZE;       /* size of both buffers if non-NULL */

#line 44 "getline.nw"
void new_buffers(void) {
    checkptr(buf1 = (char *) realloc(buf1, buf_size));
    checkptr(buf2 = (char *) realloc(buf2, buf_size));
}
#line 49 "getline.nw"
char *getline_nw (FILE *fp) {

    
#line 86 "getline.nw"
if (buf1==NULL) {
    checkptr(buf1 = (char *) malloc (buf_size));
    checkptr(buf2 = (char *) malloc (buf_size));
}
#line 52 "getline.nw"
    
    buf1=fgets(buf1, buf_size, fp);
    if (buf1==NULL) return buf1; /* end of file */
    while (buf1[strlen(buf1)-1] != '\n') { /* failed to get whole line */
        buf_size *= 2;
        new_buffers();
        if (fgets(buf1+strlen(buf1),buf_size-strlen(buf1),fp)==NULL)
            return buf1; /* end of file */
    }
    (void)rcsid; /* avoid a warning */
    (void)rcsname; /* avoid a warning */
    return buf1;
}
#line 66 "getline.nw"
char *getline_expand (FILE *fp) {
    char *s, *t;
    int width;

    if (getline_nw(fp)==NULL) return NULL;
    
#line 91 "getline.nw"
if (columnwidth(buf1) > buf_size - 1) {
    while (columnwidth(buf1) > buf_size - 1) buf_size *= 2;
    new_buffers();
}
#line 72 "getline.nw"
    s = buf1; t = buf2; width=0;
    while (*s)
        if (*s=='\t' && tabsize > 0) {
            do {
                *t++ = ' '; width++;
            } while (width % tabsize != 0);
            s++;
        } else {
            *t++ = *s++; width++;
        }
    *t='\0';
    return buf2;
}
