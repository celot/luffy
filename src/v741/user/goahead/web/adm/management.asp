<html>
<head>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<META http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate_celot.min.js"></script>
<script type="text/javascript" src="/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>
<title><% getModelName(); %> Management</title>

<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("admin");

var greenapb = '<% getGAPBuilt(); %>';
//var snortb = '<% getSnortBuilt(); %>';$(document).ready(function(){ initValue(); } );
var http_request = false;

$(document).ready(function(){ 
	initTranslation();
	initValue(); 

	var validateAdminRule = $("#Adm").validate({
		rules: {
			admuser: {
				required : true,
				minlength : 1
			},
			admpass: {
				required : true,
				minlength : 1
			}
		},		
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addAdmin] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addAdmin] span").show();
			} else {
				$("div.error[name=addAdmin] span").hide();
			}
		},
		submitHandler :function(form){
			var errors = this.numberOfInvalids();
			if (errors) {
				$("div.error[name=addAdmin] span").html(_("alert rule number exceeded"));
				$("div.error[name=addAdmin] span").show();
			} else {
				$("div.error[name=addAdmin] span").hide();
				form.submit();
			}			
		}
	});

	$('#manAdmCancel').click(function() { 
		validateAdminRule.resetForm(); 
		$("div.error[name=addAdmin] span").hide();
		initAdminSettings();
	});

		
	var validateNtpRule = $("#NTP").validate({		
		rules: {
			NTPSync : {
				required: {
					depends:function(){
						return $("#NTPServerIP").val() !="";
					}
				},
				number : true,				
				minlength : {
					param : 1,
					depends : function() {
						return $("#NTPServerIP").val() !="";
					}
				},
				min : 1,
				max : 300
			}
		},
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addNtp] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addNtp] span").show();
			} else {
				$("div.error[name=addNtp] span").hide();
			}
		},
		errorPlacement: function (error, element) { 
			if ($(element).attr('id') =="NTPSync")
			{
				error.insertAfter(element); 
			}
		},
		submitHandler :function(form){
			var errors = this.numberOfInvalids();
			if (errors) {
				$("div.error[name=addNtp] span").html(_("alert rule number exceeded"));
				$("div.error[name=addNtp] span").show();
			} else {
				$("div.error[name=addNtp] span").hide();
				form.submit();
			}			
		}
	});

	jQuery.extend(jQuery.validator.messages, {
		required : "",
		max : _("jquery message enter less than or equal to 300")
	});

	$('#manNTPCancel').click(function() { 
		validateNtpRule.resetForm(); 
		$("div.error[name=addNtp] span").hide();
		initNtpSettings();
	});


	var validateDDNSRule = $("#DDNS_Form").validate({		
		rules: {
			Account : {
				required: {
					depends:function(){
						return ($("#DDNSProvider option").index($("#DDNSProvider option:selected")) !=  0);
					}
				}, 
				minlength : 1
			},
			Password : {
				required: {
					depends:function(){
						return ($("#DDNSProvider option").index($("#DDNSProvider option:selected")) !=  0);
					}
				}, 
				minlength : 1
			},
			DDNS : {
				required: {
					depends:function(){
						return ($("#DDNSProvider option").index($("#DDNSProvider option:selected")) !=  0);
					}
				}, 
				minlength : 1
			},
			DDNSServer : {
				required: {
					depends:function(){
						return ($("#DDNSProvider option").index($("#DDNSProvider option:selected")) ==  5);
					}
				}, 
				minlength : 1
			}
		},		
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addDDNS] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addDDNS] span").show();
			} else {
				$("div.error[name=addDDNS] span").hide();
			}
		},
		submitHandler :function(form){
			var errors = this.numberOfInvalids();
			if (errors) {
				$("div.error[name=addDDNS] span").html(_("alert rule number exceeded"));
				$("div.error[name=addDDNS] span").show();
			} else {
				$("div.error[name=addDDNS] span").hide();
				form.submit();
			}			
		}
	});

	$('#manDDNSCancel').click(function() { 
		validateDDNSRule.resetForm(); 
		$("div.error[name=addNtp] span").hide();
		initDDNSSetting();
	});
} );

