#!/bin/sh

#
# Firewall script for ChilliSpot
# A Wireless LAN Access Point Controller
#
# Uses $EXTIF (eth0) as the external interface (Internet or intranet) and
# $INTIF0 (eth1) as the internal interface (access points).
#
#
# SUMMARY
# * All connections originating from chilli are allowed.
# * Only ssh is allowed in on external interface.
# * Nothing is allowed in on internal interface.
# * Forwarding is allowed to and from the external interface, but disallowed
#   to and from the internal interface.
# * NAT is enabled on the external interface.

IPTABLES="iptables"

hEnable=`nvram_get 2860 hotspotEnable`
outIf=`nvram_get 2860 hotspotOutInterface`
inIf=`nvram_get 2860 hotspotInInterface`

wMode=`nvram_get 2860 wanMode`	


if [ -z "$outIf" ]; then
	outIf="eth2.2"
fi	

if [ -z "$inIf" ]; then
	inIf="ra0"
fi	

EXTIF="$outIf"


# here i want to add EXTIF= "eth2" and adjust the rules .
INTIF="$inIf"
	
	
if [ "$wMode" = "1" ] || [ "$wMode" = "2" ]; then
	EXT2IF="eth2.2"
fi


if [ "$hEnable" = "1" ]; then

	# this added to /etc/network/interfaces
	#ip route add default scope global nexthop via 172.30.0.1 dev eth1 weight 1 \
	#        nexthop via 172.30.1.1 dev eth2 weight 1
	#Flush all rules
	#$IPTABLES -F 
	#$IPTABLES -F -t nat
	$IPTABLES -F -t mangle

	#Set default behaviour
	#$IPTABLES -P INPUT DROP
	#$IPTABLES -P FORWARD ACCEPT
	#$IPTABLES -P OUTPUT ACCEPT

	#Allow related and established on all interfaces (input)
	$IPTABLES -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

	#Allow releated, established and ssh on $EXTIF. Reject everything else.
	#$IPTABLES -A INPUT -i $EXTIF -p tcp -m tcp --dport 22 --syn -j ACCEPT
	#$IPTABLES -A INPUT -i $EXTIF -j REJECT

	#Allow related and established from $INTIF. Drop everything else.
	$IPTABLES -A INPUT -i $INTIF -j DROP

	#Allow http and https on other interfaces (input).
	#This is only needed if authentication server is on same server as chilli
	$IPTABLES -A INPUT -p tcp -m tcp --dport 80 --syn -j ACCEPT
	$IPTABLES -A INPUT -p tcp -m tcp --dport 443 --syn -j ACCEPT

	#Allow 3990 on other interfaces (input).
	$IPTABLES -A INPUT -p tcp -m tcp --dport 3990 --syn -j ACCEPT

	#Allow ICMP echo on other interfaces (input).
	$IPTABLES -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

	#Allow everything on loopback interface.
	$IPTABLES -A INPUT -i lo -j ACCEPT

	# Drop everything to and from $INTIF (forward)
	# This means that access points can only be managed from ChilliSpot
	$IPTABLES -A FORWARD -i $INTIF -j DROP
	$IPTABLES -A FORWARD -o $INTIF -j DROP

	#Enable NAT on output device
	$IPTABLES -t nat -A POSTROUTING -o $EXTIF -j MASQUERADE

	if [ ! -z "$EXT2IF" ]; then
		$IPTABLES -t nat -A POSTROUTING -o $EXT2IF -j MASQUERADE
	fi	
	
else
	$IPTABLES -D INPUT -i $INTIF -j DROP
	$IPTABLES -D FORWARD -i $INTIF -j DROP
	$IPTABLES -D FORWARD -o $INTIF -j DROP
fi

