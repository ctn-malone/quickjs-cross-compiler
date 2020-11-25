#include <stdio.h>
#include <string.h>

#include "path.h"

static char exe_dir[4096];

/**
 * Update {exe_dir} variable based on executable name
 *
 * @param {char*} exe_name executable name
 */
void set_exe_dir_from_exe_name(char* exe_name)
{
    char *p;
    /* get the directory of the executable */
    pstrcpy(exe_dir, sizeof(exe_dir), exe_name);
    p = strrchr(exe_dir, '/');
    if (p) {
        *p = '\0';
    } else {
        pstrcpy(exe_dir, sizeof(exe_dir), ".");
    }
}

/**
 * Build an absolute path by concatenating {exe_dir} and a relative path
 *
 * @param {char*} buf buffer to update
 * @param {int} buf_size size of buffer
 * @param {char*} path path to concatenate
 */
void get_path_with_exe_dir(char *buf, int buf_size, char* path)
{
    // only use {exe_dir} if it exists and path is relative
    if (NULL != exe_dir && NULL != path && '/' != path[0]) {
        pstrcpy(buf, buf_size, exe_dir);
        pstrcat(buf, buf_size, "/");
    }
    pstrcat(buf, buf_size, path);
}
