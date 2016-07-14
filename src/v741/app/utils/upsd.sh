#!/bin/sh

UPSUse=`nvram_get 2860 UPSUse`

rm -rf /var/run/ups_main.pid
rm -rf /var/run/ups_mail.pid
rm -rf /var/run/ups_sms.pid
rm -rf /var/run/ups_socket.pid

if [ "$UPSUse" != "Enable" ]; then
	killall -9 upsd
	killall -9 upsdmon
	exit 0
fi


echo "Run Upsd"
killall -USR1 upsd

if [ "$1" = "EvnBootRequest" ]; then
	upsd EvnBootRequest
else
	upsd
fi

killall -9 upsdmon
upsdmon

