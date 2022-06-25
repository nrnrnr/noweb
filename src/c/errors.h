enum errorlevel { Normal=0, Warning, Error, Fatal, Impossible };
extern enum errorlevel errorlevel;
extern int finalstage; /* set nonzero if this main() is a final stage */
extern char *progname; /* set to name of program if main() is a filter */
extern void nowebexit(char *optional_msg);
void errormsg(enum errorlevel level, char *s, ...);
#define overflow(S) errormsg(Fatal,"Capacity exceeded: %s", S)
#define impossible(S) errormsg(Impossible, "This can't happen: %s", S)
#define checkptr(P) do { if (!(P)) overflow("memory"); } while (0)
void errorat(char *filename, int lineno, enum errorlevel level, char *s, ...);
