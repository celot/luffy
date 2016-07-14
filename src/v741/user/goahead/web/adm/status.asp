<html>
<head>
<title><% getModelName(); %> Management</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>

<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("admin");

$(document).ready(function(){ PageInit(); } );

function showOpMode()
{
	var opmode = 1* <% getCfgZero(1, "OperationMode"); %>;
	if (opmode == 0)
		document.write("Bridge Mode");
	else if (opmode == 1)
	{
		var opmode = 1* <% getCfgZero(1, "OperationMode"); %>;
		var apclient = 1* <% getCfgZero(1, "ApCliEnable"); %>;
		if(apclient==1)
		{
			document.write("AP Client Mode");	
		}
		else
		{
			document.write("Gateway Mode");
		}
	}
	else if (opmode == 2)
		document.write("Ethernet Converter Mode");
	else if (opmode == 3)
		document.write("AP Client Mode");
	else
		document.write("Unknown");
}

function showAPN()
{
	var currentApn = "<% getCurrentApn(); %>";
	document.write(currentApn);
}

function initTranslation()
{
	$("#statusTitle").html(_("status title")); 
	$("#statusIntroduction").html(_("status introduction")); 
	$("#statusSysInfo").html(_("status system information")); 
	$("#statusSDKVersion").html(_("status sdk version")); 
	$("#statusSysUpTime").html(_("status system up time")); 
	$("#statusSysPlatform").html(_("status system platform")); 
	$("#statusOPMode").html(_("status operate mode")); 
	$("#statusInternetConfig").html(_("status internet config")); 
	$("#statusConnectedType").html(_("status connect type")); 
	$("#statusAPN").html(_("status apn")); 
	$("#statusWanMode").html(_("status wan mode")); 
	$("#statusWANIPAddr").html(_("status wan ipaddr")); 
	//$("#statusSubnetMask").html(_("status subnet mask")); 
	$("#statusDefaultGW").html(_("status default gateway")); 
	$("#statusPrimaryDNS").html(_("status primary dns")); 
	$("#statusSecondaryDNS").html(_("status secondary dns")); 
	$("#statusWANMAC").html(_("status mac")); 
	$("#statusLocalNet").html(_("status local network")); 
	$("#statusLANIPAddr").html(_("status lan ipaddr2")); 
	$("#statusLocalNetmask").html(_("status local netmask")); 
	$("#statusLANMAC").html(_("status mac"));

	Butterlate.setTextDomain("admin");
}

function PageInit()
{
	initTranslation();
}

function showWanMode()
{
	var mode = "<% getCfgGeneral(1, "wanMode"); %>";
	if (mode == "1") document.write("WAN");
	else if (mode == "2") document.write("WAN & WWAN");
	else document.write("WWAN");
}

</script>
</head>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("status.asp"); </script>

	<H1 id="statusTitle">Access Point Status</H1>
	<div align="left">
	&nbsp;&nbsp; <font id = "statusIntroduction">Let's take a look at the status of Router.</font> 
	</div>
	<div id = "blank"> </div>


	<table>
	<!-- ================= System Info ================= -->
	<caption id = "statusSysInfo"> System Info </caption>
	<tr>
		<th id="statusSDKVersion">SDK Version</th>
		<td><% getSdkVersion(); %></td>
	</tr>
	<tr>
		<th id="statusSysUpTime">System Time</th>
		<td><% getSysUptime(); %></td>		
	</tr>
	<tr>
		<th id="statusSysPlatform">System Platform</th>
		<td><% getPlatform(); %></td>
	</tr>
	<tr>
		<th id="statusOPMode">Operation Mode</th>
		<td><script type="text/javascript">showOpMode();</script></td>
	</tr>
	</table>

	<div id = "blank"> </div>
	<table>
	<!-- ================= Internet Configurations ================= -->
	<caption id = "statusInternetConfig"> Internet Configurations </caption>
	<tr>
		<th id="statusWanMode">WAN Mode</th>
		<td><script type="text/javascript">showWanMode();</script></td>
	</tr>
	<tr>
		<th id="statusConnectedType">Connected Type</th>
		<td><% getWanConnectionType(); %></td>
	</tr>
	<tr>
		<th id="statusAPN">Current APN</th>
		<td><script type="text/javascript">showAPN();</script></td>
	</tr>
	<tr>
		<th id="statusWANIPAddr">WAN IP Address</th>
		<td><% getWanIp(); %></td>
	</tr>
	<!--
	<tr>
		<th id="statusSubnetMask">Subnet Mask</th>
		<td><% getWanNetmask(); %></td>
	</tr>
	-->
	<tr>
		<th id="statusDefaultGW">Default Gateway</th>
		<td><% getWanGateway(); %></td>
	</tr>
	<tr>
		<th class="head" id="statusPrimaryDNS">Primary Domain Name Server</th>
		<td><% getDns(1); %></td>
	</tr>
	<tr>
		<th class="head" id="statusSecondaryDNS">Secondary Domain Name Server</th>
		<td><% getDns(2); %></td>
	</tr>
	<tr>
		<th id="statusWANMAC">MAC Address</th>
		<td><% getWanMac(); %></td>
	</tr>
	</table>

	<div id = "blank"> </div>
	<table>
	<!-- ================= Local Network ================= -->
	<caption id = "statusLocalNet"> Local Network </caption>
	<tr>
		<th id="statusLANIPAddr">Local IP Address</th>
		<td><% getLanIp(); %></td>
	</tr>
	<tr>
		<th id="statusLocalNetmask">Local Netmask</th>
		<td><% getLanNetmask(); %></td>
	</tr>
	<tr>
		<th id="statusLANMAC">MAC Address</th>
		<td><% getLanMac(); %></td>
	</tr>
	<!-- ================= Other Information ================= -->
	</table>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>
