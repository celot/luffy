<html>
<head>
<title id = "mainTitle"> <% getModelName(); %> Management </title>
<meta http-equiv="content-type" content="text/html" charset="UTF-8">
<meta http - equiv = "Cache-Control" content = "No-Cache"> <meta http - equiv = "Pragma" content = "No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"> </script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate_celot.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>

<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("service");

function isEmailCheck()
{
	var value = ($("#UPSMode").val() == "Enable") && $("input:checkbox[name=chkAlarm]").eq(1).is(":checked") ; 
	return value;
}

$(document).ready(function(){ 
	initTranslation();
	PageInit(); 

	var validateRule = $("#UPSSettings").validate({
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
			upsExtPowerPeriod : {
				required :  function() { 
					return ($("#UPSMode").val() == "Enable") && $("input:checkbox[id=Vlevel1]").is(":checked"); 
				},
				number: true,
				minlength : 1,
				min: 10,
				max: 3600
			},
			upsservers: {
				required :  function() { 
					return ($("#UPSMode").val() == "Enable") && $("input:checkbox[name=chkAlarm]").eq(0).is(":checked") ; 
				},
				minlength : 1,
				maxString : {	param : 128 }
			},
			upsservers1: {
				required :  false,
				minlength : 0,
				maxString : {	param : 128 }
			},
			upsserverport : {
				required : function() { 
					return ($("#UPSMode").val() == "Enable") && $("input:checkbox[name=chkAlarm]").eq(0).is(":checked") ;  
				},
				number: true,
				minlength : 1
			},
			upsserverport1 : {
				required : false,
				number: true,
				minlength : {
					depends: function() { 
						var port = $("#upsserverport1").val();
						if(port=="") return 0;
						return 1;
					}
				}
			},
			upssmtp : {
				required : true,
				minlength : 1,
				maxString : {	param : 128 }
			},
			upssmtp_port : {
				required : true,
				number: true,
				minlength : 1
			},
			upssmtp_login : {
				required : function(){
					return ($("#UPSMode").val() == "Enable") && $("input:checkbox[name=chkAlarm]").eq(1).is(":checked") && $("input:checkbox[id=upssmtp_auth]").is(":checked");  
				},
				minlength : 1,
				maxString : {	param : 128 }
			},
			upssmtp_passwd : {
				required : function(){
					return ($("#UPSMode").val() == "Enable") && $("input:checkbox[name=chkAlarm]").eq(1).is(":checked") && $("input:checkbox[id=upssmtp_auth]").is(":checked");    
				},
				minlength : 1,
				maxString : {	param : 128 }
			},
			upsmsendn : {
				required : true,
				minlength : 1,
				maxString : {	param : 128 }
			},
			upsmsendm : {
				required : true,
				email : true,
				maxString : {	param : 128 }
			},
			upsmreceiver1 : {
				required : true,
				email : true,
				maxString : {	param : 128 }
			},
			upsmreceiver2 : {
				required : false,
				email : {
					depends: function() { 
						var receiver = $("#upsmreceiver2").val();
						if(receiver=="") return false;
						return true;
					}
				},
				maxString : {	param : 128 }
			},
			upsmreceiver3 : {
				required : false,
				email : {
					depends: function() { 
						var receiver = $("#upsmreceiver3").val();
						if(receiver=="") return false;
						return true;
					}
				},
				maxString : {	param : 128 }
			},
			upsmreceiver4 : {
				required : false,
				email : {
					depends: function() { 
						var receiver = $("#upsmreceiver4").val();
						if(receiver=="") return false;
						return true;
					}
				},
				maxString : {	param : 128 }
			},
			upsmmodule : {
				required : true,
				minlength : 1,
				maxString : {	param : 40 }
			},
			upsmsubjectbat : {
				required : true,
				minlength : 1,
				maxString : {	param : 128 }
			},
			upsmsubjectoff : {
				required : true,
				minlength : 1,
				maxString : {	param : 128 }
			},
			upsmsubjecton : {
				required : true,
				minlength : 1,
				maxString : {	param : 128 }
			},
			upsmcontext : {
				required : true,
				minlength : 1
			},
			upsmsinterval : {
				required : true,
				number: true,
				minlength : 1,
				min: 0,
				max: 99
			},
			upsmsretry : {
				required : true,
				number: true,
				minlength : 1,
				min: 0,
				max: 9
			}
		},
		submitHandler :function(form){
			var errors = this.numberOfInvalids();
			if (errors) {
				$("div.error[name=add] span").html(_("alert rule number exceeded"));
				$("div.error[name=add] span").show();
			} else {
				$("div.error[name=add] span").hide();

				if ($("input:checkbox[name=chkAlarm]").eq(0).is(":checked")) document.UPSSettings.UPSAlarm.value |= 2;
				if ($("input:checkbox[name=chkAlarm]").eq(1).is(":checked")) document.UPSSettings.UPSAlarm.value |= 4;
				
				form.submit();
			}			
		}
	});	

	$('#upsCancel').click(function() { 
		validateRule.resetForm(); 
		$("div.error[name=add] span").hide();
		PageInit(); 
	});
	
});

