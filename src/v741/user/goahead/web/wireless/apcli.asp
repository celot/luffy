<!-- Copyright 2004, Ralink Technology Corporation All Rights Reserved. -->
<html>
<head>
<title id = "mainTitle"> <% getModelName(); %> Management </title>
<meta http - equiv = "Content-type" content = "text/html" charset = "UTF-8">
<meta http - equiv = "Cache-Control" content = "No-Cache"> <meta http - equiv = "Pragma" content = "No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type = "text/javascript" src = "/lang/b28n.js"> </script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate_celot.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<script language = "JavaScript" type = "text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("wireless");

var mode = '<% getCfgGeneral(1, "ApCliAuthMode"); %>';
var enc = '<% getCfgGeneral(1, "ApCliEncrypType"); %>';
var wpapsk = '<% getCfgGeneral(1, "ApCliWPAPSK"); %>';
var keyid = '<% getCfgGeneral(1, "ApCliDefaultKeyID"); %>';
var key1type = '<% getCfgGeneral(1, "ApCliKey1Type"); %>';
var key2type = '<% getCfgGeneral(1, "ApCliKey2Type"); %>';
var key3type = '<% getCfgGeneral(1, "ApCliKey3Type"); %>';
var key4type = '<% getCfgGeneral(1, "ApCliKey4Type"); %>';

function initTranslation()
{
	$("#apcliApply").val(_("wireless apply"));
	$("#apcliCancel").val(_("wireless cancel"));

	
	$("#apcliBasciSetting").html(_("apcli basic setting"));
	$("#apClientTitle").html(_("apcli title"));
	$("#apClientIntroduction").html(_("apcli introduction"));
	$("#apcliOPMode").html(_("apcli opmode"));

	$("#oModeA").html(_("apcli modea"))
	$("#apCliIP").html(_("apcli ip"));
	$("#apCliParams").html(_("apcli params"));
	
	$("#apCliSecMode").html(_("secure security mode"));
	$("#apCliEncType").html(_("secure encryp type"));
	$("#apCliWepDef").html(_("secure wep default key"));
	$("#apCliWEPKey").html(_("secure wep key"));
	$("#apcliPassPhrase").html(_("secure pass phrase"));
	
}

function KeyTypeSwitch(id)
{
	var webkeytype = eval("document.wireless_apcli.apcli_key"+id+"type.options.selectedIndex");
	if(id==1)
		document.wireless_apcli.apcli_key1type.options.selectedIndex = webkeytype;
	else if(id==2)
		document.wireless_apcli.apcli_key2type.options.selectedIndex = webkeytype;
	else if(id==3)
		document.wireless_apcli.apcli_key3type.options.selectedIndex = webkeytype;
	else if(id==4)
		document.wireless_apcli.apcli_key4type.options.selectedIndex = webkeytype;
}

function SecurityModeSwitch()
{
	var mysel = document.wireless_apcli.apcli_enc;
	mysel.options.length = 0;
	if (document.wireless_apcli.apcli_mode.options.selectedIndex == 0) {
		mysel.options[0] = new Option("WEP", "WEP");
		mysel.options[1] = new Option("None", "NONE");
	}
	else if (document.wireless_apcli.apcli_mode.options.selectedIndex == 1) {
		mysel.options[0] = new Option("WEP", "WEP");
	}
	else if (document.wireless_apcli.apcli_mode.options.selectedIndex == 2 ||
		 document.wireless_apcli.apcli_mode.options.selectedIndex == 3) {
		mysel.options[0] = new Option("TKIP", "TKIP");
		mysel.options[1] = new Option("AES", "AES");
	}
}

function EncryptModeSwitch()
{
	$("#div_apcli_default_key").hide();	
	$("#div_apcli_key1").hide();
	$("#div_apcli_key2").hide();
	$("#div_apcli_key3").hide();
	$("#div_apcli_key4").hide();
	$("#div_apcli_wpapsk").hide();	

	if (document.wireless_apcli.apcli_enc.value == "WEP") {
		$("#div_apcli_default_key").show();
		$("#div_apcli_key1").show();
		$("#div_apcli_key2").show();
		$("#div_apcli_key3").show();
		$("#div_apcli_key4").show();
	}
	else if (document.wireless_apcli.apcli_enc.value == "TKIP" ||
		 document.wireless_apcli.apcli_enc.value == "AES") {

		$("#div_apcli_wpapsk").show();
	}
}

