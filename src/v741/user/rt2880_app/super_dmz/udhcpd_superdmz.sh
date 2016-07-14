#!/bin/sh
#
# $Id: udhcpd_superdmz.sh,v 1.2 2010-04-06 09:09:44 yy Exp $
#
# usage: wan.sh
#

dmz=`nvram_get 2860 DMZEnable`
dmzaddress=`nvram_get 2860 DMZAddress`

restart_udhcpd()
{
    . /sbin/global.sh

    # stop all
    killall -q udhcpd
    #echo "" > /var/udhcpd.leases

    # ip address
    ip=`nvram_get 2860 lan_ipaddr`
    nm=`nvram_get 2860 lan_netmask`
    opmode=`nvram_get 2860 OperationMode`
    if [ "$opmode" = "0" ]; then
    	gw=`nvram_get 2860 wan_gateway`
    	pd=`nvram_get 2860 wan_primary_dns`
    	sd=`nvram_get 2860 wan_secondary_dns`
    fi

    # dhcp server
    dhcp=`nvram_get 2860 dhcpEnabled`
    if [ "$dhcp" = "1" ]; then

    	# No DMZ entry existed, No need to flush udhcpd
    	is_dmz_entry=`grep static_router /etc/udhcpd.conf`
    #	if [ "${#is_dmz_entry}" = "0" -a "$1" = "flush" ]; then
    #		exit
    #	fi

    	start=`nvram_get 2860 dhcpStart`
    	end=`nvram_get 2860 dhcpEnd`
    	mask=`nvram_get 2860 dhcpMask`
    	pd=`nvram_get 2860 dhcpPriDns`
    	sd=`nvram_get 2860 dhcpSecDns`
    	gw=`nvram_get 2860 dhcpGateway`
    	lease=`nvram_get 2860 dhcpLease`
    	static1=`nvram_get 2860 dhcpStatic1 | sed -e 's/;/ /'`
    	static2=`nvram_get 2860 dhcpStatic2 | sed -e 's/;/ /'`
    	static3=`nvram_get 2860 dhcpStatic3 | sed -e 's/;/ /'`
	static4=`nvram_get 2860 dhcpStatic4 | sed -e 's/;/ /'`
	static5=`nvram_get 2860 dhcpStatic5 | sed -e 's/;/ /'`
	static6=`nvram_get 2860 dhcpStatic6 | sed -e 's/;/ /'`
	static7=`nvram_get 2860 dhcpStatic7 | sed -e 's/;/ /'`
	static8=`nvram_get 2860 dhcpStatic8 | sed -e 's/;/ /'`

    	config-udhcpd.sh -s $start
    	config-udhcpd.sh -e $end
    	config-udhcpd.sh -i $lan_if
    	config-udhcpd.sh -m $mask
    	if [ "$pd" != "" -o "$sd" != "" ]; then
    		config-udhcpd.sh -d $pd $sd
    	fi
    	if [ "$gw" != "" ]; then
    		config-udhcpd.sh -g $gw
    	fi
    	if [ "$lease" != "" ]; then
    		config-udhcpd.sh -t $lease
    	fi
    	config-udhcpd.sh -S
    	if [ "$static1" != "" ]; then
    		config-udhcpd.sh -S $static1
    	fi
    	if [ "$static2" != "" ]; then
    		config-udhcpd.sh -S $static2
    	fi
    	if [ "$static3" != "" ]; then
    		config-udhcpd.sh -S $static3
    	fi
    	if [ "$static4" != "" ]; then
		config-udhcpd.sh -S $static4
	fi
	if [ "$static5" != "" ]; then
		config-udhcpd.sh -S $static5
	fi
	if [ "$static6" != "" ]; then
		config-udhcpd.sh -S $static6
	fi
	if [ "$static7" != "" ]; then
		config-udhcpd.sh -S $static7
	fi
	if [ "$static8" != "" ]; then
		config-udhcpd.sh -S $static8
	fi	


    	if [ "$1" != "flush" ]; then
    		# Deal with "super dmz".
    		# udhcpd has to lease the WAN ip/netmask/router settings to the 
    		# "super dmz" host on LAN.
    		dmzWanIf=`nvram_get 2860 DMZWanIf`
    		if [ "$dmz" = "2" -a "$dmzaddress" != "" -a "$opmode" != "0" ]; then
    			# super dmz enabled.
    			# Get WAN IP/Netmask/Gateway
    			wip=`ifconfig $dmzWanIf | sed -n '/inet addr:/p' | sed 's/ *inet addr:\([0-9\.]*\)\ \ .*/\1/'`
    			wnm=`ifconfig $dmzWanIf | sed -n '/inet addr:/p' | sed 's/.*Mask:\([0-9\.]*\)$/\1/'`
    			wgw=`route -n | grep "^0.0.0.0" | sed  's/[0-9.]*//' | sed 's/^[ ]*//' | sed 's/\([0-9.]*\)[ ]*[a-zA-Z0-9 .]*/\1/'`

    			if [ "$wip" = "" -o "$wnm" = "" -o "$wgw" = "" ]; then
    				echo "SuperDMZ: Can't get $wan_ppp_if ip/netmask/gateway currently."
    				echo "wip : $wip"
        			echo "wnm : $wnm"
        			echo "wgw : $wgw"
    			else
    				config-udhcpd.sh -S $dmzaddress $wip
    				config-udhcpd.sh -x $wnm
    				config-udhcpd.sh -y $wgw
    			fi
    		fi
    		config-udhcpd.sh -r 1
    	fi
    fi
}

if [ "$dmz" = "2" -a "$dmzaddress" != "" -a "$opmode" != "0" ]; then
        restart_udhcpd $*
fi

