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
Butterlate.setTextDomain("firewall");

$(document).ready(function(){  
	initTranslation();
	initValue(); 

	var validateRule = $("#vpnCfg").validate({
		rules: {
			secuwiz_id: {
				required : true,
				maxlength: 32,
			},
			secuwiz_pw: {
				required : true,
				maxlength: 32,	
			},
			secuwiz_ip: {
				required : true,
				IP4Checker : true
			},
			secuwiz_port: {
				required : true,
				number : true,
				min : 1,
				max : 65535,
			},
			secuwiz_log: {
				required : true,
				number : true,
				min : 1,
				max : 65535,
			}
		},

		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=add] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=add] span").show();
			} else {
				$("div.error[name=add] span").hide();
			}
		},

		submitHandler :function(form){
			if (this.numberOfInvalids()) {
				return;
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
});

function initTranslation()
{
	$("#secuwizTitle").html(_("secuwiz title"));
	$("#secuwizIntroduction").html(_("secuwiz intro"));
	$("#secuwizVpn").html(_("secuwiz vpn"));
	$("#secuwizMode").html(_("secuwiz mode"));
	$("#secuwiz_Enable").html(_("firewall enable"));
	$("#secuwiz_Disable").html(_("firewall disable"));
	$("#secuwizVpnSetup").html(_("secuwiz vpnsetup"));
	$("#secuwizUserID").html(_("secuwiz id"));
	$("#secuwizUserPW").html(_("secuwiz pw"));
	$("#secuwizVpnIP").html(_("secuwiz ip"));
	$("#secuwizVpnPort").html(_("secuwiz port"));
	$("#secuwizCrypto").html(_("secuwiz crypto"));
	$("#crypto_Y").html(_("secuwiz yes"));
	$("#crypto_N").html(_("secuwiz no"));
	$("#secuwizLogSize").html(_("secuwiz logsize"));
	$("#secuwizVer3").html(_("secuwiz ver3"));
	$("#secuwiz_ver3_Y").html(_("secuwiz yes"));
	$("#secuwiz_ver3_N").html(_("secuwiz no"));
	$("#secuwizSTS").html(_("secuwiz sts"));
	$("#secuwiz_sts_Y").html(_("secuwiz yes"));
	$("#secuwiz_sts_N").html(_("secuwiz no"));
	$("#lApply").val(_("firewall apply"));
	$("#lCancel").val(_("firewall reset"));
	$("#vpnBMlog").val(_("vpn view log"));
}

function statusSwitch()
{
	if (document.vpnCfg.statusSet.options.selectedIndex == 0)
	{
		$("#vpnSetupDiv").show();
	}
	else
	{
		$("#vpnSetupDiv").hide();
	}
}

function open_vpnlog_window()
{
	window.open("vpnlog.asp","VPNLog","toolbar=no, location=yes, scrollbars=yes, resizable=no, width=640, height=480")
}