function initValue()
{
	var wifi_mode = "<% getCfgZero(1, "ApCliEnable"); %>";
	initTranslation();

	if (wifi_mode == "1")
	{
		document.wireless_apcli.opMode[0].checked = false;
		document.wireless_apcli.opMode[1].checked = true;
	}
	else
	{
		document.wireless_apcli.opMode[0].checked = true;
		document.wireless_apcli.opMode[1].checked = false;
	}
	changeMode();
	
	if (mode == "SHARED")
		document.wireless_apcli.apcli_mode.options.selectedIndex = 1;
	else if (mode == "WPAPSK")
		document.wireless_apcli.apcli_mode.options.selectedIndex = 2;
	else if (mode == "WPA2PSK")
		document.wireless_apcli.apcli_mode.options.selectedIndex = 3;
	else
		document.wireless_apcli.apcli_mode.options.selectedIndex = 0;

	SecurityModeSwitch();
	if (enc == "WEP")
		document.wireless_apcli.apcli_enc.options.selectedIndex = 0;
	else if (enc == "TKIP")
		document.wireless_apcli.apcli_enc.options.selectedIndex = 0;
	else if (enc == "AES")
		document.wireless_apcli.apcli_enc.options.selectedIndex = 1;
	else
		document.wireless_apcli.apcli_enc.options.selectedIndex = 1;
	EncryptModeSwitch();
	if (enc == "WEP") {
		document.wireless_apcli.apcli_default_key.options.selectedIndex = 1*keyid-1;

		if (key1type == "1")
			document.wireless_apcli.apcli_key1type.options.selectedIndex = 0;
		else
			document.wireless_apcli.apcli_key1type.options.selectedIndex = 1;

		if (key2type == "1")
			document.wireless_apcli.apcli_key2type.options.selectedIndex = 0;
		else
			document.wireless_apcli.apcli_key2type.options.selectedIndex = 1;

		if (key3type == "1")
			document.wireless_apcli.apcli_key3type.options.selectedIndex = 0;
		else
			document.wireless_apcli.apcli_key3type.options.selectedIndex = 1;

		if (key4type == "1")
			document.wireless_apcli.apcli_key4type.options.selectedIndex = 0;
		else
			document.wireless_apcli.apcli_key4type.options.selectedIndex = 1;
		
		KeyTypeSwitch(1);
	} else if (enc == "TKIP" || enc == "AES") {
		document.wireless_apcli.apcli_wpapsk.value = "<% getCfgGeneral(1, "ApCliWPAPSK"); %>";
	}

}

