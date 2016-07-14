#!/bin/sh

CRONTAB=/etc/crontabs

autoRebootMode=`nvram_get 2860 autoRebootMode`
autoRebootmethod=`nvram_get 2860 autoRebootmethod`

if [ "$autoRebootMode" != "Enable" ]; then
	killall -9 crond
	exit 0
fi

if [ "$autoRebootmethod" = "" ]; then
    autoRebootmethod="Enable"
fi

autoRebootHour=`nvram_get 2860 autoRebootHour`
autoRebootMin=`nvram_get 2860 autoRebootMin`
autoRebootED=`nvram_get 2860 autoRebootED`
autoRebootDay=`nvram_get 2860 autoRebootDay`
autoRebootHourtr=`nvram_get 2860 autoRebootHourtr`

 
if [ "$autoRebootHour" = "" ]; then
	autoRebootHour=0
fi
if [ "$autoRebootMin" = "" ]; then
	autoRebootMin=0
fi
if [ "$autoRebootED" = "" ]; then
	autoRebootED=1
fi
if [ "$autoRebootDay" = "" ]; then
	autoRebootDay=0
fi
if [ "$autoRebootHourtr" = "" ]; then
	autoRebootHourtr=1
fi

mkdir -p $CRONTAB

RebootMin=`expr $autoRebootMin \* 5`


if [ "$autoRebootmethod" = "Disable" ]; then
	echo "0 */$autoRebootHourtr * * * /usr/sbin/reboot.sh" > $CRONTAB/admin
else

if [ "$autoRebootED" = "on" ]; then
	echo "$RebootMin $autoRebootHour * * * /usr/sbin/reboot.sh" > $CRONTAB/admin
else
	echo "$RebootMin $autoRebootHour * * $autoRebootDay /usr/sbin/reboot.sh" > $CRONTAB/admin
fi

fi

echo "Run Crond"
killall -9 crond
crond -c $CRONTAB &
