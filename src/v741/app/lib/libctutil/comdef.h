#ifndef _COMDEF_H_
#define _COMDEF_H_

/**
\file comdef.h
\brief 
\author tyranno
\warning 
\date 2012/11/20
*/

/*Revision history ******************************************
*
*        Author             :
*        Dept            :
*        Revision Date    :
*        Version           :
*
*/

typedef  unsigned char      byte;        /* Unsigned 8  bit value type. */
typedef  unsigned short   word;        /* Unsigned 16 bit value type. */
typedef  unsigned int   dword;       /* Unsigned 32 bit value type. */

typedef  signed char        int1;        /* Signed 8  bit value type. */
typedef  short            int2;        /* Signed 16 bit value type. */
typedef  int            int4;        /* Signed 32 bit value type. */
typedef  unsigned char      uint1;       /* Unsigned 8  bit value type. */
typedef  unsigned short   uint2;       /* Unsigned 16 bit value type. */
typedef  unsigned int   uint4;       /* Unsigned 32 bit value type. */

typedef  byte               boolean;     /* Boolean value type. */
typedef  unsigned long      qword[2];    /* Unsigned 64 bit value type. */

typedef  unsigned char      uint8;       /* Unsigned 8  bit value */
typedef  unsigned short   uint16;      /* Unsigned 16 bit value */
typedef  unsigned int   uint32;      /* Unsigned 32 bit value */
typedef  unsigned long long             uint64;      /* Unsigned 64 bit integer */

typedef  signed char        int8;        /* Signed 8  bit value */
typedef  signed short     int16;       /* Signed 16 bit value */
typedef  signed int     int32;       /* Signed 32 bit value */
typedef  signed long long              int64;       /* Signed 64 bit integer */
#define MPACKED __attribute__ ((packed))
#define PACKED

#endif//_COMDEF_H_

