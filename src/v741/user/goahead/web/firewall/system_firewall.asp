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
Butterlate.setTextDomain("firewall");

$(document).ready(function(){ 
	initTranslation();
	updateState1(); 
	updateState2(); 

	$('#sysfwReset').click(function() { 
		updateState1();
	});
	$('#sysfwReset_d2').click(function() { 
		updateState2();
	});
});

function initTranslation()
{
	$("#sysfwTitle").html(_("sysfw title"));
	$("#sysfwIntroduction").html(_("sysfw introduction"));
	$("#sysfwRemoteManagementTitle").html(_("sysfw remote management title"));
	$("#sysfwRemoteManagementHead").html(_("sysfw remote management head"));
	$("#sysfwRemoteManagementEnable").html(_("sysfw allow"));
	$("#sysfwRemoteManagementDisable").html(_("sysfw deny"));
	$("#sysfwPingFrmWANFilterHead").html(_("sysfw wanping head"));
	$("#sysfwPingFrmWANFilterEnable").html(_("firewall enable"));
	$("#sysfwPingFrmWANFilterDisable").html(_("firewall disable"));
	$("#sysfwSPIFWHead").html(_("sysfw spi head"));
	$("#sysfwSPIFWEnable").html(_("firewall enable"));
	$("#sysfwSPIFWDisable").html(_("firewall disable"));
	$("#sysfwBlockPortScanHead").html(_("sysfw bps head"));
	$("#sysfwBlockPortScanDisable").html(_("firewall disable"));
	$("#sysfwBlockPortScanEnable").html(_("firewall enable"));
	$("#sysfwBlockSynFloodHead").html(_("sysfw bsf head"));
	$("#sysfwBlockSynFloodDisable").html(_("firewall disable"));
	$("#sysfwBlockSynFloodEnable").html(_("firewall enable"));
	$("#sysfwApply").val(_("sysfw apply"));
	$("#sysfwReset").val(_("sysfw reset"));

	$("#sysfwRemoteManagementTitle_d2").html(_("sysfw remote management title_d2"));
	$("#sysfwRemoteManagementHead_d2").html(_("sysfw remote management head"));
	$("#sysfwRemoteManagementEnable_d2").html(_("sysfw allow"));
	$("#sysfwRemoteManagementDisable_d2").html(_("sysfw deny"));
	$("#sysfwPingFrmWANFilterHead_d2").html(_("sysfw wanping head"));
	$("#sysfwPingFrmWANFilterEnable_d2").html(_("firewall enable"));
	$("#sysfwPingFrmWANFilterDisable_d2").html(_("firewall disable"));
	$("#sysfwSPIFWHead_d2").html(_("sysfw spi head"));
	$("#sysfwSPIFWEnable_d2").html(_("firewall enable"));
	$("#sysfwSPIFWDisable_d2").html(_("firewall disable"));
	$("#sysfwBlockPortScanHead_d2").html(_("sysfw bps head"));
	$("#sysfwBlockPortScanDisable_d2").html(_("firewall disable"));
	$("#sysfwBlockPortScanEnable_d2").html(_("firewall enable"));
	$("#sysfwBlockSynFloodHead_d2").html(_("sysfw bsf head"));
	$("#sysfwBlockSynFloodDisable_d2").html(_("firewall disable"));
	$("#sysfwBlockSynFloodEnable_d2").html(_("firewall enable"));

	$("#sysfwApply_d2").val(_("sysfw apply"));
	$("#sysfwReset_d2").val(_("sysfw reset"));
}

