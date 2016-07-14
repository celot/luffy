#!/bin/sh

#GPS
GpsFuncEnable=`nvram_get 2860 GpsFuncEnable`
if [ "$GpsFuncEnable" == "" ]; then
    nvram_set 2860 GpsFuncEnable 0
fi

GpsType=`nvram_get 2860 GpsType`
if [ "$GpsType" == "" ]; then
    nvram_set 2860 GpsType 3
fi

GpsPositinCycle=`nvram_get 2860 GpsPositinCycle`
if [ "$GpsPositinCycle" == "" ]; then
    nvram_set 2860 GpsPositinCycle 5
fi

GpsDataFormat=`nvram_get 2860 GpsDataFormat`
if [ "$GpsDataFormat" == "" ]; then
    nvram_set 2860 GpsDataFormat 0
fi

GpsDatum=`nvram_get 2860 GpsDatum`
if [ "$GpsDatum" == "" ]; then
    nvram_set 2860 GpsDatum 0
fi

GpsPositionUnit=`nvram_get 2860 GpsPositionUnit`
if [ "$GpsPositionUnit" == "" ]; then
    nvram_set 2860 GpsPositionUnit 1
fi

GpsSuplPppID=`nvram_get 2860 GpsSuplPppID`
if [ "$GpsSuplPppID" == "" ]; then
    nvram_set 2860 GpsSuplPppID dymmyname
fi

GpsSuplPppPwType=`nvram_get 2860 GpsSuplPppPwType`
if [ "$GpsSuplPppPwType" == "" ]; then
    nvram_set 2860 GpsSuplPppPwType 0
fi

GpsSuplPppPwT=`nvram_get 2860 GpsSuplPppPwT`
if [ "$GpsSuplPppPwT" == "" ]; then
    nvram_set 2860 GpsSuplPppPwT dummypw
fi

GpsLOutMode=`nvram_get 2860 GpsLOutMode`
if [ "$GpsLOutMode" == "" ]; then
    nvram_set 2860 GpsLOutMode 0
fi

GpsLTcpCloseTime=`nvram_get 2860 GpsLTcpCloseTime`
if [ "$GpsLTcpCloseTime" == "" ]; then
    nvram_set 2860 GpsLTcpCloseTime 60
fi

GpsLExpirationTime=`nvram_get 2860 GpsLExpirationTime`
if [ "$GpsLExpirationTime" == "" ]; then
    nvram_set 2860 GpsLExpirationTime 60
fi

GpsLClDstPort=`nvram_get 2860 GpsLClDstPort`
if [ "$GpsLClDstPort" == "" ]; then
    nvram_set 2860 GpsLClDstPort 50100
fi

GpsLTSvListenPort=`nvram_get 2860 GpsLTSvListenPort`
if [ "$GpsLTSvListenPort" == "" ]; then
    nvram_set 2860 GpsLTSvListenPort 50100
fi

GpsWOutMode=`nvram_get 2860 GpsWOutMode`
if [ "$GpsWOutMode" == "" ]; then
    nvram_set 2860 GpsWOutMode 0
fi

GpsWTcpCloseTime=`nvram_get 2860 GpsWTcpCloseTime`
if [ "$GpsWTcpCloseTime" == "" ]; then
    nvram_set 2860 GpsWTcpCloseTime 60
fi

GpsWExpirationTime=`nvram_get 2860 GpsWExpirationTime`
if [ "$GpsWExpirationTime" == "" ]; then
    nvram_set 2860 GpsWExpirationTime 60
fi

GpsWTClDstIF=`nvram_get 2860 GpsWTClDstIF`
if [ "$GpsWTClDstIF" == "" ]; then
    nvram_set 2860 GpsWTClDstIF WWAN1
fi

GpsWClDstPort=`nvram_get 2860 GpsWClDstPort`
if [ "$GpsWClDstPort" == "" ]; then
    nvram_set 2860 GpsWClDstPort 50200
fi

GpsWTSvListenPort=`nvram_get 2860 GpsWTSvListenPort`
if [ "$GpsWTSvListenPort" == "" ]; then
    nvram_set 2860 GpsWTSvListenPort 50201
fi
