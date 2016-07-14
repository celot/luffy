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

<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("wireless");

$(document).ready(function(){ 
	initTranslation();	
	initAll(); 

	$.validator.addMethod('WEPKeyAscii', function(value, element) {
		if(this.optional(element)) return true;
		if(value.length != 5 && value.length != 13) return false;
		var len = value.length;
		for (var i=0; i<value.length; i++) {
			if ( value.charAt(i) == '\r' || value.charAt(i) == '\n' || value.charAt(i) == ';' || value.charAt(i) == ','){ return false; }
			else continue;
		}
		return true;
	});
	$.validator.addMethod('WEPKeyHex', function(value, element) {
		if(this.optional(element)) return true;
		if(value.length != 10 && value.length != 26) return false;
		return value.match("^[0-9a-fA-F]+$");
	});

	var validateRule = $("#security_form").validate({
		rules: {
			wep_key_1: {
				required : function() {return $("#wep_default_key").val()=="1";},
				WEPKeyHex : { depends: function() {return $("#WEP1Select").val()=="0";} },
				WEPKeyAscii : { depends: function() {return $("#WEP1Select").val()=="1";} }
			},
			wep_key_2: {
				required : function() {return $("#wep_default_key").val()=="2";},
				WEPKeyHex : { depends: function() {return $("#WEP2Select").val()=="0";} },
				WEPKeyAscii : { depends: function() {return $("#WEP2Select").val()=="1";} }
			},
			wep_key_3: {
				required : function() {return $("#wep_default_key").val()=="3";},
				WEPKeyHex : { depends: function() {return $("#WEP3Select").val()=="0";} },
				WEPKeyAscii : { depends: function() {return $("#WEP3Select").val()=="1";} }
			},
			wep_key_4: {
				required : function() {return $("#wep_default_key").val()=="4";},
				WEPKeyHex : { depends: function() {return $("#WEP4Select").val()=="0";} },
				WEPKeyAscii : { depends: function() {return $("#WEP4Select").val()=="1";} }
			},
			passphrase: {
				required:  true,
				maxlength:64
			},
			keyRenewalInterval:{
				required: true,
				number: true,
				min : 0,
				max : 9999999
			},
			PMKCachePeriod:{
				required: true,
				number: true,
				min : 1,
				max : 9999
			},
			RadiusServerIP:{
				required: true,
				IP4Checker: true
			},
			RadiusServerPort:{
				required: true,
				number: true,
				min : 1,
				max : 65535
			},
			RadiusServerSecret:{
				required: true
			},
			RadiusServerSessionTimeout:{
				required: true,
				number: true,
				min : 1
			}
		},
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=defaultPol] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=defaultPol] span").show();
			} else {
				$("div.error[name=defaultPol] span").hide();
			}
		},

		submitHandler :function(form){
			if(this.numberOfInvalids())
			{
				return;
			}
			else
			{
				$("div.error[name=defaultPol] span").hide();
				form.submit();
			}
		}
	});

	var validateAddRule = $("#securityap_form").validate({
		rules: {
			newap_text:{
				required: {
					depends:function(){
						var cntAccessPol =  '<% getAccessPolCnt(); %>';
						if(cntAccessPol > 0)
						{
							if(this.value.length == 0)
								return false;
							return true;
						}
						return true;
					}
				},
				MACChecker: 	{
					param: ["<% getWiFiMac("ra0"); %>","<% getLanMac(); %>"],
					depends: true
				}
			}
		},
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addAcessPol] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addAcessPol] span").show();
			} else {
				$("div.error[name=addAcessPol] span").hide();
			}
		},

		submitHandler :function(form){
			if(this.numberOfInvalids()) {
				return;
			}
			else
			{
				$("div.error[name=addAcessPol] span").hide();
				form.submit();
			}
		}
	});


	$(':regex(id, WEP[1-4]Select)').each( function(index, element)  {
		$(element).bind('change', function(){
			var labelId = "#"+$(element).attr('id')+"Label";
			if($(element).val() =="0")
			{
				$(labelId).html(_("Length :")+" 10, 26");
			}
			else 
			{
				
				$(labelId).html(_("Length :")+" 5, 13");
			}
		});
	});	

	$('#secureCancel').click(function() { 
		validateRule.resetForm(); 
		$("div.error[name=defaultPol] span").hide();
		initDefaultPolicy();
	});


	$('#secureApCancel').click(function() { 
		validateAddRule.resetForm(); 
		$("div.error[name=addAcessPol] span").hide();
		initAccessPol();
	});

	$('#apselect').change(function() { 
		validateAddRule.resetForm(); 
		$("div.error[name=addAcessPol] span").hide();
		updateAccessPol();
	});

	$("table[name=AccessPolicy_del] tr td").width(function(index) {
		if(index%6==0) return 42; 
		else if(index%6==1) return 127; 
		else if(index%6==2) return 42; 
		else if(index%6==3) return 127; 
		else if(index%6==4) return 42; 
		else return 127;
	});
	
	$("form[name=securityapdel_form]").submit(function() { 
		if($("input:checkbox[name^=delRule]:checked").length==0){
			$("div.error[name=deleteAccessPol] span").html(_("alert select rule to be delete"));
			$("div.error[name=deleteAccessPol] span").show();
			return false;
		}
		$("div.error[name=deleteAccessPol] span").hide();
		return true;
	});
		
} );


