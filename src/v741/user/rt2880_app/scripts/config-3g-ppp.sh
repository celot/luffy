#!/bin/sh

PPP_3G_FILE=/etc_ro/ppp/peers/3g
DISCONN_FILE=/etc_ro/ppp/3g/celot_disconn.scr

usage () {
  echo "usage: config-3g-ppp.sh [option]..."
  echo "options:"
  echo "  -h              : print this help"
  echo "  -p password     : set password"
  echo "  -u username     : set username"
  echo "  -b baud         : Set baudrate"
  echo "  -m dev 	  : set modem device"
  echo "  -c conn         : set connect AT script"
  echo "  -d disconn	  : set disconnect AT script"
  echo "  -n dialnum      : set dialnumber"
  exit
}

mkdir -p /var/run

APNNO=0
APNCID=1
NOATZ=0;
NOATF=0;
LONG_IPCP=0;
LCP_ECHO_INT=3;
LCP_ECHO_FAIL=3;
LCP_ECHO=0;
LINK_DOWN=0;
USER_ID="";
USER_PW="";

PPP_AUTH_MODE="AUTO"
PPP_STATIC_IP=""
ONDEMAND_START=0


for arg in $*
  do
    if [ "$1" != "" ] 
    then
      case "$1" in
        "-p")
          PASSWORD="password $2" 
          USER_PW="$2"
    	  shift ;;
        "-u")
          USERNAME="user $2" 
          USER_ID="$2"
    	  shift ;;
        "-b")
          BAUD="$2"
	  shift ;;
        "-m")
          MODEM="/dev/$2" 
	  shift ;;
        "-c")
          CONN="$2" 
	  shift ;;
        "-d")
          DISCONN="$2" 
	  shift ;;
	 "-n")
          DIALNUM="$2" 
	   shift ;;

	 "-no_atz")	  
          NOATZ=1
	   ;;

	  "-no_atf")	  
          NOATF=1
	   ;;

	  "-long_ipcp")
	  LONG_IPCP=1
	  ;;

	  "-lcp_echo")
            LCP_ECHO=1;
            if [ "$2" == "no" ]; then 
                shift
            else
                LCP_ECHO_INT="$2" 
                LCP_ECHO_FAIL="$3"
                shift
                shift
            fi
	  ;;
	  
	  "-keepcheck")
            LINK_DOWN=1
        ;;

	  "-auth")
            PPP_AUTH_MODE="$2" 
            shift
	  ;;
	  
	  "-staticip")
            PPP_STATIC_IP="$2" 
            shift
	  ;;

	  "-ondemand_start")
            ONDEMAND_START=1 
	  ;;
	  
        "-h")
	  usage ;;
        *) 
	  echo "illegal option -- $2" 
	  usage ;;
      esac
      shift
  fi
  done

if [ "$BAUD" = "" ]; then
	BAUD=460800
fi

if [ "$CONN" = "" ]; then
	CONN=celot.scr
fi

if [ "$DISCONN" = "" ]; then
	DISCONN=celot_disconn.scr
fi

if [ ! -f "$DISCONN_FILE" ]; then
   #creat disconnect chat script
   echo "TIMEOUT 3" > $DISCONN_FILE
   echo "ABORT 'BUSY'" > $DISCONN_FILE
   echo "ABORT 'NO DIALTONE'" >> $DISCONN_FILE
   echo "ABORT 'ERROR'" >> $DISCONN_FILE
   echo "'' '\K'" >> $DISCONN_FILE
   echo "'' '+++ATH'" >> $DISCONN_FILE
   echo "'\r' ''" >> $DISCONN_FILE
   echo "SAY 'Goodbay.'" >> $DISCONN_FILE
fi

#creat connect chat script
CONN_FILE=/etc_ro/ppp/3g/$CONN

echo "TIMEOUT 5" > $CONN_FILE
#echo "ABORT 'BUSY'" >> $CONN_FILE
#echo "ABORT 'NO CARRIER'" >> $CONN_FILE
echo "ABORT 'ERROR'" >> $CONN_FILE

echo "SAY 'Starting Modem connect script\n'" >> $CONN_FILE
echo "'' 'AT'" >> $CONN_FILE
echo "'OK' 'AT'" >> $CONN_FILE
echo "'OK' 'AT'" >> $CONN_FILE
#echo "'OK' 'ATQ0V1E1'" >> $CONN_FILE
if [ "$NOATZ" != "1" ]; then
echo "'OK' 'ATZ'" >> $CONN_FILE
fi
if [ "$NOATF" != "1" ]; then
echo "'OK' 'AT&F'" >> $CONN_FILE
fi
#echo "'OK' 'AT+CSQ'" >> $CONN_FILE

echo "ABORT 'NO CARRIER'" >> $CONN_FILE
echo "ABORT 'BUSY'" >> $CONN_FILE
echo "SAY 'Dialing...\n'" >> $CONN_FILE  

echo "'OK' 'ATDT$DIALNUM'" >> $CONN_FILE
echo "CONNECT CLIENT" >> $CONN_FILE

echo $MODEM > $PPP_3G_FILE
echo $BAUD >> $PPP_3G_FILE
echo $USERNAME >> $PPP_3G_FILE
if [ "$PPP_AUTH_MODE" = ""  -o  "$PPP_AUTH_MODE" = "AUTO" ]; then
    echo $PASSWORD >> $PPP_3G_FILE