function initTranslation()
{
	$("#upsTitle").html(_("ups title"));
	$("#upsIntroduction").html(_("ups introduction"));
	$("#upsUps").html(_("ups ups"));
	$("#upsModeT").html(_("ups mode"));
	$("#upsDisable").html(_("ups disable"));
	$("#upsEnable").html(_("ups enable"));
	$("#upsAlarm").html(_("ups alarm"));
	$("#upsANetwork").html(_("ups alarm net"));
	$("#upsAMail").html(_("ups alarm mail"));
	$("#upsLevel").html(_("ups level"));
	$("#upsExternal").html(_("ups external"));
	$("#upsLowBatt").html(_("ups lowbatt"));
	$("#upsBadBatt").html(_("ups badbatt"));
	$("#upsCustomWarningVoltTitle").html(_("ups customWarningVoltTitle"));
	$("#upsSms").html(_("ups sms"));
	$("#upsPhone").html(_("ups phone"));
	$("#upsNetwork").html(_("ups network"));
	$("#thUpsExtPowerPeriod").html(_("ups ext port period"));
	$("#upsExtPowerPeriodSec").html(_("ups ext port period sec"));
	$("#upsServerT").html(_("ups sever"));
	$("#upsServerT1").html(_("ups sever1"));
	$("#upsMail").html(_("ups mail setup"));
	$("#upsMServer").html(_("ups mail server"));
	$("#upsMSmtp").html(_("ups mail smtp"));
	$("#upsMPort").html(_("ups mail port"));
	$("#upsMSecu").html(_("ups mail secu"));
	$("#upsMUseAuth").html(_("ups mail auth"));
	$("#mailUseAuth").html(_("ups mail auth_u"));
	$("#upsMLogin").html(_("ups mail login"));
	$("#upsMPass").html(_("ups mail pw"));
	$("#upsMSend").html(_("ups mail sender"));
	$("#upsMSendN").html(_("ups mail sendn"));
	$("#upsMSendM").html(_("ups mail sendm"));
	$("#upsMRecv").html(_("ups mail receiver"));
	$("#upsMRecv1").html(_("ups mail receiver1"));
	$("#upsMRecv2").html(_("ups mail receiver2"));
	$("#upsMRecv3").html(_("ups mail receiver3"));
	$("#upsMRecv4").html(_("ups mail receiver4"));
	$("#upsMMsg").html(_("ups mail msg"));
	$("#upsMModule").html(_("ups mail module"));
	$("#upsMSubjectBat").html(_("ups mail sub_bat"));
	$("#upsMSubjectOff").html(_("ups mail sub_off"));
	$("#upsMSubjectOn").html(_("ups mail sub_on"));
	$("#upsMText").html(_("ups mail context"));
	$("#upsMRelease").html(_("ups mail release"));
	$("#upsMSretry").html(_("ups mail send_r"));
	$("#upsMSInterval").html(_("ups mail send_i"));
	$("#upsMLog").html(_("ups mail log"));
	$("#upsNetInterface0").html(_("service interface0"));
	$("#upsNetInterface1").html(_("service interface1"));
	$("#upsNetInterface2").html(_("service interface2"));
	$("#upsNetInterface3").html(_("service interface3"));
	$("#upsNetInterface4").html(_("service interface4"));
	$("#upsNetInterface5").html(_("service interface5"));
	$("#thUpsEmailInterface").html(_("service directserial interface"));
	$("#upsEmailInterface0").html(_("service interface0"));
	$("#upsEmailInterface1").html(_("service interface1"));
	$("#upsEmailInterface2").html(_("service interface2"));
	$("#upsEmailInterface3").html(_("service interface3"));
	$("#upsEmailInterface4").html(_("service interface4"));
	$("#upsEmailInterface5").html(_("service interface5"));
	$("#upsmmin").html(_("ups mail minute"));

	$("#upsApply").val(_("service apply"));
	$("#upsCancel").val(_("service cancel"));
	$("#upsBMlog").val(_("ups mail view log"));
}