function DDNSupdateState()
{
	var ddnsServer = "<% getCfgGeneral(1, "DDNSServer"); %>";
	var ddnsAccount = "<% getCfgGeneral(1, "DDNSAccount"); %>";
	var ddnsPassword = "<% getCfgGeneral(1, "DDNSPassword"); %>";
	var ddnsVal =  "<% getCfgGeneral(1, "DDNS"); %>";
	var ddnsUrl =  "<% getCfgGeneral(1, "DDNSUrl"); %>";
	var ddnsOption = "<% getCfgGeneral(1, "DDNSOption"); %>";
	
	$("#manDDNSServer").hide();
	$("#manDDNSUrl").hide();
	$("#manDDNSOption").hide();

	if(document.DDNS_Form.DDNSProvider.options.selectedIndex != 0)
	{
		$("#Account").val(ddnsAccount);
		$("#Password").val(ddnsPassword);
		$("#DDNS").val(ddnsVal);
		
		$("#trDnsAccount").show();
		$("#trDnsPasswd").show();
		$("#trDdns").show();
		
		if(document.DDNS_Form.DDNSProvider.options.selectedIndex==5)
		{
			$("#DDNSServer").val(ddnsServer);
			$("#DDNSUrl").val(ddnsUrl);
			$("#DDNSOption").val(ddnsOption);
			
			$("#manDDNSServer").show();		
			$("#manDDNSUrl").show();
			$("#manDDNSOption").show();
		}
	}
	else
	{
		$("#trDnsAccount").hide();
		$("#trDnsPasswd").hide();
		$("#trDdns").hide();
	}
}

function initTranslation()
{
	$("#manTitle").html(_("man title"));
	$("#manIntroduction").html(_("man introduction"));
	$("#manAdmSet").html(_("man admin setting"));
	$("#manAdmAccount").html(_("man admin account"));
	$("#manAdmPasswd").html(_("man admin passwd"));
	$("#manWebPort").html(_("man web port"));
	$("#manCLIPort").html(_("man cli port"));
	$("#manNTPCurrentTime").html(_("man ntp current time"));	
	$("#manAdmWatchDog").html(_("man admin watchdog"));
	$("#manAdmwatchdogEnabled").html(_("admin enable"));
	$("#manAdmwatchdogDisabled").html(_("admin disable"));	
	$("#manNTPSet").html(_("man ntp setting"));
	$("#manNTPTimeZone").html(_("man ntp timezone"));
	$("#manNTPMidIsland").html(_("man ntp mid island"));
	$("#manNTPHawaii").html(_("man ntp hawaii"));
	$("#manNTPAlaska").html(_("man ntp alaska"));
	$("#manNTPPacific").html(_("man ntp pacific"));
	$("#manNTPMountain").html(_("man ntp mountain"));
	$("#manNTPArizona").html(_("man ntp arizona"));
	$("#manNTPCentral").html(_("man ntp central"));
	$("#manNTPMidUS").html(_("man ntp mid us"));
	$("#manNTPIndianaEast").html(_("man ntp indiana east"));
	$("#manNTPEastern").html(_("man ntp eastern"));
	$("#manNTPAtlantic").html(_("man ntp atlantic"));
	$("#manNTPBolivia").html(_("man ntp bolivia"));
	$("#manNTPGuyana").html(_("man ntp guyana"));
	$("#manNTPBrazilEast").html(_("man ntp brazil east"));
	$("#manNTPMidAtlantic").html(_("man ntp mid atlantic"));
	$("#manNTPAzoresIslands").html(_("man ntp azores islands"));
	$("#manNTPGambia").html(_("man ntp gambia"));
	$("#manNTPEngland").html(_("man ntp england"));
	$("#manNTPCzechRepublic").html(_("man ntp czech republic"));
	$("#manNTPGermany").html(_("man ntp germany"));
	$("#manNTPPoland").html(_("man ntp poland"));
	$("#manNTPTunisia").html(_("man ntp tunisia"));
	$("#manNTPGreece").html(_("man ntp greece"));
	$("#manNTPSouthAfrica").html(_("man ntp south africa"));
	$("#manNTPIraq").html(_("man ntp iraq"));
	$("#manNTPMoscowWinter").html(_("man ntp moscow winter"));
	$("#manNTPArmenia").html(_("man ntp armenia"));
	$("#manNTPPakistan").html(_("man ntp pakistan"));
	$("#manNTPBangladesh").html(_("man ntp bangladesh"));
	$("#manNTPThailand").html(_("man ntp thailand"));
	$("#manNTPChinaCoast").html(_("man ntp chinacoast"));
	$("#manNTPTaipei").html(_("man ntp taipei"));
	$("#manNTPSingapore").html(_("man ntp singapore"));
	$("#manNTPAustraliaWA").html(_("man ntp australia wa"));
	$("#manNTPJapan").html(_("man ntp japan"));
	$("#manNTPKorean").html(_("man ntp korean"));
	$("#manNTPGuam").html(_("man ntp guam"));
	$("#manNTPAustraliaQLD").html(_("man ntp australia qld"));
	$("#manNTPSolomonIslands").html(_("man ntp solomon islands"));
	$("#manNTPFiji").html(_("man ntp fiji"));
	$("#manNTPNewZealand").html(_("man ntp newzealand"));
	$("#manNTPServer").html(_("man ntp server"));
	$("#manNTPEx").html(_("man ntp ex"));
	$("#manNTPSync").html(_("man ntp sync"));
	$("#manNTPSyncStatus").html(_("man ntp sync status"));
	$("#manDDNSOptionHead").html(_("man ddns optionhead"));
	$("#manDdnsSet").html(_("man ddns setting"));
	$("#DdnsProvider").html(_("man ddns provider"));
	$("#manDdnsNone").html(_("man ddns none"));
	$("#manDDNSServerHead").html(_("man ddns ddnsServer"));
	$("#manDdnsAccount").html(_("man ddns account"));
	$("#manDdnsPasswd").html(_("man ddns passwd"));
	$("#manDdns").html(_("man ddns"));
	$("#manCustom").html(_("man custom")); 
	$("#manAdmApply").val(_("admin apply"));
	$("#manAdmCancel").val(_("admin cancel"));
	$("#manNTPApply").val(_("admin apply"));
	$("#manNTPCancel").val(_("admin cancel"));
	$("#manDDNSApply").val(_("admin apply"));
	$("#manDDNSCancel").val(_("admin cancel"));
	$("#manDdns").html(_("man admin ddns value"));

	$("#manNTPSyncWithHost").val( _("man ntp sync with host"));
}


