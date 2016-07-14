#!/bin/sh

sms2SerialEnable=`nvram_get 2860 sms2Serial`
if [ "$sms2SerialEnable" != "1" ]; then
    killall -9 sms2serial
    exit 0
fi

echo "Run Sms2Serial"
killall -9 directserial  1>/dev/null 2>&1
serialmodem.sh off
killall -9 sms2serial  1>/dev/null 2>&1
sms2serial &

