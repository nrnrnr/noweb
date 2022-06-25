char *getline_expand (FILE *fp);
  /* grab a line in buffer, return new buffer or NULL for eof
     tabs in line are expanded according to tabsize */
char *getline_nw (FILE *fp);
  /* grab a line in the buffer, return a new buffer or NULL for eof
     no expansion of tabs */
