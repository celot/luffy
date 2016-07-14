#ifndef _QMI_NAS_H_
#define _QMI_NAS_H_
/**
\file qmi_nas.h
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
	struct
	{
		qmi_u8 registration_state;
		qmi_u8 cs_attach_state;
		qmi_u8 ps_attach_state;
		qmi_u8 selected_network;
		qmi_u8 in_use_radio_if_list_num;
		qmi_u8 radio_if;
	}__packed ss;
	struct
	{
		qmi_u8 srv_status;
		qmi_u8 srv_capability;
		qmi_u8 hdr_srv_status;
		qmi_u8 hdr_hybrid;
		qmi_u8 is_sys_forbidden;
	}__packed dsi;
}__packed qmi_nas_serving_system;

typedef struct 
{
	qmi_u8 num_instances;
	qmi_u8 radio_if;
	qmi_u16 active_band;
	qmi_u16 active_channel;
}__packed qmi_nas_band_info;


typedef struct 
{
	qmi_u16 num_preferred_network_instances; //Number of sets of the following elements:
                                                                                //mobile_country_code
                                                                                // mobile_network_code
                                                                                //radio_access_technology
	qmi_u16 mobile_country_code; //A 16-bit integer representation of MCC. Range: 0 to 999
	qmi_u16 mobile_network_code; //A 16-bit integer representation of MNC. Range: 0 to 999.
	qmi_u16 radio_access_technology; //RAT as a bitmask (bit count begins from zero).
                                                                //Values:
                                                                //Bit 15 - UMTS
                                                                //Bit 14 - LTE
                                                                //Bit 7 - GSM
                                                                //Bit 6 - GSM compact
                                                                // All bits set to 0 - No access technology is available from the device
}qmi_nas_preferred_networks_type;

typedef struct 
{
	qmi_nas_preferred_networks_type	prefer[2]; //0:dynamic, 1://static
}__packed qmi_nas_get_preferred_networks_type;

typedef struct 
{
	qmi_nas_preferred_networks_type	prefer[2]; //0:dynamic, 1://static
}__packed qmi_nas_set_preferred_networks_type;


extern int qmi_nas_get_signal_strength(struct qmi_state *qmi, char* sig_strength);
extern int qmi_nas_initiate_attach(struct qmi_state *qmi, qmi_u8 action);
extern int qmi_nas_get_serving_system(struct qmi_state *qmi, qmi_nas_serving_system* data);
extern int qmi_nas_get_rf_band_info(struct qmi_state *qmi, qmi_nas_band_info* data);
extern int qmi_nas_get_cell_location_info(struct qmi_state *qmi, qmi_u8* data);
extern int qmi_nas_get_sys_info(struct qmi_state *qmi, qmi_u8* data);
extern int qmi_nas_get_sig_info(struct qmi_state *qmi, qmi_u8* data);
extern int qmi_nas_get_plmn_name(struct qmi_state *qmi, void* data); //bill20140109 
extern int qmi_nas_get_preferred_select(struct qmi_state *qmi, void* data);
extern int qmi_nas_set_preferred_select(struct qmi_state *qmi, qmi_u8 data);

#ifdef __cplusplus
}
#endif

#endif//_QMI_NAS_H_

