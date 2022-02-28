#ifndef PATH_H
#define PATH_H

#include "cutils.h"

void get_path_with_dir(char *buf, int buf_size, char* dir, char* path);
void set_exe_dir_from_exe_name(char* exe_name);
void get_path_with_exe_dir(char *buf, int buf_size, char* path);

#endif  /* PATH_H */
