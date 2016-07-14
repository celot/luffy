#ifndef _QUEUE_IMP_H_
#define _QUEUE_IMP_H_

/**
\file queue_imp.h
\brief 
\author tyranno
\warning 
\date 2013/05/16
*/

/*Revision history ******************************************
*
*        Author             :
*        Dept            :
*        Revision Date    :
*        Version           :
*
*/
#include "event.h"
#include "list.h"
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <semaphore.h>

struct QData
{
	struct list_head list;
	Event event;
};

class QueueImp
{
	public:
		QueueImp(int count =20);
		~QueueImp();
		void push(const Event e, int wait_ms);
		Event pop(int wait_ms);
		void clean();
		void clean(const Event& e);
		void cleanEx(const Event& e);
		int count();
		int id() { return m_qid;}

	private:
		//void lock() {pthread_mutex_lock(&mutex_lock);}
		//void unlock() {pthread_mutex_unlock(&mutex_lock);}

	private:
		int q_count;
		struct list_head data_head, free_head;
		sem_t data_sem, free_sem;
		pthread_mutex_t mutex_lock;

		int m_qid;
		static int m_qStart;

		QData* mData;
};


#endif//_QUEUE_IMP_H_

