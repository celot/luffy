#!/bin/sh

if [ "$1" = "off" ]; then
    #sm_launcher stop
    nvram_set 2860 serialModemEnable Disable
    sm_launcher dtroff
    killall -9 ct_chat
    killall -9 disct_chat
    killall -9 ct_pppd
    exit 0
fi

serialModemEnable=`nvram_get 2860 serialModemEnable`
if [ "$serialModemEnable" != "Enable" ]; then
    #sm_launcher stop
    sm_launcher dtroff
    killall -9 ct_chat
    killall -9 disct_chat
    killall -9 ct_pppd
    exit 0
fi

echo "Run Serial Modem"
killall -9 ct_chat
killall -9 disct_chat
killall -9 ct_pppd
    
smDev=`nvram_get 2860 smDev`
smBaud=`nvram_get 2860 smBaud`

if [ "$smDev" = "UART-L" ]; then
    SM_TTY="restart1"
else    
    SM_TTY="restart0"
fi
if [ "$smBaud" = "" ]; then
    SM_BAUD="-b 115200"
else
    SM_BAUD="-b $smBaud"
fi

echo "sm_launcher $SM_TTY $SM_BAUD"
sm_launcher $SM_TTY $SM_BAUD

