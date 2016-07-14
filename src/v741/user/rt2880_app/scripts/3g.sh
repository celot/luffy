#!/bin/sh

LOCK_FILE=/var/lock/LOCK.3G
#interface=`nvram_get 2860 wan_3g_interface`
interface=`module b`
if [ "$interface" = "" ]; then
  interface=ttyUSB0
fi

if [ -f "$LOCK_FILE" ]; then
	exit 0
else
	if [ ! -f "/var/lock" ]; then
		mkdir -p /var/lock/
	fi
	touch "$LOCK_FILE"
fi

if [ "$1" != "" ]; then
        dev=$1
else
        dev=`nvram_get 2860 wan_3g_dev`
fi

killall -q module
killall -q pppd
ifconfig ppp0 down
chat -v -f /etc_ro/ppp/3g/celot_disconn.scr </dev/$interface >/dev/$interface 2> /dev/null
sleep 3

#create ppp call script for 3G connection
modem_f=$interface
user=`nvram_get 2860 wan_3g_user`
pass=`nvram_get 2860 wan_3g_pass`
apn=`nvram_get 2860 wan_3g_apn`
pin=`nvram_get 2860 wan_3g_pin`
dial=`nvram_get 2860 wan_3g_dial`
apntype=`nvram_get 2860 wan_3g_apntype`
apncid=`nvram_get 2860 wan_3g_apncid`

if [ "$user" = "" ]; then
	user=none
fi
if [ "$pass" = "" ]; then
	pass=none
fi
if [ "$dial" = "" ]; then
	dial=*98#
fi
if [ "$apn" = "" ]; then
	echo "Check APN!!!"
	exit 0
fi
if [ "$apntype" = "" ]; then
	echo "Check APN Type!!!"
	exit 0
fi

config-3g-ppp.sh -p $pass -u $user -m $modem_f -n $dial
#config-3g-ppp.sh -p $pass -u $user -m $modem_f  -n $dial -c Generic_conn.scr -d Generic_disconn.scr

echo "Connectiong via $dev ..."

#set apn 
apncid_n=1
case "$apncid" in
 "CID1")
   apncid_n=1 ;;
 "CID2")
   apncid_n=2 ;;
 "CID3")
   apncid_n=3 ;;
 "CID4")
   apncid_n=4 ;;
 "CID5")
   apncid_n=5 ;;
 "CID6")
   apncid_n=6 ;; 
 "CID7")
   apncid_n=7 ;;
 "CID8")
   apncid_n=8 ;;
 "CID9")
   apncid_n=9 ;;
 "CID10")
   apncid_n=10 ;;
 *)
   apncid_n=1 ;;

module at "AT+CGDCONT=$apncid_n,\"$apntype\",\"$apn\""

#pppd call 3g&
module ppp&

rm -f $LOCK_FILE
exit 0
