<html>
<head>
<title><% getModelName(); %> Management</title>
<meta http-equiv="Content-type" content="text/html" charset="UTF-8">
<meta http-equiv="Cache-Control" content="No-Cache"><meta http-equiv="Pragma" content="No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>

<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<script language = "JavaScript" type = "text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("main");

function initTranslation()
{
	var e = document.getElementById("titleSaving");
	e.innerHTML = _("main save title");
	e = document.getElementById("configSaved");
	e.innerHTML = _("main save saved");
	e = document.getElementById("waiting");
	e.innerHTML = _("main save waiting");
	e = document.getElementById("waitSec");
	e.innerHTML = _("main save sec");
}

function initHiddenFrame()
{
	var parse_location = "";
	var retPageTmp="";
	var val2="";
	var key2="";
	parse_location = parse_location + this.location;
	parse_location = parse_location.split("?");
	parse_location = parse_location[parse_location.length -1];

	initTranslation();

	arr = parse_location.split("&");
	arr_length = arr.length;

	for(i=0; i<arr_length; i++)
	{
		arr[i] = arr[i].split("=");
	}

	if(arr_length >= 1)
	{
		retPageTmp = arr[0][1];
	}
	if(arr_length >= 2)
	{
		key2 = arr[1][0];
		val2 = arr[1][1];
	}


	if(retPageTmp)
	{
		switch(retPageTmp) 
		{
			case 'home.asp':
				hidden_frame.location.href="";
				break;

			case 'test_hitachi.asp':
				hidden_frame.location.href="";
				break;

			case 'center_push.asp':
				if(val2=='centerPush')
				{
					hidden_frame.location.href="/goform/apply_center_push";
				}
				else if(val2=='CenterPushAdd')
				{
					hidden_frame.location.href="/goform/apply_center_push_add";
				}
				else if(val2=='centerPushDelete')
				{
					hidden_frame.location.href="/goform/apply_center_push_delete";
				}
				break;

			case 'wan.asp':
				hidden_frame.location.href="/goform/apply_wlan";
				break;
				
			case 'lan.asp':
				hidden_frame.location.href="/goform/apply_lan";
				break;
				
			case 'lan1_hitachi.asp':
				break;
				
			case 'routing.asp':
				hidden_frame.location.href="/goform/apply_routing";
				break;

			case 'basic.asp':
			case 'basic_ad.asp':
				hidden_frame.location.href="/goform/apply_basic";
				break;
				
			case 'advanced.asp':
				hidden_frame.location.href="/goform/apply_advanced";
				break;
				
			case 'security.asp':
				hidden_frame.location.href="/goform/apply_security";
				break;

			case 'apcli.asp':
				hidden_frame.location.href="/goform/apply_apcli";
				break;
				
			case 'wds.asp':
				hidden_frame.location.href="/goform/apply_wds";
				break;
				
			case 'apstatistics.asp':
				break;

			case 'wps.asp':
				break;

			case 'port_filtering.asp':
				if(val2=='basic')
				{
					hidden_frame.location.href="/goform/apply_port_filtering_basic";
				}
				else if(val2=='ipportFilter')
				{
					hidden_frame.location.href="/goform/apply_port_filtering_ipportFilter";
				}
				else if(val2=='ipportFilterDelete')
				{
					hidden_frame.location.href="/goform/apply_port_filtering_ipportFilterDelete";
				}
				break;
				
			case 'port_forward.asp':
				if(val2=='portForward')
				{
					hidden_frame.location.href="/goform/apply_port_forward";
				}
				else if(val2=='portForward1')
				{
					hidden_frame.location.href="/goform/apply_port_forward1";
				}
				else if(val2=='portForward2')
				{
					hidden_frame.location.href="/goform/apply_port_forward2";
				}
				else if(val2=='portForwardDelete')
				{
					hidden_frame.location.href="/goform/apply_port_forwardDelete";
				}
				else if(val2=='singlePortForward')
				{
					hidden_frame.location.href="/goform/apply_singlePortForward";
				}
				else if(val2=='singlePortForward1')
				{
					hidden_frame.location.href="/goform/apply_singlePortForward1";
				}
				else if(val2=='singlePortForward2')
				{
					hidden_frame.location.href="/goform/apply_singlePortForward2";
				}
				else if(val2=='singlePortForwardDelete')
				{
					hidden_frame.location.href="/goform/apply_singlePortForwardDelete";
				}
				else if(val2=='portForwardSNat')
				{
					hidden_frame.location.href="/goform/apply_port_snat";
				}
				else if(val2=='portForwardSNat1')
				{
					hidden_frame.location.href="/goform/apply_port_snat1";
				}
				else if(val2=='portForwardSNat2')
				{
					hidden_frame.location.href="/goform/apply_port_snat2";
				}
				else if(val2=='portForwardSNatDelete')
				{
					hidden_frame.location.href="/goform/apply_port_snatDelete";
				}
				else if(val2=='portForwardDNat')
				{
				}
				else if(val2=='portForwardRCNAT')
				{
					hidden_frame.location.href="/goform/apply_portForwardRCNAT";
				}
				break;
				
			case 'DMZ.asp':
				hidden_frame.location.href="/goform/apply_DMZ";
				break;
				
			case 'system_firewall.asp':
				hidden_frame.location.href="/goform/apply_firewall";
				break;
				
			case 'content_filtering.asp':
				hidden_frame.location.href="/goform/apply_content_filter";
				break;

			case 'status.asp':
			case 'statistic.asp':
			case 'management.asp':
				if(val2=='NTP')
				{
					hidden_frame.location.href="/goform/apply_NTP";
				}
				else if(val2=='GreenAP')
				{
					hidden_frame.location.href="/goform/apply_GreenAP";
				}
				else if(val2=='DDNS')
				{
					hidden_frame.location.href="/goform/apply_DDNS";
				}
				else if(val2.indexOf('ADMIN')==0)
				{
					hidden_frame.location.href="/goform/apply_admin";
				}
				else
				{
					hidden_frame.location.href="";
				}
				break;
				
			case 'settings.asp':
				if(val2=='LoadDefault')
				{
					hidden_frame.location.href="/goform/apply_loadDefault";
				}
				else if(key2=='result')
				{
					var e = document.getElementById("configSaved");
					e.innerHTML = _("Error saving setup");
					e = document.getElementById("waiting");
					if(val2.replace(/%20/g," ") == "File Format Mismatch..")
						e.innerHTML = _("file format mismatch");
					else
						e.innerHTML = val2.replace(/%20/g," ");
				}
				else
				{
					hidden_frame.location.href="";
				}
				break;
				
			case 'upload_firmware.asp':
				if(1)	
				{
					var e = document.getElementById("titleSaving");
					e.innerHTML = _("Firmware upgrading...");
					if(key2=="result")
					{
						e = document.getElementById("configSaved");
						e.innerHTML = _("Error Firmware upgrading");

						e = document.getElementById("waiting");
						
						if(val2.replace(/%20/g," ") == "Unmached model name")
							e.innerHTML = _("Unmached model name");
						else if(val2.replace(/%20/g," ") == "Not a valid firmware")
							e.innerHTML = _("Not a valid firmware");
						else if(val2.replace(/%20/g," ") == "Error file size")
							e.innerHTML = _("Error file size");
						else
							e.innerHTML = val2.replace(/%20/g," ");
					}
				}
				break;
				
			case 'syslog.asp':
				break;
				
			case 'reboot.asp':
				if(key2=='RebootNow' && val2=='1')
				{
					hidden_frame.location.href="/goform/RebootNow";
				}
				break;

			case 'vpn.asp':
				if(key2=='subPage' && val2=='1')
				{
					hidden_frame.location.href="/goform/apply_wlan";
				}
				break;
				
			case 'ups_set.asp':
			case 'gps_set.asp':
			case 'port_detect.asp':
			case 'secu_vpn.asp':
			case 'nms.asp':
			case 'power_controller.asp':
			case 'modbus.asp':
				break;

			case 'celotwireless.asp':
				if(key2=='subForm' && val2=='imei')
				{
					hidden_frame.location.href="";
				}
				break;

			case 'pref_mode_lte.asp':
				if(key2=='subForm' && val2=='prefmode')
				{
					hidden_frame.location.href="";
				}
				break;

			case 'kddi_ota.asp':
				if(val2=='SIM1')
				{
					hidden_frame.location.href="/goform/change_kddi_sim1";
				}
				else if(val2=='SIM2')
				{
					hidden_frame.location.href="/goform/change_kddi_sim2";
				}
				else
				{
					hidden_frame.location.href="";
				}
				break;

			case 'celotwifi.asp':
			case 'celotwifi_ad.asp':
				break;	

			case 'failsafe.asp':
				break;
		}
	}
}