function initValue()
{
	initAdminSettings();
	initNtpSettings();
	initDDNSSetting();
}

function initAdminSettings()
{
	var user = "<% getCfgGeneral(1, "Login"); %>";
	var pass = "<% getCfgGeneral(1, "Password"); %>";
	var watchdogb = "<% getWatchDogBuilt(); %>";
	var webPortNv = "<% getCfgGeneral(1, "webServerPort"); %>";	
	var cliPortNv = "<% getCfgGeneral(1, "ctshWaitPort"); %>";

	$("#admuser").val(user);
	$("#admpass").val(pass);	

	if (watchdogb == "1") {
		$("#div_watchdog").show();

		var watchdogcap = "<% getCfgZero(1, "WatchDogEnable"); %>";
		if (watchdogcap == "1") $("input:radio[id=admwatchdog]:radio[value=1]").attr("checked",true);
		else $("input:radio[id=admwatchdog]:radio[value=0]").attr("checked",true);
	
	} else {
		$("#div_watchdog").hide();		
	}

	if(cliPortNv == "2323") $("#cli_port option:eq(0)").attr("selected", "selected");
	else if(cliPortNv == "2333") $("#cli_port option:eq(1)").attr("selected", "selected");
	else if(cliPortNv == "2343") $("#cli_port option:eq(2)").attr("selected", "selected");
	else $("#cli_port option:eq(0)").attr("selected", "selected");

	if (webPortNv == "80") $("#web_port option:eq(0)").attr("selected", "selected");
	else if (webPortNv == "8080") $("#web_port option:eq(1)").attr("selected", "selected");
	else if (webPortNv == "8888") $("#web_port option:eq(2)").attr("selected", "selected");
	else $("#web_port option:eq(0)").attr("selected", "selected");
}

function initNtpSettings()
{
	var dateb = "<% getDATEBuilt(); %>";
	var tz = "<% getCfgGeneral(1, "TZ"); %>";
	var ntpServerIP = "<% getCfgGeneral(1, "NTPServerIP"); %>";
	var ntpSync = "<% getCfgGeneral(1, "NTPSync"); %>";

	if (dateb == "1") $("#div_date").show();
	else $("#div_date").hide();
	showCurrentTime();

	if(tz.length)
	{
		try { $("#time_zone").val(tz); }
		catch(e) { $("#time_zone").val("JST_009"); }
	}
	else
	{
		$("#time_zone").val("JST_009");
	}
	
	$("#NTPServerIP").val(ntpServerIP);
	showNtpStatus();
	$("#NTPSync").val(ntpSync);
}

