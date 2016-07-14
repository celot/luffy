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

<style type='text/css'>
div.second {
   padding-top:3px;
}
</style>

<script language = "JavaScript" type = "text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("mobile");

$(document).ready(function(){ 
	initTranslation();
	initValue();

	var validateRule = $("[name=mobileCfg]").validate({
		/*
		rules: {
			APN: {
				required : true,
				minlength : 1
			}
		},
		*/
		
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addApn] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addApn] span").show();
			} else {
				$("div.error[name=addApn] span").hide();
			}
		},

		submitHandler :function(form){
			var wan_pass = $.trim($("#wan_pass").val());	
			var wan_pass_re = $.trim($("#wan_pass_re").val());	
			if (wan_pass != wan_pass_re)
			{
				$("div.error[name=addApn] span").html(_("mobile alert password"));
				$("div.error[name=addApn] span").show();
				return false;
			}
			else
			{
				if(this.numberOfInvalids())
				{
					return;
				}
				else
				{
					$("div.error[name=addApn] span").hide();
					form.submit();
				}
			}
		}
	});

	var validateRule2 = $("[name=mobileCfg_d2]").validate({
		/*
		rules: {
			APN_d2: {
				required : true,
				minlength : 1
			}
		},
		*/
		
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addApn2] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addApn2] span").show();
			} else {
				$("div.error[name=addApn2] span").hide();
			}
		},

		submitHandler :function(form){
			var wan_pass = $.trim($("#wan_pass_d2").val());	
			var wan_pass_re = $.trim($("#wan_pass_re_d2").val());	
			if (wan_pass != wan_pass_re)
			{
				$("div.error[name=addApn2] span").html(_("mobile alert password"));
				$("div.error[name=addApn2] span").show();
				return false;
			}
			else
			{
				if(this.numberOfInvalids())
				{
					return;
				}
				else
				{
					$("div.error[name=addApn2] span").hide();
					form.submit();
				}
			}
		}
	});

	$('#btnModeReset').click(function() { 
		initMode();
	});

	$('#btnApnReset').click(function() { 
		validateRule.resetForm();
		$("div.error[name=addApn] span").hide();
		initApn();
	});

	$('#btnApnReset2').click(function() { 
		validateRule2.resetForm();
		$("div.error[name=addApn2] span").hide();
		initApn2();
	});
});

function initTranslation()
{
	$("#mobileCfgTitle").html(_("mobile cfg title"));
	$("#mobileCfgIntro").html(_("mobile cfg introduction"));

	$("#mobileAccountSetup").html(_("mobile setup"));
	$("#mobileAccountSetup_d1").html(_("mobile setup1"));
	$("#mobileAccountSetup_d2").html(_("mobile setup_d2"));
	$("#mobileUser").html(_("mobile user"));
	$("#mobileUser_d2").html(_("mobile user"));
	$("#mobilePw").html(_("mobile pass"));
	$("#mobilePw_d2").html(_("mobile pass"));
	$("#mobileRePw").html(_("mobile repass"));
	$("#mobileRePw_d2").html(_("mobile repass"));
	$("#mobileDial").html(_("mobile dial"));
	$("#mobileDial_d2").html(_("mobile dial"));
	$("#wPppOPMode").html(_("mobile protocol opmode"));
	$("#wPppKeepAlive").html(_("mobile protocol opmode keepalive"));
	$("#wPppOnDemand").html(_("mobile protocol opmode ondemand"));
	$("#manIdleTime").html(_("mobile protocol idle"));
	$("#minutes").html(_("mobile protocol minutes"));

	$("#btnModeApply").val(_("mobile apply"));
	$("#btnModeReset").val(_("mobile cancel"));
	$("#btnApnApply").val(_("mobile apply"));
	$("#btnApnReset").val(_("mobile cancel"));
	$("#btnApnApply2").val(_("mobile apply"));
	$("#btnApnReset2").val(_("mobile cancel"));
}


function initMode()
{
	var ppp_opmode = "<% getCfgGeneral(1, "wan_ppp_opmode"); %>";
	var ppp_optime = "<% getCfgGeneral(1, "wan_ppp_optime"); %>";
	var ppp_keeptime = "<% getCfgGeneral(1, "wan_ppp_ldt"); %>";
	
	if($.trim(ppp_opmode).length == 0 ) ppp_opmode = "KeepAlive";
	if($.trim(ppp_optime).length ==0) ppp_optime = 2;
	if($.trim(ppp_keeptime).length ==0) ppp_keeptime = 2;

	if (ppp_opmode == "OnDemand")
	{
		$("#pppOPMode").val("OnDemand");
		$("#pppIdleTime").val((ppp_optime=="1")?"1"
							:(ppp_optime=="2")?"2"
							:(ppp_optime=="3")?"3"
							:(ppp_optime=="5")?"5"
							:(ppp_optime=="10")?"10"
							:(ppp_optime=="15")?"15"
							:"1");
	}
	else
	{
		$("#pppOPMode").val("KeepAlive");
		$("#pppIdleTime").val((ppp_keeptime=="1")?"1"
					:(ppp_keeptime=="2")?"2"
					:(ppp_keeptime=="3")?"3"
					:(ppp_keeptime=="5")?"5"
					:(ppp_keeptime=="10")?"10"
					:(ppp_keeptime=="15")?"15"
					:"1");
	}
}