var webPort = 0;
var counter= 40;
var retPage="home.asp";
var returnPage="/home.asp";
function initValue()
{
	var parse_location = "";
	var val2="";
	var key2="";
	
	parse_location = parse_location + this.location;
	parse_location = parse_location.split("?");
	parse_location = parse_location[parse_location.length -1];

	arr = parse_location.split("&");
	arr_length = arr.length;

	for(i=0; i<arr_length; i++)
	{
		arr[i] = arr[i].split("=");
	}

	if(arr_length >= 1)
	{
		retPage = arr[0][1];
	}
	if(arr_length >= 2)
	{
		key2 = arr[1][0]; 
		val2 = arr[1][1];
	}
	
	if(retPage)
	{
		switch(retPage) 
		{
			case 'home.asp':
				counter= 5;
				returnPage = "/"+retPage;
				break;

			case 'test_hitachi.asp':
				counter= 5;
				returnPage = "/"+retPage;
				break;

			case 'center_push.asp':
				counter= 5;
				returnPage = "/mobile/"+retPage;
				break;

			case 'gps_set.asp':
				counter= 50;
				returnPage = "/service/"+retPage;
				break;

			case 'nttconfig.asp':
				counter= 5;
				returnPage = "/adm/"+retPage;
				break;

			case 'wan.asp':
			case 'lan.asp':
				counter= 40;
				returnPage = "/internet/"+retPage;
				break;

			case 'lan1_hitachi.asp':
				counter= 5;
				returnPage = "/internet/"+retPage;
				break;

			case 'vpn.asp':
				counter= 3;
				if(key2=='subPage' && val2=='1')
				{
					counter= 40;
				}
				returnPage = "/internet/"+retPage;	
				break;
				
			case 'routing.asp':
				counter= 7;	
				returnPage = "/internet/"+retPage;
				break;

			case 'basic.asp':
			case 'basic_ad.asp':
			case 'advanced.asp':
			case 'security.asp':
			case 'apcli.asp':
			case 'wds.asp':
				counter= 20;	
				returnPage = "/wireless/"+retPage;
				break;
				
			case 'stainfo.asp':
			case 'apstatistics.asp':
			case 'wps.asp':
				returnPage = "/wireless/"+retPage;
				break;

			case 'port_filtering.asp':
			case 'port_forward.asp':
			case 'DMZ.asp':
			case 'system_firewall.asp':
			case 'content_filtering.asp':
				counter= 5;
				returnPage = "/firewall/"+retPage;
				break;
				
			case 'status.asp':
			case 'statistic.asp':
			case 'management.asp':
				if(val2.indexOf('ADMIN_')==0)
				{
					webPort = val2.substring(6);
					counter= 30;
				}
				else if(val2=='ADMIN')
				{
					counter= 5;
				}
				else
				{
					counter= 5;
				}
				returnPage = "/adm/"+retPage;
				break;
				
			case 'settings.asp':
				if(val2=='LoadDefault')
				{
					counter= 60;
				}
				else if(key2=='result')
				{
					counter= 5;
				}
				returnPage = "/adm/"+retPage;
				break;
				
			case 'upload_firmware.asp':	
				if(key2=='wait')
				{
					counter= val2*1;
				}
				else if(key2=='result')
				{
					counter= 5;
				}
				returnPage = "/adm/"+retPage;
				break;

			case 'syslog.asp':
				counter= 5;
				returnPage = "/adm/"+retPage;
				break;
				
			case 'reboot.asp':
				if(key2=='RebootNow' && val2=='1')
				{
					counter= 60;
				}
				else
				{
					counter= 5;
				}
				returnPage = "/adm/"+retPage;
				break;

			case 'directserial.asp':
				counter= 5;
				returnPage = "/service/"+retPage;
				break;

			case 'serialmodem.asp':
				counter= 5;
				returnPage = "/service/"+retPage;
				break;	

			case 'ups_set.asp':
				counter= 5;
				returnPage = "/service/"+retPage;
				break;

			case 'ups_set.asp':
				counter= 5;
				returnPage = "/service/"+retPage;
				break;

			case 'nms.asp':
				counter= 5;
				returnPage = "/service/"+retPage;
				break;

			case 'emg_notifier.asp':
				counter= 5;
				returnPage = "/service/"+retPage;
				break;
			case 'modbus.asp':
				counter= 5;
				returnPage = "/service/"+retPage;
				break;
			case 'power_controller.asp':
				counter= 10;
				returnPage = "/service/"+retPage;
				break;

			case 'port_detect.asp':
				counter= 5;
				returnPage = "/service/"+retPage;
				break;				

			case 'secu_vpn.asp':
				counter= 5;
				returnPage = "/firewall/"+retPage;
				break;

			case 'celotwireless.asp':
				counter= 5;
				if(key2=='subForm' )
				{
					counter= 100;
				}
				returnPage = "/adm/celot/"+retPage;
				break;	

			case 'pref_mode_lte.asp':
				counter= 5;
				if(key2=='subForm' )
				{
					counter= 40;
				}
				returnPage = "/mobile/"+retPage;
				break;	
				
			case 'celotwifi.asp':
				counter= 40;	
				returnPage = "/adm/celot/"+retPage;
				break;

			case 'report_status.asp':
				counter= 5;
				returnPage = "/service/"+retPage;
				break;
				
			case 'kddi_ota.asp':
				counter= 5;
				returnPage = "/adm/"+retPage;
				break;

			case 'failsafe.asp':
				returnPage = "/adm/failsafe.asp";
				counter= 5;
				break;

			case 'domain_wl.asp':
				counter= 5;
				returnPage = "/adm/"+retPage;
				break;

		}
	}

	ID = window.setTimeout("Update();", 1000);
}