var ht_disallow_tkip = '<% getCfgZero(1, "HT_DisallowTKIP"); %>';
var PhyMode  = '<% getCfgZero(1, "WirelessMode"); %>';

function initTranslation()
{
	$("#securityTitle").html(_("secure ssid title"));
	$("#securityIntroduction").html(_("secure ssid introduction"));
	$("#sp_title").html(_("secure security policy"));
	$("#secureSecureMode").html(_("secure security mode"));
	$("#secureWEP").html(_("secure wep"));
	$("#secureWEPDefaultKey").html(_("secure wep default key"));
	$("#secureWEPDefaultKey1").html(_("secure wep default key1"));
	$("#secureWEPDefaultKey2").html(_("secure wep default key2"));
	$("#secureWEPDefaultKey3").html(_("secure wep default key3"));
	$("#secureWEPDefaultKey4").html(_("secure wep default key4"));
	$("#secureWEPKey").html(_("secure wep key"));
	$("#secureWEPKey1").html(_("secure wep key1"));
	$("#secureWEPKey2").html(_("secure wep key2"));
	$("#secureWEPKey3").html(_("secure wep key3"));
	$("#secureWEPKey4").html(_("secure wep key4"));
	$("#secreWPA").html(_("secure wpa"));
	$("#secureWPAAlgorithm").html(_("secure wpa algorithm"));
	$("#secureWPAPassPhrase").html(_("secure wpa pass phrase"));
	$("#secureWPAKeyRenewInterval").html(_("secure wpa key renew interval"));
	$("#secureWPAPMKCachePeriod").html(_("secure wpa pmk cache period"));
	$("#secureWPAPreAuth").html(_("secure wpa preauth"));
	$("#secureWPAPreAuthDisable").html(_("wireless disable"));
	$("#secureWPAPreAuthEnable").html(_("wireless enable"));
	$("#secure8021XWEP").html(_("secure 8021x wep"));
	$("#secure1XWEP").html(_("secure 1x wep"));
	$("#secure1XWEPDisable").html(_("wireless disable"));
	$("#secure1XWEPEnable").html(_("wireless enable"));
	$("#secureRadius").html(_("secure radius"));
	$("#secureRadiusIPAddr").html(_("secure radius ipaddr"));
	$("#secureRadiusPort").html(_("secure radius port"));
	$("#secureRadiusSharedSecret").html(_("secure radius shared secret"));
	$("#secureRadiusSessionTimeout").html(_("secure radius session timeout"));
	$("#radiusSSTSecond").html(_("secure seconds"));

	$("#renewSecond").html(_("secure seconds"));
	$("#PMKCachePeriodMin").html(_("secure minutes"));

	$("#secureAp").html(_("secure access policy"));
	$("#secureApPol").html(_("secure access policy capable"));
	$("#secureDisable").html(_("wireless disable"));
	$("#secureAllow").html(_("wireless allow"));
	$("#secureReject").html(_("wireless reject"));
	$("#secureApNew").html(_("secure access policy new"));

	if(PhyMode == 6)
	{
		$("#tkipWarningMessage").html(_("wireless tkip warning message1")); 
	}
	else
	{
		$("#tkipWarningMessage").html(_("wireless tkip warning message1") + "<br>&nbsp;&nbsp;" + _("wireless tkip warning message2") ); 
	}

	

	$("#secureApList").html(_("secure ap list"));
	$("[id=securityApNo]").each( function (index, item) { $(item).html( _("secure ap no")); });	
	$("[id=securityApMac]").each( function (index, item) { $(item).html( _("secure ap mac")); });	

	$("#secureApply").val(_("wireless apply"));
	$("#secureCancel").val(_("wireless cancel"));
	$("#secureApApply").val(_("wireless apply"));
	$("#secureApCancel").val(_("wireless cancel"));
	$("#secureDelete").val(_("secure access policy del"));
	$("#secureDelCancel").val(_("wireless cancel"));

}

