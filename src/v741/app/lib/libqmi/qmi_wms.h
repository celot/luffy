#ifndef _QMI_WMS_H_
#define _QMI_WMS_H_

/**
\file qmi_wms.h
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


enum
{
	STORAGE_TYPE_UIM = 0x00,
	STORAGE_TYPE_NV=0x01,
};

enum wms_tag_type
{
	TAG_TYPE_MT_READ = 0x00,
	TAG_TYPE_MT_NOT_READ = 0x01,
	TAG_TYPE_MO_SENT = 0x02,
	TAG_TYPE_MO_NOT_SENT = 0x03,
};

enum wms_msg_mode_type
{
	MESSAGE_MODE_CDMA = 0x00,
	MESSAGE_MODE_GW= 0x01
};

typedef struct 
{
	qmi_u8 format;
	qmi_u16 len;
	qmi_u8* raw_message;
	qmi_u8 force_on_dc;
	qmi_u8 so;
	qmi_u8 follow_on_dc;
	qmi_u8 link_timer;
	qmi_u8 sms_on_ims;
	qmi_u8 retry_message;
	qmi_u32 retry_message_id;
}__packed wms_raw_send_param;

typedef struct 
{
	qmi_u8 strorage_type;
	qmi_u8 format;
	qmi_u16 len;
	qmi_u8* raw_message;
	qmi_u8 tag_type;
}__packed wms_raw_write_param;


typedef struct 
{
	qmi_u8 strorage_type;
	qmi_u32 index;
	qmi_u8 tag_type;
	qmi_u8 message_mode;
	qmi_u8 sms_on_ims;
}__packed wms_index_param;


typedef struct 
{
	qmi_u32 transaction_id;
	qmi_u8 message_protocol;
	qmi_u8 success;
	qmi_u8 error_class;
	qmi_u8 tl_status;
	qmi_u8 rp_cause;
	qmi_u8 tp_cause;
	qmi_u8 sms_on_ims;
}__packed wms_send_ack_param;

typedef struct 
{
	qmi_u32 n_messages;
	struct list_item
	{
		qmi_u32 index;
		qmi_u8 tag;
	}__packed item[];
}__packed qmi_wms_list_rsp_type;

typedef struct 
{
	qmi_u8 tag_type;
	qmi_u8 format;
	qmi_u16 len;
	qmi_u8 data[];
}__packed qmi_wms_read_rsp_type;

extern int qmi_wms_reset(struct qmi_state *qmi, qmi_u8* data);
extern int qmi_wms_raw_send(struct qmi_state *qmi, wms_raw_send_param* param, qmi_u32 flag);
extern int qmi_wms_raw_write(struct qmi_state *qmi, wms_raw_write_param*param,  qmi_u32 flag,  qmi_u8* data);
extern int qmi_wms_raw_read(struct qmi_state *qmi, wms_index_param*param,  qmi_u32 flag,  qmi_u8* data);
extern int qmi_wms_modify_tag(struct qmi_state *qmi, wms_index_param*param,  qmi_u32 flag, qmi_u8* data);
extern int qmi_wms_delete(struct qmi_state *qmi, wms_index_param*param,  qmi_u32 flag,  qmi_u8* data);
extern int qmi_wms_list_messages(struct qmi_state *qmi, wms_index_param*param,  qmi_u32 flag, qmi_u8* data);
extern int qmi_wms_get_smsc_address(struct qmi_state *qmi, qmi_u8* data);
extern int qmi_wms_get_store_max_size(struct qmi_state *qmi, wms_index_param*param,  qmi_u32 flag,  qmi_u8* data);
extern int qmi_wms_send_ack(struct qmi_state *qmi, wms_send_ack_param*param,  qmi_u32 flag,  qmi_u8* data);
extern int qmi_wms_send_from_mem_store(struct qmi_state *qmi, wms_index_param*param,  qmi_u32 flag,  qmi_u8* data);
extern int qmi_wms_get_service_ready_status(struct qmi_state *qmi, qmi_u8* data);
extern int qmi_wms_get_transport_layer_info(struct qmi_state *qmi, qmi_u8* data);
extern int qmi_wms_get_memory_status(struct qmi_state *qmi, qmi_u8* data);

#ifdef __cplusplus
}
#endif


#endif//_QMI_WMS_H_