function initApn()
{
	var user = "<% getCfgGeneral(1, "wan_3g_user"); %>";
	var pw = "<% getCfgGeneral(1, "wan_3g_pass"); %>";
	var dial = "<% getCfgGeneral(1, "wan_3g_dial"); %>";
	var apntype = "<% getCfgGeneral(1, "wan_3g_apntype"); %>";
	var authtype = "<% getCfgGeneral(1, "wan_3g_auth"); %>";
	var apn = "<% getCfgGeneral(1, "wan_3g_apn"); %>";

	if(authtype=="" || (authtype!="PAP" && authtype!="CHAP")) authtype = "AUTO";
	$("[name=UserID]").val(user);
	$("[name=Password]").val(pw);
	$("[name=Password2]").val(pw);
	$("[name=Dial]").val(dial);
	$("#ApnType").val(apntype);
	$("#AuthType").val(authtype);
	$("#APN").val(apn);
}

function initApn2()
{
	var user = "<% getCfgGeneral(1, "wan_3g_user_d2"); %>";
	var pw = "<% getCfgGeneral(1, "wan_3g_pass_d2"); %>";
	var dial = "<% getCfgGeneral(1, "wan_3g_dial_d2"); %>";
	var apntype = "<% getCfgGeneral(1, "wan_3g_apntype_d2"); %>";
	var authtype = "<% getCfgGeneral(1, "wan_3g_auth_d2"); %>";
	var apn = "<% getCfgGeneral(1, "wan_3g_apn_d2"); %>";

	if(authtype=="" || (authtype!="PAP" && authtype!="CHAP")) authtype = "AUTO";
	$("[name=UserID_d2]").val(user);
	$("[name=Password_d2]").val(pw);
	$("[name=Password2_d2]").val(pw);
	$("[name=Dial_d2]").val(dial);
	$("#ApnType_d2").val(apntype);
	$("#AuthType_d2").val(authtype);
	$("#APN_d2").val(apn);
}

function initValue()
{
	initMode();
	initApn();
	initApn2();
}

function pppOPModeSwitch()
{
	var ppp_optime = "<% getCfgGeneral(1, "wan_ppp_optime"); %>";
	var ppp_keeptime = "<% getCfgGeneral(1, "wan_ppp_ldt"); %>";
	
	if ($("#pppOPMode").val() == "OnDemand")
	{
		$("#pppIdleTime").val((ppp_optime=="1")?"1"
							:(ppp_optime=="2")?"2"
							:(ppp_optime=="3")?"3"
							:(ppp_optime=="5")?"5"
							:(ppp_optime=="10")?"10"
							:(ppp_optime=="15")?"15"
							:"1");
	}
	else
	{
		$("#pppIdleTime").val((ppp_keeptime=="1")?"1"
					:(ppp_keeptime=="2")?"2"
					:(ppp_keeptime=="3")?"3"
					:(ppp_keeptime=="5")?"5"
					:(ppp_keeptime=="10")?"10"
					:(ppp_keeptime=="15")?"15"
					:"1");
	}

}

