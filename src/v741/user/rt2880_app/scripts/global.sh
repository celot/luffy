#!/bin/sh

. /sbin/config.sh

# WAN interface name -> $wan_if
getWanIfName()
{
    wan_mode=`nvram_get 2860 wanConnectionMode`
    apclienable=`nvram_get 2860 ApCliEnable`
    if [ "$apclienable" = "1" ]; then
        wan_if="apcli0"
    elif [ "$wan_mode" = "PPPOE" ]; then
        wan_if="ppp0"
    else
       wan_if="eth2.2"
    fi
}

# LAN interface name -> $lan_if
getLanIfName()
{
    lan_if="br0"
}

# ethernet converter enabled -> $ethconv "y"
getEthConv()
{
	ec=`nvram_get 2860 ethConvert`
	if [ "$opmode" = "0" -a "$CONFIG_RT2860V2_STA_DPB" = "y" -a "$ec" = "1" ]; then
		ethconv="y"
	else
		ethconv="n"
	fi
}

# station driver loaded -> $stamode "y"
getStaMode()
{
	if [ "$opmode" = "2" -o "$ethconv" = "y" ]; then
		stamode="y"
	else
		stamode="n"
	fi
}

opmode=`nvram_get 2860 OperationMode`
wanmode=`nvram_get 2860 wanConnectionMode`
ethconv="n"
stamode="n"
wan_if="br0"
wan_ppp_if="br0"
lan_if="br0"
getWanIfName
getLanIfName
getEthConv
getStaMode

