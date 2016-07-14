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

inIf=`nvram_get 2860 hotspotInInterface`


if [ -z "$inIf" ]; then
	inIf="ra0"
fi	

# here i want to add EXTIF= "eth2" and adjust the rules .
INTIF="$inIf"
	
$IPTABLES -D INPUT -i $INTIF -j DROP
$IPTABLES -D FORWARD -i $INTIF -j DROP
$IPTABLES -D FORWARD -o $INTIF -j DROP
