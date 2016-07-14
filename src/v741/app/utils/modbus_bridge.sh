#!/bin/sh
if [ "$1" = "off" ]; then
    #sm_launcher stop
    killall -9 modbus_bridge
    nvram_set 2860 ModbusGwAutoStart 0
    exit 0
fi
modbusEnable=`nvram_get 2860 ModbusGwAutoStart`
if [ "$modbusEnable" == "0" ]; then
    #not bridge mode
    echo "not bridge mode"
    killall -9 modbus_bridge
    exit 0
elif [ "$modbusEnable" == "" ]; then
    nvram_set 2860 ModbusGwAutoStart 0
    nvram_set 2860 ModbusGwTcpTmoResp 1000
    nvram_set 2860 ModbusGwTcpListenPort 502
    nvram_set 2860 ModbusGwRtuBps 9600
    nvram_set 2860 ModbusGwRtuParity 0
    nvram_set 2860 ModbusGwRtuDatabit 8
    nvram_set 2860 ModbusGwRtuStopbit 1
    nvram_set 2860 ModbusGwRtuFlow 0
    killall -9 modbus_bridge
    exit 0
fi

echo "Run modbus bridge"
killall -9 modbus_bridge

modbusBridgeTimeout=`nvram_get 2860 ModbusGwTcpTmoResp`
modbusBridgePort=`nvram_get 2860 ModbusGwTcpListenPort`
modbusBridgeBaud=`nvram_get 2860 ModbusGwRtuBps`
modbusBridgeParity=`nvram_get 2860 ModbusGwRtuParity`
modbusBridgeData=`nvram_get 2860 ModbusGwRtuDatabit`
modbusBridgeStop=`nvram_get 2860 ModbusGwRtuStopbit`
modbusBridgeFlow=`nvram_get 2860 ModbusGwRtuFlow`

modbus_bridge -s $modbusBridgeBaud,$modbusBridgeParity,$modbusBridgeData,$modbusBridgeStop,$modbusBridgeFlow -p $modbusBridgePort -o $modbusBridgeTimeout &