function updateState1()
{
	var rm = "<% getCfgGeneral(1, "RemoteManagement"); %>";
	var wpf = "<% getCfgGeneral(1, "WANPingFilter"); %>";
	var spi = "<% getCfgGeneral(1, "SPIFWEnabled"); %>";
	var bps = "<% getCfgGeneral(1, "BlockPortScan"); %>";
	var bsf = "<% getCfgGeneral(1, "BlockSynFlood"); %>";

	if(rm == "1")
		document.websSysFirewall.remoteManagementEnabled.options.selectedIndex = 1;
	else
		document.websSysFirewall.remoteManagementEnabled.options.selectedIndex = 0;
	
	if(wpf == "1")
		document.websSysFirewall.pingFrmWANFilterEnabled.options.selectedIndex = 1;
	else
		document.websSysFirewall.pingFrmWANFilterEnabled.options.selectedIndex = 0;
	
	if(spi == "1")
		document.websSysFirewall.spiFWEnabled.options.selectedIndex = 1;
	else
		document.websSysFirewall.spiFWEnabled.options.selectedIndex = 0;

	if(bps == "" || bps == "0")
		document.websSysFirewall.blockPortScanEnabled.options.selectedIndex = 0;
	else
		document.websSysFirewall.blockPortScanEnabled.options.selectedIndex = 1;

	if(bsf == "" || bsf == "0")
		document.websSysFirewall.blockSynFloodEnabled.options.selectedIndex = 0;
	else
		document.websSysFirewall.blockSynFloodEnabled.options.selectedIndex = 1;
}

function updateState2()
{
	var rm_d2 = "<% getCfgGeneral(1, "RemoteManagement_d2"); %>";
	var wpf_d2 = "<% getCfgGeneral(1, "WANPingFilter_d2"); %>";
	var spi_d2 = "<% getCfgGeneral(1, "SPIFWEnabled_d2"); %>";
	var bps_d2 = "<% getCfgGeneral(1, "BlockPortScan_d2"); %>";
	var bsf_d2 = "<% getCfgGeneral(1, "BlockSynFlood_d2"); %>";

	if(rm_d2 == "1")
		document.websSysFirewall_d2.remoteManagementEnabled_d2.options.selectedIndex = 1;
	else
		document.websSysFirewall_d2.remoteManagementEnabled_d2.options.selectedIndex = 0;
	
	if(wpf_d2 == "1")
		document.websSysFirewall_d2.pingFrmWANFilterEnabled_d2.options.selectedIndex = 1;
	else
		document.websSysFirewall_d2.pingFrmWANFilterEnabled_d2.options.selectedIndex = 0;
	
	if(spi_d2 == "1")
		document.websSysFirewall_d2.spiFWEnabled_d2.options.selectedIndex = 1;
	else
		document.websSysFirewall_d2.spiFWEnabled_d2.options.selectedIndex = 0;

	if(bps_d2 == "" || bps_d2 == "0")
		document.websSysFirewall_d2.blockPortScanEnabled_d2.options.selectedIndex = 0;
	else
		document.websSysFirewall_d2.blockPortScanEnabled_d2.options.selectedIndex = 1;

	if(bsf_d2 == "" || bsf_d2 == "0")
		document.websSysFirewall_d2.blockSynFloodEnabled_d2.options.selectedIndex = 0;
	else
		document.websSysFirewall_d2.blockSynFloodEnabled_d2.options.selectedIndex = 1;
}
</script>
</head>


<!--     body      -->
<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("system_firewall.asp"); </script>

