#ifndef _QMI_WDS_H_
#define _QMI_WDS_H_
/**
\file qmi_wds.h
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
	qmi_u8 Num_instances;
	struct 
	{
		qmi_u8 type;
		qmi_u8 index;
		char name[16];
	}__packed profile[8];
}__packed qmi_profile_list_type;

typedef struct 
{
	qmi_u8 traffic_class;
	qmi_u32 max_uplink_bitrate;
	qmi_u32 max_downlink_bitrate;
	qmi_u32 guaranteed_uplink_bitrate;
	qmi_u32 guaranteed_downlink_bitrate;
	qmi_u8 qos_delivery_order;
	qmi_u32 max_sdu_size;
	qmi_u8 sdu_error_ratio;
	qmi_u8 residual_ber_ratio;
	qmi_u8 delivery_erroneous_SDUs;
	qmi_u32 transfer_delay;
	qmi_u32 traffic_handling_priority;
}__packed qmi_umts_requested_qos;

typedef struct  
{
	qmi_u32 precedence_class;
	qmi_u32 delay_class;
	qmi_u32 reliability_class;
	qmi_u32 peak_throughput_class;
	qmi_u32 mean_throughput_class;
}__packed qmi_gprs_requested_qos;


typedef struct 
{
	char profile_name[16]; //Profile Name 
	qmi_u8 pdp_type; //PDP Type 
	char APN_name[128];// APN Name 
	qmi_u8 primary_DNS_IPv4_address_preference[4]; // Primary DNS IPv4 Address Preference 
	qmi_u8 secondary_DNS_IPv4_address_preference[4]; // Secondary DNS IPv4 Address Preference
	qmi_umts_requested_qos  umts_requested_qos; //UMTS Requested QoS 
	qmi_umts_requested_qos umts_minimum_qos ;// UMTS Minimum QoS 
	qmi_gprs_requested_qos gprs_requested_qos;//GPRS Requested QoS
	qmi_gprs_requested_qos gprs_minimum_qos;//GPRS Minimum QoS 	
	char username[128];// Username 
	char password[128]; // Password 
	qmi_u8 authentication_preference; // Authentication Preference 
	qmi_u8 IPv4_address_preference[4];// IPv4 Address Preference 
	qmi_u8 Pcscf_addr_using_pco;//CSCF address using PCO Flag 
}__packed qmi_wds_profile_data;


typedef struct 
{
	char APN_name[128];// APN Name 
	qmi_u8 primary_DNS_IPv4_addr[4]; // Primary DNS IPv4 Address  
	qmi_u8 secondary_DNS_IPv4_addr[4]; // Secondary DNS IPv4 Address 
	qmi_u8 IPv4_addr[4];// IPv4 Address Preference 
	qmi_u8 ipv4_gateway_addr[4];// Gateway address 
	qmi_u8 ipv4_subnet_mask[4];// Gateway address 
}__packed qmi_wds_runtime_settings;


extern int qmi_wds_report(struct qmi_state *qmi);
extern int qmi_wds_start(struct qmi_state *qmi, qmi_u8 index);
extern int qmi_wds_stop(struct qmi_state *qmi);
extern int qmi_wds_stop_autoconnect(struct qmi_state *qmi, qmi_u8 disable_autoconnect);
extern int qmi_wds_status(struct qmi_state *qmi);
extern int qmi_wds_go_dormant(struct qmi_state *qmi);
extern int qmi_wds_go_active(struct qmi_state *qmi);
extern int qmi_wds_create_profile(struct qmi_state *qmi, qmi_u32 flag, qmi_wds_profile_data* data, qmi_u8* result);
extern int qmi_wds_modify_profile_settings(struct qmi_state *qmi, qmi_u8 index, qmi_u32 flag, qmi_wds_profile_data* data);
extern int qmi_wds_delete_profile(struct qmi_state *qmi, qmi_u8 index);
extern int qmi_wds_get_profile_list(struct qmi_state *qmi, qmi_profile_list_type* list);
extern int qmi_wds_get_profile_settings(struct qmi_state *qmi, qmi_u8 index, qmi_wds_profile_data* data);
extern int qmi_wds_get_default_settings(struct qmi_state *qmi, qmi_wds_profile_data* data);
extern int qmi_wds_get_runtime_settings(struct qmi_state *qmi, qmi_wds_runtime_settings* data);
extern int qmi_wds_get_dormancy_status(struct qmi_state *qmi, qmi_u8* dormancy_status);
extern int qmi_wds_get_call_duration (struct qmi_state *qmi, qmi_u64* duration);


#ifdef __cplusplus
}
#endif


#endif//_QMI_WDS_H_

