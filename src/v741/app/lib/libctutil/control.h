#ifndef _CONTROL_H_
#define _CONTROL_H_

/**
\file control.h
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
#include "queue.h"
#include "event.h"
#include "basethread.h"

class ControlThread;
class Control 
{
	public:
		Control();
		virtual ~Control();

		virtual void init()=0;
		virtual void task()=0;
		virtual void terminate()=0;
		virtual void addEvent(const  Event& e){mQueue.push(e);};
		virtual void setWaitResult(void* result, unsigned int size){}
		virtual void setWaitResult(bool result){}

	protected:
		virtual bool waitResult(unsigned int ms){return true;}
		
	protected:
		ControlThread* mControlThread;
		bool mTerminated;
		Queue mQueue;
};


class ControlThread : public BaseThread
{
	public:
		ControlThread(Control* control):mControl(control){}
		~ControlThread(){}
		void run(void)
		{
			if(mControl)
			{
				mControl->task();
			}
		}

	private:
		Control* mControl;
};

#endif//_CONTROL_H_

