#!/bin/sh
#
# $Id: ddns.sh,v 1.1 2007-09-24 09:34:52 winfred Exp $
#
# usage: ddns.sh
#

srv=`nvram_get 2860 DDNSProvider`
ddns=`nvram_get 2860 DDNS`
u=`nvram_get 2860 DDNSAccount`
pw=`nvram_get 2860 DDNSPassword`


killall -q inadyn

if [ "$srv" = "custom2" ]; then
    option=`nvram_get 2860 DDNSOption`
    if [ "$option" != "" ]; then
        cwget $option &
    fi
    exit 0
fi

if [ "$srv" = "" -o "$srv" = "none" ]; then
	exit 0
fi
if [ "$ddns" = "" -o "$u" = "" -o "$pw" = "" ]; then
	exit 0
fi

# debug
echo "srv=$srv"
echo "ddns=$ddns"
echo "u=$u"
echo "pw=$pw"


if [ "$srv" = "dyndns.org" ]; then
	inadyn -u $u -p $pw -a $ddns --dyndns_system dyndns@$srv &
elif [ "$srv" = "freedns.afraid.org" ]; then
	inadyn -u $u -p $pw -a $ddns --dyndns_system default@$srv &
elif [ "$srv" = "zoneedit.com" ]; then
	inadyn -u $u -p $pw -a $ddns --dyndns_system default@$srv &
elif [ "$srv" = "no-ip.com" ]; then
	inadyn -u $u -p $pw -a $ddns --dyndns_system default@$srv &
elif [ "$srv" = "custom" ]; then
	server = `nvram_get 2860 DDNSServer` 
	if [ "$server" = "" ]; then
		exit 0
	fi
	url=`nvram_get 2860 DDNSUrl`
	option=`nvram_get 2860 DDNSOption`
	options="-u $u -p $pw -a $ddns"
	if [ "$server" != "" ]; then
	options="$options --dyndns_server_name $server"
	fi
	if [ "$url" != "" ]; then
	options="$options --dyndns_server_url $url"
	fi
	if [ "$option" != "" ]; then
	options="$options $option"
	fi
	inadyn $options &	
else
	echo "$0: unknown DDNS provider: $srv"
	exit 1
fi

