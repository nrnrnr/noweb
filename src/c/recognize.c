#line 35 "recognize.nw"
#include <string.h>
#include <stdlib.h>
#line 50 "recognize.nw"
typedef struct recognizer *Recognizer;
#line 65 "recognize.nw"
typedef void (*Callback) (void *closure, char *id, char *instance);
#line 48 "recognize.nw"
Recognizer new_recognizer(char *alphanum, char *symbols);
#line 56 "recognize.nw"
void add_ident(Recognizer r, char *id);
void stop_adding(Recognizer r);
#line 59 "recognize.nw"
void search_for_ident(Recognizer r, char *input, Callback f, void *closure);
#line 72 "recognize.nw"
typedef struct goto_node Goto_Node;
typedef struct move_node Move_Node;
#line 75 "recognize.nw"
typedef struct name_node {
  struct name_node *next; /* points to the next name on the output list */
  char *name;
} Name_Node;
#line 80 "recognize.nw"
struct move_node {
  Move_Node *next;      /* points to the next node on the move list */
  Goto_Node *state;     /* the next state for this character */
  unsigned char c;
};
#line 86 "recognize.nw"
struct goto_node {
  Name_Node *output;    /* list of words ending in this state */
  Move_Node *moves;     /* list of possible moves */
  Goto_Node *fail;      /* and where to go when no move fits */
  Goto_Node *next;      /* next goto node with same depth */
};
#line 93 "recognize.nw"
struct recognizer {
  Goto_Node *root[256]; /* might want 128, depending on the character set */
  char *alphas;
  char *syms;
  int max_depth;
  Goto_Node **depths; /* an array, max_depth long, of lists of goto_nodes,
                         created while adding ids, used while building
                         the failure functions */
};
#line 318 "recognize.nw"
int reject_match(Recognizer r, char *id, char *input, char *current);
#line 110 "recognize.nw"
static Goto_Node *goto_lookup(unsigned char c, Goto_Node *g)
{
  Move_Node *m = g->moves;
  while (m && m->c != c)
    m = m->next;
  return m ? m->state : NULL;
}
#line 123 "recognize.nw"
Recognizer new_recognizer(char *alphanum, char *symbols)
{
  Recognizer r = (Recognizer) calloc(1, sizeof(struct recognizer));
  r->alphas = alphanum;
  r->syms = symbols;
  r->max_depth = 10;
  r->depths = (Goto_Node **) calloc(r->max_depth, sizeof(Goto_Node *));
  return r;
}
#line 138 "recognize.nw"
void add_ident(Recognizer r, char *id)
{
  int depth = 2;
  char *p = id;
  unsigned char c = *p++;
  Goto_Node *q = r->root[c];
  if (!q) 
    
#line 158 "recognize.nw"
{
  q = (Goto_Node *) calloc(1, sizeof(Goto_Node));
  r->root[c] = q;
  q->next = r->depths[1];
  r->depths[1] = q;
}
#line 146 "recognize.nw"
  c = *p++;
  while (c) {
    Goto_Node *new = goto_lookup(c, q);
    if (!new)
      
#line 165 "recognize.nw"
{
  Move_Node *new_move = (Move_Node *) malloc(sizeof(Move_Node));
  new = (Goto_Node *) calloc(1, sizeof(Goto_Node));
  new_move->state = new;
  new_move->c = c;
  new_move->next = q->moves;
  q->moves = new_move;
  if (depth == r->max_depth)
    
#line 178 "recognize.nw"
{
  int i;
  Goto_Node **new_depths = (Goto_Node **) calloc(2*depth, sizeof(Goto_Node *));
  r->max_depth = 2 * depth;
  for (i=0; i<depth; i++)
    new_depths[i] = r->depths[i];
  free(r->depths);
  r->depths = new_depths;
}
#line 174 "recognize.nw"
  new->next = r->depths[depth];
  r->depths[depth] = new;
}
#line 151 "recognize.nw"
    q = new;
    depth++;
    c = *p++;
  }
  
#line 188 "recognize.nw"
if (!q->output) {
  char *copy = malloc(strlen(id) + 1);
  strcpy(copy, id);
  q->output = (Name_Node *) malloc(sizeof(Name_Node));
  q->output->next = NULL;
  q->output->name = copy;
}
#line 156 "recognize.nw"
}
#line 204 "recognize.nw"
void stop_adding(Recognizer r)
{
  int depth;
  for (depth=1; depth<r->max_depth; depth++) {
    Goto_Node *g = r->depths[depth];
    while (g) {
      Move_Node *m = g->moves;
      while (m) {
        unsigned char a = m->c;
        Goto_Node *s = m->state;
        Goto_Node *state = g->fail;
        while (state && !goto_lookup(a, state))
          state = state->fail;
        if (state)
          s->fail = goto_lookup(a, state);
        else
          s->fail = r->root[a];
        if (s->fail) {
          Name_Node *p = s->fail->output;
          while (p) {
            Name_Node *q = (Name_Node *) malloc(sizeof(Name_Node));
            q->name = p->name; /* depending on memory deallocation 
                                  strategy, we may need to copy this */
            q->next = s->output;
            s->output = q;
            p = p->next;
          }
        }
        m = m->next;
      }
      g = g->next;
    }
  }
}
#line 243 "recognize.nw"
void search_for_ident(Recognizer r, char *input, Callback f, void *closure)
{
  Goto_Node *state = NULL;
  char *current = input;
  unsigned char c = (unsigned char) *current++;
  while (c) {
    
#line 259 "recognize.nw"
{
  while (state && !goto_lookup(c, state))
    state = state->fail;
  state = state ? goto_lookup(c, state) : r->root[c];
}
#line 250 "recognize.nw"
    
#line 269 "recognize.nw"
{
  if (state) {
    Name_Node *p = state->output;
    while (p) {
      if (!reject_match(r, p->name, input, current))
        f(closure, p->name, current - strlen(p->name));
      p = p->next;
    }
  }
}
#line 251 "recognize.nw"
    c = *current++;
  }
}
#line 293 "recognize.nw"
int reject_match(Recognizer r, char *id, char *input, char *current)
{
  int len = strlen(id);
  char first = id[0];
  char last = id[len - 1];
  char next = *current;
  char prev = '\0';
  current = current - len - 1;
  if (input <= current)
    prev = *current;
  if (prev && strchr(r->alphas, first) && strchr(r->alphas, prev)) return 1;
  if (next && strchr(r->alphas, last ) && strchr(r->alphas, next)) return 1;
  if (prev && strchr(r->syms,   first) && strchr(r->syms,   prev)) return 1;
  if (next && strchr(r->syms,   last ) && strchr(r->syms,   next)) return 1;
  return 0;
}
