#ifndef _SYSUTIL_H_
#define _SYSUTIL_H_

/**
\file sysutil.h
\brief 
\author tyranno
\warning 
\date 2013/12/22
*/

/*Revision history ******************************************
*
*        Author             :
*        Dept            :
*        Revision Date    :
*        Version           :
*
*/
#include <signal.h>

#ifdef __cplusplus

extern int util_touch(const char* path);
extern int util_pidof(const char* pname);
extern void util_killall(const char* pname, int sig=SIGKILL);
extern int util_pidofs(const char* pname, int pid[], int max_count);

extern unsigned int Sleep(unsigned int secs);
extern unsigned int mSleep(unsigned int ms);

extern void trim(char* str, char delCh);
extern int contains_hex_string(char* buffer);
extern int is_digit_string(char* buffer);
extern void set_pid_file(int pid, char* name);
extern int get_pid_file(char* name);
extern int getNthValueSafe(int index, char *value, char delimit, char *result, int len);

class CtPopen
{
	public:
		CtPopen(int* terminated=0):m_terminated(terminated) {}
		int popen_r(const char* cmd, char* buf, unsigned int maxLen, unsigned int waitMs=1000);

	private:
		int *m_terminated;
};

// unyou 2014.10.01   app observer  ------------------->>

class AppObserver
{
	public:
		AppObserver(char* appName, 
							char* checkFileName, 
							unsigned int nInterval, 
							unsigned int nCheckCount, 
							unsigned int nThreadCount);
		~AppObserver();

		int updateAppTimer();	// every 1 second, called.   value.
		int updateObserverTimer();	// every 1 second, called.   value.
		
		int writeCheckFileData();
		int readCheckFileData();
		int deleteCheckFile();

		unsigned int* getObserverThreadValue(unsigned int nNum);
		
	protected:
		char* m_pszAppName;
		char* m_pszCheckFileName;
		unsigned int m_nInterval;
		unsigned int m_nCheckCount;

		unsigned int m_nCheckItems;
		unsigned int* m_nLatestValues;
		unsigned int* m_nOldValues;

		unsigned int m_nCheckTimer;
		unsigned int m_nIntervalTimer;
		unsigned int m_nAppOverserverValue;


		
};
// unyou 2014.10.01   app observer  <<-------------------

#endif

#endif//_SYSUTIL_H_

