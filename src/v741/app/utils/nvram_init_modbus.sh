#!/bin/sh

#MODBUS
ModbusGwAutoStart=`nvram_get 2860 ModbusGwAutoStart`
if [ "$ModbusGwAutoStart" == "" ]; then
    nvram_set 2860 ModbusGwAutoStart 0
fi

ModbusGwTcpTmoResp=`nvram_get 2860 ModbusGwTcpTmoResp`
if [ "$ModbusGwTcpTmoResp" == "" ]; then
    nvram_set 2860 ModbusGwTcpTmoResp 1000
fi

ModbusGwTcpListenPort=`nvram_get 2860 ModbusGwTcpListenPort`
if [ "$ModbusGwTcpListenPort" == "" ]; then
    nvram_set 2860 ModbusGwTcpListenPort 502
fi

ModbusGwRtuBps=`nvram_get 2860 ModbusGwRtuBps`
if [ "$ModbusGwRtuBps" == "" ]; then
    nvram_set 2860 ModbusGwRtuBps 9600
fi

ModbusGwRtuParity=`nvram_get 2860 ModbusGwRtuParity`
if [ "$ModbusGwRtuParity" == "" ]; then
    nvram_set 2860 ModbusGwRtuParity 0
fi

ModbusGwRtuDatabit=`nvram_get 2860 ModbusGwRtuDatabit`
if [ "$ModbusGwRtuDatabit" == "" ]; then
    nvram_set 2860 ModbusGwRtuDatabit 8
fi

ModbusGwRtuStopbit=`nvram_get 2860 ModbusGwRtuStopbit`
if [ "$ModbusGwRtuStopbit" == "" ]; then
    nvram_set 2860 ModbusGwRtuStopbit 1
fi

ModbusGwRtuFlow=`nvram_get 2860 ModbusGwRtuFlow`
if [ "$ModbusGwRtuFlow" == "" ]; then
    nvram_set 2860 ModbusGwRtuFlow 0
fi