function Update()
{
	counter--;
	if(counter < 0)	counter = 0;
	document.save.time_left.value = counter;

	if(counter <= 0)
	{
		if(webPort != 0)
		{
			var newUrl;
			if(webPort==80) newUrl = window.location.protocol + "//"+ window.location.hostname +  returnPage;
			else  newUrl = window.location.protocol + "//"+ window.location.hostname + ":" + webPort + returnPage;
			window.location.href = newUrl;
		}
		else
		{
			window.location.href = returnPage;
		}
	}
	else
	{
		ID = window.setTimeout("Update();", 1000);
	}
}
</script>

<body onload="initHiddenFrame()">
<script language = "JavaScript" type = "text/javascript"> initValue();printContentHead(retPage); </script>
	<H1 id="titleSaving">Reconfiguration</H1>
	
	<form name="save" method="post">
	<div id="wizard_main">
	<div id="wizard_start"></div>
	<div id="wizard_body">
		<div id = "blank"></div>
		<div id = "blank"></div>
		<p>&nbsp;&nbsp;<font id="configSaved"> New settings are saved.</font></p>
		<div id = "blank"></div>
		<p align="center">&nbsp;&nbsp;&nbsp;
		<font id="waiting">Please wait...</font>
		<div id = "blank"></div>
		<input class="noboard" type="text" style="width:20px;" name="time_left" readonly><font id="waitSec">secs</font> 
		</p>
		<div id = "blank"></div>
		<div id = "blank"></div>
		<div id = "blank"></div>
	</div>
	<div id="wizard_end"></div>
	</div>
	</form>
	<iframe name="hidden_frame" style="display:none"></iframe>
	
<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>


