#!/bin/sh
#
# $Id: config-igmpproxy.sh,v 1.8 2010-10-27 08:32:53 yy Exp $
#
# usage: config-igmpproxy.sh <wan_if_name> <lan_if_name>
#

. /sbin/global.sh

killall -q igmpproxy
igmp=`nvram_get 2860 igmpEnabled`
if [ "$igmp" = "1" ]; then
    #igmpproxy.sh $wan_ppp_if $lan_if
    igmpproxy.sh $wan_if $lan_if ppp0
    killall -q igmpproxy
    igmpproxy
fi    

