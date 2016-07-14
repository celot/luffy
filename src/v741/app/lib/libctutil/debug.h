#ifndef _DEBUG_H_
#define _DEBUG_H_

/**
\file debug.h
\brief 
\author tyranno
\warning 
\date 2009/10/14
*/

/*Revision history ******************************************
*
*	   Author		   :
*	   Dept 		   :
*	   Revision Date   :
*	   Version		   :
*
*/

#include <stdio.h>
#include <stdlib.h>


#ifdef DEBUG
/*
 ** Make sure we can call this stuff from C++.
 */
#ifdef __cplusplus
extern "C" {
#endif

#define MSG_FUNC 0x80000000

#define MSG_LOW_LEVEL 0x0001
#define MSG_MID_LEVEL 0x0002
#define MSG_HIGH_LEVEL 0x0004
#define MSG_ERROR_LEVEL 0x0008
#define MSG_FATAL_LEVEL 0x0010

#ifndef MSG_LEVEL
#define MSG_LEVEL \
	(MSG_LOW_LEVEL\
	|MSG_MID_LEVEL\
	|MSG_HIGH_LEVEL\
	|MSG_ERROR_LEVEL\
	|MSG_FATAL_LEVEL\
	|MSG_FUNC)
#endif //MSG_LEVEL

#define MSG_OUTPUT stderr
#define USE_COLOR_MSG
#define USE_FLUSH_MSG

#ifdef USE_SYSLOG_MSG
#include <syslog.h>
#define SYSLOG_MSG(fmt, ...) { \
	openlog("APP", LOG_PID, LOG_DAEMON);	\
	syslog(LOG_USER | LOG_NOTICE, fmt, ##__VA_ARGS__); \
	closelog(); \
}
#endif //USE_SYSLOG_MSG

#ifdef USE_COLOR_MSG
#define F_COL_L 	"[37m"
#define F_COL_M 	"[32m"
#define F_COL_H 	"[33m"
#define F_COL_E 	"[34m"
#define F_COL_F 	"[31m"
#define R_COL 	"[0m\n"
#else
#define F_COL_L 
#define F_COL_M 
#define F_COL_H 
#define F_COL_E 	
#define F_COL_F 	
#define R_COL "\n"
#endif

#ifdef USE_FLUSH_MSG
#define FFLUSH_MSG(x) fflush(x)
#else
#define FFLUSH_MSG(x)
#endif

#if(MSG_LEVEL & MSG_LOW_LEVEL)
	#ifdef USE_SYSLOG_MSG
		#define MSG_LOW SYSLOG_MSG
	#else
		#define MSG_LOW(fmt,...) \
			fprintf(MSG_OUTPUT,F_COL_L"[%-10s:%04d]"fmt R_COL,__FILE__,__LINE__,##__VA_ARGS__);FFLUSH_MSG(MSG_OUTPUT)
	#endif //USE_SYSLOG_MSG	
#else	
	#define MSG_LOW(fmt,...)
#endif

#if(MSG_LEVEL & MSG_MID_LEVEL)
	#ifdef USE_SYSLOG_MSG
		#define MSG_MID SYSLOG_MSG
	#else
		#define MSG_MID(fmt,...) \
			fprintf(MSG_OUTPUT,F_COL_M"[%-10s:%04d]"fmt R_COL,__FILE__,__LINE__, ##__VA_ARGS__);FFLUSH_MSG(MSG_OUTPUT)
	#endif
#else	
	#define MSG_MID(fmt,...)
#endif

#if(MSG_LEVEL & MSG_HIGH_LEVEL)
	#ifdef USE_SYSLOG_MSG
		#define MSG_HIGH SYSLOG_MSG
	#else
		#define MSG_HIGH(fmt,...) \
			fprintf(MSG_OUTPUT,F_COL_H"[%-10s:%04d]"fmt R_COL,__FILE__,__LINE__,##__VA_ARGS__);FFLUSH_MSG(MSG_OUTPUT)
	#endif
#else	
#define MSG_HIGH(fmt,...)
#endif

#if(MSG_LEVEL & MSG_ERROR_LEVEL)
	#ifdef USE_SYSLOG_MSG
		#define MSG_ERROR SYSLOG_MSG
	#else
		#define MSG_ERROR(fmt,...) \
			fprintf(MSG_OUTPUT,F_COL_E"[%-10s:%04d]"fmt R_COL,__FILE__,__LINE__,##__VA_ARGS__);FFLUSH_MSG(MSG_OUTPUT)
	#endif
#else	
#define MSG_ERROR(fmt,...)
#endif

#if(MSG_LEVEL & MSG_FATAL_LEVEL)
	#ifdef USE_SYSLOG_MSG
		#define MSG_FATAL SYSLOG_MSG
	#else
		#define MSG_FATAL(fmt,...) \
		    fprintf(MSG_OUTPUT,F_COL_F"[%-10s:%04d]"fmt R_COL,__FILE__,__LINE__,##__VA_ARGS__);FFLUSH_MSG(MSG_OUTPUT)
	#endif
#else	
#define MSG_FATAL(fmt,...)
#endif

#if(MSG_LEVEL & MSG_FUNC)
	#ifdef USE_SYSLOG_MSG
		#define F_IN() SYSLOG_MSG("[%s:%d] FUNC IN",__FUNCTION__,__LINE__);
		#define F_OUT() SYSLOG_MSG("[%s:%d] FUNC OUT",__FUNCTION__,__LINE__);
	#else	
		#define F_IN() fprintf(MSG_OUTPUT,F_COL_L"[%s:%d] FUNC IN"R_COL,__FUNCTION__,__LINE__);FFLUSH_MSG(MSG_OUTPUT)
		#define F_OUT() fprintf(MSG_OUTPUT,F_COL_L"[%s:%d] FUNC OUT"R_COL,__FUNCTION__,__LINE__);FFLUSH_MSG(MSG_OUTPUT)
	#endif
#else	
	#define F_IN()
	#define F_OUT()
#endif

#ifdef __cplusplus
}  /* End of the 'extern "C"' block */
#endif

#else
#define MSG_LOW(fmt,...)
#define MSG_MID(fmt,...)
#define MSG_HIGH(fmt,...)
#define MSG_ERROR(fmt,...)
#define MSG_FATAL(fmt,...)
#define F_IN()
#define F_OUT()
#endif//DEBUG

#endif//_DEBUG_H_

