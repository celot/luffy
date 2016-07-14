#!/bin/sh

usage () {
    echo "usage: config-3g-ppp.sh [option]..."
    echo "options:"
    echo "  -h                : print this help"
    echo "  -b baud           : Set baudrate"
    echo "  -m dev 	        : set modem device"
    echo "  -l local_ip 	    : set local ip"
    echo "  -r remote_ip 	    : set remote ip"
    echo "  -d dns_ip 	    : set dns ip"
    echo "  -s dns_second_ip  : set dns ip"
    exit
}

read_dns() 
{
    file=/etc/resolv.conf
    i=0
    while IFS=' ' read -r f1 f2
    do
    	if [ "$i" = "0" ]; then 
    	    DNS_PRIMARY=$f2; 
    	elif [ "$i" = "1" ]; then 
    	    DNS_SECOND=$f2; 
    	fi
    	i=`expr $i + 1`
    done < "$file"
}



for arg in $*
do
    if [ "$1" != "" ] 
    then
        case "$1" in
            "-b")
            BAUD="$2"
            shift ;;
      
            "-m")
                TTY_NAME=$2
                SERIAL_DEVICE="/dev/$TTY_NAME" 
                shift ;;

            "-m")
                TTY_NAME=$2
                SERIAL_DEVICE="/dev/$TTY_NAME" 
                shift ;;

            "-l")
                LOCAL_IP=$2
                shift ;;
             
            "-r")
                REMOTE_IP=$2
                shift ;;

            "-d")
                DNS_PRIMARY=$2
                shift ;;

            "-s")
                DNS_SECOND=$2
                shift ;;

            "-h")
                usage ;;
                
            *) 
                echo "illegal option -- $2" 
                usage ;;
        esac
        
        shift
    fi
done


if [ "$TTY_NAME" = "ttyS0" ]; then
    OPTIONS_FILE=/etc_ro/ppp/peers/ttyS0
    UNIT_NO=90
elif [ "$TTY_NAME" = "ttyS1" ]; then
    OPTIONS_FILE=/etc_ro/ppp/peers/ttyS1
    UNIT_NO=91
else
    echo "Device configuration error, Support device S0, S1"
    exit 0
fi

if [ "$BAUD" = "" ]; then
    BAUD=115200
fi

if [ "$LOCAL_IP" = "" ]; then
    LOCAL_IP=10.10.11.1
fi

if [ "$REMOTE_IP" = "" ]; then
    if [ "$TTY_NAME" = "ttyS0" ]; then
        REMOTE_IP=10.10.11.2
    else
        REMOTE_IP=10.10.11.3
    fi
fi

if [ "$DNS_PRIMARY" = "" ]; then
    read_dns
fi


echo "/dev/$TTY_NAME" > $OPTIONS_FILE
echo $BAUD >> $OPTIONS_FILE
echo "modem" >> $OPTIONS_FILE
echo "noauth" >> $OPTIONS_FILE
echo "nodefaultroute" >> $OPTIONS_FILE #added in ip-up 
echo "nopcomp" >> $OPTIONS_FILE
echo "noaccomp" >> $OPTIONS_FILE
echo "novj" >> $OPTIONS_FILE
echo "nobsdcomp" >> $OPTIONS_FILE
echo "nodetach" >> $OPTIONS_FILE
echo "nodeflate" >> $OPTIONS_FILE 
#echo "debug" >> $OPTIONS_FILE
echo "local" >> $OPTIONS_FILE
echo "persist" >> $OPTIONS_FILE
echo "unit $UNIT_NO" >> $OPTIONS_FILE
echo "linkname $TTY_NAME" >> $OPTIONS_FILE
echo "$LOCAL_IP:$REMOTE_IP" >> $OPTIONS_FILE
if [ "$DNS_PRIMARY" != "" ]; then
    echo "ms-dns $DNS_PRIMARY" >> $OPTIONS_FILE
fi
if [  "$DNS_SECOND" != "" ]; then
    echo "ms-dns $DNS_SECOND" >> $OPTIONS_FILE
fi

echo "connect \"/usr/sbin/ct_chat\"" >> $OPTIONS_FILE 