function UPSTypeSet()
{
	$("#tableSms").hide();	
	$("#Vlevel2").hide();
	$("#upsLowBatt").hide();
	$("#Vlevel3").hide();
	$("#upsBadBatt").hide();
	
	if(document.UPSSettings.chkAlarm[0].checked) 
	{
		$("#tableNetwork").show();
	}
	else 
	{
		$("#tableNetwork").hide();	
	}
	
	if(document.UPSSettings.chkAlarm[1].checked)	//e-mail // bbanzzu_d2
	{
		$("#tableMail").show();
		mAuthChanged();
	}
	else $("#tableMail").hide();

	changeExternalPower();
}

function UPSinit()
{
	var upsvolt1 = '<% getUPSVolt1(); %>';
	var upsvolt2 = '<% getUPSVolt2(); %>';
	var upsvolt3 = '<% getUPSVolt3(); %>';
	var upsvolt4 = '<% getUPSVolt4(); %>';
	var upsCustomWarningVoltIndex = '<% getUPSCustomVolt(); %>';
	var upsExternalPowerPeriodVal = '<% getUPSExternPowerPeriod(); %>';
	
	var snumber = '<% getUPSNum(); %>';
	var serveip = '<% getUPSServer(); %>';
	var serveport = '<% getUPSServerPort(); %>';
	var serveip1 = '<% getUPSServer1(); %>';
	var serveport1 = '<% getUPSServerPort1(); %>';
	
	var upsalarm =  '<% getUPSAlarm(); %>';
	var UPSSmtp = "<% getCfgGeneral(1, "UPSSmtp"); %>";
	var UPSSmtpSecu = "<% getCfgGeneral(1, "UPSSmtpSecu"); %>";
	var UPSSmtpPort = "<% getCfgGeneral(1, "UPSSmtpPort"); %>";
	var UPSSmtpAuth = "<% getCfgGeneral(1, "UPSSmtpAuth"); %>";
	var UPSSmtpLogin = "<% getCfgGeneral(1, "UPSSmtpLogin"); %>";
	var UPSSmtpPass = "<% getCfgGeneral(1, "UPSSmtpPass"); %>";
	var UPSMSendN = "<% getCfgGeneral(1, "UPSMSendN"); %>";
	var UPSMSendM = "<% getCfgGeneral(1, "UPSMSendM"); %>";
	var UPSMRecv1 = "<% getCfgGeneral(1, "UPSMRecv1"); %>";
	var UPSMRecv2 = "<% getCfgGeneral(1, "UPSMRecv2"); %>";
	var UPSMRecv3 = "<% getCfgGeneral(1, "UPSMRecv3"); %>";	
	var UPSMRecv4 = "<% getCfgGeneral(1, "UPSMRecv4"); %>";
	var UPSModule = "<% getCfgGeneral(1, "UPSModule"); %>";
	var UPSMSubBat = "<% getCfgGeneral(1, "UPSMSubBat"); %>";
	var UPSMSubOff = "<% getCfgGeneral(1, "UPSMSubOff"); %>";
	var UPSMSubOn = "<% getCfgGeneral(1, "UPSMSubOn"); %>";
	var UPSMSendR = "<% getCfgGeneral(1, "UPSMSendR"); %>";
	var UPSMSendI = "<% getCfgGeneral(1, "UPSMSendI"); %>";

	var upsEmailInterface = "<% getCfgGeneral(1, "upsEmailInterface"); %>";


	 if (upsEmailInterface != "") 
		document.UPSSettings.upsEmailInterface.options.selectedIndex = parseInt(upsEmailInterface);
	 else 
	 	document.UPSSettings.upsEmailInterface.options.selectedIndex = 0;

	$("#upsnumbers").val(snumber);
	$("#upsservers").val(serveip);
	$("#upsservers1").val(serveip1);
	$("#upsserverport").val(serveport);
	$("#upsserverport1").val(serveport1);

	$("#upsExtPowerPeriod").val(upsExternalPowerPeriodVal);
	
	if(upsvolt1=="1") $("input:checkbox[name=Vlevel1]").attr("checked", true);
	else $("input:checkbox[name=Vlevel1]").attr("checked", false);
		
	if(upsvolt2=="1") $("input:checkbox[name=Vlevel2]").attr("checked", true);		
	else $("input:checkbox[name=Vlevel2]").attr("checked", false);

	if(upsvolt3=="1") $("input:checkbox[name=Vlevel3]").attr("checked", true);
	else $("input:checkbox[name=Vlevel3]").attr("checked", false);

	if(upsvolt4=="1") $("input:checkbox[name=Vlevel4]").attr("checked", true);
	else $("input:checkbox[name=Vlevel4]").attr("checked", false);

	$("#UPSAlarm").val(upsalarm);
	$("#upssmtp").val(UPSSmtp);
	
	if(UPSSmtpAuth=="1") $("input:checkbox[id=upssmtp_auth]").attr("checked", true);
	else $("input:checkbox[id=upssmtp_auth]").attr("checked", false);

  	if(UPSSmtpSecu == "TLS") document.UPSSettings.upsmsecurity.options.selectedIndex = 1;
	else if(UPSSmtpSecu == "SSL") document.UPSSettings.upsmsecurity.options.selectedIndex = 2;
	else document.UPSSettings.upsmsecurity.options.selectedIndex = 0;

	$("#upssmtp_port").val(UPSSmtpPort);
	$("#upssmtp_login").val(UPSSmtpLogin);
	$("#upssmtp_passwd").val(UPSSmtpPass);
	$("#upsmsendn").val(UPSMSendN);
	$("#upsmsendm").val(UPSMSendM);
	$("#upsmreceiver1").val(UPSMRecv1);
	$("#upsmreceiver2").val(UPSMRecv2);
	$("#upsmreceiver3").val(UPSMRecv3);
	$("#upsmreceiver4").val(UPSMRecv4);
	$("#upsmmodule").val(UPSModule);
	$("#upsmsubjectbat").val(UPSMSubBat);
	$("#upsmsubjectoff").val(UPSMSubOff);
	$("#upsmsubjecton").val(UPSMSubOn);
	$("#upsmsretry").val(UPSMSendR);
	$("#upsmsinterval").val(UPSMSendI);

	if (upsCustomWarningVoltIndex != "") 
		document.UPSSettings.upsCustomWarningVoltIndex.options.selectedIndex = parseInt(upsCustomWarningVoltIndex);
	 else 
	 	document.UPSSettings.upsCustomWarningVoltIndex.options.selectedIndex = 0;
	
	if(upsalarm & 0x02)	$("input:checkbox[name=chkAlarm]").eq(0).attr("checked", true);
	else $("input:checkbox[name=chkAlarm]").eq(0).attr("checked", false);

	if(upsalarm & 0x04)	$("input:checkbox[name=chkAlarm]").eq(1).attr("checked", true);
	else $("input:checkbox[name=chkAlarm]").eq(1).attr("checked", false);
}


