#ifndef _TIMER_H_
#define _TIMER_H_

/**
\file timer.h
\brief 
\author tyranno
\warning 
\date 2013/05/22
*/

/*Revision history ******************************************
*
*        Author             :
*        Dept            :
*        Revision Date    :
*        Version           :
*
*/
#include "list.h"
#include <pthread.h>
#include <semaphore.h>
#include <time.h>
#include <signal.h>

#define USE_THREAD_TIMER

#ifdef __cplusplus

class Timer
{
	public:
		static Timer* getInstance();
		int create(int ms100, bool repeat, void ((*callback)(int)), void* user=NULL); ///ms100: unit 100 ms
		int createSingleShot(int ms100, void ((*callback)(int)), void* user=NULL); ///ms100: unit 100 ms
		void del(int timer);
		void start(int timer);
		void start(int timer, int ms);
		void stop(int timer);
		void stopAll();

		~Timer();
		
	private:
		Timer();
		
#ifdef USE_THREAD_TIMER
		static void* procTimer(void *arg);
#endif
		static void SignalHandler(int signo, siginfo_t * info, void *context);


	private:
		static Timer* self;
		timer_t m_timerid;
		int m_lastTimerID;
		list_head m_timerList;

		static pthread_mutex_t mutex_lock;

#ifdef USE_THREAD_TIMER
		pthread_t m_pthread;
		bool m_terminate;
#endif		
};

#endif

#endif//_TIMER_H_

