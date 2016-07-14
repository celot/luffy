#!/bin/sh
#
# $Id: apcli_nat.sh,v 1.5 2011-02-16 10:26:21 chhung Exp $
#
# usage: apcli_nat.sh
#

. /sbin/global.sh


lan_ip=`nvram_get 2860 lan_ipaddr`
nat_en=`nvram_get 2860 natEnabled`
wanMode=`nvram_get 2860 wanMode`


if [ "$nat_en" = "1" ]; then
 
	if [ "$wanMode" = "0" ]; then
		if [ "$apclienable" = "1" ]; then
			iptables -t nat -D POSTROUTING -s $lan_ip/24 -o $wan_if -j MASQUERADE  --random
			iptables -t nat -A POSTROUTING -s $lan_ip/24 -o $wan_if -j MASQUERADE  --random
		fi
	fi
fi