function updatePolicy()
{
	var security_mode = $("#security_mode").val();
	
	$("#div_wpa").hide();
	$("#div_wpa_algorithms").hide();
	$("#wpa_passphrase").hide();
	$("#wpa_key_renewal_interval").hide();
	$("#wpa_PMK_Cache_Period").hide();
	$("#wpa_preAuthentication").hide();
	
	document.security_form.cipher[0].disabled = true;
	document.security_form.cipher[1].disabled = true;
	document.security_form.cipher[2].disabled = true;
	document.security_form.passphrase.disabled = true;
	document.security_form.keyRenewalInterval.disabled = true;
	document.security_form.PMKCachePeriod.disabled = true;
	document.security_form.PreAuthentication.disabled = true;

	// 802.1x
	$("#div_radius_server").hide();
	$("#div_8021x_wep").hide();
	document.security_form.ieee8021x_wep.disable = true;
	document.security_form.RadiusServerIP.disable = true;
	document.security_form.RadiusServerPort.disable = true;
	document.security_form.RadiusServerSecret.disable = true;	
	document.security_form.RadiusServerSessionTimeout.disable = true;

	$("#div_wep").hide();
	if (security_mode == "OPEN" || security_mode == "SHARED" ||security_mode == "WEPAUTO")
	{
		$("#div_wep").show();
	}
	else if (security_mode == "WPAPSK" || security_mode == "WPA2PSK" || security_mode == "WPAPSKWPA2PSK"){
		$("#div_wpa").show();
		$("#div_wpa_algorithms").show();
		document.security_form.cipher[0].disabled = false;
		document.security_form.cipher[1].disabled = false;

		// deal with TKIP-AES mixed mode
		if(security_mode == "WPA2PSK" || security_mode == "WPAPSKWPA2PSK")
			document.security_form.cipher[2].disabled = false;

		$("#wpa_passphrase").show();
		$("#passphrase").attr("disabled",false);

		$("#wpa_key_renewal_interval").show();		
		document.security_form.keyRenewalInterval.disabled = false;
	}
	else if (security_mode == "WPA" || security_mode == "WPA2" || security_mode == "WPA1WPA2") //wpa enterprise
	{
		$("#div_wpa").show();
		$("#div_wpa_algorithms").show();
		
		document.security_form.cipher[0].disabled = false;
		document.security_form.cipher[1].disabled = false;

		$("#wpa_key_renewal_interval").show();
		$("#keyRenewalInterval").attr("disabled",false);
		$("#div_radius_server").show();
		$("#RadiusServerIP").attr("disabled",false);
		$("#RadiusServerPort").attr("disabled",false);
		$("#RadiusServerSecret").attr("disabled",false);
		$("#RadiusServerSessionTimeout").attr("disabled",false);

		if(security_mode == "WPA2" || security_mode == "WPA1WPA2")
			document.security_form.cipher[2].disabled = false;

		if(security_mode == "WPA2"){
			$("#wpa_preAuthentication").show();		
			$("#PreAuthentication").attr("disabled",false);
			$("#wpa_PMK_Cache_Period").show();
			$("#PMKCachePeriod").attr("disabled",false);
		}
	}
	else if (security_mode == "IEEE8021X"){ // 802.1X-WEP
		$("#div_8021x_wep").show();
		$("#div_radius_server").show();
		$("#ieee8021x_wep").attr("disabled",false);
		$("#RadiusServerIP").attr("disabled",false);
		$("#RadiusServerPort").attr("disabled",false);
		$("#RadiusServerSecret").attr("disabled",false);
		$("#RadiusServerSessionTimeout").attr("disabled",false);
	}


	if(security_mode == "WPA" || security_mode == "WPAPSK")
	{
		if ($(":radio[name=cipher]:checked").val() == "2")
			document.security_form.cipher[1].checked = true;
	}


	if(ht_disallow_tkip == 1 && PhyMode == 6)
	{
		document.security_form.cipher[0].disabled = true;
		document.security_form.cipher[2].disabled = true;
	
		document.security_form.cipher[1].checked = true;
		$("#tkipWarningMessageDiv").show();

	}
	else if(ht_disallow_tkip == 1 && PhyMode == 9)
	{
		if ($(":radio[name=cipher]:checked").val() == "1")	
		{
			$("#tkipWarningMessageDiv").hide();		
		}
		else
		{
			$("#tkipWarningMessageDiv").show();

		}
	}
	else
	{
		$("#tkipWarningMessageDiv").hide();
	}

	
}