function showCurrentTime()
{
	var e = document.getElementById("ntpcurrenttime");
	var currentDate  = "<% getCurrentTimeASP(); %>";
	var options = {
	    weekday: "long", year: "numeric", month: "short",
	    day: "numeric", hour: "2-digit", minute: "2-digit", second: "2-digit"
	};

	var s = document.cookie.indexOf("language=");
	var ee= document.cookie.indexOf(";", s);
	var lang = "jp";
	var format = "ja-JP";
	if (s != -1) 
	{
		if (ee == -1)
			lang = document.cookie.substring(s+9);
		else
			lang = document.cookie.substring(s+9, ee);
	}
	if(lang == "en")
	{
		format = "en-US";
	}
	else if(lang == "kor")
	{
		format = "ko-KR";
	}
	else
	{
		format = "ja-JP";
	}
	
	if(currentDate.length>0)
	{
		try
		{
			var d = new Date(currentDate);
			e.value  = d.toLocaleDateString(format,options);
		}
		catch(e)
		{
			var d = new Date();
			e.value = d.toLocaleDateString(format,options);
		}
	}
	else
	{
		var d = new Date();
		e.value = d.toLocaleDateString(format,options);
	}
}

function initDDNSSetting()
{
	var ddns_provider = "<% getDDNSProvider(); %>";   
	var ddnsb = "<% getDDNSBuilt(); %>"; 
	var service_portsb = "<% getServicePortsBuilt(); %>";
	 
	if (ddnsb == "1")
	{
 		$("#div_ddns").show(); 		
		if (ddns_provider == "none") $("#DDNSProvider option:eq(0)").attr("selected", "selected");
		else if (ddns_provider == "dyndns.org") $("#DDNSProvider option:eq(1)").attr("selected", "selected");
		else if (ddns_provider == "freedns.afraid.org") $("#DDNSProvider option:eq(2)").attr("selected", "selected");
		else if (ddns_provider == "zoneedit.com") $("#DDNSProvider option:eq(3)").attr("selected", "selected");
		else if (ddns_provider == "no-ip.com") $("#DDNSProvider option:eq(4)").attr("selected", "selected");
		else if (ddns_provider == "custom") $("#DDNSProvider option:eq(5)").attr("selected", "selected");

		DDNSupdateState();
	} 
	else
	{
 		$("#div_ddns").hide();
 	}
}


function syncWithHost()
{
	var currentTime = new Date();

	var seconds = currentTime.getSeconds();
	var minutes = currentTime.getMinutes();
	var hours = currentTime.getHours();
	var month = currentTime.getMonth() + 1;
	var day = currentTime.getDate();
	var year = currentTime.getFullYear();

	var seconds_str = " ";
	var minutes_str = " ";
	var hours_str = " ";
	var month_str = " ";
	var day_str = " ";
	var year_str = " ";

	if(seconds < 10)
		seconds_str = "0" + seconds;
	else
		seconds_str = ""+seconds;

	if(minutes < 10)
		minutes_str = "0" + minutes;
	else
		minutes_str = ""+minutes;

	if(hours < 10)
		hours_str = "0" + hours;
	else
		hours_str = ""+hours;

	if(month < 10)
		month_str = "0" + month;
	else
		month_str = ""+month;

	if(day < 10)
		day_str = "0" + day;
	else
		day_str = day;

 	var tmp = year+"."+month_str+"."+ day_str +"-"+ hours_str+":"+ minutes_str +":"+ seconds_str;

	// later must make format
	$.get( "/goform/NTPSyncWithHost", { syncTime : tmp } ).done(
		function( args ) {
			if(args.length>0) 
			{
				var options = {
				    weekday: "long", year: "numeric", month: "short",
				    day: "numeric", hour: "2-digit", minute: "2-digit", second: "2-digit"
				};

				var s = document.cookie.indexOf("language=");
				var ee= document.cookie.indexOf(";", s);
				var lang = "jp";
				var format = "ja-JP";
				if (s != -1) 
				{
					if (ee == -1)
						lang = document.cookie.substring(s+9);
					else
						lang = document.cookie.substring(s+9, ee);
				}
				if(lang == "en")
				{
					format = "en-US";
				}
				else if(lang == "kor")
				{
					format = "ko-KR";
				}
				else
				{
					format = "ja-JP";
				}
				
				try
				{
					var d = new Date(args);
					$("#ntpcurrenttime").val(d.toLocaleDateString(format,options));
				}
				catch(e){}
			}
	});
}