$(document).ready(function(){ 
	initValue(); 

	$.validator.addMethod("jqCheckInjection", function(value, element) {
		if(this.optional(element)) return true;
		var len = value.length;
		for (var i=0; i<value.length; i++) {
			if ( value.charAt(i) == '\r' || value.charAt(i) == '\n' || value.charAt(i) == ';' || value.charAt(i) == ','){ return false; }
			else continue;
		}		
		return true ;
	}, _("jquery apcli invalid char"));

	$.validator.addMethod("ApcliKeyAsciiLengthCehcker", function(value, element) {
		if(this.optional(element)) return true;
		var result = ($(element).val().length == 5 || $(element).val().length == 13) ;
		return result ;
	}, _("jquery must be 5 or 13"));

	$.validator.addMethod("jqCheckHex", function(value, element) {
		if(this.optional(element)) return true;
		return value.match("^[0-9a-fA-F]+$");
	}, _("jquery input valid hexacode"));

	$.validator.addMethod("ApcliKeyHexLengthCehcker", function(value, element) {
		if(this.optional(element)) return true;
		var result = ($(element).val().length == 10 || $(element).val().length == 26) ;
		return result ;
	}, _("jquery must be 10 or 26"));

	var validateRule = $("#wireless_apcli").validate({
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
			apcli_ssid: {
				required : function() { return ($(":radio[name=opMode]:checked").val() == "3");},
				minlength : 1,
				maxlength : 32
			}, 
			apcli_wpapsk : {
				required :  function () { 
					return ($("#apcli_mode").val() == "WPAPSK") || ($("#apcli_mode").val() == "WPA2PSK");
				},
				minlength : 8,
				jqCheckInjection : {
					param : "#apcli_wpapsk",
					depends : function() { 			
						return ($("#apcli_mode").val() == "WPAPSK") || ($("#apcli_mode").val() == "WPA2PSK");
					}
				}
			},
			apcli_key1 : {
				required :  function() {return $("#apcli_default_key").val()=="1";},		
				jqCheckInjection : { depends : function() { return $("#apcli_key1type").val() == "1" ;	}},
				ApcliKeyAsciiLengthCehcker : { depends : function() { return $("#apcli_key1type").val() == "1" ; }},
				jqCheckHex : { depends : function() { return $("#apcli_key1type").val() == "0" ;	}},
				ApcliKeyHexLengthCehcker : { depends : function() { return $("#apcli_key1type").val() == "0" ;	}}
			},
			apcli_key2 : {
				required :  function() {return $("#apcli_default_key").val()=="2";},		
				jqCheckInjection : { depends : function() { return $("#apcli_key2type").val() == "1" ;	}},
				ApcliKeyAsciiLengthCehcker : { depends : function() { return $("#apcli_key2type").val() == "1" ; }},
				jqCheckHex : { depends : function() { return $("#apcli_key2type").val() == "0" ;	}},
				ApcliKeyHexLengthCehcker : { depends : function() { return $("#apcli_key2type").val() == "0" ;	}}
			},
			apcli_key3 : {
				required :  function() {return $("#apcli_default_key").val()=="3";},		
				jqCheckInjection : { depends : function() { return $("#apcli_key3type").val() == "1" ;	}},
				ApcliKeyAsciiLengthCehcker : { depends : function() { return $("#apcli_key3type").val() == "1" ; }},
				jqCheckHex : { depends : function() { return $("#apcli_key3type").val() == "0" ;	}},
				ApcliKeyHexLengthCehcker : { depends : function() { return $("#apcli_key3type").val() == "0" ;	}}
			},
			apcli_key4 : {
				required :  function() {return $("#apcli_default_key").val()=="4";},		
				jqCheckInjection : { depends : function() { return $("#apcli_key4type").val() == "1" ;	}},
				ApcliKeyAsciiLengthCehcker : { depends : function() { return $("#apcli_key4type").val() == "1" ; }},
				jqCheckHex : { depends : function() { return $("#apcli_key4type").val() == "0" ;	}},
				ApcliKeyHexLengthCehcker : { depends : function() { return $("#apcli_key4type").val() == "0" ;	}}
			}
		},		
		errorPlacement: function (error, element) { 
			//error.insertAfter(element);
			if ($(element).attr('id') =="apcli_key1") error.insertAfter($("#apcli_key1type")[0]);
			else if ($(element).attr('id') =="apcli_key2") error.insertAfter($("#apcli_key2type")[0]);
			else if ($(element).attr('id') =="apcli_key3") error.insertAfter($("#apcli_key3type")[0]);
			else if ($(element).attr('id') =="apcli_key4") error.insertAfter($("#apcli_key4type")[0]);
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

	jQuery.extend(jQuery.validator.messages, {
		required : ""
	});
	
} );

function changeMode()
{
	
	if ($(":radio[name=opMode]:checked").val() == "3")
	{
		$("#apcliTable").show();
		$("#apcliSatus").show();
	}
	else
	{
		$("#apcliTable").hide();
		$("#apcliSatus").hide();
	}
}

function showApCliStatus()
{
	var status = "<% getApCliStatus(); %>";
	if (status == "Disconnected") document.write(_("apci disconnected"));
	else  document.write(status);
}
</script>
</head>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("apcli.asp"); </script>
	<h1 id="apClientTitle">AP Client Feature</h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "apClientIntroduction"> You could configure AP Client parameters here. </font> 
	</div>
	<div id = "blank"> </div>


	<form method=post name=wireless_apcli id="wireless_apcli" action="/goform/wirelessApcli">
	<table>
	<caption id="apcliBasciSetting" >WIFI</caption>
	<tr>
		<th id="apcliOPMode">Operation Mode</th>
		<td>
			<input type="radio" name="opMode" id="opMode" value="1" onClick="changeMode()"><label for="opMode" id="oModeG">AP </label>&nbsp;&nbsp;
			<input type="radio" name="opMode" id="opMode1" value="3" onClick="changeMode()"><label for="opMode1" id="oModeA">AP Client</label>&nbsp;&nbsp;
		</td>
	</tr>
	<tr id="apcliSatus">
		<th id = "apCliIP">Ap Client IP</th>
		<td> <script type="text/javascript">showApCliStatus();</script> </td>
	</tr>
	</table>
	
	<div id="apcliTable">
	<div id = "blank"> </div>
	<table >
	<caption id = "apCliParams"> AP Client Parameters</caption>
	<tr> 
		<th id="apCliSSID" colspan="2" >SSID</th>
		<td><input type=text name="apcli_ssid" id="apcli_ssid" size=20 maxlength=32 value="<% getCfgToHTML(1, "ApCliSsid"); %>"></td>
	</tr>
	<tr> 
		<th id="apCliSecMode" colspan="2">Security Mode</th>
		<td>
			<select name="apcli_mode" id="apcli_mode" size="1" onchange="SecurityModeSwitch(); EncryptModeSwitch();">
			<option value="OPEN">OPEN</option>
			<option value="SHARED">SHARED</option>
			<option value="WPAPSK">WPAPSK</option>
			<option value="WPA2PSK">WPA2PSK</option>
			</select>
		</td>
	</tr>
	<tr id="div_apcli_enc">
		<th id="apCliEncType" colspan="2">Encryption Type</th>
		<td>
			<select name="apcli_enc" id="apcli_enc" size="1" onchange="EncryptModeSwitch()">
			</select>
		</td>
	</tr>
	

	<tr id="div_apcli_default_key">
		<th id="apCliWepDef" colspan="2">WEP Default Key</th>
		<td>
			<select name="apcli_default_key" id="apcli_default_key" size="1">
			<option value="1">Key 1</option>
			<option value="2">Key 2</option>
			<option value="3">Key 3</option>
			<option value="4">Key 4</option>
			</select>
		</td>
	</tr>	
	<tr id="div_apcli_key1">
		<th class="width_70" id = "apCliWEPKey" rowspan="4"> WEP Keys </th>
		<th class="width_80" id = "apCliWEPKey1" > WEP Key 1 : </th>
		<td>
			<input name="apcli_key1" id="apcli_key1" maxlength="26" value="<% getCfgGeneral(1, "ApCliKey1Str"); %>">
			<select id="apcli_key1type" name="apcli_key1type" onchange="KeyTypeSwitch(1)"> 
			<option value="1">ASCII</option>
			<option value="0">Hex</option>
			</select>
		</td>
	</tr>
	
	<tr id="div_apcli_key2">
		<th class="width_80" id = "apCliWEPKey2" > WEP Key 2 : </th>
		<td>
			<input name="apcli_key2" id="apcli_key2" maxlength="26" value="<% getCfgGeneral(1, "ApCliKey2Str"); %>">
			<select id="apcli_key2type" name="apcli_key2type" onchange="KeyTypeSwitch(2)"> 
			<option value="1">ASCII</option>
			<option value="0">Hex</option>
			</select>
		</td>
	</tr>
	<tr id="div_apcli_key3">
		<th class="width_80" id = "apCliWEPKey3" > WEP Key 3 : </th>
		<td>
			<input name="apcli_key3" id="apcli_key3" maxlength="26" value="<% getCfgGeneral(1, "ApCliKey3Str"); %>">
			<select id="apcli_key3type" name="apcli_key3type" onchange="KeyTypeSwitch(3)"> 
			<option value="1">ASCII</option>
			<option value="0">Hex</option>
			</select>
		</td>
	</tr>
	<tr id="div_apcli_key4">
		<th class="width_80" id = "apCliWEPKey4" > WEP Key 4 : </th>
		<td>
			<input name="apcli_key4" id="apcli_key4" maxlength="26" value="<% getCfgGeneral(1, "ApCliKey4Str"); %>">
			<select id="apcli_key4type" name="apcli_key4type" onchange="KeyTypeSwitch(4)"> 
			<option value="1">ASCII</option>
			<option value="0">Hex</option>
			</select>
		</td>
	</tr>
	<tr id="div_apcli_wpapsk"> 
		<th colspan="2" id="apcliPassPhrase">Pass Phrase</th>
		<td><input type=text name="apcli_wpapsk" id="apcli_wpapsk" size=20 maxlength=64 value=""></td>
	</tr>
	</table>
	</div>

	<div id = "blank" class="error" name="add" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" id="apcliApply" type=submit value="Apply"> 
	<input class = "btn" id="apcliCancel"  type=reset  value="Cancel" onClick="window.location.reload()">
	</form>  

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

