#ifndef _QMI_DMS_H_
#define _QMI_DMS_H_

/**
\file qmi_dms.h
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


typedef struct 
{
	qmi_u8 status;
	qmi_u8 verify_retries_left;
	qmi_u8 unblock_retries_left;
}__packed qmi_dms_pin_status;

typedef struct 
{
	qmi_u8 esn[8+1];
	qmi_u8 imei[16+1];
	qmi_u8 meid[16+1];
}__packed qmi_dms_device_serial_numbers;

typedef struct 
{
	qmi_u8 band_capability[8];
}__packed qmi_dms_uim_get_state_type;

typedef struct 
{
	qmi_u8 iccid[64];
}__packed qmi_dms_uim_get_iccid_type;

typedef struct 
{
	qmi_u8 imsi[32];
}__packed qmi_dms_uim_get_imsi_type;

typedef struct 
{
	qmi_u8 time_count[6]; //Count of 1.25 ms that have elapsed from the start of GPS time (January 6, 1980) 
	qmi_u16 time_source; //Source of the timestamp 
						// 0x00 ?32 kHz device clock 
						// 0x01 ? CDMA network 
						// 0x02 ? HDR network 
}__packed qmi_dms_get_time_type;

extern int qmi_dms_get_device_serial_numbers(struct qmi_state *qmi, qmi_dms_device_serial_numbers* info);
extern int qmi_dms_verify_pin(struct qmi_state *qmi, qmi_dms_pin_status* pin_status);
extern int qmi_dms_uim_verify_pin(struct qmi_state *qmi
	, qmi_u8 id, qmi_u8 pin_len, char* pin
	, qmi_dms_pin_status* pin_status);
extern int qmi_dms_uim_unblock_pin (struct qmi_state *qmi 
	, qmi_u8 id, qmi_u8 pin_len , char* pin 
	, qmi_u8 puk_len, char* puk
	, qmi_dms_pin_status* pin_status);

extern int qmi_dms_uim_get_state(struct qmi_state *qmi, void* data);
extern int qmi_dms_uim_get_imsi(struct qmi_state *qmi, void* data);
extern int qmi_dms_uim_get_iccid(struct qmi_state *qmi, void* data);
extern int qmi_dms_get_time(struct qmi_state *qmi, void* data);


#ifdef __cplusplus
}
#endif

#endif//_QMI_DMS_H_