function greenap_action_switch(index)
{
	var shour_e = eval("document.GreenAP.GAPSHour"+index);
	var sminute_e = eval("document.GreenAP.GAPSMinute"+index);
	var ehour_e = eval("document.GreenAP.GAPEHour"+index);
	var eminute_e = eval("document.GreenAP.GAPEMinute"+index);
	var action_e = eval("document.GreenAP.GAPAction"+index);

	shour_e.disabled = true;
	sminute_e.disabled = true;
	ehour_e.disabled = true;
	eminute_e.disabled = true;

	if (action_e.options.selectedIndex != 0)
	{
		shour_e.disabled = false;
		sminute_e.disabled = false;
		ehour_e.disabled = false;
		eminute_e.disabled = false;
	}
}

function onlyNumber(event) {
	var key = window.event ? event.keyCode : event.which;    

	if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
		|| key  == 35 || key  == 36 || key  == 37 || key  == 39  // ����Ű �¿�,home,end  
		|| key  == 8  || key  == 46 ) // del, back space
	) {
		return true;
	}else {
		return false;
	}    
};

function showNtpStatus()
{
	var e = document.getElementById("SyncStatus");
	var ntpStauts  = "<% mkNtpStatus(); %>";
	var arrayStatus = new Array();
	if(ntpStauts.length>3)
	{
		arrayStatus = ntpStauts.split("-");
	}

	if(arrayStatus.length==2 && arrayStatus[1].length==15)
	{
		var yyyy =  arrayStatus[1].substr(0,2)*1+2000;
		var MM =  arrayStatus[1].substr(2,2)*1-1;
		var dd =  arrayStatus[1].substr(4,2);
		var hh =  arrayStatus[1].substr(6,2);
		var mm =  arrayStatus[1].substr(8,2);
		var ss =  arrayStatus[1].substr(10,2);
		var nnn =  arrayStatus[1].substr(12,3);
		var d;
		try
		{
			d = new Date(yyyy, MM, dd, hh, mm, ss, nnn);
		}
		catch(e)
		{
			d = new Date();
		}
		var options = {
		    weekday: "long", year: "numeric", month: "short",
		    day: "numeric", hour: "2-digit", minute: "2-digit", second: "2-digit"
		};

		var s = document.cookie.indexOf("language=");
		var ee= document.cookie.indexOf(";", s);
		var lang = "jp";
		var format = "ja-JP";
		if (s != -1) 
		{
			if (ee == -1)
				lang = document.cookie.substring(s+9);
			else
				lang = document.cookie.substring(s+9, ee);
		}

		if(lang == "en")
		{
			format = "en-US";
		}
		else if(lang == "kor")
		{
			format = "ko-KR";
		}
		else
		{
			format = "ja-JP";
		}
	
		if(arrayStatus[0] == "11" || arrayStatus[0] == "21") //11--ntp, 21--module
		{
			e.innerHTML  = _("NTP Sycn Succeed.")+ "<br>"
				+_("NTP Sycn :") + "&nbsp;&nbsp;" +  d.toLocaleDateString(format,options);
		}
		else
		{
			e.innerHTML  = _("NTP Sycn Atempted.")+ "<br>"
				+_("NTP SycnA :") + "&nbsp;&nbsp;" + d.toLocaleDateString(format,options);
			
		}
	}
	else
	{
		e.innerHTML  = _("NTP Sycn Failed.");
	}
}


</script>