function updateCustomWarningVoltForm()
{

	if($("input:checkbox[name=Vlevel4]").is(":checked") )
	{
		$("#upsCustomWarningVoltIndex").show();
	}
	else
	{
		$("#upsCustomWarningVoltIndex").hide();
	}
	
}
function autoUPSSwitch()
{
	if (document.UPSSettings.UPSMode.options.selectedIndex == 1)
	{
		$("#UPSmethod").show();
		$("#UPSVlevel").show();
		UPSTypeSet();
	}
	else
	{
		$("#UPSmethod").hide();
		$("#UPSVlevel").hide();
		$("#tableSms").hide();
		$("#tableNetwork").hide();
		$("#tableMail").hide();
		$("#trExternalPowerPeriod").hide();
	}
	updateCustomWarningVoltForm();
	
}

function updateState()
{
	var UPSMode = '<% getUPSMode(); %>';

	UPSinit();
    	if(UPSMode == "Enable"){
		document.UPSSettings.UPSMode.options.selectedIndex = 1;
		$("#UPSmethod").show();
		$("#UPSVlevel").show();
		$("#trExternalPowerPeriod").show();
		UPSTypeSet();
	}
	else
	{
		document.UPSSettings.UPSMode.options.selectedIndex = 0;
		$("#UPSmethod").hide();
		$("#UPSVlevel").hide();
		$("#trExternalPowerPeriod").hide();
		$("#tableSms").hide();
		$("#tableNetwork").hide();
		$("#tableMail").hide();
	}
}

