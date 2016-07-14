#ifndef _EVENT_H_
#define _EVENT_H_

/**
\file event.h
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

class Event 
{
	public:
		Event(int type=0, int subtype=0, int data=0);

		int type() const {return m_type;}
		int subtype() const {return m_subtype;}
		int data() const {return m_data;}

		bool operator==(const Event& other) const
		{
			return (m_type == other.m_type) && (m_subtype==other.m_subtype) && (m_data==other.m_data);
		}
		bool operator!=(const Event& other) const
		{
			return (m_type != other.m_type) || (m_subtype!=other.m_subtype) || (m_data==other.m_data);
		}

	private:
		int m_type;
		int m_subtype;
		int m_data;
};

#endif//_EVENT_H_

