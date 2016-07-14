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
	jQuery.validator.addMethod("checkDevice", function(value, element, param) {
		var parity = document.getElementById('SerialParity');
		var data = document.getElementById('SerialData');
		var retValue = 0;
		if(parity.options.selectedIndex == 3 && data.options.selectedIndex == 1)
		{
			return false;
		}
		return true;
	});
	var validateRule = $("#directSerialCfg").validate({
		invalidHandler: function(e, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=add] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=add] span").show();
			} else {
				$("div.error[name=add] span").hide();
			}
		},		
		rules: {
			SerialData: {
				required : true,
				checkDevice : true
			},
			ServerName: {
				required : true,
				IP4Checker: true
			},	
			ServerPort: {
				required : true,
				number : true,
				min : 1,
				max : 65535
			},	
			ListenPort: {
				required : true,
				number : true,
				min : 1,
				max : 65535
			},
			directSerialBufSize: {
				required : true,
				number : true,
				min : 1,
				max : 4096
			},
			directSerialBufTimeout: {
				required : true,
				number : true,
				min : 1,
				max : 10000
			},
			directSerialDefServer: {
				required : true,
				IP4Checker: true
			},
			directSerialDefPort: {
				required : true,
				number : true,
				min : 1,
				max : 65535
			},
			directSerialGuardTime: {
				required : true,
				number : true,
				min : 1,
				max : 999
			}

					
		},		
		submitHandler :function(form){
			var errors = this.numberOfInvalids();
			if (errors) {
				$("div.error[name=add] span").html(_("alert rule number exceeded"));
				$("div.error[name=add] span").show();
			} else {
				$("div.error[name=add] span").hide();
				form.submit();
			}			
		}
	});	

	$('#lCancel').click(function() { 
		validateRule.resetForm(); 
		$("div.error[name=add] span").hide();
		initValue();
	});

} );

function initTranslation()
{
	$("#directSerialTitle").html(_("service directserial title"));
	$("#directSerialIntroduction").html(_("service directserial introduction"));
	$("#directStatusSetup").html(_("service directserial statussetup"));
	$("#currentStatus").html(_("service directserial currentstatus"));
	$("#connStatus").html(_("service directserial curStatus"));
	$("#directSerialSetup").html(_("service directserial devicesetup"));
	$("#deviceSerial").html(_("service directserial serial"));
	$("#deviceBaudRate").html(_("service directserial baud"));
	$("#deviceDataHead").html(_("service directserial data"));
	$("#deviceParityHead").html(_("service directserial parity"));
	$("#deviceStopHead").html(_("service directserial stop"));
	$("#deviceFlowHead").html(_("service directserial flow"));
	$("#directServerSetup").html(_("service directserial serversetup"));
	$("#serverAddr").html(_("service directserial server"));
	$("#serverPort").html(_("service directserial port"));
	$("#ListenPort").html(_("service directserial listenport"));
	
	$("#statusEnable").html(_("service enable"));
	$("#statusDisable").html(_("service disable"));
	$("#connectProtocolHead").html(_("service directserial connectProtocol"));
	$("#connectModeHead").html(_("service directserial connectMode"));
	$("#connectionClient").html(_("service directserial connectionClient"));
	$("#connectionServer").html(_("service directserial connectionServer"));

	
	$("#tdirectSerialModeUDP").html(_("service directserial tdirectSerialModeUDP"));
	$("#connectionStatic").html(_("service directserial connectionStatic"));
	$("#connectionDynamic").html(_("service directserial connectionDynamic"));
	$("#thdirectSerialDefInterface").html(_("service directserial thdirectSerialDefInterface"));
	$("#thdirectSerialDefServer").html(_("service directserial thdirectSerialDefServer"));
	$("#thdirectSerialDefPort").html(_("service directserial thdirectSerialDefPort"));

	$("#thdirectSerialGuardTime").html(_("service directserial directSerialGuardTime"));
	$("#lbdirectSerialGuardTimeSec").html(_("service directserial directSerialGuardTimeSec"));
	
	$("#thdirectSerialInitFlag").html(_("service directserial thdirectSerialInitFlag"));
	$("#directSerialInitFlag0").html(_("service directserial directSerialInitFlag0"));
	$("#directSerialInitFlag1").html(_("service directserial directSerialInitFlag1"));

	
	$("#thDirectSerialInterface").html(_("service directserial interface"));
	$("#directSerialInterface0").html(_("service interface0"));
	$("#directSerialInterface1").html(_("service interface1"));
	$("#directSerialDefInterface0").html(_("service interface0"));
	$("#directSerialDefInterface1").html(_("service interface1"));

	$("#directSerialBufSizeTh").html(_("service directserial bufsize"));
	$("#directSerialBufTimeoutTh").html(_("service directserial buftimeout"));

	$("#btnRefresh").val(_("service refresh"));
	$("#lApply").val(_("service apply"));
	$("#lCancel").val(_("service cancel"));
}

