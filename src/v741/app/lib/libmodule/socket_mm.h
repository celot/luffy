#ifndef _SOCKET_MM_H_
#define _SOCKET_MM_H_

/**
\file socket_mm.h
\brief 
\author tyranno
\warning 
\date 2013/05/28
*/

/*Revision history ******************************************
*
*        Author             :
*        Dept            :
*        Revision Date    :
*        Version           :
*
*/
#define _packed __attribute__((packed))
typedef enum
{
	CMDMM_GET_PIN_STATUS=0xFACE0001,
	CMDMM_VERIFY_PIN=0xFACE0002,
	CMDMM_GET_IMEI=0xFACE0003,
	CMDMM_SET_IMEI=0xFACE0004,	
	CMDMM_GET_DBG_STATUS=0xFACE0005,
	CMDMM_CTRL_POWER=0xFACE0006,
	CMDMM_CTRL_CONNECT=0xFACE0007,
	CMDMM_GET_SMS_LIST=0xFACE0008,
	CMDMM_GET_SMS_DATA=0xFACE0009,
	CMDMM_ROUTE_REFRESH=0xFACE000A,
	CMDMM_DOMAIN_CHECK=0xFACE000B,
	CMDMM_NETCHECK_REFRESH=0xFACE000C,
	CMDMM_CTRL_CHANGE_DOMAIN=0xFACE000D,

	//category SMS
	CMDMM_SMS_DELETE=0xFACE1001,

	//category EMG
	CMDMM_EMG_DELETE=0xFACE2001,

	//pref mode
	CMDMM_GET_PREF_MODE=0xFACE3001,
	CMDMM_SET_PREF_MODE=0xFACE3002,	
	
	CMDMM_MAX
}cmd_mm_type;


struct _packed CmdMM_Req
{
	cmd_mm_type cmd;
	unsigned int len;
	char data[];
};

struct _packed CmdMM_Res
{
	cmd_mm_type cmd;
	char result;
	unsigned int len;
	char data[];
};

class SocketMM
{
	public:
		SocketMM();
		~SocketMM();

		int writeCmd(const CmdMM_Req* cmd);
		int readResult(CmdMM_Res* res, unsigned int wait_10ms);

	private:
		int m_fd;
	
};

#endif//_SOCKET_MM_H_

