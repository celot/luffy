#ifndef _CRCCHECKER_H_
#define _CRCCHECKER_H_

/**
\file crcchecker.h
\brief 
\author tyranno
\warning 
\date 2011/08/19
*/

/*Revision history ******************************************
*
*        Author             :
*        Dept            :
*        Revision Date    :
*        Version           :
*
*/
#include "comdef.h"
#include "list.h"

class DrainRxData
{
	public:
		DrainRxData();
		void append(char data);
		void clear();
		char* data() { return m_data;}

	private:
		char m_data[256];
		int m_dataSize;
};

struct DrainListItem
{
	struct list_head list;
	DrainRxData item;
};

class DrainRxList
{
	public:
		DrainRxList();

		void push(const DrainRxData& drainRxData);
		DrainRxData* pop();

	private:
		struct list_head data_head, free_head;

		DrainListItem mData[32];
};

class CrcChecker
{
	public:
		const static uint16 CRC_SEED = 0xFFFF;
		const static uint16 CRC_END = 0xF0B8;
		const static uint8 ESC_ASYNC = 0x7D;
		const static uint8 FLAG_ASYNC = 0x7E;
		const static uint8 ESC_COMPL = 0x20;

		CrcChecker();
		~CrcChecker();

		void clear();
		uint32 computeTx(uint8 *tx_byte, int tx_len);
		bool computeRx(uint8 *rx_buf, int rx_len);

		uint32 computeTxStr(uint8 *tx_byte, int tx_len);
		bool computeRxStr(uint8 *rx_buf, int rx_len);

		char* getTxData() { return m_dataTx;}
		uint32 getTxSize() { return m_sizeTx;}
		
		char* getRxData() { return m_dataRx;}
		uint32 getRxSize() { return m_sizeRx;}

		bool computeDrainRx(uint8 *rx_buf, int rx_len);
		char* getDrainRxData();

	private:
		uint32 getCtrlByteCnt(uint8 *tx_byte, int tx_len) const;
		bool checkByte(uint8 *result, uint8 chk_byte);
		inline uint16 computeCRC(uint16 x_crc, uint8 x_byte);

	private:
		char* m_dataTx;
		uint32 m_sizeTx;
		
		char* m_dataRx;
		uint32 m_sizeRx;
		
		bool m_rxCrcOk;

		DrainRxList m_drainRxList;
		DrainRxData m_drainRx;
		int m_drainRxStart;
		int m_drainRxEnd;
};

#endif//_CRCCHECKER_H_

