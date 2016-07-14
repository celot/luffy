#!/bin/sh

GPSUse=`nvram_get 2860 GpsFuncEnable`
GPSLanPort=`nvram_get 2860 GpsLTSvListenPort`
GPSWanPort=`nvram_get 2860 GpsWTSvListenPort`

echo "GPSUse=$GPSUse"

COMMAND="$1"

isOneshotCmd="false"

if [ "$GPSUse" != "1" ]; then
	killall -SIGTSTP gps_func
	echo "gps stop.... exit 0"
	exit 0
fi

first_start()
{
    echo 1 > /var/gps_temp
}

restart()
{
    if [ -f /var/gps_temp ]; then
        echo "gps restart.. first start setting. exit..."
        rm -rf /var/gps_temp
        exit 0
    fi
    
    #killall -SIGTSTP gps_func
    number=0
    
    echo "gps restart() sleep $number start"
    while [ ${number} -lt 60 ];  do
        sleep 1
        number=`expr $number + 1`
        echo "$number"
    done
    echo "gps restart() sleep $number end"

    exit 0
}

oneshot()
{
    isOneshotCmd="true"
}

#checkGpsCount=
wait_moment()
{
    checkGpsCount=`ps -ef | grep gps_func |grep -v 'grep' | wc -l`

    while [ ${checkGpsCount} -gt 0 ];  do
        sleep 1       
        echo "wait...checkGpsCount:$checkGpsCount"
        checkGpsCount=`ps -ef | grep gps_func |grep -v 'grep' | wc -l`
    done
}

delete_reject_input_chain()
{
    echo "delete_reject_input_chain()"
    if [ -n $GPSLanPort ]; then
        echo "GPSLanPort:$GPSLanPort"
        eval  "iptables -D INPUT -p tcp --tcp-flags SYN SYN --dport $GPSLanPort -j REJECT --reject-with tcp-reset 1>/dev/null 2>&1"
    fi
    if [ -n $GPSWanPort ]; then
        echo "GPSWanPort:$GPSWanPort"
        eval  "iptables -D INPUT -p tcp --tcp-flags SYN SYN --dport $GPSWanPort -j REJECT --reject-with tcp-reset 1>/dev/null 2>&1"
    fi
}

if [ -n COMMAND ]; then
   $COMMAND
fi

GPSCount=`ps -ef | grep gps_func |grep -v 'grep' | wc -l`
echo "GPSCount=$GPSCount"

if [ "$GPSCount" = "0" ]; then 
    echo "GPSCount=$GPSCount, start now"
    delete_reject_input_chain

    echo "isOneshotCmd:$isOneshotCmd"
    if [ ${isOneshotCmd} = "true" ]; then
        echo "gps start oneshot!"
        gps_func onlyOneshot &
    else
        echo "gps normal start!"
        gps_func
    fi
else
    echo "GPSCount is not 0, count=$GPSCount"
    #if [ ${isOneshotCmd} = "true" ]; then
        #echo "receive oneshot. but gps is already runnig."
        #echo "gps oneshot. wait exist gps process."
        #killall -SIGTSTP gps_func
        #wait_moment
        #echo "ok! now oneshot!"
        #gps_func onlyOneshot &
    #else
        echo "gps normal SIGURG"
        killall -SIGURG gps_func
    #fi
fi

