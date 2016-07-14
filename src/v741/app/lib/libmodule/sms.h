#ifndef _SMS_H_
#define _SMS_H_

/**
\file sms.h
\brief 
\author tyranno
\warning 
\date 2013/06/26
*/

/*Revision history ******************************************
*
*        Author             :
*        Dept            :
*        Revision Date    :
*        Version           :
*
*/
#include <stdint.h>

#ifdef __cplusplus
extern "C"
{
#endif	

#define __packed			__attribute__((packed))

#define SMS_MESSAGE_SIZE    161
#define SMS_SENDER_SIZE     25

enum sms_tag_t
{
	TAG_READ = 0x00,
	TAG_NOT_READ = 0x01,
	TAG_SENT = 0x02,
	TAG_NOT_SENT = 0x03,
};

typedef struct
{
	uint8_t sender_length;
	uint8_t sender_type;
	uint8_t sender_num[SMS_SENDER_SIZE];
	uint8_t timestamp[7];
	uint8_t message_length;
	char msg_dcs;
	uint8_t message[SMS_MESSAGE_SIZE];
} __packed sms_t;


typedef struct 
{
	uint32_t n_messages;
	struct list_item
	{
		uint32_t index;
		uint8_t tag;
	}__packed item[];
}__packed sms_list_t;


int sms_decode_pdu(const char *data, size_t sz, sms_t *sms);


#ifdef __cplusplus
}
#endif

#endif//_SMS_H_

