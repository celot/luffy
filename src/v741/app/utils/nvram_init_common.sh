#!/bin/sh

#DIRECT SERIAL
directSerialEnable=`nvram_get 2860 directSerialEnable`
if [ "$directSerialEnable" == "" ]; then
    nvram_set 2860 directSerialEnable Disable
fi

directDev=`nvram_get 2860 directDev`
if [ "$directDev" == "" ]; then
    nvram_set 2860 directDev UART-F
fi

directBaud=`nvram_get 2860 directBaud`
if [ "$directBaud" == "" ]; then
    nvram_set 2860 directBaud 115200
fi

directSerialData=`nvram_get 2860 directSerialData`
if [ "$directSerialData" == "" ]; then
    nvram_set 2860 directSerialData 1
fi

directSerialParity=`nvram_get 2860 directSerialParity`
if [ "$directSerialParity" == "" ]; then
    nvram_set 2860 directSerialParity 0
fi

directSerialStop=`nvram_get 2860 directSerialStop`
if [ "$directSerialStop" == "" ]; then
    nvram_set 2860 directSerialStop 0
fi

directSerialFlow=`nvram_get 2860 directSerialFlow`
if [ "$directSerialFlow" == "" ]; then
    nvram_set 2860 directSerialFlow 0
fi

directSerialMode=`nvram_get 2860 directSerialMode`
if [ "$directSerialMode" == "" ]; then
    nvram_set 2860 directSerialMode 0
fi

directServer=`nvram_get 2860 directServer`
if [ "$directServer" == "" ]; then
    nvram_set 2860 directServer 192.168.0.1
fi

directServerPort=`nvram_get 2860 directServerPort`
if [ "$directServerPort" == "" ]; then
    nvram_set 2860 directServerPort 1212
fi

directSerialListenPort=`nvram_get 2860 directSerialListenPort`
if [ "$directSerialListenPort" == "" ]; then
    nvram_set 2860 directSerialListenPort 1212
fi

directSerialInterface=`nvram_get 2860 directSerialInterface`
if [ "$directSerialInterface" == "" ]; then
    nvram_set 2860 directSerialInterface 0
fi

directSerialModeUdp=`nvram_get 2860 directSerialModeUdp`
if [ "$directSerialModeUdp" == "" ]; then
    nvram_set 2860 directSerialModeUdp $directSerialMode
fi

directDnGuardTime=`nvram_get 2860 directDnGuardTime`
if [ "$directDnGuardTime" == "" ]; then
    nvram_set 2860 directDnGuardTime 3
fi

directDnTrgInitFlag=`nvram_get 2860 directDnTrgInitFlag`
if [ "$directDnTrgInitFlag" == "" ]; then
    nvram_set 2860 directDnTrgInitFlag 0
fi

directDnDefaultServer=`nvram_get 2860 directDnDefaultServer`
if [ "$directDnDefaultServer" == "" ]; then
    nvram_set 2860 directDnDefaultServer 192.168.0.1
fi

directDnDefaultServerPort=`nvram_get 2860 directDnDefaultServerPort`
if [ "$directDnDefaultServerPort" == "" ]; then
    nvram_set 2860 directDnDefaultServerPort 1212
fi

directDnDefaultInterface=`nvram_get 2860 directDnDefaultInterface`
if [ "$directDnDefaultInterface" == "" ]; then
    nvram_set 2860 directDnDefaultInterface 0
fi

directSerialBufferSize=`nvram_get 2860 directSerialBufferSize`
if [ "$directSerialBufferSize" == "" ]; then
    nvram_set 2860 directSerialBufferSize 1024
fi

directSerialBufferTimeout=`nvram_get 2860 directSerialBufferTimeout`
if [ "$directSerialBufferTimeout" == "" ]; then
    nvram_set 2860 directSerialBufferTimeout 300
fi

directSerialProtocol=`nvram_get 2860 directSerialProtocol`
if [ "$directSerialProtocol" == "" ]; then
    nvram_set 2860 directSerialProtocol 0
fi

#UPS
UPSUse=`nvram_get 2860 UPSUse`
if [ "$UPSUse" == "" ]; then
    nvram_set 2860 UPSUse Disable
fi
UPSAlarm=`nvram_get 2860 UPSAlarm`
if [ "$UPSAlarm" == "" ]; then
    nvram_set 2860 UPSAlarm 4
fi
upsserverport=`nvram_get 2860 upsserverport`
if [ "$upsserverport" == "" ]; then
    nvram_set 2860 upsserverport 65535
fi
upsEmailInterface=`nvram_get 2860 upsEmailInterface`
if [ "$upsEmailInterface" == "" ]; then
    nvram_set 2860 upsEmailInterface 0
fi
UPSSmtpPort=`nvram_get 2860 UPSSmtpPort`
if [ "$UPSSmtpPort" == "" ]; then
    nvram_set 2860 UPSSmtpPort 65535
fi
UPSSmtpSecu=`nvram_get 2860 UPSSmtpSecu`
if [ "$UPSSmtpSecu" == "" ]; then
    nvram_set 2860 UPSSmtpSecu NONE
fi
UPSSmtpAuth=`nvram_get 2860 UPSSmtpAuth`
if [ "$UPSSmtpAuth" == "" ]; then
    nvram_set 2860 UPSSmtpAuth 1
fi
UPSMSendR=`nvram_get 2860 UPSMSendR`
if [ "$UPSMSendR" == "" ]; then
    nvram_set 2860 UPSMSendR 3
fi
UPSMSendI=`nvram_get 2860 UPSMSendI`
if [ "$UPSMSendI" == "" ]; then
    nvram_set 2860 UPSMSendI 10
fi
UPSVoltlevel1=`nvram_get 2860 UPSVoltlevel1`
if [ "$UPSVoltlevel1" == "" ]; then
    nvram_set 2860 UPSVoltlevel1 0
fi
UPSVoltlevel2=`nvram_get 2860 UPSVoltlevel2`
if [ "$UPSVoltlevel2" == "" ]; then
    nvram_set 2860 UPSVoltlevel2 0
fi
UPSVoltlevel3=`nvram_get 2860 UPSVoltlevel3`
if [ "$UPSVoltlevel3" == "" ]; then
    nvram_set 2860 UPSVoltlevel3 0
fi
UPSVoltlevel4=`nvram_get 2860 UPSVoltlevel4`
if [ "$UPSVoltlevel4" == "" ]; then
    nvram_set 2860 UPSVoltlevel4 0
fi
upsserverport1=`nvram_get 2860 upsserverport1`
if [ "$Upsserverport1" == "" ]; then
    nvram_set 2860 upsserverport1 22220
fi
upsCustomWarningVoltIndex=`nvram_get 2860 upsCustomWarningVoltIndex`
if [ "$UpsCustomWarningVoltIndex" == "" ]; then
    nvram_set 2860 upsCustomWarningVoltIndex 3
fi
UPSPwDwNotifyWaitTime=`nvram_get 2860 UPSPwDwNotifyWaitTime`
if [ "$UPSPwDwNotifyWaitTime" == "" ]; then
    nvram_set 2860 UPSPwDwNotifyWaitTime 60
fi