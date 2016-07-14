<html>
<head>
<title id = "mainTitle"> <% getModelName(); %> Management </title>
<meta http - equiv = "Content-type" content = "text/html" charset = "UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<meta http - equiv = "Cache-Control" content = "No-Cache"> <meta http - equiv = "Pragma" content = "No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"> </script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<script language = "JavaScript" type = "text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("admin");
var MAX_RULES = 30;
var http_request = false;

var autoRebootMode = '<% getAutoRebootMode(); %>';
var autoRebootmethod = '<% getAutoRebootmethod(); %>';
var autoEveryDayon = '<% getAutoRebootED(); %>';
var autoRebooHour = '<% getAutoRebootHour(); %>';
var autoRebooHourtr = '<% getAutoRebootHourtr(); %>';
var autoRebooMin = '<% getAutoRebootMin(); %>';
var autoAutoRebootDay = '<% getAutoRebootDay(); %>';

$(document).ready(function(){ 
	initTranslation();
	InitValue(); 
} );

function initTranslation()
{
	$("#rebootTitle").html(_("reboot title")); 
	$("#rebootIntroduction").html(_("reboot introduction")); 
	$("#lApply").val( _("admin apply")); 
	$("#lCancel").val( _("admin cancel")); 
	$("#rebootSettings").html(_("reboot settings")); 
	$("#rebootSettings2").html(_("reboot settings2")); 
	$("#powerRebootT").html(_("reboot powerreboot")); 
	$("#powerRebootNow").val( _("reboot rebootNow")); 
	$("#autoReboot").html(_("reboot autoReboot")); 
	$("#autoEnable").html(_("reboot autoEnable")); 
	$("#autoDisable").html(_("reboot autoDisable")); 
	$("#schedule").html(_("reboot schedule")); 
	$("#autoTime").html(_("reboot autoTime")); 
	$("#everyDay").html(_("reboot everyDay")); 
	$("#dayOfTheWeek").html(_("reboot dayOfWeek")); 
	$("#Sun").html(_("reboot Sun")); 
	$("#Mon").html(_("reboot Mon")); 
	$("#Tue").html(_("reboot Tue")); 
	$("#Wed").html(_("reboot Wed")); 
	$("#Thu").html(_("reboot Thu")); 
	$("#Fri").html(_("reboot Fri")); 
	$("#Sat").html(_("reboot Sat")); 
	$("#bootLog").html(_("reboot log")); 
	$("#bootList").html(_("reboot Log list")); 
	$("#maxRuleCnt").html(_("reboot max Log List"));
}

function CheckPowerReboot()
{
	var now = confirm(_("reboot rebootNow button"));
	if(now == true)
	{
		window.location.href="/menu/saved.asp?retPage=reboot.asp&RebootNow=1";
		return true;
	}
	return false;
}

function autoRebootSwitch()
{
	if (document.SystemRebootSettings.autoRebootSet.options.selectedIndex == 0)
	{
		$("#autoSchedule").show();		
		$("#rebootlog").show();
	}
	else
	{
		$("#autoSchedule").hide();	
		$("#rebootlog").hide();		
	}
}

function everyDayClick()
{
	if (document.SystemRebootSettings.autoEveryDay.checked == true)
	{
		document.SystemRebootSettings.autoDays.disabled = true;
	}
	else
	{
		document.SystemRebootSettings.autoDays.disabled = false;
	}
}

function showBootLog()
{
	var rebootLog = '<% getCfgZero(1, "rebootLog"); %>';
	var logCnt = 0;

	if(rebootLog.length>0)
	{
		var arrLog = new Array();
		arrLog = rebootLog.split(";");

		if(arrLog.length>0)
		{
			for (var i=0; i<arrLog.length; i++) 
			{
				if(arrLog[i].length>10)
				{
					var j;
					j= i+1
					document.write("["+j+"]  "+" "+" "+arrLog[i]);
					document.write("<br>");	
					logCnt = logCnt+1;
					if( logCnt>=MAX_RULES)
						return;
				}
			}
		}
	}

	if(logCnt==0)
	{
		document.write(_("reboot Log list empty"));
	}
}

function PageInit()
{
	var autoRebootMode = '<% getAutoRebootMode(); %>';
	var autoRebooHour = '<% getAutoRebootHour(); %>';
	var autoRebooMin = '<% getAutoRebootMin(); %>';
	var autoEveryDay = '<% getAutoRebootED(); %>';
	var autoAutoRebootDay = '<% getAutoRebootDay(); %>';

	if (autoRebootMode == "Enable") 
	{
		document.SystemRebootSettings.autoRebootSet.options.selectedIndex = 0;
		$("#autoSchedule").show();		
		$("#rebootlog").show();
	}
	else
	{
		document.SystemRebootSettings.autoRebootSet.options.selectedIndex = 1;
		$("#autoSchedule").hide();
		$("#autoSchedule").hide();
	}
	document.SystemRebootSettings.autoTimeHour.options.selectedIndex = parseInt(autoRebooHour,10);
	document.SystemRebootSettings.autoTimeMin.options.selectedIndex = parseInt(autoRebooMin,10);
	
	if(autoEveryDay=="on")
	{
		document.SystemRebootSettings.autoEveryDay.checked = true;
		document.SystemRebootSettings.autoDays.disabled = true;
	}
	else
	{
		document.SystemRebootSettings.autoEveryDay.checked = false;
		document.SystemRebootSettings.autoDays.disabled = false;
	}
	document.SystemRebootSettings.autoDays.options.selectedIndex = parseInt(autoAutoRebootDay,10);
}

