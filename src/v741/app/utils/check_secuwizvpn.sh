#!/bin/sh

checkSecuDir()
{
    if [ ! -d /home/SecuwaySSL ]; then
        cp -a /system/SecuwaySSL /home
    else
        if [ ! -d /home/SecuwaySSL/conf ]; then
            cp -a  /system/SecuwaySSL/conf /home/SecuwaySSL/
        fi
        if [ ! -d /home/SecuwaySSL/sbin ]; then
            cp -a  /system/SecuwaySSL/sbin /home/SecuwaySSL/
        fi
        if [ ! -f /home/SecuwaySSL/secuway_client ]; then
            cp -a  /system/SecuwaySSL/secuway_client /home/SecuwaySSL/
        fi
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
        checkSecuDir
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

runSecuVpn