</script>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("config.asp"); </script>

	<h1 id = "mobileCfgTitle"> Dial Up </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "mobileCfgIntro"> </font> 
	</div>
	<div id = "blank"> </div>

	<form method = post name = "mobileConfigMode" action = "/goform/mobileConfigMode">
	<table>
	<caption id = "mobileAccountSetup">  Setup </caption>
	<tr>
		<th id="wPppOPMode">Operation Mode</th>
		<td>
			<select name="pppOPMode" id="pppOPMode" size="1" onChange="pppOPModeSwitch()">
			<option value="KeepAlive" id="wPppKeepAlive">Keep Alive</option>
			<option value="OnDemand" id="wPppOnDemand">On Demand</option>
			</select>
			<div class = "second">
			<div id="divIdleTime">
			<font id="manIdleTime">Idle Time </font>&nbsp;:&nbsp;
			<select id="pppIdleTime" name="pppIdleTime" size="1">
			<option value="1">1</option>
			<option value="2">2</option>
			<option value="3">3</option>
			<option value="5">5</option>
			<option value="10">10</option>
			<option value="15">15</option>
			</select>
			<font id="minutes"> minutes </font>
			</div>
			</div>
		</td>
	</tr>	
	
	</table>
	<div id = "blank"> </div>
	<input class = "btn" type = "submit" value = "Apply" id = "btnModeApply">
	<input class = "btn" type = "button" value = "Cancel" id = "btnModeReset" >
	</form>	
	<div id = "blank"> </div>

	<form method = post name = "mobileCfg" action = "/goform/mobileConfigD1">
	<table>
	<caption id = "mobileAccountSetup_d1">  Setup </caption>
	<tr>
		<th id="mobileUser"> User ID </th>
		<td><input name="UserID" style="ime-mode:disabled;" onpaste="return false;" maxlength="64" size=40></td>
	</tr>
	<tr>
		<th id="mobilePw"> Password </th>
		 <td><input name="Password" style="ime-mode:disabled;" onpaste="return false;" id="wan_pass" maxlength="64" size=40></td> 
	</tr>
	<tr>
		<th id="mobileRePw"> Re Password </th>
		<td><input  name="Password2" style="ime-mode:disabled;" onpaste="return false;" id="wan_pass_re" maxlength="64" size=40></td>
	</tr>
	<tr>
		<th id="mobileDial"> Dial Number </th>
		<td><input name="Dial" maxlength="15" size=15></td>
	</tr>
	
	<tr id="trAPN">
		<th> APN </th>
		<td>
			<select name="ApnCid" id="ApnCid" size="1">
			<option value="CID1" id="CID1">CID=1</option>
			</select>
			&nbsp;&nbsp;
			<select name="ApnType" id="ApnType" size="1">
			<option value="PPP" id="APNPPP">PPP</option>
			<option value="IP" id="APNIP">IP</option>
			<option value="IPV4V6" id="APNIPV4V6">IPV4V6</option>
			</select>
			&nbsp;&nbsp;
			<select name="AuthType" id="AuthType" size="1">
			<option value="PAP" id="AuthPap">PAP</option>
			<option value="CHAP" id="AuthChap">CHAP</option>
			<option value="AUTO" id="AuthPapChap">PAP+CHAP</option>
			</select>
			<div class = "second">
			<input name="APN" id="APN" type="text" maxlength="64" size=30>
			</div>
		</td>
	</tr>		
	</table>

	<div id = "blank" class="error" name="addApn" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "btnApnApply">
	<input class = "btn" type = "button" value = "Cancel" id = "btnApnReset">
	</form>

	<div id = "blank"> </div>
	<form method = post name = "mobileCfg_d2" action = "/goform/mobileConfigD2">
	<table>
	<caption id = "mobileAccountSetup_d2">  Setup </caption>
	<tr>
		<th id="mobileUser_d2"> User ID </th>
		<td><input name="UserID_d2" style="ime-mode:disabled;" onpaste="return false;" maxlength="64" size=40></td>
	</tr>
	<tr>
		<th id="mobilePw_d2"> Password </th>
		 <td><input name="Password_d2" style="ime-mode:disabled;" onpaste="return false;" id="wan_pass_d2" maxlength="64" size=40></td> 
	</tr>
	<tr>
		<th id="mobileRePw_d2"> Re Password </th>
		<td><input  name="Password2_d2" style="ime-mode:disabled;" onpaste="return false;" id="wan_pass_re_d2" maxlength="64" size=40></td>
	</tr>
	<tr>
		<th id="mobileDial_d2"> Dial Number </th>
		<td><input name="Dial_d2" maxlength="15" size=15></td>
	</tr>
	
	<tr id="trAPN_d2">
		<th> APN </th>
		<td>
			<select name="ApnCid_d2" id="ApnCid_d2" size="1">
			<option value="CID2" id="CID2">CID=2</option>
			</select>
			&nbsp;&nbsp;
			<select name="ApnType_d2" id="ApnType_d2" size="1">
			<option value="PPP" id="APNPPP_d2">PPP</option>
			<option value="IP" id="APNIP_d2">IP</option>
			<option value="IPV4V6" id="APNIPV4V6_d2">IPV4V6</option>
			</select>
			<select name="AuthType_d2" id="AuthType_d2" size="1">
			<option value="PAP" id="AuthPap_d2">PAP</option>
			<option value="CHAP" id="AuthChap_d2">CHAP</option>
			<option value="AUTO" id="AuthPapChap_d2">PAP+CHAP</option>
			</select>
			<div class = "second">
			<input name="APN_d2" id="APN_d2" type="text" maxlength="64" size=30>
			</div>
		</td>
	</tr>		
	</table>

	<div id = "blank" class="error" name="addApn2" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "btnApnApply2">
	<input class = "btn" type = "button" value = "Cancel" id = "btnApnReset2">
	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

