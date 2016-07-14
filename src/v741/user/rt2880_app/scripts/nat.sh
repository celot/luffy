#!/bin/sh
#
# $Id: nat.sh,v 1.5 2011-02-16 10:26:21 chhung Exp $
#
# usage: nat.sh
#

. /sbin/global.sh


lan_ip=`nvram_get 2860 lan_ipaddr`
nat_en=`nvram_get 2860 natEnabled`
tcp_timeout=`nvram_get 2860 TcpTimeout`
udp_timeout=`nvram_get 2860 UdpTimeout`
wanMode=`nvram_get 2860 wanMode`

if [ "$udp_timeout" = "" ]; then
	nvram_set 2860 UdpTimeout 900
fi
if [ "$tcp_timeout" = "" ]; then
	nvram_set 2860 TcpTimeout 900
fi

echo 1 > /proc/sys/net/ipv4/ip_forward

if [ "$nat_en" = "1" ]; then
	if [ "$CONFIG_NF_CONNTRACK_SUPPORT" = "1" ]; then
		if [ "$udp_timeout" = "" ]; then
			echo 900 > /proc/sys/net/netfilter/nf_conntrack_udp_timeout
		else	
			echo "$udp_timeout" > /proc/sys/net/netfilter/nf_conntrack_udp_timeout
		fi

		if [ "$tcp_timeout" = "" ]; then
			echo 900 >  /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_established
		else
			echo "$tcp_timeout" >  /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_established
		fi
	else
		if [ "$udp_timeout" = "" ]; then
			echo 900 > /proc/sys/net/ipv4/netfilter/ip_conntrack_udp_timeout
		else	
			echo "$udp_timeout" > /proc/sys/net/ipv4/netfilter/ip_conntrack_udp_timeout
		fi

		if [ "$tcp_timeout" = "" ]; then
			echo 900 > /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_established
		else
			echo "$tcp_timeout" > /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_established
		fi
	fi

	if [ "$wanMode" = "0" ]; then
		if [ "$apclienable" = "1" ]; then
			iptables -t nat -D POSTROUTING -s $lan_ip/24 -o $wan_if -j MASQUERADE  --random
			iptables -t nat -A POSTROUTING -s $lan_ip/24 -o $wan_if -j MASQUERADE  --random
		fi
	else
		if [ "$wanMode" = "1" -o "$wanMode" = "2" ]; then
			iptables -t nat -D POSTROUTING -s $lan_ip/24 -o $wan_if -j MASQUERADE  --random
			iptables -t nat -A POSTROUTING -s $lan_ip/24 -o $wan_if -j MASQUERADE  --random
		fi
	fi
fi

