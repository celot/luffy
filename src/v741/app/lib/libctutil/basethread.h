#ifndef _BASETHREAD_H_
#define _BASETHREAD_H_

/**
\file basethread.h
\brief
\author tyranno
\warning
\date 2012/08/14
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
#include <unistd.h>
#include <sched.h>
#include <signal.h>
#include <pthread.h>


/// Thread without wxwidget
#define MY_DEFAULT_PRIORITY 50u

class BaseThread
{
	public:
		enum STATE_TYPE
		{
			STATE_NEW = 0, 
			STATE_PAUSED, 
			STATE_EXITED, 
			STATE_RUNNING
		};

		BaseThread(char* threadName=0);
		virtual ~BaseThread();

		int getPriority() const
		{
			return this->priority;
		};
		void setPriority(const int& pri)
		{
			this->priority = pri;
		};
		BaseThread::STATE_TYPE getStatus() const
		{
			return this->sType;
		};
		void signal(int signo)
		{
			pthread_kill(internalm, signo);
		};

		char* getThreadName();
		virtual bool create();
		virtual void exit();
		virtual void cancel();
		virtual void start();
		virtual void stop();
		virtual void run() = 0;
		virtual void wait();

	private:
		void initThread();
		void pthreadStart();
		static void* realProc(void *arg);
		static void realCleanProc(void* arg)
		{
			BaseThread* pp = (BaseThread*) arg;
			pp->cleanStart();
		};

	protected:
		virtual void cleanStart() { };
		void setStatus(const BaseThread::STATE_TYPE& st)
		{
			this->sType = st;
		};
		void checkPausePoint();

		char mThreadName[100];
		STATE_TYPE sType;
		int priority;
		pthread_t internalm;
		pthread_cond_t m_cond;
		pthread_mutex_t m_mutex;

		bool pthreadStarted;
		bool initRun;
};


#endif//_BASETHREAD_H_

