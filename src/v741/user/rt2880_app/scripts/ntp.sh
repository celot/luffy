#!/bin/sh
#
# $Id: ntp.sh,v 1.4 2008-01-21 08:39:58 yy Exp $
#
# usage: ntp.sh
#

tz=`nvram_get 2860 TZ`
echo $tz > /etc/tmpTZ
sed -e 's|\(.*\)_\(-*\)0*\(.*\)|\1-\2\3|' /etc/tmpTZ > /etc/tmpTZ2
sed -e 's|\(.*\)--\(.*\)|\1\2|' /etc/tmpTZ2 > /etc/TZ
rm -rf /etc/tmpTZ
rm -rf /etc/tmpTZ2

if [ "$1" = "setTZ" ]; then exit 0; fi

if [ -f "/var/run/ntp.lock" ]; then exit 0; fi
echo "Run NTP" > "/var/run/ntp.lock"

srv=`nvram_get 2860 NTPServerIP`
sync=`nvram_get 2860 NTPSync`

killall -q ntpclient

if [ "$srv" = "" ]; then
       killall -SIGTSTP mod_man
       rm -rf "/var/run/ntp.lock"
	exit 0
fi


if [ "$sync" = "" ]; then
	sync=2
fi

sync=`expr $sync \* 3600`

if [ "$tz" = "" ]; then
	tz="UCT_000"
fi

#debug
echo "serv=$srv"
echo "sync=$sync"
echo "tz=$tz"

if hash nslookup 2>/dev/null; then
       index=0       
	while ! nslookup pool.ntp.org >/dev/null 2>&1 ; do
		echo "NTP: Waiting for Internet to be ready"
		sleep 5
		index=`expr $index + 1`
		if [ "$index" -eq 12 ]; then
			killall -SIGTSTP mod_man
			index=1
	       fi
	done
fi
ntpclient -s -c 0 -h $srv -i $sync &

rm -rf "/var/run/ntp.lock"

