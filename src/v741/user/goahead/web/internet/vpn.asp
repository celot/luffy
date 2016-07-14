<html>
<head>
<title id = "mainTitle"> <% getModelName(); %> Management </title>
<meta http - equiv = "Content-type" content = "text/html" charset = "UTF-8">
<meta http - equiv = "Cache-Control" content = "No-Cache"> <meta http - equiv = "Pragma" content = "No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<script type = "text/javascript" src = "/lang/b28n.js"> </script>
<script language = "JavaScript" type = "text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("internet");

function initTranslation()
{
	var e = document.getElementById("vpnTitle");
	e.innerHTML = _("vpn title");
	e = document.getElementById("vpnIntroduction");
	e.innerHTML = _("vpn introduction");

	e = document.getElementById("vpnMode");
	e.innerHTML = _("vpn mode");
	e = document.getElementById("vpnType");
	e.innerHTML = _("vpn type");
	e = document.getElementById("vpnDisable");
	e.innerHTML = _("inet disable");
	e = document.getElementById("vpnConnTypeL2tp");
	e.innerHTML = _("vpn l2tp");
	e = document.getElementById("vpnConnTypePptp");
	e.innerHTML = _("vpn pptp");
	
	e = document.getElementById("vpnL2tpMode");
	e.innerHTML = _("vpn l2tp mode");
	e = document.getElementById("vpnL2tpServer");
	e.innerHTML = _("vpn l2tp server");
	e = document.getElementById("vpnL2tpUser");
	e.innerHTML = _("vpn l2tp user");
	e = document.getElementById("vpnL2tpPassword");
	e.innerHTML = _("vpn l2tp pw");
	e = document.getElementById("vpnL2tpOPMode");
	e.innerHTML = _("vpn l2tp opmode");
	e = document.getElementById("vpnL2tpKeepAlive");
	e.innerHTML = _("vpn l2tp keepalive");
	e = document.getElementById("vpnL2tpOnDemand");
	e.innerHTML = _("vpn l2tp demand");
	e = document.getElementById("vpnL2tpManual");
	e.innerHTML = _("vpn l2tp manual");

	e = document.getElementById("wL2tpKeepAlive2");
	e.innerHTML = _("wan protocol opmode keepalive");
	e = document.getElementById("wL2tpRedial");
	e.innerHTML = _("wan protocol redial");
	e = document.getElementById("wL2tpSec");
	e.innerHTML = _("wan protocol seconds");
	e = document.getElementById("wL2tpOnDemand2");
	e.innerHTML = _("wan protocol opmode ondemand");
	e = document.getElementById("wL2tpIdleTime");
	e.innerHTML = _("wan protocol idle");
	e = document.getElementById("wL2tpMin");
	e.innerHTML = _("wan protocol minutes");
	
	e = document.getElementById("vpnPptpMode");
	e.innerHTML = _("vpn pptp mode");
	e = document.getElementById("vpnPptpServer");
	e.innerHTML = _("vpn pptp server");
	e = document.getElementById("vpnPptpUser");
	e.innerHTML = _("vpn pptp user");
	e = document.getElementById("vpnPptpPassword");
	e.innerHTML = _("vpn pptp pw");
	e = document.getElementById("vpnPptpOPMode");
	e.innerHTML = _("vpn pptp opmode");
	e = document.getElementById("vpnPptpKeepAlive");
	e.innerHTML = _("vpn pptp keepalive");
	e = document.getElementById("vpnPptpOnDemand");
	e.innerHTML = _("vpn pptp demand");
	e = document.getElementById("vpnPptpManual");
	e.innerHTML = _("vpn pptp manual");

	e = document.getElementById("wPptpKeepAlive2");
	e.innerHTML = _("wan protocol opmode keepalive");
	e = document.getElementById("wPptpRedial");
	e.innerHTML = _("wan protocol redial");
	e = document.getElementById("wPptpSec");
	e.innerHTML = _("wan protocol seconds");
	e = document.getElementById("OnDemand2");
	e.innerHTML = _("wan protocol opmode ondemand");
	e = document.getElementById("wPptpIdleTime");
	e.innerHTML = _("wan protocol idle");
	e = document.getElementById("wPptpMin");
	e.innerHTML = _("wan protocol minutes");

	e = document.getElementById("wApply");
	e.value = _("inet apply");
	e = document.getElementById("wCancel");
	e.value = _("inet cancel");

	e = document.getElementById("vPassThru");
	e.innerHTML = _("vpn pass thru");
	e = document.getElementById("vL2tpPassThru");
	e.innerHTML = _("vpn l2tp pass thru");
	e = document.getElementById("vL2tpD");
	e.innerHTML = _("inet disable");
	e = document.getElementById("vL2tpE");
	e.innerHTML = _("inet enable");

	e = document.getElementById("vIpsecPassThru");
	e.innerHTML = _("vpn ipsec pass thru");
	e = document.getElementById("vIpsecD");
	e.innerHTML = _("inet disable");
	e = document.getElementById("vIpsecE");
	e.innerHTML = _("inet enable");

	e = document.getElementById("vPptpPassThru");
	e.innerHTML = _("vpn pptp pass thru");
	e = document.getElementById("vPptpD");
	e.innerHTML = _("inet disable");
	e = document.getElementById("vPptpE");
	e.innerHTML = _("inet enable");

	e = document.getElementById("vApply");
	e.value = _("inet apply");
	e = document.getElementById("vCancel");
	e.value = _("inet cancel");
}

