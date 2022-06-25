#line 7 "main.nw"
static char rcsid[] = "$Id: main.nw,v 2.25 2008/10/06 01:03:05 nr Exp nr $";
static char rcsname[] = "$Name: v2_12 $";
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "notangle.h"
#include "errors.h"
#include "columns.h"
#include "modules.h"
#include "modtrees.h"

#line 25 "main.nw"
int main(int argc, char **argv) {
    int i;
    char *locformat = "";
    char *Clocformat = "#line %L \"%F\"%N";
    int root_options_seen = 0;

    tabsize = 0;  /* default for nt is not to use tabs */
    progname = argv[0];
    finalstage = 1;

    for (i=1; i<argc; i++) {
        
#line 55 "main.nw"
if (*argv[i]=='-') {
    
#line 71 "main.nw"
    switch (argv[i][1]) {
        case 't': /* set tab size or turn off */
            if (isdigit(argv[i][2]))
                tabsize = atoi(argv[i]+2);
            else if (argv[i][2]==0)
                tabsize = 0;            /* no tabs */
            else 
                errormsg(Error, "%s: ill-formed option %s\n", argv[0], argv[i]);
            break;          
        case 'R': /* change name of root module */
            root_options_seen++;
            break;
        case 'L': /* have a #line number format */
            locformat = argv[i]+2;
            if (!*locformat) locformat = Clocformat;
            break;
        default:
            errormsg(Warning, "Ignoring unknown option -%s", argv[i]);
     }
#line 57 "main.nw"
} else {
    
#line 92 "main.nw"
errormsg(Warning,
    "I can't handle arguments yet, so I'll just ignore `%s'",argv[i]);

#line 59 "main.nw"
}
#line 37 "main.nw"
    }

    read_defs(stdin);                        /* read all the definitions */
    apply_each_module(remove_final_newline); /* pretty up the module texts */
    if (root_options_seen == 0)
      emit_module_named(stdout, "*", locformat);
    else
      for (i=1; i<argc; i++) 
        if (argv[i][0] == '-' && argv[i][1] == 'R')
	  emit_module_named(stdout, argv[i]+2, locformat);

    nowebexit(NULL);
    (void)rcsid; /* avoid a warning */
    (void)rcsname; /* avoid a warning */
    return errorlevel;  /* slay warning */
}
