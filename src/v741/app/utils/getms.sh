#!/bin/sh

dev=`ls /sys/bus/usb/devices/*3/ | grep ttyUSB`
if [ "$dev" = "" ]; then  echo "devfile not found!";   exit; fi

devfile=/dev/$dev
#echo "devfile:$devfile"

usage () 
{
    echo "usage: getms.sh [option]..."
    echo "options:"
    echo "  -h              : print this help"
    echo "  -imei           : get imei"
    echo "  -imsi           : get ims"
    echo "  -rssi           : get rssi"
    exit
}

read_imei()
{
    echo "at+gsn" > $devfile
    while read line
    do
        trim_line=`echo $line`
        case "$trim_line" in
           *"OK"* ) 
            return 
           ;;
           
           *"ERROR"* ) 
            return
           ;;

           "")
           ;;

           *)
               echo $trim_line
           ;;
        esac
    done < $devfile
}

read_imsi()
{
     echo "at+cimi" > $devfile
    while read line
    do
        trim_line=`echo $line`
        case "$trim_line" in
           *"OK"* ) 
            return 
           ;;
           
           *"ERROR"* ) 
            return
           ;;

           "")
           ;;

           *)
               echo $trim_line
           ;;
        esac
    done < $devfile
}

read_rssi()
{
     echo "at+csq" > $devfile
    while read line
    do
        trim_line=`echo $line`
        case "$trim_line" in
           *"OK"* ) 
            return 
           ;;
           
           *"ERROR"* ) 
            return
           ;;

           "")
           ;;

           *)
               echo $trim_line
           ;;
        esac
    done < $devfile
}

for arg in $*
do
    if [ "$1" != "" ]; then 
        case "$1" in
            "-imei")
                read_imei
                shift ;;
            
            "-imsi")
                read_imsi
                shift ;;
            
            "-rssi")
                read_rssi
                shift ;;
            
            "-h")
                usage ;;
            *) 
            ;;
        esac
        shift
    fi
done