function initValue()
{
	var device = '<% getDirectSerialDev(); %>';
	var deviceBaud = '<% getDirectSerialDevBaud(); %>';
	var deviceData = '<% getDirectSerialDevData(); %>';
	var deviceParity = '<% getDirectSerialDevParity(); %>';
	var deviceStop = '<% getDirectSerialDevStop(); %>';
	var deviceFlow = '<% getDirectSerialDevFlow(); %>';
	var serverName = '<% getDirectSerialServer(); %>';
	var serverPort = '<% getDirectSerialServerPort(); %>';
	var serviceStatus = '<% getDirectSerialStatus(); %>';
	var connectionMode = '<% getDirectSerialMode(); %>';
	var connectionProtocol = '<% getDirectSerialProtocol(); %>';
	var listenPort = '<% getDirectSerialListenPort(); %>'; 
	var directSerialInterface = '<% getDirectSerialInterface(); %>';

	var directSerialBufSize = '<% getDirectSerialBufSize(); %>';
	var directSerialBufTimeout = '<% getDirectSerialBufTimeout(); %>';


	var directSerialModeUDP=  '<% getDirectSerialModeUDP(); %>';
	var directSerialGuardTime=  '<% getDirectSerialGuardTime(); %>';
	var directSerialInitFlag=  '<% getDirectSerialInitFlag(); %>';
	var directSerialDefServer=  '<% getDirectSerialDefServer(); %>';
	var directSerialDefPort=  '<% getDirectSerialDefPort(); %>';
	var directSerialDefInterface=  '<% getDirectSerialDefInterface(); %>';
	if (device == "UART-F") 
	{
		document.directSerialCfg.SerialDevice.options.selectedIndex = 0;
	}
	else
	{
		document.directSerialCfg.SerialDevice.options.selectedIndex = 1;
	}	
	
	if (deviceBaud == "230400") 
	{
		document.directSerialCfg.SerialBaud.options.selectedIndex = 8;
	} 	
	else if (deviceBaud == "115200") 
	{
		document.directSerialCfg.SerialBaud.options.selectedIndex = 7;
	} 
	else if (deviceBaud == "57600") 
	{
		document.directSerialCfg.SerialBaud.options.selectedIndex = 6;
	}
	else if (deviceBaud == "38400") 
	{
		document.directSerialCfg.SerialBaud.options.selectedIndex = 5;
	}
	else if (deviceBaud == "19200") 
	{
		document.directSerialCfg.SerialBaud.options.selectedIndex = 4;
	}
	else if (deviceBaud == "9600") 
	{
		document.directSerialCfg.SerialBaud.options.selectedIndex = 3;
	}
	else if (deviceBaud == "4800") 
	{
		document.directSerialCfg.SerialBaud.options.selectedIndex = 2;
	}
	else if (deviceBaud == "2400") 
	{
		document.directSerialCfg.SerialBaud.options.selectedIndex = 1;
	}
	else 
	{
		document.directSerialCfg.SerialBaud.options.selectedIndex = 0;
	}

	document.directSerialCfg.SerialData.options.selectedIndex = parseInt(deviceData,10);
	document.directSerialCfg.SerialParity.options.selectedIndex = parseInt(deviceParity,10);
	document.directSerialCfg.SerialStop.options.selectedIndex = parseInt(deviceStop,10);
	document.directSerialCfg.deviceFlow.options.selectedIndex = parseInt(deviceFlow,10);	
	
	document.directSerialCfg.directSerialBufSize.value = directSerialBufSize;
	document.directSerialCfg.directSerialBufTimeout.value = directSerialBufTimeout;
	
	if (serviceStatus == "Enable") 
	{
		document.directSerialCfg.statusSet.options.selectedIndex = 0;
	}
	else
	{
		document.directSerialCfg.statusSet.options.selectedIndex = 1;
	}

	if (directSerialInterface == "0") 
	{
		document.directSerialCfg.directSerialInterface.options.selectedIndex = 0;
	}
	else if (directSerialInterface == "1") 
	{
		document.directSerialCfg.directSerialInterface.options.selectedIndex = 1;
	}	
	else if (directSerialInterface == "2") 
	{
		document.directSerialCfg.directSerialInterface.options.selectedIndex = 2;
	}
	else if (directSerialInterface == "3") 
	{
		document.directSerialCfg.directSerialInterface.options.selectedIndex = 3;
	}
	else if (directSerialInterface == "4") 
	{
		document.directSerialCfg.directSerialInterface.options.selectedIndex = 4;
	}

	if (directSerialModeUDP == "0") 
	{
		document.directSerialCfg.directSerialModeUDP.options.selectedIndex = 0;
	}
	else if (directSerialModeUDP == "1") 
	{
		document.directSerialCfg.directSerialModeUDP.options.selectedIndex = 1;
	}
	
	if (directSerialDefInterface == "0") 
	{
		document.directSerialCfg.directSerialDefInterface.options.selectedIndex = 0;
	}
	else if (directSerialDefInterface == "1") 
	{
		document.directSerialCfg.directSerialDefInterface.options.selectedIndex = 1;
	}
	
	if (directSerialInitFlag == "0") 
	{
		document.directSerialCfg.directSerialInitFlag.options.selectedIndex = 0;
	}
	else if (directSerialInitFlag == "1") 
	{
		document.directSerialCfg.directSerialInitFlag.options.selectedIndex = 1;
	}
	document.directSerialCfg.directSerialDefServer.value = directSerialDefServer;
	document.directSerialCfg.directSerialDefPort.value = directSerialDefPort;
	document.directSerialCfg.directSerialGuardTime.value = directSerialGuardTime;
	
	document.directSerialCfg.ServerName.value = serverName;
	document.directSerialCfg.ServerPort.value = serverPort;
	document.directSerialCfg.ListenPort.value = listenPort;

	if(connectionMode =="1")
	{
		document.directSerialCfg.connectMode.options.selectedIndex =1;
	}
	else
	{
		document.directSerialCfg.connectMode.options.selectedIndex =0;
	}

	if(connectionProtocol =="1")
	{
		document.directSerialCfg.connectProtocol.options.selectedIndex =1;
	}
	else
	{
		document.directSerialCfg.connectProtocol.options.selectedIndex =0;
	}
	
	statusSwitch();
}