function setAlarm(type)
{
	var tableName;
	
	 if(type==0)
	{
		tableName ="tableNetwork";
	}
	else if(type==1)
	{
		tableName ="tableMail";
	}
	else
	{
		return;
	}
	if(	/*!document.UPSSettings.chkAlarm[0].checked && */ // bbanzzu_d2
		!document.UPSSettings.chkAlarm[0].checked && 
		!document.UPSSettings.chkAlarm[1].checked)
	{
		document.UPSSettings.chkAlarm[type].checked = true;
		return;
	}

	tableName = "#" + tableName;
	
	if(document.UPSSettings.chkAlarm[type].checked) $(tableName).show();	
	else $(tableName).hide();	
}

function changeExternalPower()
{
	if(document.UPSSettings.Vlevel1.checked)
	{
		$("#trExternalPowerPeriod").show();
	}
	else
	{
		$("#trExternalPowerPeriod").hide();
	}
}

function mAuthChanged()
{
	if(document.UPSSettings.upssmtp_auth.checked)
	{
		document.getElementById('upsMServer').rowSpan = 7;  
		$("#trMLogin").show();
		$("#trMPasswd").show();
		$("[name=upssmtp_auth]").val("1");
	}
	else
	{
		document.getElementById('upsMServer').rowSpan = 5; 
		$("#trMLogin").hide();
		$("#trMPasswd").hide();
		$("[name=upssmtp_auth]").val("0");
	}
	
}

function open_upslog_window()
{
	window.open("upslog.asp","UPSLog","toolbar=no,location=yes,scrollbars=yes,resizable=no,width=640,height=480");
}

