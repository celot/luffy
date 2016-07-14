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
var http_request = false;
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("internet");

$(document).ready(function(){ 
	initTranslation();
	initValue(); 

	var validateRule = $("#wanCfg").validate({
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
			staticIp: {
				required : function() { return ($("#connectionType").val()=="STATIC") && ($("#wmSelection").val()==1 || $("#wmSelection").val()==2);},
				IP4Checker : true
			},
			staticNetmask: {
				required : function() { return ($("#connectionType").val()=="STATIC") && ($("#wmSelection").val()==1 || $("#wmSelection").val()==2);},
				IP4Checker : true
			},
			staticGateway: {
				required : function() { return ($("#connectionType").val()=="STATIC") && ($("#wmSelection").val()==1 || $("#wmSelection").val()==2);},
				IP4Checker : true
			},
			staticPriDns: {
				required : function() { return ($("#connectionType").val()=="STATIC") && ($("#wmSelection").val()==1 || $("#wmSelection").val()==2);},
				IP4Checker : true
			},
			staticSecDns: {
				required : function() { return ($("#connectionType").val()=="STATIC") && ($("#wmSelection").val()==1 || $("#wmSelection").val()==2);},
				IP4Checker : true
			},
			macCloneMac: {
				required : function() { return ($("#connectionType").val()=="STATIC") && ($("#wmSelection").val()==1 || $("#wmSelection").val()==2) && ($("#macCloneEnbl").val()=="1") ;},
				MACChecker : true
			},
			pppoePass : {
				required : function() { return ($("#connectionType").val()=="PPPOE") && ($("#wmSelection").val()==1 || $("#wmSelection").val()==2);},
				equalTo : "#pppoePass2"
			},
			hostname: {
				required : { depends:function(){return $("i_hostname").length>0; }},
				maxString : {	param : 32 }
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

	$('#wCancel').click(function() { 
		validateRule.resetForm(); 
		$("div.error[name=add] span").hide();
		initValue(); 
	});
} );

function macCloneMacFillSubmit()
{
	$.get("/goform/getMyMAC", function(args){
		if(args.length>0) $("#macCloneMac").val(args);
	});
}

function pingAddrSubmit()
{
	var tmp = document.wanCfg.pingAddr.value;
	
	if (tmp == "")
	{
		alert(_("alert specify media server name"));
		document.wanCfg.pingAddr.value.focus();
		return false;
	}	
	 
	$.get( "/goform/pingAddr", { pingAddr: tmp } ).done(
		function( args ) {
			if (args == "PingOK") window.location.reload();
	});
}

function macCloneSwitch()
{
	if(document.wanCfg.macCloneEnbl.options.selectedIndex == 1) $("#macCloneMacRow").show();
	else $("#macCloneMacRow").hide();
}

function connectionTypeSwitch()
{
	$("#static").hide();
	$("#dhcp").hide();
	$("#pppoe").hide();

	var index = $("#connectionType option").index($("#connectionType option:selected"));
	if (index== 0) $("#static").show();
	else if (index == 1) $("#dhcp").show();
	else if (index == 2) $("#pppoe").show();
	else $("#static").show();
}

function initTranslation()
{
	$("#wTitle").html(_("wan title"));
	$("#wIntroduction").html(_("wan introduction"));
	$("#wanCommunicationSpeed").html(_("wan communication speed"));
	$("#wConnectionType").html(_("wan connection type"));
	$("#wConnTypeStatic").html(_("wan connection type static"));
	$("#wConnTypeDhcp").html(_("wan connection type dhcp"));
	$("#wConnTypePppoe").html(_("wan connection type pppoe"));
	$("#wStaticMode").html(_("wan static mode"));
	$("#wStaticIp").html(_("inet ip"));
	$("#wStaticNetmask").html(_("inet netmask"));
	$("#wStaticGateway").html(_("inet gateway"));
	$("#wStaticPriDns").html(_("inet pri dns"));
	$("#wStaticSecDns").html(_("inet sec dns"));
	$("#wDhcpMode").html(_("wan dhcp mode"));
	$("#wDhcpHost").html(_("inet hostname"));
	$("#wPppoeMode").html(_("wan pppoe mode"));
	$("#wPppoeUser").html(_("inet user"));
	$("#wPppoePassword").html(_("inet password"));
	$("#wPppoePass2").html(_("inet pass2"));
	$("#wMacClone").html(_("wan mac clone"));
	$("#wEnabled").html(_("wan enabled"));
	$("#wMacCloneD").html(_("inet disable"));
	$("#wMacCloneE").html(_("inet enable"));
	$("#thManCloneEnbl").html(_("wan mac clone"));
	$("#wMacCloneAddr").html(_("inet mac"));
	$("#wanModeTitle").html(_("wanmode title2"));
	$("#wCCA").html(_("wan ping title"));
	$("#wPingAddr").html(_("wan ping addr"));
	$("#btnPingAddr").val(_("wan ping button"));	
	$("#macCloneMacFill").val(_("wan fillmac"));
	// $("#wmMode").val(_("vpn type"));
	$("#wmMode").html(_("wanmode title2"));
	$("#wDhcpHostOptional").html(_("wan dhcp optional"));
	$("#wApply").val(_("inet apply"));
	$("#wCancel").val(_("inet cancel"));
}

function initValue()
{
	var mode = "<% getCfgGeneral(1, "wanConnectionMode"); %>";
	var pptpMode = <% getCfgZero(1, "wan_pptp_mode"); %>;
	var clone = <% getCfgZero(1, "macCloneEnabled"); %>;
	var ping_addr = '<% getPingAddr(); %>';

	if (mode == "STATIC") 
	{
		$("#connectionType option:eq(0)").attr("selected", "selected");
	}
	else if (mode == "DHCP") 
	{
		$("#connectionType option:eq(1)").attr("selected", "selected");
		document.wanCfg.hostname.value = "<% getCfgGeneral(1, "wan_dhcp_hn"); %>";
	}
	else if (mode == "PPPOE") 
	{
		$("#connectionType option:eq(2)").attr("selected", "selected");
	}
	else 
	{
		$("#connectionType option:eq(0)").attr("selected", "selected");
	}

	connectionTypeSwitch();	

	if (clone == 1)
		document.wanCfg.macCloneEnbl.options.selectedIndex = 1;
	else
		document.wanCfg.macCloneEnbl.options.selectedIndex = 0;

	macCloneSwitch();
	initWanMode();
	initWanSpeed();

	initCfgValue();

	$("#pingAddr").val(ping_addr);
}

function initWanSpeed()
{
	var wanComSpeed = "<% getWanCommunicationSpeed(); %>";	
	document.wanCfg.wanComSpeed.options.selectedIndex = 1*wanComSpeed;
}

function initWanMode()
{
	var mode = "<% getCfgGeneral(1, "wanMode"); %>";
	
	if (mode == "0") document.wanCfg.wmSelection.options.selectedIndex = 0; // wwan
	else if (mode == "1") document.wanCfg.wmSelection.options.selectedIndex = 1; 	// wan
	else if (mode == "2") document.wanCfg.wmSelection.options.selectedIndex = 2; 	// wwan&wan

	wmOnChange();
}

function initCfgValue()
{
	var staticIP = "<% getCfgGeneral(1, "wan_ipaddr"); %>";
	var staticNetMask = "<% getCfgGeneral(1, "wan_netmask"); %>";
	var staticGateWay = "<% getCfgGeneral(1, "wan_gateway"); %>";
	var staticPriDNS = "<% getCfgGeneral(1, "wan_primary_dns"); %>";
	var staticSecDNS = "<% getCfgGeneral(1, "wan_secondary_dns"); %>";
	if(staticIP == "" || staticIP == "0.0.0.0")  staticIP = "<% getSWanIp(); %>";
	if(staticNetMask == "" || staticNetMask == "0.0.0.0")  staticIP = "<% getSWanNetmask(); %>";
	if(staticGateWay == "" || staticGateWay == "0.0.0.0")  staticIP = "<% getWanGateway(); %>";
	if(staticPriDNS == "" || staticPriDNS == "0.0.0.0")  staticIP = "<% getDns(1); %>";
	if(staticSecDNS == "" || staticSecDNS == "0.0.0.0")  staticIP = "<% getDns(2); %>";
	
	var ppoeUSER = "<% getCfgGeneral(1, "wan_pppoe_user"); %>";
	var pppoePASS = "<% getCfgGeneral(1, "wan_pppoe_pass"); %>";
	var pppoePASS2 = "<% getCfgGeneral(1, "wan_pppoe_pass"); %>";
	var macCloneMacFILL = "<% getCfgGeneral(1, "macCloneMac"); %>";

	// STATIC Mode
	$("#staticIp").val(staticIP);
	$("#staticNetmask").val(staticNetMask);
	$("#staticGateway").val(staticGateWay);
	$("#staticPriDns").val(staticPriDNS);
	$("#staticSecDns").val(staticSecDNS);

	// PPPOE Mode
	$("#pppoeUser").val(ppoeUSER);
	$("#pppoePass").val(pppoePASS);
	$("#pppoePass2").val(pppoePASS2);
	$("#macCloneMac").val(macCloneMacFILL);
	
}

function wmOnChange()
{
	var e = document.getElementById("wmModeHelp");
	if (document.wanCfg.wmSelection.options.selectedIndex== 1 // wan
		|| document.wanCfg.wmSelection.options.selectedIndex== 2)  // wan & wwan
	{
		if(document.wanCfg.wmSelection.options.selectedIndex ==1) e.innerHTML = _("wanmode help_1");
		else e.innerHTML = _("wanmode help_2"); 
		
		$("#trConnectionType").show();
		$("#divWanCfg").show();
		if(document.wanCfg.wmSelection.options.selectedIndex== 2) $("#divPingCfg").show();
		else	 $("#divPingCfg").hide();
		connectionTypeSwitch();
	}
	else 													   // wwan1, wwan2
	{
		e.innerHTML = _("wanmode help_0");
		$("#trConnectionType").hide();
		$("#divWanCfg").hide();
		$("#divPingCfg").hide();
	}
}
</script>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("wan.asp"); </script>

	<h1 id="wTitle"> Wide Area Network (WAN) Settings </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "wIntroduction"> </font> 
	</div>
	<div id = "blank"> </div>

	<form method = post name = "wanCfg" id="wanCfg" action = "/goform/setWans">

	<table>
	<caption id = "wanModeTitle"> Wan Mode </caption>
	<tr>
		<th id="wmMode">Mode</th>
		<td>
			<select name="wmSelection" id="wmSelection" size="1" onchange="wmOnChange()">
				<option value=0 >WWAN</option>
				<option value=1 >WAN</option>
				<option value=2 >WWAN&WAN</option>
			</select>&nbsp;&nbsp;
			<br>
			<font id = "wmModeHelp"></font>
		</td>
	</tr>
	<tr id="trConnectionType">
		<th><b id="wConnectionType"></b>&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<td>
			<select  id="connectionType" name="connectionType" size="1" onChange="connectionTypeSwitch();">
			<option value="STATIC" id="wConnTypeStatic">Static Mode (fixed IP)</option>
			<option value="DHCP" id="wConnTypeDhcp">DHCP (Auto Config)</option>
			<option value="PPPOE" id="wConnTypePppoe">PPPOE (ADSL)</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id = "wanCommunicationSpeed"> Wan Com Speed </th>
		<td>
			<select name="wanComSpeed" id="wanComSpeed" size="1">
				<option value="0" id="comSpeed0"> 10base/half </option>
				<option value="1" id="comSpeed1"> 10base/full </option>
				<option value="2" id="comSpeed2"> 100base/half </option>
				<option value="3" id="comSpeed3"> 100base/full </option>
				<option value="4" id="comSpeed4"> auto </option>
			</select>
		</td>
	</tr>	
	</table>

	<div id="divWanCfg">
	<div id = "blank"> </div>
	<!-- ================= STATIC Mode ================= -->
	<table id="static">
	<caption id = "wStaticMode"> Static Mode(WAN) </caption>
	<tr>
		<th id="wStaticIp">IP Address</th>
		<td><input name="staticIp" id="staticIp" maxlength=15></td>
	</tr>
	<tr>
		<th id="wStaticNetmask">Subnet Mask</th>
		<td><input name="staticNetmask" id="staticNetmask" maxlength=15> </td>
	</tr>
	<tr>
		<th id="wStaticGateway">Default Gateway</th>
		<td><input name="staticGateway" id="staticGateway" maxlength=15></td>
	</tr>
	<tr>
		<th id="wStaticPriDns">Primary DNS Server</th>
		<td><input name="staticPriDns" id="staticPriDns" maxlength=15></td>
	</tr>
	<tr>
		<th id="wStaticSecDns">Secondary DNS Server</th>
		<td><input name="staticSecDns" id="staticSecDns" maxlength=15></td>
	</tr>
	</table>

	<!-- ================= DHCP Mode ================= -->
	<table id="dhcp">
	<caption id = "wDhcpMode"> DHCP Mode </caption>
	<tr>
		<th><div id="wDhcpHost">Host Name</div> <font id = "wDhcpHostOptional"></font></th>
		<td><input type=text name="hostname" id="i_hostname" size=28 maxlength=32 value=""></td>
	</tr>
	</table>

	<!-- ================= PPPOE Mode ================= -->
	<table id="pppoe">
	<caption id = "wPppoeMode"> PPPoE Mode </caption>
	<tr>
		<th id="wPppoeUser">User Name</th>
		<td><input name="pppoeUser" id="pppoeUser" maxlength=32 size=32></td>
	</tr>
	<tr>
		<th id="wPppoePassword">Password</th>
		<td><input type="password" name="pppoePass" id="pppoePass" maxlength=32 size=32></td>
	</tr>
	<tr>
		<th id="wPppoePass2">Verify Password</th>
		<td><input type="password" name="pppoePass2" id="pppoePass2" maxlength=32 size=32></td>
	</tr>
	</table>

	<div id = "blank"> </div>
	<table id="tblMacClone">
	<caption id = "wMacClone"> MAC Address Clone </caption>
	<tr>
		<th id = "thManCloneEnbl"> Enabled </th>
		<td>
			<select name="macCloneEnbl" id="macCloneEnbl" size="1" onChange="macCloneSwitch()">
                        <option value="0" id="wMacCloneD">Disable</option>
                        <option value="1" id="wMacCloneE">Enable</option>
                    </select>
		</td>
	</tr>
	<tr id="macCloneMacRow">
		<th id = "wMacCloneAddr"> MAC Address </th>
		<td>
			<input name="macCloneMac" class = "tbox_120" id="macCloneMac" maxlength=17>
                	<input class = "btn_white" type="button" name="macCloneMacFill" id="macCloneMacFill" value="Fill my MAC" onclick="macCloneMacFillSubmit();" >
		</td>
	</tr>
	</table>
	</div>

	<div id="divPingCfg">
	<div id = "blank"> </div>
	<table>
	<caption id = "wCCA"> Wan Connection checking address </caption>
	<tr>
		<th id = "wPingAddr"> Ping Address </th>
		<td>
			<input name="pingAddr" id="pingAddr" class = "tbox_120" id="pingAddr" size="16" maxlength="128">
                	<input class = "btn_white" type="button" name="btnPingAddr" id="btnPingAddr" value="Save" onclick="pingAddrSubmit();" >
		</td>
	</tr>
	</table>
	</div>

	<div id = "blank" class="error" name="add" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "wApply">
	<input class = "btn" type = "button" value = "Cancel" id = "wCancel" >
	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

