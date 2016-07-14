#ifndef _QUEUE_H_
#define _QUEUE_H_

/**
\file Queue.h
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

#include "event.h"

class QueueImp;
class Queue
{
	public:
		Queue(int count=100);
		~Queue();

		void push(const Event& e, int wait_ms=100); ///wait==0 infinitly
		Event pop(int wait_ms=1000); ///wait==0 infinitly
		void clean();
		void clean(const Event& e);
		void cleanEx(const Event& e);
		int count();
		int id();
		
	private:
		QueueImp* qImp;
};

#endif//_QUEUE_H_

