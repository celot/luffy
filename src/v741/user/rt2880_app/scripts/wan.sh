#!/bin/sh
#
# $Id: wan.sh,v 1.21 2010-03-10 13:48:06 chhung Exp $
#
# usage: wan.sh
#

. /sbin/global.sh

# stop all
#killall -q syslogd
killall -q udhcpc
killall -USR2 mod_man
killall -q pppd
killall -q l2tpd
killall -q openl2tpd

#WWAN : 0
#WAN:1
#AUTO:2
if [ -f /etc/resolv.conf ];then rm -rf /etc/resolv.conf; fi
wan_mode=`nvram_get 2860 wanMode`
WAN_GW="/var/wan_gw"

if [ "$wan_mode" = "" -o "$wan_mode" = "0" ]; then
	   killall -USR1 mod_man
	   module wwan connect

# Delete  : Moved to wifi.sh
#	apcli_enable=`nvram_get 2860 ApCliEnable`
#       #apclient mode
#       if [ "$apcli_enable" = "1" ]; then
#        	hn=`nvram_get 2860 wan_dhcp_hn`
#        	if [ "$hn" != "" ]; then
#        		udhcpc -i apcli0 -h $hn -s /sbin/udhcpc.sh -p /var/run/udhcpc.pid &
#       	else
#        		udhcpc -i apcli0 -s /sbin/udhcpc.sh -p /var/run/udhcpc.pid &
#        	fi
#       fi

else
    clone_en=`nvram_get 2860 macCloneEnabled`
    clone_mac=`nvram_get 2860 macCloneMac`
    #MAC Clone: bridge mode doesn't support MAC Clone
    if [ "$opmode" != "0" -a "$clone_en" = "1" ]; then
    	ifconfig $wan_if down
   	ifconfig $wan_if hw ether $clone_mac
    	ifconfig $wan_if up
    fi

    if [ "$wanmode" = "STATIC" ]; then
    	#always treat bridge mode having static wan connection
    	ip=`nvram_get 2860 wan_ipaddr`
    	nm=`nvram_get 2860 wan_netmask`
    	gw=`nvram_get 2860 wan_gateway`
    	pd=`nvram_get 2860 wan_primary_dns`
    	sd=`nvram_get 2860 wan_secondary_dns`

    	#lan and wan ip should not be the same except in bridge mode
	lan_ip=`nvram_get 2860 lan_ipaddr`
	if [ "$ip" = "$lan_ip" ]; then
		echo "wan.sh: warning: WAN's IP address is set identical to LAN"
		exit 0
	fi
    	ifconfig $wan_if $ip netmask $nm
    	route del default
    	if [ "$gw" != "" ]; then
    		route add default gw $gw
    	fi
    	echo "$gw" > $WAN_GW
    	config-dns.sh $pd $sd
    	module route refresh
    elif [ "$wanmode" = "DHCP" ]; then
    	hn=`nvram_get 2860 wan_dhcp_hn`
    	if [ "$hn" != "" ]; then
    		udhcpc -i $wan_if -h $hn -s /sbin/udhcpc.sh -p /var/run/udhcpc.pid &
    	else
    		udhcpc -i $wan_if -s /sbin/udhcpc.sh -p /var/run/udhcpc.pid &
    	fi
    elif [ "$wanmode" = "PPPOE" ]; then
    	u=`nvram_get 2860 wan_pppoe_user`
    	pw=`nvram_get 2860 wan_pppoe_pass`
    	#pppoe_opmode=`nvram_get 2860 wan_pppoe_opmode`
    	#if [ "$pppoe_opmode" = "" ]; then
    	#	echo "pppoecd eth2.2 -u $u -p $pw -R -k &"
    	#	#pppoecd $wan_if -u "$u" -p "$pw"
    	#	pppoecd eth2.2 -u "$u" -p "$pw" -R -k &
    	#else
    	#	pppoe_optime=`nvram_get 2860 wan_pppoe_optime`
    	#	config-pppoe.sh $u $pw $wan_if $pppoe_opmode $pppoe_optime
    	#fi
    	config-pppoe.sh $u $pw eth2.2 KeepAlive
    elif [ "$wanmode" = "L2TP" ]; then
	srv=`nvram_get 2860 wan_l2tp_server`
	u=`nvram_get 2860 wan_l2tp_user`
	pw=`nvram_get 2860 wan_l2tp_pass`
	mode=`nvram_get 2860 wan_l2tp_mode`
	l2tp_opmode=`nvram_get 2860 wan_l2tp_opmode`
	l2tp_optime=`nvram_get 2860 wan_l2tp_optime`
	if [ "$mode" = "0" ]; then
		ip=`nvram_get 2860 wan_l2tp_ip`
		nm=`nvram_get 2860 wan_l2tp_netmask`
		gw=`nvram_get 2860 wan_l2tp_gateway`
		if [ "$gw" = "" ]; then
			gw="0.0.0.0"
		fi
		config-l2tp.sh static $wan_if $ip $nm $gw $srv $u $pw $l2tp_opmode $l2tp_optime
	else
		config-l2tp.sh dhcp $wan_if $srv $u $pw $l2tp_opmode $l2tp_optime
	fi
    elif [ "$wanmode" = "PPTP" ]; then
	srv=`nvram_get 2860 wan_pptp_server`
	u=`nvram_get 2860 wan_pptp_user`
	pw=`nvram_get 2860 wan_pptp_pass`
	mode=`nvram_get 2860 wan_pptp_mode`
	pptp_opmode=`nvram_get 2860 wan_pptp_opmode`
	pptp_optime=`nvram_get 2860 wan_pptp_optime`
	if [ "$mode" = "0" ]; then
		ip=`nvram_get 2860 wan_pptp_ip`
		nm=`nvram_get 2860 wan_pptp_netmask`
		gw=`nvram_get 2860 wan_pptp_gateway`
		if [ "$gw" = "" ]; then
			gw="0.0.0.0"
		fi
		config-pptp.sh static $wan_if $ip $nm $gw $srv $u $pw $pptp_opmode $pptp_optime
	else
		config-pptp.sh dhcp $wan_if $srv $u $pw $pptp_opmode $pptp_optime
	fi
   fi
   
   if [ "$wan_mode" = "2" ]; then
	    killall -USR1 mod_man
	    module wwan connect 
    fi
fi