<h1 id="sysfwTitle"> System Firewall Settings </h1>
<% checkIfUnderBridgeModeASP(); %>

	<div align="left">
	&nbsp;&nbsp; <font id = "sysfwIntroduction"> You may configure the system firewall to protect itself from attacking.</font> 
	</div>
	<div id = "blank"> </div>

	<form method=post name="websSysFirewall" id="websSysFirewall" action=/goform/websSysFirewall>
	<table>
	<caption id = "sysfwRemoteManagementTitle">Remote management</caption>

	<tr>
		<th id="sysfwRemoteManagementHead"> Remote management (via WAN) </th>
		<td>
			<select name="remoteManagementEnabled" size="1">
			<option value=0 id="sysfwRemoteManagementDisable">Disable</option>
			<option value=1 id="sysfwRemoteManagementEnable">Enable</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="sysfwPingFrmWANFilterHead"> Ping form WAN Filter </th>
		<td>
			<select name="pingFrmWANFilterEnabled" size="1">
			<option value=0 id="sysfwPingFrmWANFilterDisable">Disable</option>
			<option value=1 id="sysfwPingFrmWANFilterEnable">Enable</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="sysfwBlockPortScanHead"> Block Port Scan </th>
		<td>
			<select name="blockPortScanEnabled" size="1">
			<option value=0 id="sysfwBlockPortScanDisable">Disable</option>
			<option value=1 id="sysfwBlockPortScanEnable">Enable</option>
			</select>
		</td>
	</tr>
	<tr>
		<th class="head" id="sysfwBlockSynFloodHead"> Block Syn Flood </th>
		<td>
			<select name="blockSynFloodEnabled" size="1">
			<option value=0 id="sysfwBlockSynFloodDisable">Disable</option>
			<option value=1 id="sysfwBlockSynFloodEnable">Enable</option>
			</select>
		</td>
	</tr>
	<tr>
		<th class="head" id="sysfwSPIFWHead"> SPI Firewall </th>
		<td>
			<select name="spiFWEnabled" size="1">
			<option value=0 id="sysfwSPIFWDisable">Disable</option>
			<option value=1 id="sysfwSPIFWEnable">Enable</option>
			</select>
		</td>
	</tr>
	</table>

	<div id = "blank"> </div>
	<input class = "btn" type = "submit" value = "Apply" id = "sysfwApply" name="sysfwApply">
	<input class = "btn" type = "button" value = "Reset" id = "sysfwReset"  name="sysfwReset">
	</form>


	<div id = "blank"> </div>
	<form method=post name="websSysFirewall_d2" id="websSysFirewall_d2" action=/goform/websSysFirewall_d2>
	<table>
	<caption id = "sysfwRemoteManagementTitle_d2">Remote management</caption>

	<tr>
		<th id="sysfwRemoteManagementHead_d2"> Remote management (via WAN) </th>
		<td>
			<select name="remoteManagementEnabled_d2" size="1">
			<option value=0 id="sysfwRemoteManagementDisable_d2">Disable</option>
			<option value=1 id="sysfwRemoteManagementEnable_d2">Enable</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="sysfwPingFrmWANFilterHead_d2"> Ping form WAN Filter </th>
		<td>
			<select name="pingFrmWANFilterEnabled_d2" size="1">
			<option value=0 id="sysfwPingFrmWANFilterDisable_d2">Disable</option>
			<option value=1 id="sysfwPingFrmWANFilterEnable_d2">Enable</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="sysfwBlockPortScanHead_d2"> Block Port Scan </th>
		<td>
			<select name="blockPortScanEnabled_d2" size="1">
			<option value=0 id="sysfwBlockPortScanDisable_d2">Disable</option>
			<option value=1 id="sysfwBlockPortScanEnable_d2">Enable</option>
			</select>
		</td>
	</tr>
	<tr>
		<th class="head" id="sysfwBlockSynFloodHead_d2"> Block Syn Flood </th>
		<td>
			<select name="blockSynFloodEnabled_d2" size="1">
			<option value=0 id="sysfwBlockSynFloodDisable_d2">Disable</option>
			<option value=1 id="sysfwBlockSynFloodEnable_d2">Enable</option>
			</select>
		</td>
	</tr>
	<tr>
		<th class="head" id="sysfwSPIFWHead_d2"> SPI Firewall </th>
		<td>
			<select name="spiFWEnabled_d2" size="1">
			<option value=0 id="sysfwSPIFWDisable_d2">Disable</option>
			<option value=1 id="sysfwSPIFWEnable_d2">Enable</option>
			</select>
		</td>
	</tr>
	</table>

	<div id = "blank"> </div>
	<input class = "btn" type = "submit" value = "Apply" id = "sysfwApply_d2" name="sysfwApply_d2">
	<input class = "btn" type = "button" value = "Reset" id = "sysfwReset_d2"  name="sysfwReset_d2" >
	</form>
	
<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>
