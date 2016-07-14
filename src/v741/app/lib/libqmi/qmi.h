#ifndef _QMI_H_
#define _QMI_H_
#include <stdio.h>      
/**
\file qmi.h
\brief 
\author tyranno
\warning 
\date 2013/01/23
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

#ifdef __cplusplus
extern "C"
{
#endif	

#define __packed			__attribute__((packed))

#define QMI_BUFLEN 512
#define QMI_FLAG_RECV		0x00000001
#define QMI_FLAG_PINOK		0x00000002

typedef unsigned char qmi_u8;
typedef unsigned short qmi_u16;
typedef unsigned int qmi_u32;
typedef unsigned long long qmi_u64;


enum qmi_device_state 
{
	QMI_STATE_INIT = 0, /* allocate CIDs, verify pin code */
	QMI_STATE_DOWN,    /* connection is down */
	QMI_STATE_UP,      /* connection is up */
	QMI_STATE_ERR,     /* fatal and final error state, e.g. no CID available - no way out of here! */
};

/* the different QMI subsystems we are using */
enum qmi_subsystems 
{
	QMI_CTL = 0,
	QMI_WDS,
	QMI_DMS,
	QMI_NAS,
	QMI_QOS,
	QMI_WMS,
	QMI_PDS,
	QMI_VOICE,
	QMI_CAT,
	QMI_SYSMAX,
};

enum qmi_error
{
	QMI_ERR_NONE,
	QMI_ERR_OPEN,
	QMI_ERR_WRITE,
	QMI_ERR_READ,
	QMI_ERR_PARSE
};

struct qmi_state 
{
	int dev;
	unsigned char rcvbuf[QMI_BUFLEN];		/* pre-allocated receive buffer */
	unsigned long flags;		/* used for en/dis-abling functionality on the fly */
	qmi_u8 state;			/* for connection state machine */
	qmi_u8 wds_status;			/* current value for QMI_WDS message 0x0022 or 0 if uninitialized */
	qmi_u16 intfnr;			/* keeping track of the interface we are referring to */
	qmi_u8 handle[4];			/* connection handle needed for disconnect */
	qmi_u8 cid[QMI_SYSMAX];		/* keeping track of cid per subsystem */

	char devfile[256];
	int last_err;
	int last_status;
	qmi_u16 last_msgid;
};

extern int qmi_init(struct qmi_state *qmi);
extern int qmi_finalize(struct qmi_state *qmi);
extern int qmi_dev_available(struct qmi_state *qmi);

#ifdef __cplusplus
}
#endif

#endif//_QMI_H_