function changeEncMode()
{
	
	if(ht_disallow_tkip == 1 && PhyMode == 6)
	{
		document.security_form.cipher[0].disabled = true;
		document.security_form.cipher[2].disabled = true;
	
		document.security_form.cipher[1].checked = true;
		$("#tkipWarningMessageDiv").show();

	}
	else if(ht_disallow_tkip == 1 && PhyMode == 9)
	{
		if ($(":radio[name=cipher]:checked").val() == "1")	
		{
			$("#tkipWarningMessageDiv").hide();		
		}
		else
		{
			$("#tkipWarningMessageDiv").show();

		}
	}
	else
	{
		$("#tkipWarningMessageDiv").hide();
	}
}


function initAll()
{
	initDefaultPolicy();
	initAccessPol();
}

function initDefaultPolicy()
{
	var AuthMode = '<% getCfgNthGeneral(1, "AuthMode", 0); %>';
	var EncrypType = '<% getCfgNthGeneral(1, "EncrypType", 0); %>'; 
	var IEEE8021X = '<% getCfgNthGeneral(1, "IEEE8021X", 0); %>'; 

	var sp_select = document.getElementById("security_mode");

	if(AuthMode .length !=0 && AuthMode == "OPEN" && IEEE8021X == "1")
		AuthMode = "IEEE8021X";	

	if(AuthMode .length==0 || (AuthMode == "OPEN" && EncrypType == "NONE")) 
		AuthMode = "Disable";


	sp_select.options.length = 0;
	sp_select.options[sp_select.length] = new Option(_("wireless disable"),"Disable",false, AuthMode == "Disable");
	sp_select.options[sp_select.length] = new Option("OPENWEP","OPEN",false, AuthMode == "OPEN");
	sp_select.options[sp_select.length] = new Option("SHAREDWEP","SHARED",false, AuthMode == "SHARED");
	sp_select.options[sp_select.length] = new Option("WEPAUTO","WEPAUTO",false, AuthMode == "WEPAUTO");
	sp_select.options[sp_select.length] = new Option("WPA","WPA",false, AuthMode == "WPA");
	sp_select.options[sp_select.length] = new Option("WPA-PSK","WPAPSK",	false, AuthMode == "WPAPSK");
	sp_select.options[sp_select.length] = new Option("WPA2","WPA2",false, AuthMode == "WPA2");
	sp_select.options[sp_select.length] = new Option("WPA2-PSK","WPA2PSK",false, AuthMode == "WPA2PSK");
	sp_select.options[sp_select.length] = new Option("WPAPSKWPA2PSK","WPAPSKWPA2PSK",false, AuthMode == "WPAPSKWPA2PSK");
	sp_select.options[sp_select.length] = new Option("WPA1WPA2","WPA1WPA2",false, AuthMode == "WPA1WPA2");
	sp_select.options[sp_select.length] = new Option("802.1X","IEEE8021X",false, AuthMode == "IEEE8021X");

	initWep();
	initWPA();
	init8021x();
	initRadius();

	updatePolicy();
}

