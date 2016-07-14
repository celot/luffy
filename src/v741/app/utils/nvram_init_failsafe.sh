#!/bin/sh

#FAILSAFE
FsWWANConnectMode=`nvram_get 2860 FsWWANConnectMode`
if [ "$FsWWANConnectMode" == "" ]; then
    nvram_set 2860 FsWWANConnectMode 0
fi

FsTransactionCheckEnable=`nvram_get 2860 FsTransactionCheckEnable`
if [ "$FsTransactionCheckEnable" == "" ]; then
    nvram_set 2860 FsTransactionCheckEnable 0
fi

FsWWANServerCheckEnable=`nvram_get 2860 FsWWANServerCheckEnable`
if [ "$FsWWANServerCheckEnable" == "" ]; then
    nvram_set 2860 FsWWANServerCheckEnable 0
fi

FsWWANServerCheckCycle=`nvram_get 2860 FsWWANServerCheckCycle`
if [ "$FsWWANServerCheckCycle" == "" ]; then
    nvram_set 2860 FsWWANServerCheckCycle 20
fi

FsAutoResetElapsedEnable=`nvram_get 2860 FsAutoResetElapsedEnable`
if [ "$FsAutoResetElapsedEnable" == "" ]; then
    nvram_set 2860 FsAutoResetElapsedEnable 0
fi

FsAutoResetElapsedTimer=`nvram_get 2860 FsAutoResetElapsedTimer`
if [ "$FsAutoResetElapsedTimer" == "" ]; then
    nvram_set 2860 FsAutoResetElapsedTimer 1
fi

FsMaintenanceLogSize=`nvram_get 2860 FsMaintenanceLogSize`
if [ "$FsMaintenanceLogSize" == "" ]; then
    nvram_set 2860 FsMaintenanceLogSize 1024
fi
