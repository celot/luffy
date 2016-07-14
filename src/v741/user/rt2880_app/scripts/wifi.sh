#!/bin/sh
#
# $Id: internet.sh,v 1.139.2.8 2012-03-07 07:04:49 steven Exp $
#
# usage: internet.sh
#

. /sbin/global.sh


ra_Bssidnum=`nvram_get 2860 BssidNum`
radio_off1=`nvram_get 2860 RadioOff`
wifi_off=`nvram_get 2860 WiFiOff`
m2uenabled=`nvram_get 2860 M2UEnabled`


###wifiIf=`nvram_get 2860 hotspotTunInterface`
###nvram_set 2860 hotspotTunInterface tun0

hpEnable=`nvram_get 2860 hotspotEnable`
wifiIf="br0"

if [ -f "/usr/sbin/chilli.sh" ]; then
	
	if [ "$hpEnable" = "1" ]; then
		wifiIf="tun0"
	fi
fi	

if [ -f /var/run/udhcpc_wifi.pid ]; then 
	kill `cat /var/run/udhcpc_wifi.pid`
fi


ifRaxWdsxDown()
{
	num=16
	while [ "$num" -gt 0 ]
	do
		num=`expr $num - 1`
		ifconfig ra$num down 1>/dev/null 2>&1
	done

	ifconfig wds0 down 1>/dev/null 2>&1
	ifconfig wds1 down 1>/dev/null 2>&1
	ifconfig wds2 down 1>/dev/null 2>&1
	ifconfig wds3 down 1>/dev/null 2>&1

	ifconfig apcli0 down 1>/dev/null 2>&1

	ifconfig mesh0 down 1>/dev/null 2>&1
	echo -e "\n##### disable 1st wireless interface #####"
}


addRax2Br0()
{
	num=1 
	brctl addif $wifiIf ra0
        while [ $num -lt $ra_Bssidnum ] 
        do 
                ifconfig ra$num 0.0.0.0 1>/dev/null 2>&1
                brctl addif $wifiIf ra$num 
                num=`expr $num + 1` 
        done 
}

addWds2Br0()
{
	wds_en=`nvram_get 2860 WdsEnable`
	if [ "$wds_en" != "0" ]; then
		ifconfig wds0 up 1>/dev/null 2>&1
		ifconfig wds1 up 1>/dev/null 2>&1
		ifconfig wds2 up 1>/dev/null 2>&1
		ifconfig wds3 up 1>/dev/null 2>&1
		brctl addif $wifiIf wds0
		brctl addif $wifiIf wds1
		brctl addif $wifiIf wds2
		brctl addif $wifiIf wds3
	fi
}

##############################################################
#
#           MAIN
#
##############################################################

wan_mode=`nvram_get 2860 wanMode`
apcli_enable=`nvram_get 2860 ApCliEnable`

ifRaxWdsxDown

if [ "$1" = "force_down" ]; then
    iwpriv ra0 set RadioOn=0

    rmmod rt2860v2_ap.ko 1>/dev/null 2>&1  
    reg s b0180000
    reg w 400 0x1080
    reg w 1204 8
    reg w 1004 3
    exit 0
else
    ralink_init make_wireless_config rt2860

    if [ "$m2uenabled" = "1" ]; then
        iwpriv ra0 set IgmpSnEnable=1
        echo "iwpriv ra0 set IgmpSnEnable=1"
    fi

    if [ "$radio_off1" = "1" ]; then
    	iwpriv ra0 set RadioOn=0
    fi

    if [ "$wifi_off" = "1" ]; then
        rmmod rt2860v2_ap.ko 1>/dev/null 2>&1  
        reg s b0180000
        reg w 400 0x1080
        reg w 1204 8
        reg w 1004 3
    else
        #echo "==========================WIFI Config==========================Start"
        # config interface
        wifi_loaded=`lsmod | grep rt2860v2_ap | wc -l`
        if [ $wifi_loaded -eq 0 ]; then
            insmod rt2860v2_ap.ko
        fi    
        ifconfig ra0 0.0.0.0 1>/dev/null 2>&1
       addRax2Br0
       addWds2Br0
        #echo "==========================WIFI Config==========================Done"
    fi


    if [ "$wan_mode" = "" -o "$wan_mode" = "0" ]; then
    	if [ "$apcli_enable" = "1" ]; then
    		ifconfig apcli0 up
    	 	addRax2Br0

    		hn=`nvram_get 2860 wan_dhcp_hn`
    	 	if [ "$hn" != "" ]; then
    			udhcpc -i apcli0 -h $hn -s /sbin/udhcpc.sh -p /var/run/udhcpc_wifi.pid &
    	 	else
    			udhcpc -i apcli0 -s /sbin/udhcpc.sh -p /var/run/udhcpc_wifi.pid &
    	 	fi
    	fi    
    fi

    apcli_nat.sh&

    if [ -f "/usr/sbin/wifi_state_checker.sh" ]; then
        /usr/sbin/wifi_state_checker.sh &
    fi

    if [ -f "/usr/sbin/chilli.sh" ]; then
		
	 #sleep 2	

	 /usr/sbin/chilli.sh start &
    fi

  	
fi
