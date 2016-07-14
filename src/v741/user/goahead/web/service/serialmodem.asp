<html>
<head>
<title id = "mobileDialTitle"> <% getModelName(); %> Management </title>
<meta http - equiv = "Content-type" content = "text/html" charset = "UTF-8">
<meta http - equiv = "Cache-Control" content = "No-Cache"> <meta http - equiv = "Pragma" content = "No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"> </script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate_celot.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<script language = "JavaScript" type = "text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("service");

$(document).ready(function(){ 
	initTranslation();
	initValue(); 

	$('#lCancel').click(function() { 
		initValue();
	});
} );

function initTranslation()
{
	$("#serialModemTitle").html(_("service serialmodem title"));
	$("#serialModemIntroduction").html(_("service serialmodem introduction"));
	$("#serialModemStatusSetup").html(_("service directserial statussetup"));
	$("#currentStatus").html(_("service serialmodem currentstatus"));
	$("#connStatus").html(_("service directserial curStatus"));
	$("#serialModemSetup").html(_("service directserial serversetup"));
	$("#deviceSerial").html(_("service directserial serial"));
	$("#deviceBaudRate").html(_("service directserial baud"));
	$("#statusEnable").html(_("service enable"));
	$("#statusDisable").html(_("service disable"));

	$("#btnRefresh").val(_("service refresh"));
	$("#lApply").val(_("service apply"));
	$("#lCancel").val(_("service cancel"));
}

function initValue()
{
	var device = '<% getSerialModemDev(); %>';
	var deviceBaud = '<% getSerialModemDevBaud(); %>';
	var serviceEnable = '<% getSerialModemEnable(); %>';
	
	if (device == "UART-F") 
	{
		document.serialModemCfg.SerialDevice.options.selectedIndex = 0;
	}
	else
	{
		document.serialModemCfg.SerialDevice.options.selectedIndex = 1;
	}	

	if (deviceBaud == "230400") 
	{
		document.serialModemCfg.SerialBaud.options.selectedIndex = 8;
	} 
	else if (deviceBaud == "115200") 
	{
		document.serialModemCfg.SerialBaud.options.selectedIndex = 7;
	} 
	else if (deviceBaud == "57600") 
	{
		document.serialModemCfg.SerialBaud.options.selectedIndex = 6;
	}
	else if (deviceBaud == "38400") 
	{
		document.serialModemCfg.SerialBaud.options.selectedIndex = 5;
	}
	else if (deviceBaud == "19200") 
	{
		document.serialModemCfg.SerialBaud.options.selectedIndex = 4;
	}
	else if (deviceBaud == "9600") 
	{
		document.serialModemCfg.SerialBaud.options.selectedIndex = 3;
	}
	else if (deviceBaud == "4800") 
	{
		document.serialModemCfg.SerialBaud.options.selectedIndex = 2;
	}
	else if (deviceBaud == "2400") 
	{
		document.serialModemCfg.SerialBaud.options.selectedIndex = 1;
	}	
	else 
	{
		document.serialModemCfg.SerialBaud.options.selectedIndex = 0;
	}

	if (serviceEnable == "Enable") 
	{
		document.serialModemCfg.statusSet.options.selectedIndex = 0;
	}
	else
	{
		document.serialModemCfg.statusSet.options.selectedIndex = 1;
	}
	statusSwitch();

}

function statusSwitch()
{
	$("#serialModemSetupDiv").hide();
	$("#connStatusTr").hide();

	if (document.serialModemCfg.statusSet.options.selectedIndex == 0)
	{
		$("#serialModemSetupDiv").show();
		$("#connStatusTr").show();
	}
}

</script>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("serialmodem.asp"); </script>

	<h1 id = "serialModemTitle"> Serial Modem </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "serialModemIntroduction"> </font> 
	</div>
	<div id = "blank"> </div>
	
	<form method = post name = "serialModemCfg" id = "serialModemCfg" action = "/goform/setSerialModem">
	<table>
	<caption id = "serialModemStatusSetup"> Status Setup </caption>
	<tr>
	<tr>
		<th id="currentStatus"> SerialModem Mode </th>
		<td>
			<select name="statusSet" id="statusSet"  size="1" onChange="statusSwitch();">
			<option value="Enable" id="statusEnable">Enable</option>
			<option value="Disable" id="statusDisable">Disable</option>
			</select>
		</td>
	</tr>
	<tr id="connStatusTr">
		<th id="connStatus"> Status </th>
		<td>
			<% getSerialModemStatus(); %> 
			&nbsp; &nbsp; &nbsp;<input type="button" class=btn_white  id="btnRefresh" value="Refresh"  onClick = "window.location.reload()">
		</td>
	</tr>
	</table>
	<div id = "blank"> </div>

	<div id = "serialModemSetupDiv">
	<table>
	<caption id = "serialModemSetup"> Device Setup </caption>
	<tr>
		<th id="deviceSerial"> Serial</th>
		<td>
			<select name="SerialDevice" id="SerialDevice"  size="1">
			<option value="UART-F" id="UART-F">Full UART</option>
			<option value="UART-L" id="UART-L">Lite UART</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="deviceBaudRate"> Baudrate</th>
		<td>
			<select name="SerialBaud" id="SerialBaud" size="1">
			<option value="1200" id="B1200">1200</option>
			<option value="2400" id="B2400">2400</option>
			<option value="4800" id="B4800">4800</option>
			<option value="9600" id="B9600">9600</option>
			<option value="19200" id="B19200">19200</option>
			<option value="38400" id="B38400">38400</option>
			<option value="57600" id="B57600">57600</option>
			<option value="115200" id="B115200">115200</option>
			<option value="230400" id="B230400">230400</option>
			</select>
		</td>
	</tr>
	</table>
	<div id = "blank"> </div>
	</div>
	
	<input class = "btn" type = "submit" value = "Apply" id = "lApply">
	<input class = "btn" type = "button" value = "Cancel" id = "lCancel">
	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

