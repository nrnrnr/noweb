#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <errno.h>

main(int argc, char *argv[]) {
  struct stat b1, b2;

  if (argc != 3) {
    fprintf(stderr, "Usage: %s file1 file2\n", argv[0]);
    exit (-1);
  } else if (stat(argv[1],&b1) < 0) {
    perror(argv[1]);
    exit(-2);
  } else if (stat(argv[2],&b2) < 0) {
    perror(argv[2]);
    exit(-2);
  } else exit(b1.st_mtime > b2.st_mtime ? 0 : 1);
}
