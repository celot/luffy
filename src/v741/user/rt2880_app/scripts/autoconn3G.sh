#! /bin/sh

LOCK_FILE=/var/lock/LOCK.3G.auto
DEV_FILE=/tmp/usb_dev
DISCONN_FILE=/etc_ro/ppp/3g/celot_disconn.scr

SUPPORT_3G="12D1:1001:HUAWEI-E169
	    0408:EA02:MU-Q101
	    0408:1000:MU-Q101
	    0AF0:6971:OPTION-ICON225
	    1AB7:5700:DATANG-M5731
	    1AB7:5731:DATANG-M5731		
	    FEED:5678:MobilePeak-Titan
	    FEED:0001:MobilePeak-Titan
	    1A8D:1000:BandLuxe-C270
	    1A8D:1009:BandLuxe-C270"		

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

if [ ! -f "$DISCONN_FILE" ]; then
  #creat disconnect chat script
  echo "ABORT 'BUSY'" > $DISCONN_FILE
  echo "ABORT 'NO DIALTONE'" >> $DISCONN_FILE
  echo "ABORT 'ERROR'" >> $DISCONN_FILE
  echo "'' '\K'" >> $DISCONN_FILE
  echo "'' '+++ATH'" >> $DISCONN_FILE
  echo "SAY 'Goodbay.'" >> $DISCONN_FILE
fi

if [ "$1" = "connect" ]; then
	wanmode=`nvram_get 2860 wanConnectionMode`

	if [ "$wanmode" != "3G" ]; then
		rm -f $DEV_FILE
		rm -f $LOCK_FILE
		exit 0
	fi

	#DEV=`nvram_get 2860 wan_3g_dev`
	#cat /proc/bus/usb/devices | sed -n '/.* Vendor=.* ProdID=.*/p' | sed -e 's/.*Vendor=\(.*\) ProdID=\(.*\) Rev.*/\1:\2/' | sed 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/' > $DEV_FILE

	#for i in `cat "$DEV_FILE"`
	#do
	#	for j in $SUPPORT_3G
	#	do
	#	k=`echo $j | sed -e 's/\(.*\):\(.*\):.*/\1:\2/'`
	#	if [ "$i" = "$k"  ]; then
	#		k=`echo $j | sed -e 's/.*:.*:\(.*\)$/\1/'`
	#		if [ "$DEV" = "Auto" ] || [ "$DEV" = "" ] || [ "$k" = "$DEV" ] ; then
	#			3g.sh $k    
	#			rm -f $DEV_FILE
	#			rm -f $LOCK_FILE
	#			exit 1
	#		fi
	#	fi
	#    done
	#done
elif [ "$1" = "disconnect" ]; then
	killall -q pppd
	ifconfig ppp0 down
	chat -v -f /etc_ro/ppp/3g/celot_disconn.scr </dev/$interface >/dev/$interface 2> /dev/null
	rm -f $DEV_FILE
	rm -f $LOCK_FILE
	exit 1
fi

rm -f $DEV_FILE
rm -f $LOCK_FILE
exit 0

