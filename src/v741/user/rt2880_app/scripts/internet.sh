#!/bin/sh
#
# $Id: internet.sh,v 1.139.2.8 2012-03-07 07:04:49 steven Exp $
#
# usage: internet.sh
#

. /sbin/global.sh

set_vlan_map()
{
	# vlan priority tag => skb->priority mapping
	vconfig set_ingress_map $1 0 0
	vconfig set_ingress_map $1 1 1
	vconfig set_ingress_map $1 2 2
	vconfig set_ingress_map $1 3 3
	vconfig set_ingress_map $1 4 4
	vconfig set_ingress_map $1 5 5
	vconfig set_ingress_map $1 6 6
	vconfig set_ingress_map $1 7 7

	# skb->priority => vlan priority tag mapping
	vconfig set_egress_map $1 0 0
	vconfig set_egress_map $1 1 1
	vconfig set_egress_map $1 2 2
	vconfig set_egress_map $1 3 3
	vconfig set_egress_map $1 4 4
	vconfig set_egress_map $1 5 5
	vconfig set_egress_map $1 6 6
	vconfig set_egress_map $1 7 7
}


addBr0()
{
	brctl addbr br0

# configure stp forward delay
if [ "$wan_if" = "br0" -o "$lan_if" = "br0" ]; then
	stp=`nvram_get 2860 stpEnabled`
	if [ "$stp" = "1" ]; then
		brctl setfd br0 15
		brctl stp br0 1
	else
		brctl setfd br0 1
		brctl stp br0 0
	fi
	enableIPv6dad br0 2
fi

}

#
#	ipv6 config#
#	$1:	interface name
#	$2:	dad_transmit number
#
enableIPv6dad()
{
	if [ "$CONFIG_IPV6" == "y" -o "$CONFIG_IPV6" == "m" ]; then
		echo "2" > /proc/sys/net/ipv6/conf/$1/accept_dad
		echo $2 > /proc/sys/net/ipv6/conf/$1/dad_transmits
	fi
}

disableIPv6dad()
{
	if [ "$CONFIG_IPV6" == "y" -o "$CONFIG_IPV6" == "m" ]; then
		echo "0" > /proc/sys/net/ipv6/conf/$1/accept_dad
	fi
}

#

genSysFiles()
{
	login=`nvram_get 2860 Login`
	pass=`nvram_get 2860 Password`
	if [ "$login" != "" -a "$pass" != "" ]; then
	echo "$login::0:0:Adminstrator:/:/bin/sh" > /etc/passwd
	echo "$login:x:0:$login" > /etc/group
		chpasswd.sh $login $pass
	fi
	if [ "$CONFIG_PPPOL2TP" == "y" ]; then
	echo "l2tp 1701/tcp l2f" > /etc/services
	echo "l2tp 1701/udp l2f" >> /etc/services
	fi
}


configSecuVpn()
{
    secuwiz_id=`nvram_get 2860 secuwiz_id`
    secuwiz_pw=`nvram_get 2860 secuwiz_pw`
    secuwiz_ip=`nvram_get 2860 secuwiz_ip`
    secuwiz_port=`nvram_get 2860 secuwiz_port`
    secuwiz_crypto=`nvram_get 2860 secuwiz_crypto`
    secuwiz_log=`nvram_get 2860 secuwiz_log`
    secuwiz_ver3=`nvram_get 2860 secuwiz_ver3`
    secuwiz_sts=`nvram_get 2860 secuwiz_sts`

    echo userid: $secuwiz_id >/system/SecuwaySSL/conf/client.info
    echo userpw: $secuwiz_pw >>/system/SecuwaySSL/conf/client.info
    echo vpn_ip: $secuwiz_ip >>/system/SecuwaySSL/conf/client.info
    echo vpn_port: $secuwiz_port >>/system/SecuwaySSL/conf/client.info
    echo crypto: $secuwiz_crypto >>/system/SecuwaySSL/conf/client.info
    echo log_size: $secuwiz_log >>/system/SecuwaySSL/conf/client.info
    echo version3: $secuwiz_ver3 >>/system/SecuwaySSL/conf/client.info
    echo site-to-site: $secuwiz_sts >>/system/SecuwaySSL/conf/client.info

    cp -f /system/SecuwaySSL/conf/client.info /home/SecuwaySSL/conf/client.info
}

