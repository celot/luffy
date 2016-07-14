#!/bin/sh

. /sbin/config.sh

# udhcpc script edited by Tim Riker <Tim@Rikers.org>
#$1: file, $2:address
exist_address()
{
    while read type address
    do
        if [ "$address" = "$2" ]; then
            return 1
        fi
    done < $1
    return  0
}

aquire_lock()
{
    while [ -f "/var/run/resolv.lock" ]
    do
        sleep 1
    done
    echo "lock : uchcpc_lte" > /var/run/resolv.lock
}

release_lock()
{
    [ -f "/var/run/resolv.lock" ] && rm -rf /var/run/resolv.lock
}


[ -z "$1" ] && echo "Error: should be called from udhcpc" && exit 1

RESOLV_CONF="/etc/resolv.conf"
[ -n "$broadcast" ] && BROADCAST="broadcast $broadcast"
[ -n "$subnet" ] && NETMASK="netmask $subnet"

wwan=`cat /var/modman_wwan`
if [ "$wwan" = "2" ]; then
	netmaskntt=`nvram_get 2860 nttSubnetMask_d2`
else
	netmaskntt=`nvram_get 2860 nttSubnetMask`
fi
if [ "$netmaskntt" != "" ]; then
NETMASKNTT="netmask $netmaskntt"
fi

case "$1" in
	deconfig)
    		#/sbin/ifconfig $interface 0.0.0.0
		;;

	renew|bound)
		usb_ip=`ifconfig $interface | sed -n '/inet addr:/p' | sed -e 's/ *inet addr:\(.*\)  Bcast.*/\1/'`
		if [ "$usb_ip" = "$ip" ]; then 
			logger "same ip($ip)"
			exit 0; 
		fi
		
		echo 0 > /proc/sys/net/ipv4/ip_forward
		ifconfig $interface down
		iptables -t nat -F
		iptables -t nat --delete-chain
              
		if [ "$NETMASKNTT" != "" ]; then 
			/sbin/ifconfig $interface $ip $NETMASKNTT
		else
			#/sbin/ifconfig $interface $ip $BROADCAST $NETMASK
			/sbin/ifconfig $interface $ip netmask 255.255.0.0
		fi
		
		iptables -t nat -A POSTROUTING -o $interface -j MASQUERADE --random
		nat.sh
		ifconfig $interface up

		if [ -n "$router" ] ; then
			echo "deleting routers"
			while route del default gw 0.0.0.0 dev $interface ; do
				:
			done

                    #metric=0
                    #for i in $router ; do
                    #    metric=`expr $metric + 1`
                    #    route add default gw $i dev $interface metric $metric
                    #done

                    route add default dev $interface metric 1
		fi

		echo -n > $RESOLV_CONF.lte
		[ -n "$domain" ] && echo search $domain >> $RESOLV_CONF.lte
		for i in $dns ; do
			echo nameserver $i >> $RESOLV_CONF.lte
		done

              aquire_lock              
              [ ! -f $RESOLV_CONF ] && echo -n > $RESOLV_CONF
		if [ -f $RESOLV_CONF.wan ]; then
		     while read name addr
                   do
                       exist_address $RESOLV_CONF $addr
                       if [ $? -eq 0 ]; then
                            echo adding $name $addr
                            echo $name $addr >> $RESOLV_CONF
                       fi
                   done < $RESOLV_CONF.wan
              fi

              if [ -f $RESOLV_CONF.lte ]; then
		     while read name addr
                   do
                       exist_address $RESOLV_CONF $addr
                       if [ $? -eq 0 ]; then
                            echo adding $name $addr
                            echo $name $addr >> $RESOLV_CONF
                       fi
                   done < $RESOLV_CONF.lte
              fi
              release_lock

		module route refresh
		
		# notify goahead when the WAN IP has been acquired. --yy
		#tyranno
		#if goahead not  did not complete initInternet(),  wait.
		while [ -f "/var/run/goahead.lock" ]
		do
			sleep 1
		done
		
		killall -SIGTSTP goahead

		lan_restart.sh &

		# restart igmpproxy daemon
		#config-igmpproxy.sh
		;;
esac

exit 0


check_vpn()
{
    if [ ! -d "/dev/net" ]; then
        mkdir -p /dev/net
    fi
    if [ ! -f "/dev/net/tun" ]; then
        mknod /dev/net/tun c 10 200
        chmod 600 /dev/net/tun
    fi
}

#secuwiz_enable=`nvram_get 2860 secuwiz_enable`
#if [ "$secuwiz_enable" = "Enable" ]; then
#    check_vpn
#    killall -9 secuway_client
#    /home/SecuwaySSL/secuway_client &

#    iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE --random
#    iptables -A FORWARD -i tun0 -j ACCEPT
#    iptables -A INPUT -i tun0 -j ACCEPT
#fi
