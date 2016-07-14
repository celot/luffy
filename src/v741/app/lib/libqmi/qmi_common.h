#ifndef _QMI_DEFS_H_
#define _QMI_DEFS_H_

/**
\file qmi_defs.h
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

#ifndef BIT
#define BIT(x) (1<<(x))
#endif

#ifndef QMI_MIN
#define QMI_MIN(x,y) (x)>(y)?(y):(x)
#endif

/* combined QMUX and SDU */
struct qmux 
{
	qmi_u8 tf;		/* always 1 */
	qmi_u16 len;	/* excluding tf */
	qmi_u8 ctrl;	/* b7: sendertype 1 => service, 0 => control point */
	qmi_u8 service;	/* 0 => QMI_CTL, 1 => QMI_WDS, .. */
	qmi_u8 qmicid;	/* client id or 0xff for broadcast */
	qmi_u8 flags;	/* always 0 for req */
	union {
		qmi_u16 w;  /* each control point maintains a transaction id counter - non-zero */
		qmi_u8 b;	/* system QMI_CTL uses one byte transaction ids! */
	} tid;
	qmi_u8 msg[];	/* one or more messages */
} __packed;

struct qmi_msg 
{
	qmi_u16 msgid;
	qmi_u16 len;
	qmi_u8 tlv[];	/* zero or more tlvs */
} __packed;

struct qmi_tlv 
{
	qmi_u8 type;
	qmi_u16 len;
	qmi_u8 bytes[];
} __packed;

struct qmi_tlv_response_data 
{
	qmi_u16 error;
	qmi_u16 code;
} __packed;


extern struct qmi_tlv *qmi_get_tlv(qmi_u8 type, qmi_u8 *buf, size_t len);
extern int qmi_verify_status_tlv(qmi_u8 *buf, size_t len);
extern struct qmi_msg *qmi_send_and_wait_for_ack(struct qmi_state *qmi, unsigned char *data, size_t len, int timeout);
extern size_t qmi_add_tlv(qmi_u8 *buf, size_t buflen, qmi_u8 type, const qmi_u8 *tlvdata, size_t datalen);
extern size_t qmi_create_msg(char *buf, size_t buflen, qmi_u8 cid, qmi_u8 system, qmi_u16 msgid);


#ifdef __cplusplus
}
#endif

#endif//_QMI_DEFS_H_