function initValue()
{
	var serviceEnable = '<% getCfgGeneral(1, "secuwiz_enable"); %>';
	var secuwiz_crypto = '<% getCfgGeneral(1, "secuwiz_crypto"); %>';
	var secuwiz_ver3 = '<% getCfgGeneral(1, "secuwiz_ver3"); %>';
	var secuwiz_sts = '<% getCfgGeneral(1, "secuwiz_sts"); %>';

	$("[name=secuwiz_id]").val("<% getCfgGeneral(1, "secuwiz_id"); %>");
	$("[name=secuwiz_pw]").val("<% getCfgGeneral(1, "secuwiz_pw"); %>");
	$("[name=secuwiz_ip]").val("<% getCfgGeneral(1, "secuwiz_ip"); %>");
	$("[name=secuwiz_port]").val("<% getCfgGeneral(1, "secuwiz_port"); %>");
	document.vpnCfg.statusSet.options.selectedIndex = (serviceEnable == "Enable")?0:1;
	document.vpnCfg.secuwiz_crypto.options.selectedIndex = (secuwiz_crypto == "yes")?0:1;
	document.vpnCfg.secuwiz_ver3.options.selectedIndex = (secuwiz_ver3 == "yes")?0:1;
	document.vpnCfg.secuwiz_sts.options.selectedIndex = (secuwiz_sts == "yes")?0:1;
	$("[name=secuwiz_log]").val("<% getCfgGeneral(1, "secuwiz_log"); %>");
	
	statusSwitch();
}
</script>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("secu_vpn.asp"); </script>

	<h1  id="secuwizTitle"> SecuWiz Vpn </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "secuwizIntroduction"> SecuWiz VPN Configuration </font> 
	</div>
	<div id = "blank"> </div>
	
	<form method = post name = "vpnCfg" id = "vpnCfg" action = "/goform/setVpnCfg">
	<table>
	<caption id = "secuwizVpn"> VPN Mode </caption>
	<tr>
	<tr>
		<th id="secuwizMode"> VPN  Mode </th>
		<td>
			<select name="statusSet" id="statusSet"  size="1" onChange="statusSwitch()">
			<option value="Enable" id = "secuwiz_Enable"><font id="secuwizEnable">Enable</font></option>
			<option value="Disable" id = "secuwiz_Disable"><font id="secuwizDisable">Disable</font></option>
			</select>
		</td>
	</tr>
	</table>

	<div id = "vpnSetupDiv">
	<div id = "blank"> </div>
	<table>
	<caption id = "secuwizVpnSetup"> VPN Setup </caption>
	<tr>
		<th  id = "secuwizUserID"> User ID</th>
		<td><input type=text name=secuwiz_id size=20 maxlength=32></td>
	</tr>
	<tr>
		<th id = "secuwizUserPW"> User PW</th>
		<td><input type=password name=secuwiz_pw size=20 maxlength=32></td>
	</tr>
	<tr>
		<th id = "secuwizVpnIP"> VPN IP</th>
		<td><input type=text name=secuwiz_ip size=20 maxlength=32></td>
	</tr>
	<tr>
		<th id = "secuwizVpnPort"> User Port</th>
		<td><input type=text name=secuwiz_port size=20 maxlength=32></td>
	</tr>
	<tr>
		<th id = "secuwizCrypto"> Crypto</th>
		<td>
			<select name="secuwiz_crypto" id="secuwiz_crypto"  size="1" >
			<option value="yes" id="crypto_Y"><font id="cryptoY">Yes</font></option>
			<option value="no" id="crypto_N"><font id="cryptoN"> No</font></option>
			</select>
		</td>
	</tr>
	<tr>
		<th  id = "secuwizVer3"> Version 3</th>
		<td>
			<select name="secuwiz_ver3" id="secuwiz_ver3"  size="1" >
			<option value="yes" id="secuwiz_ver3_Y"><font id="secuwizver3Y">Yes</font></option>
			<option value="no" id="secuwiz_ver3_N">< font id="secuwizver3N">No</font></option>
			</select>
		</td>
	</tr>
	<tr>
		<th id = "secuwizSTS"> Site-To-Site</th>
		<td>
			<select name="secuwiz_sts" id="secuwiz_sts"  size="1" >
			<option value="yes" id="secuwiz_sts_Y"><font id="secuwizstsY">Yes</font></option>
			<option value="no" id="secuwiz_sts_N"><font id="secuwizstsN">No</font></option>
			</select>
		</td>
	</tr>
	<tr>
		<th id = "secuwizLogSize"> Log Size</th>
		<td>
			<input type=text name=secuwiz_log size=20 maxlength=32>
			<input class = "btn_white" type = "button" id="vpnBMlog" value = "View Log" onClick = "open_vpnlog_window()">
		</td>
	</tr>
	</table>
	</div>

	<div id = "blank" class="error" name="add" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "lApply">
	<input class = "btn" type = "button" value = "Cancel" id = "lCancel">
	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

