#ifndef _NVRAM_WRAP_H_
#define _NVRAM_WRAP_H_

/**
\file nvram_wrap.h
\brief 
\author tyranno
\warning 
\date 2015/04/07
*/

/*Revision history ******************************************
*
*        Author             :
*        Dept            :
*        Revision Date    :
*        Version           :
*
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

void safe_nvram_init();
void safe_nvram_close();

int safe_nvram_set(char *name, char *value);
const char *safe_nvram_get(char *name);
int safe_nvram_bufset(char *name, char *value);
char const *safe_nvram_bufget(char *name);

void safe_nvram_buflist();
int safe_nvram_commit();
int safe_nvram_clear();

#endif//_NVRAM_WRAP_H_

