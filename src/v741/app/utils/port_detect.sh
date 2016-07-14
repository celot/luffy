#!/bin/sh

portDetectEnabled=`nvram_get 2860 portDetectEnabled`

rm -rf /var/run/portdetect_main.pid
rm -rf /var/run/portdetect_mail.pid

echo "$portDetectEnabled"

if [ "$portDetectEnabled" != "Enable" ]; then
	killall -9 port_detect
	killall -9 port_dmon
	exit 0
fi

echo "Run port_detect"
killall -USR1 port_detect
port_detect

killall -9 port_dmon
port_dmon