function statusSwitch()
{
	$("#directSerialSetupDiv").hide();
	$("#directServerSetupDiv").hide();
	$("#connStatusTr").hide();

	if (document.directSerialCfg.statusSet.options.selectedIndex == 0)
	{
		$("#directSerialSetupDiv").show();
		$("#directServerSetupDiv").show();
		$("#connStatusTr").show();
		connectionSwitch();
	}
}

function connectionSwitch()
{
	
	if (document.directSerialCfg.connectProtocol.options.selectedIndex == 0)
	{//tcp
		$("#trconnectMode").show();

		$("#trdirectSerialModeUDP").hide();
		$("#trdirectSerialGuardTime").hide();
		$("#trdirectSerialInitFlag").hide();
		$("#trdirectSerialDefServer").hide();
		$("#trdirectSerialDefPort").hide();
		$("#trdirectSerialDefInterface").hide();
		if (document.directSerialCfg.connectMode.options.selectedIndex == 0)
		{//client
			$("#trDirectSerialInterface").attr("disabled",false);
			$("#ClientModeA").attr("disabled",false);
			$("#ClientModeP").attr("disabled",false);
			$("#ServerModeP").attr("disabled",true);

			$("#trDirectSerialInterface").show();
			$("#ClientModeA").show();
			$("#ClientModeP").show();
			$("#ServerModeP").hide();
			$("#thDirectSerialInterface").show();
		}
		else
		{//server
			$("#trDirectSerialInterface").attr("disabled",true);
			$("#ClientModeA").attr("disabled",true);
			$("#ClientModeP").attr("disabled",true);
			$("#ServerModeP").attr("disabled",false);

			$("#trDirectSerialInterface").hide();
			$("#ClientModeA").hide();
			$("#ClientModeP").hide();
			$("#ServerModeP").show();
			$("#thDirectSerialInterface").hide();
		}
	}
	else
	{//udp
		$("#trconnectMode").hide();
		
		$("#trdirectSerialModeUDP").show();
		if (document.directSerialCfg.directSerialModeUDP.options.selectedIndex == 0)
		{//client
			$("#trDirectSerialInterface").attr("disabled",false);
			$("#ClientModeA").attr("disabled",false);
			$("#ClientModeP").attr("disabled",false);
			$("#ServerModeP").attr("disabled",true);

			$("#trDirectSerialInterface").show();
			$("#ClientModeA").show();
			$("#ClientModeP").show();
			$("#ServerModeP").hide();
			$("#thDirectSerialInterface").show();

			$("#trdirectSerialGuardTime").hide();
			$("#trdirectSerialInitFlag").hide();
			$("#trdirectSerialDefServer").hide();
			$("#trdirectSerialDefPort").hide();
			$("#trdirectSerialDefInterface").hide();
		}
		else
		{//server
			$("#trDirectSerialInterface").attr("disabled",true);
			$("#ClientModeA").attr("disabled",true);
			$("#ClientModeP").attr("disabled",true);
			$("#ServerModeP").attr("disabled",false);

			$("#trDirectSerialInterface").hide();
			$("#ClientModeA").hide();
			$("#ClientModeP").hide();
			$("#ServerModeP").show();
			$("#thDirectSerialInterface").hide();

			$("#trdirectSerialGuardTime").show();
			$("#trdirectSerialInitFlag").show();
			$("#trdirectSerialDefServer").show();
			$("#trdirectSerialDefPort").show();
			$("#trdirectSerialDefInterface").show();

		}
	}
}