function PageInit()
{	
	updateState();
	updateCustomWarningVoltForm();
}
</script>
</head>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("ups_set.asp"); </script>

	<h1 id="upsTitle"> UPS Configuration </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "upsIntroduction"> You could setup UPS configuration. </font> 
	</div>
	<div id = "blank"> </div>

	<form method=post name="UPSSettings" id="UPSSettings" action="/goform/SetSystemUPS2">
	<table>
	<caption id = "upsUps"> UPS </caption>
	<tr id = "USPUse">
		<th id="upsModeT"> UPS Mode </th>
		<td>
			<select name="UPSMode" id="UPSMode"  size="1" onChange="autoUPSSwitch();">
			<option value="Disable" id = "upsDisable">Disable</option>
			<option value="Enable" id = "upsEnable">Enable</option>
	   		</select>	   			
		</td>
	</tr>

	<tr id = "UPSmethod">
		<th id="upsAlarm"> Alarm Type </th>
		<td>   	
			<input type="hidden" name="UPSAlarm" value='0'>
			<!-- bbanzzu_d2 -->
			<input name="chkAlarm" id="chkAlarm" type="checkbox" value="upsNetwork" onClick = "setAlarm(0)"><label for="chkAlarm"  id="upsANetwork"> Network </label> &nbsp;
			<input name="chkAlarm" id="chkAlarm1" type="checkbox" value="upsMail" onClick = "setAlarm(1)"><label for="chkAlarm1" id="upsAMail"> E-Mail </label> &nbsp;
		</td>
	</tr>
	<tr id = "UPSVlevel">
		<th id="upsLevel"> Alarm Level </th>
		<td>
			<input name="Vlevel1" id="Vlevel1" value="1" type="checkbox" onClick="changeExternalPower()" ><label for="Vlevel1" id="upsExternal"> Ejected Ext. </label> &nbsp;
			<input name="Vlevel2" id="Vlevel2" value="1" type="checkbox"><label for="Vlevel2"  id="upsLowBatt"> Low Battery </label> &nbsp;
			<input name="Vlevel3" id="Vlevel3" value="1" type="checkbox"><label for="Vlevel3"  id="upsBadBatt"> Bad Battery </label> &nbsp;
			

			<br>
			<input name="Vlevel4" id="Vlevel4" value="1" type="checkbox" onClick = "updateCustomWarningVoltForm()"><label for="Vlevel4"  id="upsCustomWarningVoltTitle"> Warning voltage </label> &nbsp;
			<select name="upsCustomWarningVoltIndex" id="upsCustomWarningVoltIndex"  size="1" >
			<option value="0" id="upsCustomWarningVoltIndex0">4.1V</option>
			<option value="1" id="upsCustomWarningVoltIndex1">4.0V</option>
			<option value="2" id="upsCustomWarningVoltIndex2">3.9V</option>
			<option value="3" id="upsCustomWarningVoltIndex3">3.8V</option>
			<option value="4" id="upsCustomWarningVoltIndex4">3.7V</option>
			</select>
		</td>
	</tr>

	<tr id = "trExternalPowerPeriod">
		<th  class="width_80" id="thUpsExtPowerPeriod" name="thUpsExtPowerPeriod"> Issued grace period</th>
		<td>
	   		<input name="upsExtPowerPeriod" id="upsExtPowerPeriod" type="text" size=5 maxlength = 4 > &nbsp; <label for=upsExtPowerPeriod id="upsExtPowerPeriodSec">Sec</label>
		</td>
	</tr>

	</table>
	<div id = "blank"> </div>

	<table id=tableSms>
	<caption id = "upsSms"> SMS</caption>
	<tr id = "upsnumber">
		<th id="upsPhone"> Phone Number </th>
		<td>
	   		<input name="upsnumbers" id="upsnumbers" type="text" size="15"> &nbsp;
		</td>
	</tr>
	</table>

	<table id=tableNetwork>
	<caption id = "upsNetwork"> Server Setup </caption>

	<tr id = "upsserver">
		<th id="upsServerT">Server Addr./Port(Target1) </th>
		<td>
	   		<input name="upsservers" id="upsservers" type="text" size=48 maxlength = 128 > &nbsp;
	   		<input name="upsserverport" id="upsserverport" type="text" size="5" maxlength = 5 >
		</td>
	</tr>
	<tr id = "upsserver1">
		<th id="upsServerT1"> Server Addr./Port(Target2)</th>
		<td>
	   		<input name="upsservers1" id="upsservers1" type="text" size=48 maxlength = 128 > &nbsp;
	   		<input name="upsserverport1" id="upsserverport1" type="text" size="5" maxlength = 5 >
		</td>
	</tr>
	</table>

	<table id=tableMail>
	<caption id = "upsMail"> Mail Setup </caption>
	<tr>
		<th class="width_70" id="upsMServer" rowspan="7"> Server </th>  
		<th id="thUpsEmailInterface"> Interface </th>
		<td>
			<select name="upsEmailInterface" id="upsEmailInterface"  size="1" >
			<option value="0" id="upsEmailInterface0">WWAN(Domain. 1)/WAN</option>
			<option value="1" id="upsEmailInterface1">WWAN(Domain. 2)</option>
			</select>
		</td>
	</tr>
	<tr>		
		<th class="width_80" id="upsMSmtp"> Server(SMTP) </th>
		<td>
	   		<input name="upssmtp" id="upssmtp" type="text" size=48 maxlength = 128 >
		</td>
	</tr>
	<tr>
		<th  class="width_80" id="upsMPort"> Port </th>
		<td>
	   		<input name="upssmtp_port" id="upssmtp_port" type="text" size=5 maxlength = 5 >
		</td>
	</tr>
	<tr>
		<th class="width_80" id="upsMSecu"> Security </th>
		<td>
			<select name="upsmsecurity" size="1">
			<option value="NONE">No Security</option>
			<option value="TLS">TLS</option>
			<option value="SSL">SSL</option>
	   		</select>	   			
		</td>
	</tr>
	<tr>
		<th  class="width_80" id="upsMUseAuth"> Auth </th>  
		<td>
	   		<input name="upssmtp_auth" id="upssmtp_auth" value="1" type="checkbox" onClick="mAuthChanged()"><label for=upssmtp_auth id="mailUseAuth">Use Auth</label>
		</td>
	</tr>
	<tr id="trMLogin">
		<th  class="width_80" id="upsMLogin"> Login </th>
		<td>
	   		<input name="upssmtp_login" id="upssmtp_login" type="text" size=48>
		</td>
	</tr>
	<tr id="trMPasswd">
		<th  class="width_80" id="upsMPass"> Password </th>
		<td>
	   		<input name="upssmtp_passwd" id="upssmtp_passwd" type="text" size=48>
		</td>
	</tr>
	<tr>
		<th class="width_70" id="upsMSend" rowspan="2"> Sender </th>
		<th class="width_80" id="upsMSendN"> Name </th>
		<td>
	   		<input name="upsmsendn" id="upsmsendn" type="text" size=48>
		</td>
	</tr>
	<tr>		
		<th class="width_80" id="upsMSendM"> Mail </th>
		<td>
	   		<input name="upsmsendm" id="upsmsendm" type="text" size=48>
		</td>
	</tr>
	<tr>
		<th class="width_70" id="upsMRecv" rowspan="4"> Receiver </th>
		<th class="width_80" id="upsMRecv1"> Receiver1 </th>
		<td>
	   		<input name="upsmreceiver1" id="upsmreceiver1" type="text" size=48>
		</td>
	</tr>
	<tr>		
		<th class="width_80" id="upsMRecv2"> Receiver2 </th>
		<td>
	   		<input name="upsmreceiver2" id="upsmreceiver2" type="text" size=48>
		</td>
	</tr>
	<tr>
		<th class="width_80" id="upsMRecv3"> Receiver3 </th>
		<td>
	   		<input name="upsmreceiver3" id="upsmreceiver3" type="text" size=48>
		</td>
	</tr>
	<tr>
		<th class="width_80" id="upsMRecv4"> Receiver4 </th>
		<td>
	   		<input name="upsmreceiver4" id="upsmreceiver4" type="text" size=48>
		</td>
	</tr>	
	<tr>
		<th class="width_70" id="upsMMsg" rowspan="5"> Message </th>
		<th class="width_80" id="upsMModule"> Module name </th>
		<td>
	   		<input name="upsmmodule" id="upsmmodule" type="text" size=48>
		</td>
	</tr>
	<tr>
		<th class="width_80" id="upsMSubjectBat"> Subject(Bat) </th>
		<td>
	   		<input name="upsmsubjectbat" id="upsmsubjectbat" type="text" size=48>
		</td>
	</tr>
	<tr>
		<th class="width_80" id="upsMSubjectOff"> Subject(Off) </th>
		<td>
	   		<input name="upsmsubjectoff" id="upsmsubjectoff" type="text" size=48>
		</td>
	</tr>
	<tr>	
		<th class="width_80" id="upsMSubjectOn"> Subject(On) </th>
		<td>
	   		<input name="upsmsubjecton" id="upsmsubjecton" type="text" size=48>
		</td>
	</tr>
	<tr>
		<th class="width_80" id="upsMText"> Context </th>
		<td>
	   		<textarea name="upsmcontext" id="upsmcontext" cols="50" rows="7" value="" wrap="off"><% getCfgGeneral(1, "UPSMContext"); %></textarea>
		</td>
	</tr>
	<tr>
		<th class="width_70" id="upsMRelease" rowspan="2"> Release </th>
		<th class="width_80" id="upsMSretry"> Send Retry </th>
		<td>
	   		<input name="upsmsretry" id="upsmsretry" type="text" size=1 value="3" maxlength = 1 >
		</td>
	</tr>
	<tr>
		<th class="width_80" id="upsMSInterval"> Send Interval </th>
		<td>
	   		<input name="upsmsinterval" id="upsmsinterval" type="text" size=2 value="10" maxlength = 2 > &nbsp; <font id="upsmmin"> Min </font>
		</td>
	</tr>
	<tr>
		<th id="upsMLog" colspan="2"> Log </th>
		<td>
	   		<input class = "btn_white" type = "button" id="upsBMlog"value = "View Log"  onClick = "open_upslog_window()">&nbsp;&nbsp;
		</td>
	</tr>
	</table>

	<div id = "blank" class="error" name="add" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" id="upsApply" value = "Apply" name="addups" >
	<input class = "btn" type = "button" id="upsCancel"value = "Cancel">
	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

