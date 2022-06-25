Module insert (char *modname);  /* add a module to the world */
Module lookup (char *modname);  /* return ptr to module or NULL */
void apply_each_module(void (*fun)(Module));
     /* apply [[fun]] to each module in the tree */
