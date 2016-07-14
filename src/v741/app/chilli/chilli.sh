#!/bin/sh

. /sbin/config.sh

start()
{
	echo "------------ chilli start "
		
	killall -9 chilli
	rm /dev/net/tun

	hotspotEnable=`nvram_get 2860 hotspotEnable`

	if [ "$CONFIG_SERVICE_WIFI_HOTSPOT_LOCAL" == "y" ]; then 	

		# Local Mode -------------------------------------
		hotspotLocalMode=`nvram_get 2860 hotspotLocalMode`
		hotspotAdvUrl=`nvram_get 2860 hotspotAdvUrl`
		hotspotDefaultUrl=`nvram_get 2860 hotspotDefaultUrl`
		hotspotTimeOut=`nvram_get 2860 hotspotTimeOut`
		# ----------------------------------------------
	fi
	
	hotspotTunInterface=`nvram_get 2860 hotspotTunInterface`
	hotspotInInterface=`nvram_get 2860 hotspotInInterface`
	hotspotOutInterface=`nvram_get 2860 hotspotOutInterface`

	hotspotRadiusServer1=`nvram_get 2860 hotspotRadiusServer1`
	hotspotRadiusServer2=`nvram_get 2860 hotspotRadiusServer2`
	hotspotRadiusSecret=`nvram_get 2860 hotspotRadiusSecret`	
	hotspotDhcpif=`nvram_get 2860 hotspotDhcpif`
	hotspotUamSecret=`nvram_get 2860 hotspotUamSecret`	
	hotspotUamServer=`nvram_get 2860 hotspotUamServer`
	hotspotUamAllowed=`nvram_get 2860 hotspotUamAllowed`
	hotspotDns1=`nvram_get 2860 hotspotDns1`	
	hotspotDns2=`nvram_get 2860 hotspotDns2`	

	lanHead=`nvram_get 2860 lan_ipaddr`	
	#echo "lanip = $lanHead"
	
	lanHead="${lanHead%\.*}"
	#echo "head = $lanHead"

	if [ ! -f "/var/chilli/first_check_chillispot" ]; then
		mkdir /var/chilli
		mkdir /dev/net
		touch /var/chilli/first_check_chillispot

		sleep 5

		## For Web updating  ##
		if [ ! -d /system/chilli ]; then
			mkdir /system/chilli
		else
			cp -r /system/chilli/* /etc_ro/web/chilli/ 
			#####*//
		fi

		echo "check chilli.conf"
		
		# make /etc/chilli.conf
		if [ -z "$hotspotEnable" ]; then
			hotspotEnable="0"
			nvram_set 2860 hotspotEnable $hotspotEnable
		fi

		if [ "$CONFIG_SERVICE_WIFI_HOTSPOT_LOCAL" == "y" ]; then	

			if [ -z "$hotspotLocalMode" ]; then
				hotspotLocalMode="1"
				nvram_set 2860 hotspotLocalMode $hotspotLocalMode
			fi		

			##if [ -z "$hotspotDefaultUrl" ]; then
			##	hotspotDefaultUrl="http://www.google.com"
			##	nvram_set 2860 hotspotDefaultUrl $hotspotDefaultUrl
			##fi	
			
			if [ -z "$hotspotAdvUrl" ]; then
				hotspotAdvUrl="http://192.168.182.1/chilli/no_adv.asp"
				nvram_set 2860 hotspotAdvUrl $hotspotAdvUrl
			fi	

			if [ -z "$hotspotTimeOut" ]; then
				hotspotTimeOut="86400"
				nvram_set 2860 hotspotTimeOut $hotspotTimeOut
			fi	
		fi
		

		if [ -z "$hotspotRadiusServer1" ]; then
			hotspotRadiusServer1="127.0.0.1"
			nvram_set 2860 hotspotRadiusServer1 $hotspotRadiusServer1
		fi

		if [ -z "$hotspotRadiusServer2" ]; then
			hotspotRadiusServer2="127.0.0.1"
			nvram_set 2860 hotspotRadiusServer2 $hotspotRadiusServer2
		fi

		if [ -z "$hotspotRadiusSecret" ]; then
			hotspotRadiusSecret="testing123"
			nvram_set 2860 hotspotRadiusSecret $hotspotRadiusSecret
		fi

		if [ -z "$hotspotDhcpif" ]; then
			hotspotDhcpif="ra0"
			nvram_set 2860 hotspotDhcpif $hotspotDhcpif
		fi
		
		if [ -z "$hotspotUamSecret" ]; then
			hotspotUamSecret="ht2eb8ej6s4et3rg1ulp"
			nvram_set 2860 hotspotUamSecret $hotspotUamSecret
		fi

		if [ "$CONFIG_SERVICE_WIFI_HOTSPOT_LOCAL" == "y" ]; then	
			if [ -z "$hotspotUamServer" ]; then
				hotspotUamServer="http://192.168.182.1/chilli/hotspot.asp"
				nvram_set 2860 hotspotUamServer $hotspotUamServer
			fi
		else
			if [ -z "$hotspotUamServer" ]; then
				hotspotUamServer="http://127.0.0.1/cgi-bin/greeting.php"
				nvram_set 2860 hotspotUamServer $hotspotUamServer
			fi
		fi	

		if [ -z "$hotspotUamAllowed" ]; then
			hotspotUamAllowed="10.10.10.0/24,192.168.182.0/24"
			nvram_set 2860 hotspotUamAllowed $hotspotUamAllowed
		fi

		if [ -z "$hotspotDns1" ]; then
			dnsIP1=`nvram_get 2860 wan_primary_dns`	
			hotspotDns1="$dnsIP1"
			nvram_set 2860 hotspotDns1 $hotspotDns1
		fi
		
		if [ -z "$hotspotDns2" ]; then
			dnsIP2=`nvram_get 2860 wan_secondary_dns`	
			hotspotDns2="$dnsIP2"
			nvram_set 2860 hotspotDns2 $hotspotDns2
		fi
		
		if [ -z "$hotspotTunInterface" ]; then
			hotspotTunInterface="tun0"
			nvram_set 2860 hotspotTunInterface $hotspotTunInterface
		fi

		if [ -z "$hotspotInInterface" ]; then
			hotspotInInterface="ra0"
			nvram_set 2860 hotspotInInterface $hotspotInInterface
		fi

		if [ -z "$hotspotOutInterface" ]; then
			if [ "$CONFIG_CPRN_NLW" == "y" ] || [ "$CONFIG_CPRW_NLW" == "y" ]; then		
				hotspotOutInterface="usb0"
				nvram_set 2860 hotspotOutInterface $hotspotOutInterface
			elif [ "$CONFIG_CPRN_KLW" == "y" ] || [ "$CONFIG_CPRW_KLW" == "y" ]; then		
				hotspotOutInterface="ppp0"
				nvram_set 2860 hotspotOutInterface $hotspotOutInterface
			else
				hotspotOutInterface="usb0"
				nvram_set 2860 hotspotOutInterface $hotspotOutInterface
			fi	
		fi
		

	fi


	if [ "$hotspotEnable" = "1" ]; then

		echo "make chilli.conf"
		rm /var/chilli/chilli.conf
		touch /var/chilli/chilli.conf

		if [ "$CONFIG_SERVICE_WIFI_HOTSPOT_LOCAL" == "y" ]; then	
			#advurl="$hotspotAdvUrl"
			#advurl="${advurl#[hH][tT][tT][pP]*//}"
			#advurl="${advurl%%[:/]*}"

			##if [ ${#advurl} -eq 0 ]; then
			##	advurl="192.168.182.1"
			##	hotspotAdvUrl="http://192.168.182.1/chilli/no_adv.asp"
			##	nvram_set 2860 hotspotAdvUrl $hotspotAdvUrl				
			##fi

			##advurlTmp="${advurl%%[a-zA-Z]*}"

			##if [ "$advurl" != "$advurlTmp" ]; then
			##	 advurl="192.168.182.1"
			##	 hotspotAdvUrl="http://192.168.182.1/chilli/no_adv.asp"
			##	 nvram_set 2860 hotspotAdvUrl $hotspotAdvUrl
			##fi

		
			
			echo "radiusserver1 192.168.182.1" >> /var/chilli/chilli.conf
			echo "radiusserver2 192.168.182.1" >> /var/chilli/chilli.conf
			echo "radiussecret $hotspotRadiusSecret" >> /var/chilli/chilli.conf
			echo "dhcpif $hotspotDhcpif" >> /var/chilli/chilli.conf
			echo "uamsecret $hotspotUamSecret" >> /var/chilli/chilli.conf
			#echo "uamserver http://192.168.182.1/chilli/hotspot.asp" >> /var/chilli/chilli.conf
			#echo "uamallowed $hotspotUamAllowed,$lanHead.0/24,$advurl" >> /var/chilli/chilli.conf
			echo "uamserver $hotspotUamServer" >> /var/chilli/chilli.conf
			echo "uamallowed $hotspotUamAllowed,$lanHead.0/24" >> /var/chilli/chilli.conf
			echo "dns1 $hotspotDns1" >> /var/chilli/chilli.conf
			echo "dns2 $hotspotDns2" >> /var/chilli/chilli.conf

			rm /var/chilli/default_url
			if [ ! -z  $hotspotDefaultUrl ]; then
				echo "$hotspotDefaultUrl" > /var/chilli/default_url
			fi	

		else	
			echo "radiusserver1 $hotspotRadiusServer1" >> /var/chilli/chilli.conf
			echo "radiusserver2 $hotspotRadiusServer2" >> /var/chilli/chilli.conf
			echo "radiussecret $hotspotRadiusSecret" >> /var/chilli/chilli.conf
			echo "dhcpif $hotspotDhcpif" >> /var/chilli/chilli.conf
			echo "uamsecret $hotspotUamSecret" >> /var/chilli/chilli.conf
			echo "uamserver $hotspotUamServer" >> /var/chilli/chilli.conf
			echo "uamallowed $hotspotUamAllowed" >> /var/chilli/chilli.conf
			echo "dns1 $hotspotDns1" >> /var/chilli/chilli.conf
			echo "dns2 $hotspotDns2" >> /var/chilli/chilli.conf
		fi

		mknod /dev/net/tun c 10 200
		/usr/sbin/chilli --dns1=$hotspotDns1 &

		if [ -f "/usr/sbin/chilli_firewall.sh" ]; then
			/usr/sbin/chilli_firewall.sh
		fi	

		checkOutIf=0
		checkCount=0
		checkNetwork=0
		
		wanMode=`nvram_get 2860 wanMode`	
		
		while [ $checkOutIf -lt 1 ]; do

			checkOutIf=`ifconfig|grep $hotspotOutInterface| grep -v grep|wc -l`

			checkCount=`expr $checkCount + 1`
			
			if [ $checkCount -ge 50 ]; then
				if [ -f "/usr/sbin/clr_chilli_firewall.sh" ]; then
            				/usr/sbin/clr_chilli_firewall.sh
        			fi	
				return
			fi
			sleep 6

			checkNetwork=`ps|grep chilli|grep -v chilli.sh|grep -v grep|wc -l`

			if [ $checkNetwork -lt 1 ]; then
				#echo "Restart chilli"
				checkOutIf=0 
				/usr/sbin/chilli --dns1=$hotspotDns1 &
			fi
			
		done	
	fi

        if [ -f "/usr/sbin/chilli_firewall.sh" ]; then
            /usr/sbin/chilli_firewall.sh
        fi	
}


stop()
{
	echo "------------ chilli stop "
		
	killall -9 chilli
	rm /dev/net/tun


}


if [ "$1" = "start" ]; then
	start
else
	stop
fi	


