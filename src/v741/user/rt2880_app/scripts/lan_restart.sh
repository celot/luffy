#!/bin/sh
lan_wait_time=20

if [ "$1" = "force" ]; then
	config-udhcpd.sh -D
	sleep $lan_wait_time
	config-udhcpd.sh -U
	exit 0
fi

dmz=`nvram_get 2860 DMZEnable`
dmzaddress=`nvram_get 2860 DMZAddress`

if [ "$dmz" = "2" -a "$dmzaddress" != "" ]; then
	config-udhcpd.sh -D
	sleep $lan_wait_time
	config-udhcpd.sh -U
fi

