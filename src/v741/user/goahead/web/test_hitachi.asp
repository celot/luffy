<html>
<head>
<title id = "mainTitle"> <% getModelName(); %> Management </title>
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
Butterlate.setTextDomain("internet");

$(document).ready(function(){ 
	PageInit();
	initTranslation();
	/*
	var validateRule = $("#diagnosisTest").validate({
		invalidHandler: function(e, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addEmgTest] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addEmgTest] span").show();
			} else {
				$("div.error[name=addEmgTest] span").hide();
			}
		},		
		rules: {
			emgValue : {
				required :  true,
				minlength : 1,
				maxlength : 1,
				range: [1, 6]
			},
		}
	});	
	*/
} );


function emgTestSubmit()
{
	var emgValue = document.diagnosisTest.emgValue.value;
	 
	$.get( "/goform/stratEmgTest", { valueInput : emgValue } ).done(
		function( args ) {
			alert(args);
/*			if (args == "emgTestOk") 
			{
				//alert("Emg Test end.");
			}
*/			
	});
}

function useWifiSubmit()
{
	 
	$.get( "/goform/useWifiSubmit", function(args){
		alert(args);
	});
}


function finishDiagnosisTest()
{
	$.get("/goform/finishDiagnosisTest", function(args){
			if(args.length>0) 
			{
				//alert("Diagnosis Test end.");
			}
		}
	);
}

function diagnosisStartClick()
{
	// ram
	$("[name=ramTotal]").val($("[name=ramTotal]").is(":checked")?1:0);
	$("[name=ramLeft]").val($("[name=ramLeft]").is(":checked")?1:0);
	$("[name=ramRead]").val($("[name=ramRead]").is(":checked")?1:0);
	// rom
	$("[name=romTotal]").val($("[name=romTotal]").is(":checked")?1:0);
	// network
	$("[name=allNicStatics]").val($("[name=allNicStatics]").is(":checked")?1:0);
	$("[name=ethnetStatus]").val($("[name=ethnetStatus]").is(":checked")?1:0);
	$("[name=lanWanNameIP]").val($("[name=lanWanNameIP]").is(":checked")?1:0);
	$("[name=pingResult]").val($("[name=pingResult]").is(":checked")?1:0);
	// firmware
	$("[name=firmOs]").val($("[name=firmOs]").is(":checked")?1:0);
	$("[name=firmCPU]").val($("[name=firmCPU]").is(":checked")?1:0);
	$("[name=firmDevice]").val($("[name=firmDevice]").is(":checked")?1:0);
	$("[name=firmExternal]").val($("[name=firmExternal]").is(":checked")?1:0);
	$("[name=firmSerial]").val($("[name=firmSerial]").is(":checked")?1:0);
	$("[name=firmUSBSerial]").val($("[name=firmUSBSerial]").is(":checked")?1:0);
	$("[name=firmHostName]").val($("[name=firmHostName]").is(":checked")?1:0);
	$("[name=firmDomainName]").val($("[name=firmDomainName]").is(":checked")?1:0);
	$("[name=firmPartions]").val($("[name=firmPartions]").is(":checked")?1:0);
	$("[name=firmUpTime]").val($("[name=firmUpTime]").is(":checked")?1:0);
	$("[name=firmMajorProcess]").val($("[name=firmMajorProcess]").is(":checked")?1:0);
	// module
	$("[name=moduleStatus]").val($("[name=moduleStatus]").is(":checked")?1:0);
	$("[name=modyleSysInfo]").val($("[name=modyleSysInfo]").is(":checked")?1:0);
	$("[name=modulePhoneNumber]").val($("[name=modulePhoneNumber]").is(":checked")?1:0);
	$("[name=modulePinStatus]").val($("[name=modulePinStatus]").is(":checked")?1:0);
	$("[name=moduleCallStatus]").val($("[name=moduleCallStatus]").is(":checked")?1:0);
	$("[name=moduleOTAStatus]").val($("[name=moduleOTAStatus]").is(":checked")?1:0);
	$("[name=moduleImei]").val($("[name=moduleImei]").is(":checked")?1:0);
	$("[name=moduleIccid]").val($("[name=moduleIccid]").is(":checked")?1:0);
	
	return true;
}