</script>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("directserial.asp"); </script>

	<h1 id = "directSerialTitle"> Direct Serial </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "directSerialIntroduction"> </font> 
	</div>
	<div id = "blank"> </div>
	
	<form method = post name = "directSerialCfg" id = "directSerialCfg" action = "/goform/setDirectSerial">
	<table>
	<caption id = "directStatusSetup"> Status Setup </caption>
	<tr>
	<tr>
		<th id="currentStatus"> DirectSerial Mode </th>
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
			<% getDirectSerialConnStatus(); %> 
			&nbsp; &nbsp; &nbsp;<input type="button" class=btn_white id="btnRefresh" value="Refresh"  onClick = "window.location.reload()">
		</td>
	</tr>
	</table>
	<div id = "blank"> </div>

	<div id = "directSerialSetupDiv">
	<table>
	<caption id = "directSerialSetup"> Device Setup </caption>
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
	<tr>
		<th id="deviceDataHead"> Data </th>
		<td>
			<select name="SerialData" id="SerialData" size="1">
			<option value="0" id="Data7">7 bit</option>
			<option value="1" id="Data8">8 bit</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="deviceParityHead"> Parity </th>
		<td>
			<select name="SerialParity" id="SerialParity" size="1">
			<option value="0" id="PNone">none</option>
			<option value="1" id="POdd">odd</option>
			<option value="2" id="PEven">even</option>
			<option value="3" id="PSpace">space</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="deviceStopHead"> Stop </th>
		<td>
			<select name="SerialStop" id="SerialStop" size="1">
			<option value="0" id="S1bit">1 bit</option>
			<option value="1" id="S2bit">2 bit</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="deviceFlowHead"> Flow Control </th>
		<td>
			<select name="deviceFlow" id="deviceFlow" size="1">
			<option value="0" id="Fnone">none</option>
			<option value="1" id="Fonoff">Xon/Xoff</option>
			<option value="2" id="Fhardware">hardware</option>
			</select>
		</td>
	</tr>

	<tr>
		<th id="directSerialBufSizeTh"> Buffer Size </th>
		<td> <input type = "text" id= "directSerialBufSize" name = "directSerialBufSize" size=4 maxlength = 4>  &nbsp; <label for="directSerialBufSize"  id="lbdirectSerialBufSize"> Byte </label></td>
	</tr>

	<tr>
		<th id="directSerialBufTimeoutTh"> Buffer Timeout </th>
		<td> <input type = "text" id= "directSerialBufTimeout" name = "directSerialBufTimeout" size=5 maxlength = 5>  &nbsp; <label for="directSerialBufTimeout"  id="lbdirectSerialBufTimeout"> msec </label></td>
	</tr>
	</table>
	<div id = "blank"> </div>
	</div>

	<div id = "directServerSetupDiv">
	<table id="directServerSetupTbl">
	<caption id = "directServerSetup"> Server Setup </caption>
	<tr>
		<th id="connectProtocolHead"> Connection Protocol </th>
		<td>
			<select name="connectProtocol" id="connectProtocol"  size="1"  onChange="connectionSwitch();">
			<option value="0" id="connectionTCP">TCP</option>
			<option value="1" id="connectionUDP">UDP</option>
			</select>
		</td>
	</tr>
	<tr id="trconnectMode">
		<th id="connectModeHead"> Connection Mode </th>
		<td>
			<select name="connectMode" id="connectMode"  size="1" onChange="connectionSwitch();">
			<option value="0" id="connectionClient">Client</option>
			<option value="1" id="connectionServer">Server</option>
			</select>
		</td>
	</tr>
	<tr id="trdirectSerialModeUDP">
		<th id="tdirectSerialModeUDP"> UDP Mode </th>
		<td>
			<select name="directSerialModeUDP" id="directSerialModeUDP"  size="1" onChange="connectionSwitch();">
			<option value="0" id="connectionStatic">Static</option>
			<option value="1" id="connectionDynamic">Dynamic</option>
			</select>
		</td>
	</tr>
	<tr id="trDirectSerialInterface" >
		<th id="thDirectSerialInterface"> Interface </th>
		<td>
			<select name="directSerialInterface" id="directSerialInterface"  size="1" >
			<option value="0" id="directSerialInterface0">WWAN(Domain. 1)/WAN</option>
			<option value="1" id="directSerialInterface1">WWAN(Domain. 2)</option>
			</select>
		</td>
	</tr>
	
	<tr id ="ClientModeA">
		<th id="serverAddr"> Server </th>
		<td> <input type = "text" name = "ServerName" size=32 maxlength = 128> </td>
	</tr>
	<tr id="ClientModeP">
		<th id="serverPort"> Port </th>
		<td> <input type = "text" name = "ServerPort" size=5 maxlength = 5> </td>
	</tr>
	<tr id="ServerModeP">
		<th id="ListenPort"> Port </th>
		<td> <input type = "text" name = "ListenPort" size=5 maxlength = 5> </td>
	</tr>

	<tr id="trdirectSerialDefInterface" >
		<th id="thdirectSerialDefInterface"> Default Interface </th>
		<td>
			<select name="directSerialDefInterface" id="directSerialDefInterface"  size="1" >
			<option value="0" id="directSerialDefInterface0">WWAN(Domain. 1)/WAN</option>
			<option value="1" id="directSerialDefInterface1">WWAN(Domain. 2)</option>
			</select>
		</td>
	</tr>
	<tr id ="trdirectSerialDefServer">
		<th id="thdirectSerialDefServer"> Default Server </th>
		<td> <input type = "text" name = "directSerialDefServer" size=32 maxlength = 128> </td>
	</tr>
	<tr id="trdirectSerialDefPort">
		<th id="thdirectSerialDefPort"> Default Port </th>
		<td> <input type = "text" name = "directSerialDefPort" size=5 maxlength = 5> </td>
	</tr>

	<tr id="trdirectSerialGuardTime">
		<th id="thdirectSerialGuardTime"> Guard Time </th>
		<td> <input type = "text" name = "directSerialGuardTime" size=5 maxlength = 5>  &nbsp; <label for="directSerialGuardTime"  id="lbdirectSerialGuardTimeSec"> sec </label> </td>
	</tr>
	<tr id="trdirectSerialInitFlag" >
		<th id="thdirectSerialInitFlag"> Initialization connection </th>
		<td>
			<select name="directSerialInitFlag" id="directSerialInitFlag"  size="1" >
			<option value="0" id="directSerialInitFlag0">Disable</option>
			<option value="1" id="directSerialInitFlag1">Enable</option>
			</select>
		</td>
	</tr>

	</table>
	<div id = "blank"> </div>
	</div>

	<div id = "blank" class="error" name="add" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "lApply">
	<input class = "btn" type = "button" value = "Cancel" id = "lCancel">
	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

