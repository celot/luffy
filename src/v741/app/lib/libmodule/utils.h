#ifndef _UTILS_H_
#define _UTILS_H_

/**
\file utils.h
\brief 
\author tyranno
\warning 
\date 2013/05/21
*/

/*Revision history ******************************************
*
*        Author             :
*        Dept            :
*        Revision Date    :
*        Version           :
*
*/
enum
{
	MODULE_NAME_00W, //0: CTR100W -- default, CTM600, CTM700
	MODULE_NAME_10W, //1: CTR110W --DTW600	
	MODULE_NAME_20X, //2: CTR120L -- CTM920	           
	MODULE_NAME_30L, //3: CTR130L -- AME200M, AME5210
	MODULE_NAME_80C, //4: CTR180C -- C6xxxx 
	MODULE_NAME_30W, //5: CTR130W -- AME300KM
	MODULE_NAME_40W, //6: CTR240W -- PHS8-J
	MODULE_NAME_50L, //7: CTR250L -- PLS8-E
	MODULE_NAME_10L, //8: CTR310L -- DTM970-W(ANYDATA)
	MODULE_NAME_20L, //9: CTR320L -- pantech PM-L300
	MODULE_NAME_20LP, //10: CTR320L -- pantech PM-L300_ppp
	MODULE_NAME_60L, //11: CTR360L -- kyocera KYM11
	MODULE_NAME_80A, //12: C6EMA -- C6EMA 
	MODULE_NAME_90L, //13: SIM7100 -- Simtech
	
	MODULE_NAME_MAX,
};


enum
{
	MODULE_NONE,
	MODULE_CTM_DATA1,
	MODULE_CTM_DATA2,	
	MODULE_AMTEL,
	MODULE_ANYDATA,	
	MODULE_CINTERION,
	MODULE_PANTECH,
	MODULE_KYOCERA,
	MODULE_SIMTECH,

	MODULE_NCM=0x20000000,
	MODULE_PPP=0x40000000,
	MODULE_QMI=0x80000000,
};

#define MODULE_TYPE_MASK 0xF0000000
#define MODULE_MODEL_MASK 0xFFFFFFF

#define GET_MODULE_TYPE() (get_module_type()&MODULE_TYPE_MASK)
#define GET_MODULE_MODEL() (get_module_type()&MODULE_MODEL_MASK)
#define IS_QMI_MODULE() ((get_module_type()&MODULE_QMI)==MODULE_QMI)

extern int get_ttyUSB_dev(unsigned char* list);
extern int get_ttyACM_dev(unsigned char* list);
extern int get_ttyCdcWdm_dev(char *dev_file);
extern int get_qmi_name(char* qmi_name);
extern int check_netinterface_addr(char* interf, char* addr, int maxlen);
extern int get_module_dev(char* devDm, char* devData);
extern int get_module_data2(char* devData2);
extern int get_module_type();
extern int getModelName(char* modelName);
extern int is_reset_required_model();
extern int is_wcdma_model();
extern int is_cdma_model();
extern int get_modem_dev(char* devFile, int maxlen);
extern int getCarrierNames(char* CarrierName);
extern void set_zigmode(const int onoff);
extern void module_reset();
extern int get_current_wwan();
extern void set_current_wwan(int wwanid);
extern void set_module_value(const char* key, char* value);
extern void get_module_value(const char* key, char* value);

extern int isGpsData(char *values);
extern int get_gps_data(char* readMsg);
extern void set_gps_data(char* writeMsg);
extern void gps_remove_file();
extern void set_gps_lock_init();
extern void gps_lock_destroy();
extern void gps_send_data(const char* gpsData);

#endif//_UTILS_H_



