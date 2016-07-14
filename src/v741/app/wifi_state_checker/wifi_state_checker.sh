#!/bin/sh

. /sbin/global.sh

sleep 2
killall -9 ws_checker
sleep 10
	

if [ "$wifi_off" != "1" ]; then
	
	ws_checker &

fi


