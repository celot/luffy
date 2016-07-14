#ifndef _LOCKER_H_
#define _LOCKER_H_

/**
\file locker.h
\brief 
\author tyranno
\warning 
\date 2013/03/29
*/

/*Revision history ******************************************
*
*        Author             :
*        Dept            :
*        Revision Date    :
*        Version           :
*
*/

#include <semaphore.h>
#include <pthread.h>

class Locker
{
	private:
		pthread_mutex_t* m_mutex;
		
	public:
		Locker(pthread_mutex_t* mutex):m_mutex(mutex)
		{
			pthread_mutex_lock(m_mutex);
		}
		
		~Locker()
		{
			pthread_mutex_unlock(m_mutex);
		}
};


#endif//_LOCKER_H_