runSecuVpn()
{
    secuwiz_enable=`nvram_get 2860 secuwiz_enable`
    killall secuway_client  1>/dev/null 2>&1
    if [ "$secuwiz_enable" = "Enable" ]; then        
        logger "SecuwizVpn Config"
        configSecuVpn
        rmmod tun.ko
        insmod tun.ko
        mkdir -p /dev/net
        mknod /dev/net/tun c 10 200
        chmod 600 /dev/net/tun    
        /home/SecuwaySSL/secuway_client &
        echo "run secuvpn" > /var/secuvpn_run
        logger "SecuwizVpn Run"
    fi
}

##############################################################
#
#           MAIN
#
##############################################################
killall -q module 1>/dev/null 2>&1
rm -rf /var/secuvpn_run

killall -q pppd
killall -q l2tpd
killall -q openl2tpd

genSysFiles

# disable ipv6 DAD on all interfaces by default
if [ "$CONFIG_IPV6" == "y" -o "$CONFIG_IPV6" == "m" ]; then
	echo "0" > /proc/sys/net/ipv6/conf/default/accept_dad
fi

ifconfig eth2 0.0.0.0

# avoid eth2 doing ipv6 DAD
disableIPv6dad eth2

vpn-passthru.sh

vconfig rem eth2.1
vconfig rem eth2.2

vconfig add eth2 1
set_vlan_map eth2.1
vconfig add eth2 2
set_vlan_map eth2.2

ifconfig eth2.2 down
wan_mac=`nvram_get 2860 WAN_MAC_ADDR`
if [ "$wan_mac" != "FF:FF:FF:FF:FF:FF" ]; then
	ifconfig eth2.2 hw ether $wan_mac
fi
enableIPv6dad eth2.2 1

ifconfig eth2.1 0.0.0.0
ifconfig eth2.2 0.0.0.0
ifconfig lo 127.0.0.1
ifconfig br0 down 1>/dev/null 2>&1
brctl delbr br0 1>/dev/null 2>&1

# stop all
iptables --flush
iptables --flush -t nat
iptables --flush -t mangle

addBr0

#WWAN : 0
#WAN:1
#AUTO:2
wan_mode=`nvram_get 2860 wanMode`
apcli_enable=`nvram_get 2860 ApCliEnable`
if [ "$wan_mode" = "" -o "$wan_mode" = "0" -o "$apcli_enable" = "1" ]; then
    config-vlan.sh 2 LLLLW
    #if [ "$CONFIG_IPV6" == "y" -o "$CONFIG_IPV6" == "m" ]; then
    #    sleep 2
    #fi
    brctl addif br0 eth2.1
    brctl addif br0 eth2.2

# move to below
#    if [ "$apcli_enable" = "1" ]; then
#        ifconfig apcli0 up
#        addRax2Br0
#    fi    

else
    config-vlan.sh 2 WLLLL
    #if [ "$CONFIG_IPV6" == "y" -o "$CONFIG_IPV6" == "m" ]; then
    #    sleep 2
    #fi
    brctl addif br0 eth2.1
fi   

runSecuVpn

lan.sh
wan.sh
nat.sh

# in order to use broadcast IP address in L2 management daemon
route add -host 255.255.255.255 dev $lan_if

wifi.sh&

HWNAT=`nvram_get 2860 hwnatEnabled`
if [ "$HWNAT" = "1" ]; then
	insmod -q hw_nat
fi

# wan, lan set speed
set_lan_speed.sh