function initValue()
{
	initTranslation();
	initVpn();
	initVpnPassThru();
	vpnModeSwitch();
}

function initVpn()
{
	var mode = '<% getCfgZero(1, "vpnMode"); %>';

	if(mode == "L2TP")  document.setupVPN.vpnMode.options.selectedIndex = 1;
	else if(mode == "PPTP")  document.setupVPN.vpnMode.options.selectedIndex = 2;
	else document.setupVPN.vpnMode.options.selectedIndex = 0;
}

function initVpnPassThru()
{
	var l2tp = <% getCfgZero(1, "l2tpPassThru"); %>;
	var ipsec = <% getCfgZero(1, "ipsecPassThru"); %>;
	var pptp = <% getCfgZero(1, "pptpPassThru"); %>;

	document.vpnpass.l2tpPT.options.selectedIndex = 1*l2tp;
	document.vpnpass.ipsecPT.options.selectedIndex = 1*ipsec;
	document.vpnpass.pptpPT.options.selectedIndex = 1*pptp;
}

function vpnModeSwitch()
{
	if (document.setupVPN.vpnMode.options.selectedIndex == 1) 
	{
		var l2tp_opmode = "<% getCfgGeneral(1, "wan_l2tp_opmode"); %>";
		var l2tp_optime = "<% getCfgGeneral(1, "wan_l2tp_optime"); %>";

		document.getElementById("l2tp").style.visibility = "visible";
		document.getElementById("l2tp").style.display = style_display_on();
		document.getElementById("pptp").style.visibility = "hidden";
		document.getElementById("pptp").style.display = "none";
		
		if (l2tp_opmode == "Manual")
		{
			document.setupVPN.l2tpOPMode.options.selectedIndex = 2;
		}
		else if (l2tp_opmode == "OnDemand")
		{
			document.setupVPN.l2tpOPMode.options.selectedIndex = 1;
			if (l2tp_optime != "")
				document.setupVPN.l2tpIdleTime.value = l2tp_optime;
		}
		else if (l2tp_opmode == "KeepAlive")
		{
			document.setupVPN.l2tpOPMode.options.selectedIndex = 0;
			if (l2tp_optime != "")
				document.setupVPN.l2tpRedialPeriod.value = l2tp_optime;
		}
		l2tpOPModeSwitch();
	} 
	else if (document.setupVPN.vpnMode.options.selectedIndex == 2) 
	{
		var pptp_opmode = "<% getCfgGeneral(1, "wan_pptp_opmode"); %>";
		var pptp_optime = "<% getCfgGeneral(1, "wan_pptp_optime"); %>";

		document.getElementById("l2tp").style.visibility = "hidden";
		document.getElementById("l2tp").style.display = "none";
		document.getElementById("pptp").style.visibility = "visible";
		document.getElementById("pptp").style.display = style_display_on();

		if (pptp_opmode == "Manual")
		{
			document.setupVPN.pptpOPMode.options.selectedIndex = 2;
			if (pptp_optime != "")
				document.setupVPN.pptpIdleTime.value = pptp_optime;
		}
		if (pptp_opmode == "OnDemand")
		{
			document.setupVPN.pptpOPMode.options.selectedIndex = 1;
			if (pptp_optime != "")
				document.setupVPN.pptpIdleTime.value = pptp_optime;
		}
		else if (pptp_opmode == "KeepAlive")
		{
			document.setupVPN.pptpOPMode.options.selectedIndex = 0;
			if (pptp_optime != "")
				document.setupVPN.pptpRedialPeriod.value = pptp_optime;
		}
		pptpOPModeSwitch();
	}
	else
	{
		document.getElementById("l2tp").style.visibility = "hidden";
		document.getElementById("l2tp").style.display = "none";
		document.getElementById("pptp").style.visibility = "hidden";
		document.getElementById("pptp").style.display = "none";
	}
}

