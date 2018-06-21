#line 10 "nwmktemp.nw"
#define _POSIX_C_SOURCE 200809L

#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <unistd.h>
#line 21 "nwmktemp.nw"
static const char *tmpdir(void) {
    char *tmpdir = getenv("TMPDIR");
    if (tmpdir && *tmpdir)
        return tmpdir;
    else
        return "/tmp";
}
#line 29 "nwmktemp.nw"
int main(int argc, char **argv) {
    char template[] = "nwtemp.XXXXXXXXXX";
    const char *tmp = tmpdir();
    char *path = malloc(strlen(tmp) + strlen(template) + 3); /* slash, newline, \0 */
    int fd;

    assert(argc == 1);

    assert(path);
    strcpy(path, tmp);
    path[strlen(tmp)] = '/';
    strcpy(path+strlen(tmp)+1, template);

    fd = mkstemp(path);
    if (fd < 0) {
        perror(argv[0]);
        free(path);
        return 1;
    } else {
        printf("%s\n", path);
        free(path);
        close(fd);
        return 0;
    }
}
