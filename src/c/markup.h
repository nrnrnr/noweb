extern char at_sign;                    /* the at sign */
int starts_doc(char *);
char *first_doc_line(char *);
int is_def(char *);
char *remove_def_marker(char *);
char *mod_start (char *s, int mark);    /* find the first module name */
char *mod_end (char *s, int mark);              /* find the end of module name */
int starts_code (char *line, char *filename, int lineno);  
                                        /* does this line start module defn? */
void getmodname(char *dest, int size, char *source);
                                        /* extract module name and put in dest */
char *find_escaped(register char *s, char *search, char *escape, int mark);
                /* find escaped strings. See markup.nw for details */