</head>
<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("management.asp"); </script>

	<h1 id="manTitle">System Management</h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "manIntroduction">You may configure administrator account and password, NTP settings, and Dynamic NTP settings here. </font> 
	</div>
	<div id = "blank"> </div>
	

	<!-- ================= Adm Settings ================= -->
	<form method="post" name="Adm" id="Adm" action="/goform/setSysAdm">
	<table>
	<caption id = "manAdmSet"> Adminstrator Settings </caption>
	<tr>
		<th id="manAdmAccount">Account</th>
		<td><input type="text" style="ime-mode:disabled;" onpaste="return false;" id="admuser" name="admuser" size="16" maxlength="16"</td>
	</tr>
	<tr>
		<th id="manAdmPasswd">Password</th>
		 <td><input id="admpass" name="admpass" style="ime-mode:disabled;" onpaste="return false;" size="16" maxlength="32"></td>
	</tr>
	<tr id="div_watchdog">
		<th id="manAdmWatchDog">WatchDog</th>
		<td>
			<input type="radio" id="admwatchdog" name="admwatchdog" value="1"><font id="manAdmwatchdogEnabled">Enable</font>
			<input type="radio" id="admwatchdog" name="admwatchdog" value="0"><font id="manAdmwatchdogDisabled">Disable</font>
		</td>
	</tr>

	<!-- ================= Service Ports Settings for HITACHI ================= -->
	<tr id="div_web_port">
		<th id="manWebPort">Web port</th>
		<td>
			<select name="web_port" id="web_port">
			<option value="80">80</option>
			<option value="8080">8080</option>
			<option value="8888">8888</option>
			</select>
		</td>
	</tr>
	<tr id="div_cli_port">
		<th id="manCLIPort">CLI port</th>
		<td>
			<select name="cli_port" id="cli_port">
			<option value="2323">2323</option>
			<option value="2333">2333</option>
			<option value="2343">2343</option>
			</select>
		</td>
	</tr>	
	
	</table>
	<div id = "blank" class="error" name="addAdmin" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "manAdmApply">
	<input class = "btn" type = "button" value = "Cancel" id = "manAdmCancel">
	</form>
	<div id = "blank"> </div>

	<!-- ================= NTP Settings ================= -->
	<form method="post" name="NTP" id="NTP" action="/goform/NTP">
	<table>
	<caption id = "manNTPSet"> manNTPSet </caption>
	<tr id="div_date">
		<th id="manNTPCurrentTime">Current Time</th>
		<td>		
			<input size="32" name="ntpcurrenttime" id="ntpcurrenttime" value="" type="text" readonly="1">
			<input class = "btn2_white" type="button" value="Sync with host" id="manNTPSyncWithHost" onClick="syncWithHost()">
		</td>
	</tr>
	<tr>
		<th id="manNTPTimeZone">Time Zone:</th>
		<td>
			<select name="time_zone" id="time_zone">
			<option value="UCT_-11" id="manNTPMidIsland">(GMT-11:00) Midway Island, Samoa</option>
			<option value="UCT_-10" id="manNTPHawaii">(GMT-10:00) Hawaii</option>
			<option value="NAS_-09" id="manNTPAlaska">(GMT-09:00) Alaska</option>
			<option value="PST_-08" id="manNTPPacific">(GMT-08:00) Pacific Time</option>
			<option value="MST_-07" id="manNTPMountain">(GMT-07:00) Mountain Time</option>
			<option value="AZT_-07" id="manNTPArizona">(GMT-07:00) Arizona Time</option>
			<option value="CST_-06" id="manNTPCentral">(GMT-06:00) Central Time</option>
			<option value="UCT_-06" id="manNTPMidUS">(GMT-06:00) Middle America</option>
			<option value="UCT_-05" id="manNTPIndianaEast">(GMT-05:00) Indiana East, Colombia</option>
			<option value="EST_-05" id="manNTPEastern">(GMT-05:00) Eastern Time</option>
			<option value="AST_-04" id="manNTPAtlantic">(GMT-04:00) Atlantic Time, Brazil West</option>
			<option value="UCT_-04" id="manNTPBolivia">(GMT-04:00) Bolivia, Venezuela</option>
			<option value="UCT_-03" id="manNTPGuyana">(GMT-03:00) Guyana</option>
			<option value="EBS_-03" id="manNTPBrazilEast">(GMT-03:00) Brazil East, Greenland</option>
			<option value="NOR_-02" id="manNTPMidAtlantic">(GMT-02:00) Mid-Atlantic</option>
			<option value="EUT_-01" id="manNTPAzoresIslands">(GMT-01:00) Azores Islands</option>
			<option value="UCT_000" id="manNTPGambia">(GMT) Gambia, Liberia, Morocco</option>
			<option value="GMT_000" id="manNTPEngland">(GMT) England</option>
			<option value="MET_001" id="manNTPCzechRepublic">(GMT+01:00) Czech Republic, N</option>
			<option value="MEZ_001" id="manNTPGermany">(GMT+01:00) Germany</option>
			<option value="CET_001" id="manNTPPoland">(GMT+01:00) Poland</option>
			<option value="UCT_001" id="manNTPTunisia">(GMT+01:00) Tunisia</option>
			<option value="EET_002" id="manNTPGreece">(GMT+02:00) Greece, Ukraine, Turkey</option>
			<option value="SAS_002" id="manNTPSouthAfrica">(GMT+02:00) South Africa</option>
			<option value="IST_003" id="manNTPIraq">(GMT+03:00) Iraq, Jordan, Kuwait</option>
			<option value="MSK_003" id="manNTPMoscowWinter">(GMT+03:00) Moscow Winter Time</option>
			<option value="UCT_004" id="manNTPArmenia">(GMT+04:00) Armenia</option>
			<option value="UCT_005" id="manNTPPakistan">(GMT+05:00) Pakistan, Russia</option>
			<option value="UCT_006" id="manNTPBangladesh">(GMT+06:00) Bangladesh, Russia</option>
			<option value="UCT_007" id="manNTPThailand">(GMT+07:00) Thailand, Russia</option>
			<option value="CST_008" id="manNTPChinaCoast">(GMT+08:00) China Coast, Hong Kong</option>
			<option value="CCT_008" id="manNTPTaipei">(GMT+08:00) Taipei</option>
			<option value="SST_008" id="manNTPSingapore">(GMT+08:00) Singapore</option>
			<option value="AWS_008" id="manNTPAustraliaWA">(GMT+08:00) Australia (WA)</option>
			<option value="JST_009" id="manNTPJapan">(GMT+09:00) Japan, Korea</option>
			<option value="KST_009" id="manNTPKorean">(GMT+09:00) Korean</option>
			<option value="UCT_010" id="manNTPGuam">(GMT+10:00) Guam, Russia</option>
			<option value="AES_010" id="manNTPAustraliaQLD">(GMT+10:00) Australia (QLD, TAS,NSW,ACT,VIC)</option>
			<option value="UCT_011" id="manNTPSolomonIslands">(GMT+11:00) Solomon Islands</option>
			<option value="UCT_012" id="manNTPFiji">(GMT+12:00) Fiji</option>
			<option value="NZS_012" id="manNTPNewZealand">(GMT+12:00) New Zealand</option>
		</select>
		</td>
	</tr>
	<tr>
		<th id="manNTPServer">NTP Server</th>
		<td><input type="text" style="ime-mode:disabled;" onpaste="return false;" size="32"  maxlength="64" name="NTPServerIP" id="NTPServerIP">
			<br>&nbsp;<font color="#808080" id="manNTPEx">ex:</font>&nbsp;<font color="#808080">time.windows.com</font>
			<br>&nbsp;&nbsp;<font color="#808080">&nbsp;&nbsp;&nbsp;&nbsp;ntp.jst.mfeed.ad.jp</font>
			<br>&nbsp;&nbsp;<font color="#808080">&nbsp;&nbsp;&nbsp;&nbsp;ntp.nict.jp</font>
		</td>
	</tr>
	<tr id="trNTPStatus">
		<th id="manNTPSyncStatus">NTP Status</th>
		<td id="SyncStatus"></td>
	</tr>
	<tr>
		<th id="manNTPSync">NTP synchronization</th>
		<td><input type="text" size="4" name="NTPSync" id="NTPSync" style="ime-mode:disabled;" onkeydown="return onlyNumber(event)"> </td>
	</tr>
	</table>
	
	<div id = "blank" class="error" name="addNtp" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "manNTPApply">
	<input class = "btn" type = "button" value = "Cancel" id = "manNTPCancel">
	</form>

	<!-- ================= DDNS  ================= -->
	<div id="div_ddns">
	<div id = "blank"> </div>
	<form method="post" name="DDNS_Form" id="DDNS_Form" action="/goform/DDNS">
	<table >
	<caption id = "manDdnsSet"> DDNS Settings </caption>
	<tr>
		<th id="DdnsProvider">Dynamic DNS Provider</th>
		<td>
			<select onChange="DDNSupdateState()" name="DDNSProvider" id="DDNSProvider">
			<option value="none" id="manDdnsNone"> None </option>
			<option value="dyndns.org"> dyndns.org </option>
			<option value="freedns.afraid.org"> freedns.afraid.org </option>
			<option value="zoneedit.com"> www.zoneedit.com </option>
			<option value="no-ip.com"> www.no-ip.com </option>
			<option value="custom"id="manCustom"> custom  </option>
			</select>
		</td>
	</tr>
	<tr id="manDDNSServer">
		<th id="manDDNSServerHead">DDNS Server</th>
		<td><input size="40" maxlength="40" id ="DDNSServer" name="DDNSServer"type="text"> </td>
	</tr>
	<tr id="trDnsAccount">
		<th id="manDdnsAccount">Account</th>
		<td><input size="40" maxlength="40" id="Account" name="Account"type="text"> </td>
	</tr>
	<tr id="trDnsPasswd">
		<th id="manDdnsPasswd">Password</th>
		<td><input size="40" maxlength="40" id="Password" name="Password"type="password"> </td>
	</tr>
	<tr id="trDdns">
		<th id="manDdns">DDNS</th>
		<td><input size="40" maxlength="40" id="DDNS" name="DDNS"type="text"> </td>
	</tr>
	<tr id="manDDNSUrl">
		<th id="manDDNSUrlHead">URL</th>
		<td>
			<textarea style=font-size:9pt maxlength="40" name="DDNSUrl" id="DDNSUrl" cols="60" rows="2" wrap="off"></textarea>
		</td>
	</tr>
	<tr id="manDDNSOption">
		<th id="manDDNSOptionHead">Additional DDNS Options</th>
		<td>
			<textarea style=font-size:9pt maxlength="40" name="DDNSOption" id="DDNSOption" cols="60" rows="3" wrap="off"></textarea>
		</td>
	</tr>
	</table>

	<div id = "blank" class="error" name="addDDNS" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "manDDNSApply">
	<input class = "btn" type = "button" value = "Cancel" id = "manDDNSCancel">
	</form>
	</div>	
	
	<!-- ================= GreenAP ================= -->
