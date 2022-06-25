#line 10 "match.nw"
#include <string.h>
#include "match.h"
static int matches(char *line, char *search) {
    return !strncmp(line,search,strlen(search));
}
#line 20 "match.nw"
int is_keyword(char *line, char *keyword) {
    char low_at_sign = '@';
    return *line==low_at_sign && matches(line+1,keyword) && 
           (line[strlen(keyword)+1]==' ' || line[strlen(keyword)+1]=='\n' ||
            line[strlen(keyword)+1]=='\0');
}
int is_begin(char *line, char *type) {
    return is_keyword(line,"begin") && matches(line+1+6,type);
}
int is_end(char *line, char *type) {
    return is_keyword(line,"end") && matches (line+1+4,type);
}
int is_index(char *line, char *type) {
    return is_keyword(line,"index") && matches(line+1+6,type);
}
