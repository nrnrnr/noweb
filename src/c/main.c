#line 7 "main.nw"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "notangle.h"
#include "errors.h"
#include "columns.h"
#include "modules.h"
#include "modtrees.h"

#line 23 "main.nw"
int main(int argc, char **argv) {
    int i;
    char *locformat = "";
    char *Clocformat = "#line %L \"%F\"%N";
    int root_options_seen = 0;

    tabsize = 0;  /* default for nt is not to use tabs */
    progname = argv[0];
    finalstage = 1;

    for (i=1; i<argc; i++) {
        
#line 51 "main.nw"
if (*argv[i]=='-') {
    
#line 67 "main.nw"
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
#line 53 "main.nw"
} else {
    
#line 88 "main.nw"
errormsg(Warning,
    "I can't handle arguments yet, so I'll just ignore `%s'",argv[i]);

#line 55 "main.nw"
}
#line 35 "main.nw"
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
    return errorlevel;  /* slay warning */
}
