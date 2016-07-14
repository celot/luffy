#!/bin/sh

# udhcpc script edited by Tim Riker <Tim@Rikers.org>

. /sbin/global.sh

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
    echo "lock : uchcpc" > /var/run/resolv.lock
}

release_lock()
{
    [ -f "/var/run/resolv.lock" ] && rm -rf /var/run/resolv.lock
}

aquire_route_lock()
{
    while [ -f "/var/run/resolv.lock" ]
    do
        sleep 1
    done
    echo "lock: udhcpc" > /var/run/route.lock
}

release_route_lock()
{
    [ -f "/var/run/route.lock" ] && rm -rf /var/run/route.lock
}


[ -z "$1" ] && echo "Error: should be called from udhcpc" && exit 1

RESOLV_CONF="/etc/resolv.conf"
WAN_GW="/var/wan_gw"

[ -n "$broadcast" ] && BROADCAST="broadcast $broadcast"
[ -n "$subnet" ] && NETMASK="netmask $subnet"

case "$1" in
    deconfig)
        /sbin/ifconfig $interface 0.0.0.0
        route del default dev $interface
        ;;

    renew|bound)
        /sbin/ifconfig $interface $ip $BROADCAST $NETMASK

        if [ -n "$router" ] ; then
            echo "deleting routers"
            while route del default gw 0.0.0.0 dev $interface ; do
                :
            done

            aquire_route_lock
            metric=2
            for i in $router ; do
                metric=`expr $metric + 1`
                route add default gw $i dev $interface metric $metric
                echo "$i">$WAN_GW
            done
            release_route_lock
        fi

        echo -n > $RESOLV_CONF.wan
        [ -n "$domain" ] && echo search $domain >> $RESOLV_CONF.wan
        for i in $dns ; do
            echo adding dns $i
            echo nameserver $i >> $RESOLV_CONF.wan
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

        # restart igmpproxy daemon
        config-igmpproxy.sh
        
        if [ "$wanmode" = "L2TP" ]; then
        if [ "$CONFIG_PPPOL2TP" == "y" ]; then
        	openl2tpd
        else
        	l2tpd
        	sleep 1
        	l2tp-control "start-session $l2tp_srv"
        fi
        elif [ "$wanmode" = "PPTP" ]; then
            pppd file /etc/options.pptp  &
        fi
        ;;
esac

exit 0