function initTranslation()
{
	$("#TestHitachiTitle").html(_("hitachi test diagnosis title"));
	$("#TestHitachiIntrodution").html(_("hitachi test diagnosis introduction"));
	$("#capTableDiagnosis").html(_("hitachi test diagnosis caption"));
	// ram
	$("#RamTest").html(_("hitachi test diagnosis ram info"));
	$("#fontRamTotal").html(_("hitachi test diagnosis ram total"));
	$("#fontRamLeft").html(_("hitachi test diagnosis ram left"));
	$("#fontRamRead").html(_("hitachi test diagnosis ram read"));
	// rom
	$("#RomTest").html(_("hitachi test diagnosis rom info"));
	$("#fontRomTotal").html(_("hitachi test diagnosis rom total"));
	// network 
	$("#InterfaceTest").html(_("hitachi test diagnosis interface info"));
	$("#fontAllNicStatics").html(_("hitachi test diagnosis all nic statics"));
	$("#fontEthnetStatus").html(_("hitachi test diagnosis ethernet status"));
	$("#fontLanWanNameIP").html(_("hitachi test diagnosis wan lan name ip"));
	$("#fontPingResult").html(_("hitachi test diagnosis ping result"));
	// firmware	
	$("#FirmwareTest").html(_("hitachi test diagnosis firmware info"));	
	$("#fontFirmOs").html(_("hitachi test diagnosis os"));
	$("#fontFirmCPU").html(_("hitachi test diagnosis cpu"));
	$("#fontDevice").html(_("hitachi test diagnosis device"));
	$("#fontFirmExternal").html(_("hitachi test diagnosis external power status"));
	$("#fontFirmSerial").html(_("hitachi test diagnosis serial"));
	$("#fontFirmUSBSerial").html(_("hitachi test diagnosis usb serial"));
	$("#fontFirmHostName").html(_("hitachi test diagnosis host name"));
	$("#fontFirmDomainName").html(_("hitachi test diagnosis domain name"));
	$("#fontFirmPartions").html(_("hitachi test diagnosis partions"));
	$("#fontFirmUpTime").html(_("hitachi test diagnosis uptime"));
	$("#fontFirmMajorProcess").html(_("hitachi test diagnosis major process"));
	//module
	$("#ModuleTest").html(_("hitachi test diagnosis module info"));
	$("#fontModuleStatus").html(_("hitachi test diagnosis module status"));
	$("#fontModyleSysInfo").html(_("hitachi test diagnosis module sys info"));
	$("#fontModulePhoneNumber").html(_("hitachi test diagnosis phone number"));
	$("#fontModulePinStatus").html(_("hitachi test diagnosis pin status"));
	$("#fontModuleCallStatus").html(_("hitachi test diagnosis call status"));
	$("#fontModuleOTAStatus").html(_("hitachi test diagnosis ota status"));
	$("#fontModuleImei").html(_("hitachi test diagnosis imei"));
	$("#fontModuleIccid").html(_("hitachi test diagnosis iccid"));
	// emg	
	$("#capEmgTest").html(_("hitachi test emg caption"));
	$("#thEmgValue").html(_("hitachi test emg value"));
	$("#btnEmgVal").val(_("hitachi test emg start btn"));
	// diagnosis start, end
	$("#btnStartDiagnosis").val(_("hitachi test diagnosis test start"));
	$("#btnFinishDiagnosis").val(_("hitachi test diagnosis test end"));
}

function PageInit()
{
}