function InitValue()
{
	PageInit();
}

</script>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("reboot.asp"); </script>

	<h1 id="rebootTitle"> Reboot Settings </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "rebootIntroduction"> System reboot management.</font> 
	</div>
	<div id = "blank"> </div>

	<table>
	<caption id = "rebootSettings"> Reboot Settings</caption>
	<tr>
		<th id="powerRebootT">System Reboot</th>
		<td>
                        <input type="button" class="btn2_white"  value="Reboot Now" id="powerRebootNow" name="powerReboot" onclick="return CheckPowerReboot()">
		</td>
	</tr>
	</table>
	<div id = "blank"> </div>
	
	<form method="post" name="SystemRebootSettings" action="/goform/SetSystemReboot">
	<table>
	<caption id = "rebootSettings2"> Reboot Settings </caption>
	<tr>
		<th id="autoReboot">Auto Reboot</th>
		<td>
			<select name="autoRebootSet" id="autoRebootSet"  size="1" onChange="autoRebootSwitch();">
			<option value="Enable" id="autoEnable">Enable</option>
			<option value="Disable" id="autoDisable">Disable</option>
			</select>
		</td>
	</tr>
	<tr id="autoSchedule">
		<th id="schedule">Schedule</th>
		<td>
			<font id="autoTime">Time </font> &nbsp;:&nbsp;
				<select name="autoTimeHour" id="autoTimeHour"  size="1">
				<option value="0" id="Hour0">0</option>
				<option value="1" id="Hour1">1</option>
				<option value="2" id="Hour2">2</option>
				<option value="3" id="Hour3">3</option>
				<option value="4" id="Hour4">4</option>
				<option value="5" id="Hour5">5</option>
				<option value="6" id="Hour6">6</option>
				<option value="7" id="Hour7">7</option>
				<option value="8" id="Hour8">8</option>
				<option value="9" id="Hour9">9</option>
				<option value="10" id="Hour10">10</option>
				<option value="11" id="Hour11">11</option>
				<option value="12" id="Hour12">12</option>
				<option value="13" id="Hour13">13</option>
				<option value="14" id="Hour14">14</option>
				<option value="15" id="Hour15">15</option>
				<option value="16" id="Hour16">16</option>
				<option value="17" id="Hour17">17</option>
				<option value="18" id="Hour18">18</option>
				<option value="19" id="Hour19">19</option>
				<option value="20" id="Hour20">20</option>
				<option value="21" id="Hour21">21</option>
				<option value="22" id="Hour22">22</option>
				<option value="23" id="Hour23">23</option>
				</select>
				:
				<select name="autoTimeMin" id="autoTimeMin"  size="1">
				<option value="0" id="Min0">0</option>
				<option value="1" id="Min5">5</option>
				<option value="2" id="Min10">10</option>
				<option value="3" id="Min15">15</option>
				<option value="4" id="Min20">20</option>
				<option value="5" id="Min25">25</option>
				<option value="6" id="Min30">30</option>
				<option value="7" id="Min35">35</option>
				<option value="8" id="Min40">40</option>
				<option value="9" id="Min45">45</option>
				<option value="10" id="Min50">50</option>
				<option value="11" id="Min55">55</option>
				</select>
				<br>
				&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
				<label for="autoEveryDay" id="everyDay">EveryDay</label><input type="checkbox" id="autoEveryDay"  name="autoEveryDay" value="on" onClick="everyDayClick()">
				&nbsp; &nbsp; &nbsp;
				<font id="dayOfTheWeek">Day</font> 
				<select name="autoDays" id="autoDays"  size="1">
				<option value="0" id="Sun">Sun</option>
				<option value="1" id="Mon">Mon</option>
				<option value="2" id="Tue">Tue</option>
				<option value="3" id="Wed">Wed</option>
				<option value="4" id="Thu">Thu</option>
				<option value="5" id="Fri">Fri</option>
				<option value="6" id="Sat">Sat</option>
				</select>
		</td>
	</tr>
	</table>

	<!--	reboot time log -->		
	<div id=rebootlog>
	<div id = "blank"> </div>
	<table>
	<caption id = "bootLog"> Reboot Log </caption>
	<tr>
		<th id="bootList">Reboot Time Log List</th>		
		<td>
			<script language="JavaScript" type="text/javascript"> showBootLog(); </script>
		</td>
	</tr>
	</table>
	<font id="maxRuleCnt">The maximum List :</font>
	</div>
	
	<div id = "blank"> </div>
	<input class = "btn" type = "submit" value = "Apply" id = "lApply" >
	<input class = "btn" type = "button" value = "Cancel" id = "lCancel" onClick = "window.location.reload()">
	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>
