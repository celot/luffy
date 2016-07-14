#!/bin/sh

if [ "$1" = "off" ]; then
    #sm_launcher stop
    nvram_set 2860 directSerialEnable Disable
    killall -USR1 ds_observer
    killall -9 directserial
    exit 0
fi

directSerialEnable=`nvram_get 2860 directSerialEnable`

if [ "$directSerialEnable" != "Enable" ]; then
	killall -9 directserial
	killall -USR1 ds_observer
	exit 0
fi

directSerialMode=`nvram_get 2860 directSerialMode`
directServer=`nvram_get 2860 directServer`
directServerPort=`nvram_get 2860 directServerPort`
directSerialListenPort=`nvram_get 2860 directSerialListenPort`

if [ "$directSerialMode" = "" ]; then
	directSerialMode=0
fi

if [ "$directSerialMode" = "0" ]; then
	if [ "$directServer" = "" -o  "$directServerPort" = "" ]; then
		exit 0
	fi 
else
	if [ "$directSerialListenPort" = "" ]; then
		exit 0
	fi
fi

echo "Run DirectSerial"
killall -USR1 ds_observer
killall -9 directserial

rm -rf /var/run/ds.chk
rm /usr/sbin/ds_observer
cp /usr/sbin/app_observer /usr/sbin/ds_observer

ds_observer autodirectserial.sh /var/run/ds.chk 60 2

directserial &