</script>
</head>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("test_hitachi.asp"); </script>

	<h1 id="TestHitachiTitle" nam="TestHitachiTitle" > Diagnosis and EMG test </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "TestHitachiIntrodution"> </font> 
	</div>
	<div id = "blank"> </div>

	<form method=post name="diagnosisTest" id ="diagnosisTest" action="/goform/startDiagnosisTest">
	
	<table id>
	<caption id = "capTableDiagnosis">Diagnosis test setting </caption>
	<!-- ram -->
	<tr>
		<th  id="RamTest"> Ram Info </th>
		<td>
			<input type=checkbox name="ramTotal" id="ramTotal" value="0" > <font id="fontRamTotal"> Ram Total </font> &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="ramLeft" id="ramLeft" value="0" > <font id="fontRamLeft"> Ram Left </font> &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="ramRead" id="ramRead" value="0" > <font id="fontRamRead"> Ram Read </font> 
		</td>
	</tr>	
	<!-- rom -->
	<tr>
		<th  id="RomTest"> Rom Info </th>
		<td>
			<input type=checkbox name="romTotal" id="romTotal" value="0" > <font id="fontRomTotal"> Rom Total </font> <br></br>
		</td>
	</tr>
	<!-- network -->
	<tr>
		<th  id="InterfaceTest"> Interface Info </th>
		<td>
			<input type=checkbox name="allNicStatics" id="allNicStatics" value="0" > <font id="fontAllNicStatics"> All Nic Statics</font> &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="ethnetStatus" id="ethnetStatus" value="0" > <font id="fontEthnetStatus"> Ethernet Status </font> <br></br>
			<input type=checkbox name="lanWanNameIP" id="lanWanNameIP" value="0" > <font id="fontLanWanNameIP"> Lan/Wan Name,IP</font>  &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="pingResult" id="pingResult" value="0" > <font id="fontPingResult"> Ping </font>
		</td>
	</tr>
	<!-- firmware -->
	<tr>
		<th  id="FirmwareTest"> Firmware Info </th>
		<td>
			<input type=checkbox name="firmOs" id="firmOs" value="0" > <font id="fontFirmOs"> OS </font> &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="firmCPU" id="firmCPU" value="0" > <font id="fontFirmCPU"> CPU </font> &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="firmDevice" id="firmDevice" value="0" > <font id="fontDevice"> Device </font>  &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="firmExternal" id="firmExternal" value="0" > <font id="fontFirmExternal"> External </font> <br></br>
			<input type=checkbox name="firmSerial" id="firmSerial" value="0" > <font id="fontFirmSerial"> Serial </font> &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="firmUSBSerial" id="firmUSBSerial" value="0" > <font id="fontFirmUSBSerial"> USB Serial </font> &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="firmHostName" id="firmHostName" value="0" > <font id="fontFirmHostName"> Host Name</font>  <br></br>
			<input type=checkbox name="firmDomainName" id="firmDomainName" value="0" > <font id="fontFirmDomainName"> Domain Name </font> &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="firmPartions" id="firmPartions" value="0" > <font id="fontFirmPartions"> Partitions </font> &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="firmUpTime" id="firmUpTime" value="0" > <font id="fontFirmUpTime"> Up Time </font> <br></br>
			<input type=checkbox name="firmMajorProcess" id="firmMajorProcess" value="0" > <font id="fontFirmMajorProcess"> Major Process </font>  
		</td>
	</tr>
	<!-- module -->
	<tr>
		<th  id="ModuleTest"> Module Info </th>
		<td>
			<input type=checkbox name="moduleStatus" id="moduleStatus" value="0" > <font id="fontModuleStatus"> Status </font> &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="modyleSysInfo" id="modyleSysInfo" value="0" > <font id="fontModyleSysInfo"> System Info </font> &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="modulePhoneNumber" id="modulePhoneNumber" value="0" > <font id="fontModulePhoneNumber"> Phone Number</font>  <br></br>
			<input type=checkbox name="modulePinStatus" id="modulePinStatus" value="0" > <font id="fontModulePinStatus"> Pin Status </font> &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="moduleCallStatus" id="moduleCallStatus" value="0" > <font id="fontModuleCallStatus"> Call Status </font>  &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="moduleOTAStatus" id="moduleOTAStatus" value="0" > <font id="fontModuleOTAStatus"> OTA Status </font> <br></br>
			<input type=checkbox name="moduleImei" id="moduleImei" value="0" > <font id="fontModuleImei"> Imei </font>  &nbsp;&nbsp;&nbsp;&nbsp;
			<input type=checkbox name="moduleIccid" id="moduleIccid" value="0" > <font id="fontModuleIccid"> Iccid </font>
		</td>
	</tr>
	</table>
	
	<div id = "blank"> </div>
	<input class = "btn" type = "submit" value = "Apply" id = "btnStartDiagnosis" name="btnStartDiagnosis" onClick="return diagnosisStartClick()">
	<input class = "btn" type="button" name="btnFinishDiagnosis" id="btnFinishDiagnosis" value="End" onclick="finishDiagnosisTest();" >

	<div id = "blank"> </div>
	<table>
	<caption id = "capEmgTest"> EMG Test</caption>
	<tr>
		<th id = "thEmgValue"> EMG Value</th>
		<td>
			<input name="emgValue" id="emgValue" class = "tbox_120" size="16" maxlength="1" minlength="1">
                	<input class = "btn_white" type="button" name="btnEmgVal" id="btnEmgVal" value="EMG Start" onclick="emgTestSubmit();" >
		</td>
	</tr>
	</table>
	<div id = "blank" class="error" name="addEmgTest" align="center"> <span></span> <br clear="all"></div>

	<table>
	<caption id = "capUseWifi"> Use WiFi</caption>
	<tr>
		<th id = "thUseWifiValue"> Use WiFi</th>
		<td>
                	<input class = "btn_white" type="button" name="btnUseWifiVal" id="btnUseWifiVal" value="Set Use WiFi" onclick="useWifiSubmit();" >
		</td>
	</tr>
	</table>
	<div id = "blank" class="error" name="setUseWifi" align="center"> <span></span> <br clear="all"></div>

	</form>

	

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>

</html>