<!-- 
	<div id="div_greenap">
	<div id = "blank"> </div>
	<form method="post" name="GreenAP" action="/goform/GreenAP">
	<table>
	<caption id = "manGAPTitle"> Green AP </caption>
	<tr align="center">
		<td id="manGAPTime">Time</td>
		<td id="manGAPAction">Action</td>
	</tr>
	<script language="JavaScript" type="text/javascript">
		for(var j=1;j<=4;j++)
		{
			var item = "<tr align=\"center\"><td><select name=\"GAPSHour"+j+"\">";
			for(var i=0;i<24;i++)
			{
				if (i < 10)
					item += "<option value=\""+i+"\">0"+i+"</option>";
				else
					item += "<option value=\""+i+"\">"+i+"</option>";
			}
			item += "</select>&nbsp;:&nbsp;";
			document.write(item);

			var item = "<select name=\"GAPSMinute"+j+"\">";
			for(var i=0;i<60;i++)
			{
				if (i < 10)
					item += "<option value=\""+i+"\">0"+i+"</option>";
				else
					item += "<option value=\""+i+"\">"+i+"</option>";
			}
			item += "</select>&nbsp;~&nbsp;";
			document.write(item);

			var item = "<select name=\"GAPEHour"+j+"\">";
			for(var i=0;i<24;i++)
			{
				if (i < 10)
					item += "<option value=\""+i+"\">0"+i+"</option>";
				else
					item += "<option value=\""+i+"\">"+i+"</option>";
			}
			item += "</select>&nbsp;:&nbsp;";
			document.write(item);

			var item = "<select name=\"GAPEMinute"+j+"\">";
			for(var i=0;i<60;i++)
			{
				if (i < 10)
					item += "<option value=\""+i+"\">0"+i+"</option>";
				else
					item += "<option value=\""+i+"\">"+i+"</option>";
			}
			item += "</select></td>";
			item += "<td><select name=\"GAPAction"+j+"\" onClick=\"greenap_action_switch('"+j+"')\">";
			item += "<option value=\"Disable\" id=\"manGAPActionDisable"+j+"\">Disable</option>";
			item += "<option value=\"WiFiOFF\">WiFi TxPower OFF</option>";
			item += "<option value=\"TX25\">WiFi TxPower 25%</option>";
			item += "<option value=\"TX50\">WiFi TxPower 50%</option>";
			item += "<option value=\"TX75\">WiFi TxPower 75%</option";
			item += "</select></td></tr>";
			document.write(item);
		}
	</script> 
	</table>

	<div id = "blank"> </div>
	<input class = "btn" type = "submit" value = "Apply" id = "manAdmApply">
	<input class = "btn" type = "reset" value = "Cancel" id = "manAdmCancel"  onClick="window.location.reload()">
	</form>
	</div>
	-->

	<!-- ================= Snort ================= -->
	<!-- 
	<div id="div_snort">
	<form method="post" name="Snort" action="/goform/Snort">
	<table>
	<caption id = "manSnortTitle"> Snort </caption>
	<tr>
		<th id="manSnort">Snort</th>
		<td>
			<select name="SnortSelect" id="SnortSelect">
			<option value="0"> Disable </option>
			<option value="1"> Enable </option>
			</select>
		</td>
	</tr>
	</table>
	<div id = "blank"> </div>

	<input class = "btn" type = "submit" value = "Apply" id = "manAdmApply">
	<input class = "btn" type = "reset" value = "Cancel" id = "manAdmCancel"  onClick="window.location.reload()">
	</form
	</div>>
	-->

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body></html>