function l2tpOPModeSwitch()
{
	document.setupVPN.l2tpRedialPeriod.disabled = true;
	document.setupVPN.l2tpIdleTime.disabled = true;
	if (document.setupVPN.l2tpOPMode.options.selectedIndex == 0) 
		document.setupVPN.l2tpRedialPeriod.disabled = false;
	else if (document.setupVPN.l2tpOPMode.options.selectedIndex == 1)
		document.setupVPN.l2tpIdleTime.disabled = false;
}

function pptpOPModeSwitch()
{
	document.setupVPN.pptpRedialPeriod.disabled = true;
	document.setupVPN.pptpIdleTime.disabled = true;
	if (document.setupVPN.pptpOPMode.options.selectedIndex == 0) 
		document.setupVPN.pptpRedialPeriod.disabled = false;
	else if (document.setupVPN.pptpOPMode.options.selectedIndex == 1)
		document.setupVPN.pptpIdleTime.disabled = false;
}
</script>

</head>
<body onload="initValue()">
<script language = "JavaScript" type = "text/javascript"> printContentHead("vpn.asp"); </script>

	<h1 id="vpnTitle"> Virtual Private Network (VPN) Settings  </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "vpnIntroduction"> Enter information to configure the VPN settings.</font> 
	</div>
	<div id = "blank"> </div>
	
	<form method="post" name="setupVPN" action="/goform/setupVPN">
	<table>
	<caption id = "vpnMode"> VPN Mode </caption>
	<tr>
		<th id="vpnType">Mode</th>
		<td>
			<select  id="vpnMode" name="vpnMode" size="1" onChange="vpnModeSwitch();">
			<option value="Disable" id="vpnDisable">Disable</option>
			<option value="L2TP" id="vpnConnTypeL2tp">L2TP</option>
			<option value="PPTP" id="vpnConnTypePptp">PPTP</option>
			</select>
		</td>
	</tr>
	</table>

	<!-- ================= L2TP Mode ================= -->
	<table id="l2tp">
	<caption id = "vpnL2tpMode"> L2TP Mode </caption>
	<tr>
		<th id="vpnL2tpServer">L2TP Server IP Address</th>
		<td><input name="l2tpServer" maxlength="15" size=15 value="<% getCfgGeneral(1, "wan_l2tp_server"); %>"></td>
	</tr>
	<tr>
		<th id="vpnL2tpUser">User Name</th>
		<td><input name="l2tpUser" maxlength="20" size=20 value="<% getCfgGeneral(1, "wan_l2tp_user"); %>"></td>
	</tr>
	<tr>
		<th id="vpnL2tpPassword">Password</th>
		<td><input type="password" name="l2tpPass" maxlength="32" size=32 value="<% getCfgGeneral(1, "wan_l2tp_pass"); %>"></td>
	</tr>
	<tr>
		<th rowspan="3" id="vpnL2tpOPMode">Operation Mode</th>
		<td>
			<select name="l2tpOPMode" size="1" onChange="l2tpOPModeSwitch()">
			<option value="KeepAlive" id="vpnL2tpKeepAlive">Keep Alive</option>
			<option value="OnDemand" id="vpnL2tpOnDemand">On Demand</option>
			<option value="Manual" id="vpnL2tpManual">Manual</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			<font id="wL2tpKeepAlive2"> Keep Alive Mode</font>: <font id="wL2tpRedial"> Redial Period </font>
			<input type="text" name="l2tpRedialPeriod" maxlength="5" size="3" value="60"> <font id="wL2tpSec">senconds</font>
			<br />
			<font id="wL2tpOnDemand2">On demand Mode</font>:  <font id="wL2tpIdleTime">Idle Time</font>
			<input type="text" name="l2tpIdleTime" maxlength="3" size="2" value="5"> <font id="wL2tpMin">minutes<font>
		</td>
	</tr>
	</table>

	<!-- ================= PPTP Mode ================= -->
	<table id="pptp">
	<caption id = "vpnPptpMode"> PPTP Mode </caption>
	<tr>
		<th id="vpnPptpServer">PPTP Server IP Address</th>
		<td><input name="pptpServer" maxlength="15" size=15 value="<% getCfgGeneral(1, "wan_pptp_server"); %>"></td>
	</tr>
	<tr>
		<th id="vpnPptpUser">User Name</th>
		<td><input name="pptpUser" maxlength="20" size=20 value="<% getCfgGeneral(1, "wan_pptp_user"); %>"></td>
	</tr>
	<tr>
		<th id="vpnPptpPassword">Password</th>
		<td><input type="password" name="pptpPass" maxlength="32" size=32 value="<% getCfgGeneral(1, "wan_pptp_pass"); %>"></td>
	</tr>
	<tr>
		<th rowspan="3" id="vpnPptpOPMode">Operation Mode</th>
		<td>
			<select name="pptpOPMode" size="1" onChange="pptpOPModeSwitch()">
			<option value="KeepAlive" id="vpnPptpKeepAlive">Keep Alive</option>
			<option value="OnDemand" id="vpnPptpOnDemand">On Demand</option>
			<option value="Manual" id="vpnPptpManual">Manual</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			<font id="wPptpKeepAlive2">Keep Alive Mode</font>: <font id="wPptpRedial"> Redial Period </font>
			<input type="text" name="pptpRedialPeriod" maxlength="5" size="3" value="60">
			<font id="wPptpSec">senconds </font>
			<br />
			<font id="OnDemand2">On demand Mode</font>:  <font id="wPptpIdleTime">Idle Time </font>
			<input type="text" name="pptpIdleTime" maxlength="3" size="2" value="5">
			<font id="wPptpMin">minutes </font>
		</td>
	</tr>
	</table>

	<div id = "blank"> </div>
	<input class = "btn" type = "submit" value = "Apply" id = "wApply">
	<input class = "btn" type = "reset" value = "Cancel" id = "wCancel" onClick = "window.location.reload()">
	</form>

	

	<div id = "blank"> </div>
	<form method=post name="vpnpass" action="/goform/setVpnPaThru">
	<table>
	<caption id = "vPassThru"> VPN Pass Through </caption>
	<tr>
		<th id="vL2tpPassThru">L2TP passthrough</th>
		<td>
			<select name="l2tpPT" size="1">
			<option value="0" id="vL2tpD">Disable</option>
			<option value="1" id="vL2tpE">Enable</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="vIpsecPassThru">IPSec passthrough</th>
		<td>
			<select name="ipsecPT" size="1">
			<option value="0" id="vIpsecD">Disable</option>
			<option value="1" id="vIpsecE">Enable</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="vPptpPassThru">PPTP passthrough</th>
		<td>
			<select name="pptpPT" size="1">
			<option value="0" id="vPptpD">Disable</option>
			<option value="1" id="vPptpE">Enable</option>
			</select>
		</td>
	</tr>
	</table>

	<div id = "blank"> </div>
	<input class = "btn" type = "submit" value = "Apply" id = "vApply">
	<input class = "btn" type = "reset" value = "Cancel" id = "vCancel" onClick = "window.location.reload()">
	</form>


<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>