function initWep()
{
	var DefaultKeyID = '<% getCfgNthGeneral(1, "DefaultKeyID", 0); %>';
	var Key1Str = '<% getCfgGeneral(1, "Key1Str1"); %>';
	var Key2Str = '<% getCfgGeneral(1, "Key2Str1"); %>';
	var Key3Str = '<% getCfgGeneral(1, "Key3Str1"); %>';
	var Key4Str = '<% getCfgGeneral(1, "Key4Str1"); %>';
	var Key1Type = '<% getCfgNthGeneral(1, "Key1Type",0); %>';
	var Key2Type = '<% getCfgNthGeneral(1, "Key2Type",0); %>';
	var Key3Type = '<% getCfgNthGeneral(1, "Key3Type",0); %>';
	var Key4Type = '<% getCfgNthGeneral(1, "Key4Type",0); %>';
	var KeyTypes = [Key1Type, Key2Type, Key3Type, Key4Type];

	$("#WEP1").val(Key1Str);
	$("#WEP2").val(Key2Str);
	$("#WEP3").val(Key3Str);
	$("#WEP4").val(Key4Str);
	for(var i=0; i<4;i++) {
		var selName = "#WEP"+(i+1)+"Select";
		var selLabel = selName+"Label";
		if(KeyTypes[i]=="0")	{$(selName).val("0"); $(selLabel).html(_("Length :")+" 10, 26");}
		else {$(selName).val("1"); $(selLabel).html(_("Length :")+" 5, 13");}	
	}
	$("#wep_default_key").val((DefaultKeyID=="1" || DefaultKeyID=="2" ||DefaultKeyID=="3" || DefaultKeyID=="4")?DefaultKeyID:"1");
}

function initWPA()
{
	var EncrypType = '<% getCfgNthGeneral(1, "EncrypType", 0); %>';
	var WPAPSK = '<% getCfgGeneral(1, "WPAPSK1"); %>';
	var PreAuth = '<% getCfgNthGeneral(1, "PreAuth",0); %>';
	var RekeyInterval = '<% getCfgNthGeneral(1, "RekeyInterval",0); %>';
	var PMKCachePeriod = '<% getCfgNthGeneral(1, "PMKCachePeriod",0); %>';
		
	if(EncrypType == "TKIP")
		document.security_form.cipher[0].checked = true;
	else if(EncrypType == "AES")
		document.security_form.cipher[1].checked = true;
	else //if(EncrypType == "TKIPAES")
		document.security_form.cipher[2].checked = true;

	$("#passphrase").val(WPAPSK);
	$("#keyRenewalInterval").val(RekeyInterval);
	$("#PMKCachePeriod").val(PMKCachePeriod);
	
	if(PreAuth == "0")
		document.security_form.PreAuthentication[0].checked = true;
	else
		document.security_form.PreAuthentication[1].checked = true;
}

function init8021x()
{
	var IEEE8021X = '<% getCfgNthGeneral(1, "IEEE8021X", 0); %>';
	var EncrypType = '<% getCfgNthGeneral(1, "EncrypType", 0); %>';
	
	if(IEEE8021X  == "1"){
		if(EncrypType == "WEP")  
			document.security_form.ieee8021x_wep[1].checked = true;
		else
			document.security_form.ieee8021x_wep[0].checked = true;
	}
	else
	{
		document.security_form.ieee8021x_wep[0].checked = true;
	}
}

function initRadius()
{
	var RADIUS_Server = '<% getCfgNthGeneral(1, "RADIUS_Server",0); %>';
	var RADIUS_Port = '<% getCfgNthGeneral(1, "RADIUS_Port",0); %>';
	var RADIUS_Key1 = '<% getCfgNthGeneral(1, "RADIUS_Key1",0); %>';
	var session_timeout_interval  = '<% getCfgNthGeneral(1, "session_timeout_interval",0); %>';
	
	if(RADIUS_Server.length==0) RADIUS_Server="0.0.0.0";
	$("#RadiusServerIP").val(RADIUS_Server);
	$("#RadiusServerPort").val(RADIUS_Port);
	$("#RadiusServerSecret").val(RADIUS_Key1);
	$("#RadiusServerSessionTimeout").val(session_timeout_interval);
}

