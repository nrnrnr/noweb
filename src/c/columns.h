extern int tabsize;
extern int columnwidth (char *s);      /* number of columns string occupies */
extern int limitcolumn (char *s, int startcolumn);
                                /* width of startcolumn blanks plus s */
extern void indent_for (int width, FILE *fp);
                                /* indent to width; next char -> width+1 */