fi
echo "modem" >> $PPP_3G_FILE
echo "crtscts" >> $PPP_3G_FILE
echo "noauth" >> $PPP_3G_FILE
#echo "defaultroute" >> $PPP_3G_FILE #added in ip-up 
echo "noipdefault" >> $PPP_3G_FILE
echo "nopcomp" >> $PPP_3G_FILE
echo "noaccomp" >> $PPP_3G_FILE
echo "novj" >> $PPP_3G_FILE
echo "novjccomp" >> $PPP_3G_FILE
echo "nobsdcomp" >> $PPP_3G_FILE
echo "nodetach" >> $PPP_3G_FILE
echo "usepeerdns" >> $PPP_3G_FILE
echo "nodeflate" >> $PPP_3G_FILE 
echo "debug" >> $PPP_3G_FILE
echo "local" >> $PPP_3G_FILE
echo "holdoff 3" >> $PPP_3G_FILE
#echo "mtu 2048" >> $PPP_3G_FILE
#echo "mru 2048" >> $PPP_3G_FILE
#if [ $PPPOE_OPMODE == "KeepAlive" ]; then
#	echo "persist" >> $PPP_3G_FILE
#	echo "holdoff $PPPOE_OPTIME" >> $PPP_3G_FILE
#elif [ $PPPOE_OPMODE == "OnDemand" ]; then
#	PPPOE_OPTIME=`expr $PPPOE_OPTIME \* 60`
#	echo "demand" >> $PPP_3G_FILE
#	echo "idle $PPPOE_OPTIME" >> $PPP_3G_FILE
#fi

echo "linkname wwan" >> $PPP_3G_FILE

echo "nomp" >> $PPP_3G_FILE

if [ "$LONG_IPCP" = "1" ]; then
echo "ipcp-max-configure 30" >> $PPP_3G_FILE
echo "ipcp-max-failure 30" >> $PPP_3G_FILE
echo "maxfail 30" >> $PPP_3G_FILE
fi

#echo "ipcp-restart 2" >> $PPP_3G_FILE

PPP_OPMODE=`nvram_get 2860 wan_ppp_opmode`
PPP_OPTIME=`nvram_get 2860 wan_ppp_optime`
LINK_DOWN_TIME=`nvram_get 2860 wan_ppp_ldt`
if [ "$PPP_OPMODE" = "" ]; then
	PPP_OPMODE="KeepAlive"
fi
if [ "$PPP_OPTIME" = "" ]; then
	PPP_OPTIME="2"
fi
if [ "$LINK_DOWN_TIME" = "" ]; then
	LINK_DOWN_TIME="2"
fi

if [ "$PPP_OPMODE" == "KeepAlive" ]; then
if [ "$LCP_ECHO" = "0" ]; then
	echo "lcp-echo-interval 20" >> $PPP_3G_FILE
	echo "lcp-echo-failure 6" >> $PPP_3G_FILE
elif [ "$LCP_ECHO" != "no" ]; then
	echo "lcp-echo-interval $LCP_ECHO_INT" >> $PPP_3G_FILE
	echo "lcp-echo-failure $LCP_ECHO_FAIL" >> $PPP_3G_FILE
fi
if [ "$LINK_DOWN" = "1" ]; then
        LINK_DOWN_TIME=`expr $LINK_DOWN_TIME \* 60 - 5`
        echo "idle $LINK_DOWN_TIME" >> $PPP_3G_FILE
fi
	echo "persist" >> $PPP_3G_FILE
elif [ "$PPP_OPMODE" == "OnDemand" ]; then
	PPP_OPTIME=`expr $PPP_OPTIME \* 60`
	echo "demand" >> $PPP_3G_FILE
	if [ "$ONDEMAND_START" = "1" ]; then
	echo "demand_start" >> $PPP_3G_FILE
	fi
	echo "idle $PPP_OPTIME" >> $PPP_3G_FILE
fi

echo "connect \"chat -v -f /etc_ro/ppp/3g/$CONN\"" >> $PPP_3G_FILE 
echo "disconnect \"chat -v -f /etc_ro/ppp/3g/$DISCONN; rm -rf /var/run/ppp*_status\"" >> $PPP_3G_FILE 

if [ -f "/etc_ro/ppp/chap-secrets" ]; then rm -rf "/etc_ro/ppp/chap-secrets"; fi
if [ -f "/etc_ro/ppp/pap-secrets" ]; then rm -rf "/etc_ro/ppp/pap-secrets"; fi
if [ "$PPP_AUTH_MODE" = "PAP" ]; then
    echo "$USER_ID  *   $USER_PW   *" > /etc_ro/ppp/pap-secrets
elif [ "$PPP_AUTH_MODE" = "CHAP" ]; then
    echo "$USER_ID  *   $USER_PW   *" > /etc_ro/ppp/chap-secrets
else
    echo "$USER_ID  *   $USER_PW   *" > /etc_ro/ppp/pap-secrets
    echo "$USER_ID  *   $USER_PW   *" > /etc_ro/ppp/chap-secrets
fi

if [ "$PPP_STATIC_IP" != "" ]; then
    echo "$PPP_STATIC_IP:" >> $PPP_3G_FILE 
fi

