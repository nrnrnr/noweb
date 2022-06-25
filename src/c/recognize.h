typedef struct recognizer *Recognizer;
typedef void (*Callback) (void *closure, char *id, char *instance);
Recognizer new_recognizer(char *alphanum, char *symbols);
void add_ident(Recognizer r, char *id);
void stop_adding(Recognizer r);
void search_for_ident(Recognizer r, char *input, Callback f, void *closure);