function updateAccessPol()
{
	var cntAccessPol =  '<% getAccessPolCnt(); %>';
	if( $("#apselect").val() == "0") {
		$("#newap_text").attr("disabled", true);
		$("#divApList").hide();
	}
	else{
		$("#newap_text").attr("disabled", false);
		if(cntAccessPol>0)	$("#divApList").show();
		else $("#divApList").hide();
	}
}

function initAccessPol()
{
	var accessPolicy  = '<% getCfgZero(1, "AccessPolicy0"); %>';
	if(accessPolicy.length) $("#apselect").val(accessPolicy);
	else $("#apselect").val(0);
	$("#newap_text").val("");

	updateAccessPol();
}

function showAccessPolList()
{
	var accessControlList  = '<% getCfgGeneral(1, "AccessControlList0"); %>';

	var aplist = new Array;
	if(accessControlList.length != 0)
	{
		aplist = accessControlList.split(";");
		for(var j=0; j<aplist.length; j+=3)
		{
			if(j<aplist.length && aplist[j].length)
			{
				document.write("<tr>");
				document.write("<td> <label for=delRule"+(j)+">" + (j+1) +"</label>"); 
				document.write("<input type=checkbox name=delRule"+(j)+">");	
				document.write("</td>"); 
				document.write("<td id=newap_" +j + ">"); 
				document.write(aplist[j]);
				document.write("</td>");
			}
			else
			{
				break;
			}

			if(j+1<aplist.length && aplist[j+1].length)
			{
				document.write("<td> <label for=delRule"+(j+1)+">" + (j+2) +"</label>"); 
				document.write("<input type=checkbox name=delRule"+(j+1)+">");	
				document.write("</td>"); 
				document.write("<td id=newap_" +(j+1) + ">"); 
				document.write(aplist[j+1]);
				document.write("</td>");
			}
			else
			{
				document.write("<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>");
				break;
			}

			if(j+2<aplist.length && aplist[j+2].length)
			{
				document.write("<td> <label for=delRule"+(j+2)+">" + (j+3) +"</label>"); 
				document.write("<input type=checkbox name=delRule"+(j+2)+">");	
				document.write("</td>"); 
				document.write("<td id=newap_" +(j+2) + ">"); 
				document.write(aplist[j+2]);
				document.write("</td></tr>");
			}
			else
			{
				document.write("<td>&nbsp;</td><td>&nbsp;</td></tr>");
				break;
			}
		}
	}
}
</script>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("security.asp"); </script>

	<h1 id="securityTitle"> Wireless Security/Encryption Settings </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "securityIntroduction">Setup the wireless security and encryption to prevent from unauthorized access and monitoring.</font> 
	</div>
	<div id = "blank"> </div>
	
	<form method="post" name="security_form" id="security_form" action="/goform/APSecurityDefault">
	<table>
	<caption id = "sp_title"> Security Policy </caption>
	<tr>
		<th id = "secureSecureMode"> Security Mode </th>
		<td>
			<select name="security_mode" id="security_mode" size="1" onchange="updatePolicy()">
                    	<!-- ....Javascript will update options.... -->
                    </select>
		</td>
	</tr>
	</table>
	<br>

	<!-- WEP -->
	<table id="div_wep"  name="div_wep">
	<caption id = "secureWEP"> Wire Equivalence Protection (WEP) </caption>
	<tr>
		<th id = "secureWEPDefaultKey" colspan="2"> Default Key </th>
		<td>
			<select name="wep_default_key" id="wep_default_key" size="1">
                        <option value="1" id="secureWEPDefaultKey1">Key 1</option>
                        <option value="2" id="secureWEPDefaultKey2">Key 2</option>
                        <option value="3" id="secureWEPDefaultKey3">Key 3</option>
                        <option value="4" id="secureWEPDefaultKey4">Key 4</option>
                    </select>
		</td>
	</tr>
	<tr>
		<th class="width_70" id = "secureWEPKey" rowspan="4"> WEP Keys </th>
		<th class="width_80" id = "secureWEPKey1" > WEP Key 1 : </th>
		<td> <input name="wep_key_1" id="WEP1" maxlength="26" value=""> 
			<select id="WEP1Select" name="WEP1Select"> 
                        <option value="1">ASCII</option>
                        <option value="0">Hex</option>
                    </select>
                    <label id=WEP1SelectLabel> </label>
		</td>
	</tr>
	<tr>
		<th class="width_80" id = "secureWEPKey2" > WEP Key 2 : </th>
		<td> <input name="wep_key_2" id="WEP2" maxlength="26" value="">
			<select id="WEP2Select" name="WEP2Select">
                        <option value="1">ASCII</option>
                        <option value="0">Hex</option>
                    </select>
                    <label id=WEP2SelectLabel> </label>
		</td>
	</tr>
	<tr>
		<th class="width_80" id = "secureWEPKey3" > WEP Key 3 : </th>
		<td> <input name="wep_key_3" id="WEP3" maxlength="26" value=""> 
			<select id="WEP3Select" name="WEP3Select">
                        <option value="1">ASCII</option>
                        <option value="0">Hex</option>
                    </select>
                    <label id=WEP3SelectLabel> </label>
		</td>
	</tr>
	<tr>
		<th class="width_80" id = "secureWEPKey4" > WEP Key 4 : </th>
		<td> <input name="wep_key_4" id="WEP4" maxlength="26" value="">
			<select id="WEP4Select" name="WEP4Select">
                        <option value="1">ASCII</option>
                        <option value="0">Hex</option>
                    </select>
                    <label id=WEP4SelectLabel> </label>
		</td>
	</tr>
	</table>

	<!-- WPA -->
	<table id="div_wpa" name="div_wpa">
	<caption id = "secreWPA"> WPA</caption>
	<tr id="div_wpa_algorithms" name="div_wpa_algorithms">
		<th id = "secureWPAAlgorithm" > WPA Algorithms </th>
		<td> 
			<input name="cipher" id="cipher0" value="0" type="radio" onClick="changeEncMode()"><label for=cipher0> TKIP &nbsp; </label>
			<input name="cipher" id="cipher1" value="1" type="radio" onClick="changeEncMode()"><label for=cipher1>AES &nbsp;</label>
			<input name="cipher" id="cipher2" value="2" type="radio" onClick="changeEncMode()"><label for=cipher2>TKIPAES &nbsp;</label>
			
			<div id = "tkipWarningMessageDiv"> 
			&nbsp;&nbsp;<font  id="tkipWarningMessage">TKIP is disallowed on 11N. </font>
			</div>
			
		</td>
	</tr>
	<tr id="wpa_passphrase" name="wpa_passphrase">
		<th id = "secureWPAPassPhrase" > Pass Phrase </th>
		<td> 
			<input name="passphrase" id="passphrase" size="28" maxlength="64" value="">
		</td>
	</tr>
	<tr id="wpa_key_renewal_interval" name="wpa_key_renewal_interval">
		<th id = "secureWPAKeyRenewInterval" > Key Renewal Interval </th>
		<td> 
			<input name="keyRenewalInterval" id="keyRenewalInterval" size="6" maxlength="7" value="3600"> <font  id="renewSecond"> seconds </font> &nbsp;&nbsp;(0 ~ 9999999)
		</td>
	</tr>
	<tr id="wpa_PMK_Cache_Period" name="wpa_PMK_Cache_Period">
		<th id = "secureWPAPMKCachePeriod" > PMK Cache Period </th>
		<td> 
			<input name="PMKCachePeriod" id="PMKCachePeriod" size="4" maxlength="4" value=""> <font id="PMKCachePeriodMin"> minute </font>
		</td>
	</tr>
	<tr id="wpa_preAuthentication" name="wpa_preAuthentication">
		<th id = "secureWPAPreAuth" > Pre-Authentication </th>
		<td> 
			<input name="PreAuthentication" id="PreAuthentication0" value="0" type="radio"><label for=PreAuthentication0 id="secureWPAPreAuthDisable">Disable &nbsp;</label>
			<input name="PreAuthentication" id="PreAuthentication1" value="1" type="radio"><label for=PreAuthentication1 id="secureWPAPreAuthEnable">Enable &nbsp;</label>
		</td>
	</tr>
	</table>

	<!-- 802.1x -->
	<!-- WEP  -->
	<table id="div_8021x_wep" name="div_8021x_wep">
	<caption id = "secure8021XWEP"> 802.1x WEP</caption>
	<tr>
		<th id = "secure1XWEP" > WEP </th>
		<td> 
			<input name="ieee8021x_wep" id="ieee8021x_wep0" value="0" type="radio"><label for=ieee8021x_wep0 id="secure1XWEPDisable">Disable &nbsp; </label>
			<input name="ieee8021x_wep" id="ieee8021x_wep1" value="1" type="radio"><label for=ieee8021x_wep1 id="secure1XWEPEnable">Enable</label>
		</td>
	</tr>
	</table>
	<br>
	
	<table id="div_radius_server" name="div_radius_server">
	<caption id = "secureRadius"> Radius Server</caption>
	<tr>
		<th id = "secureRadiusIPAddr" > IP Address </th>
		<td> 
			<input name="RadiusServerIP" id="RadiusServerIP" size="16" maxlength="32" value="">
		</td>
	</tr>
	<tr>
		<th id = "secureRadiusPort" > Port </th>
		<td> 
			<input name="RadiusServerPort" id="RadiusServerPort" size="5" maxlength="5" value="">
		</td>
	</tr>
	<tr>
		<th id = "secureRadiusSharedSecret" > Shared Secret </th>
		<td> 
			<input name="RadiusServerSecret" id="RadiusServerSecret" size="16" maxlength="64" value="">
		</td>
	</tr>
	<tr>
		<th id = "secureRadiusSessionTimeout" > Session Timeout </th>
		<td> 
			<input name="RadiusServerSessionTimeout" id="RadiusServerSessionTimeout" size="3" maxlength="4" value="0">  &nbsp;&nbsp; <font  id="radiusSSTSecond"> seconds </font>
		</td>
	</tr>
	</table>
	<div id = "blank" class="error" name="defaultPol" align="center">	<span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "secureApply">
	<input class = "btn" type = "button" value = "Cancel" id = "secureCancel">
	</form>

	<div id = "blank"> </div>
	<form method="post" name="securityap_form" id="securityap_form" action="/goform/APAddAccessPolicy">
	<table id=AccessPolicy_add>
	<caption id="secureAp"></caption>
	<tr>
		<th id="secureApPol"> </th>
		<td>				
			<select name=apselect id=apselect size=1>
				<option value=0 id="secureDisable" >Disable</option> 
				<option value=1 id="secureAllow">Allow</option>
				<option value=2 id="secureReject">Reject</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="secureApNew">Add a station Mac:</th>
		<td> <input name=newap_text id=newap_text size=16 maxlength=20> </td>
	<tr>
	</table>
	
	<div id = "blank" class="error" name="addAcessPol" align="center"><span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "secureApApply">
	<input class = "btn" type = "button" value = "Cancel" id = "secureApCancel">
	</form>

	<div id=divApList>
	<div id = "blank"> </div>
	<form method="post" name="securityapdel_form" id="securityapdel_form" action="/goform/APDeleteAccessPolicy">
	<table name=AccessPolicy_del>
	<caption id="secureApList">Station Mac List</caption>
	<tr>
		<td bgcolor=#E8F8FF id="securityApNo"> No.</td>
		<td bgcolor=#E8F8FF id="securityApMac"> Mac</td>
		<td bgcolor=#E8F8FF id="securityApNo"> No.</td>
		<td bgcolor=#E8F8FF id="securityApMac"> Mac</td>
		<td bgcolor=#E8F8FF id="securityApNo"> No.</td>
		<td bgcolor=#E8F8FF id="securityApMac"> Mac</td>
	</tr>
	<script language="JavaScript" type="text/javascript"> showAccessPolList(); </script>				
	</table>
	<div id = "blank" class="error" name="deleteAccessPol" align="center">	<span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "secureDelete" >
	<input class = "btn" type = "reset" value = "Cancel" id = "secureDelCancel">
	</form>
	</div>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

