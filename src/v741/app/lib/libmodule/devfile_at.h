#ifndef _DEVFILE_AT_H_
#define _DEVFILE_AT_H_

/**
\file devfile_at.h
\brief 
\author tyranno
\warning 
\date 2013/05/28
*/

/*Revision history ******************************************
*
*        Author             :
*        Dept            :
*        Revision Date    :
*        Version           :
*
*/
#include <sys/types.h>
#include <sys/shm.h>
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>									// File control definitions

class DevFile
{
	public:
		DevFile(char* devFile, bool isNoFlush=false);
		~DevFile();
		int writeString(const char* str, bool add_crcl=true);
		int writeStringE(const char* str, const char* strEcho=NULL);
		int readLine(char* line, unsigned int wait_ms);
		int readLineA(char* line, unsigned int wait_ms);
		void setMaxlen(unsigned int len) {m_maxLen = len;}
		void setExitCodition(bool* exitCondition) {m_exitCondition = exitCondition;}

	private :
		inline void lock();
		inline void unlock();
		inline void lock2();
		inline void unlock2();
		int config(int baud, int data = 1, int parity = 0, int stop = 0, int flow = 0);
		
	private:
		int m_fd;
		struct termios old_options;

		char* m_devFile;
		bool m_isNoFlush;

		unsigned int m_maxLen;

		bool* m_exitCondition;

};
#endif//_DEVFILE_AT_H_

