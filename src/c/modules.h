typedef struct location {       /* identify lines of source */
    char *filename;
    int lineno;
} Location;

typedef enum parttype {STRING=1, MODULE, NEWLINE} Parttype;

struct modpart {
    Parttype ptype;             /* type of fragment: STRING, MODULE, NEWLINE */
    char *contents;
    Location loc;               /* for String, where's it from ? */
    struct modpart *next;
};
typedef struct module {
    char *name;
    int usecount;
    struct modpart *head, *tail;
} *Module;
Module newmodule(char *modname);         /* create a new, blank module */
#define addstring(MP,S,L) add_part(MP,S,STRING,&L)
        /* add a string to a module definition (stripping final newline) */
#define addmodule(MP,S) add_part(MP,S,MODULE,0)
        /* add a module reference to a module definition (stripping final newline) */
#define addnewline(MP) add_part(MP,0,NEWLINE,0)
void add_part (Module mp, char *s, Parttype type, Location *loc);
typedef struct parent {
    Module this;
    struct parent *parent;
} *Parent;

int expand (Module mp, int indent, int partial_distance, Parent parent, 
            char *locformat, FILE *out);
        /* expand a module, writing to file out */
void resetloc(void);
int printloc(FILE *fp, char *fmt, Location loc, int partial);
void remove_final_newline (Module mp);
        /* remove trailing newline that must be in module */
