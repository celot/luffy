#ifndef _QMI_CTL_H_
#define _QMI_CTL_H_

/**
\file qmi_ctl.h
\brief 
\author tyranno
\warning 
\date 2013/05/02
*/

/*Revision history ******************************************
*
*        Author             :
*        Dept            :
*        Revision Date    :
*        Version           :
*
*/
#include <unistd.h>    
#include <linux/types.h>    
#include "qmi.h"

#ifdef __cplusplus
extern "C"
{
#endif	


extern int qmi_ctl_request_cid(struct qmi_state *qmi, qmi_u8 system);
extern int qmi_ctl_release_cid(struct qmi_state *qmi, qmi_u8 system);


#ifdef __cplusplus
}
#endif


#endif//_QMI_CTL_H_

