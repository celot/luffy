<html>
<head>
<title id = "mobileDialTitle"> <% getModelName(); %> Management </title>
<meta http - equiv = "Content-type" content = "text/html" charset = "UTF-8">
<meta http - equiv = "Cache-Control" content = "No-Cache"> <meta http - equiv = "Pragma" content = "No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"> </script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<style type='text/css'>
label {
    width:50px;
    padding-top:5px;
    float:left;
}

label.caption {
    padding-top:0px;	
    width:600px;
    float:left;
}

label.caption1 {
    width:600px;
    font-weight: bold;
    font-size:12px;
    color : red;
    float:left;
}
</style>

<script language = "JavaScript" type = "text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("admin");
var http_request = false;

var otasp_s;
var secs;
var timerID = null;
var timerRunning = false;
var timeout = 1;
var delay = 1000; // 1sec
var simtype =  "<% getsimtype(); %>";

$(document).ready(function(){ 
	initTranslation();
	initValue(); 
} );

function InitializeTimer()
{
	secs = timeout;
	StopTheClock();
	StartTheTimer();
}

function StopTheClock()
{
	if(timerRunning)
		clearTimeout(timerID);
		
	timerRunning = false;
}

function StartTheTimer()
{
	if (secs==0)
	{
		StopTheClock();
		timerHandler();
		secs = timeout;
		StartTheTimer();
	}
	else
	{
		self.status = secs
		secs = secs - 1;
		timerRunning = true;
		timerID = self.setTimeout("StartTheTimer()", delay)
	}
}

function makeRequest(url, content, handler) {
	http_request = false;
	if (window.XMLHttpRequest) { // Mozilla, Safari,...
		http_request = new XMLHttpRequest();
		if (http_request.overrideMimeType) {
			http_request.overrideMimeType('text/xml');
		}
	} else if (window.ActiveXObject) { // IE
		try {
			http_request = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try {
			http_request = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e) {}
		}
	}
	if (!http_request) {
		alert('Giving up :( Cannot create an XMLHTTP instance)');
		return false;
	}
	http_request.onreadystatechange = handler;
	http_request.open('POST', url, true);
	http_request.send(content);
}

function alertContents() {

	if (http_request.readyState == 4) {
		if (http_request.status == 200) {

			var res = http_request.responseText;
			if(res.search("OTASt:")!=-1)
			{
				var resStr = res.substr(6);

				if(resStr == 5 || resStr == 8 || resStr == 9)
				{
					document.getElementById('otaprocessstatusid').value =  " (OTASPOK)";
					document.getElementById("contactstateid").value = _("ota otacontract2");
					StopTheClock();
					setDisableElements(false);
					document.getElementById("btnRefreshSP").disabled=true;	

					otasp_s=0;
					document.getElementById("btnRefresh").disabled=true;
					document.getElementById("btnRefresh").className = "btn_white_d";
				}
				else if(resStr == 0 || resStr == 1 || resStr == 2 || resStr == 3 || resStr == 4)
				{
					otasp_s=1;
					document.getElementById("btnRefresh").disabled=false;
					document.getElementById("btnRefresh").className = "btn_white";

					document.getElementById('otaprocessstatusid').value =  _("ota state ing")+" (OTASP"+resStr+")";
					document.getElementById("contactstateid").value = _("ota otacontract1");

				}
				else
				{
					otasp_s=0;
					document.getElementById("btnRefresh").disabled=true;
					document.getElementById("btnRefresh").className = "btn_white_d";

					if(resStr == -1)
						document.getElementById('otaprocessstatusid').value = "OTASP " +" (ERROR"+"UNKNOWN"+")";
					else
						document.getElementById('otaprocessstatusid').value =resStr;
					/*
					if(resStr == -99)
						document.getElementById('otaprocessstatusid').value ="OTASP " +" (ERROR"+"A99"+")";
					else if(resStr == -98)
						document.getElementById('otaprocessstatusid').value ="OTASP " +" (ERROR"+"NO SERVICED"+")";
					else if(resStr == -97)
						document.getElementById('otaprocessstatusid').value = "OTASP " +" (ERROR"+"NO CARRIER"+")";
					else if(resStr == -96)
						document.getElementById('otaprocessstatusid').value = "OTASP " +" (ERROR"+"MODEM Command fail."+")";
					else if(resStr == -88)
						document.getElementById('otaprocessstatusid').value = "OTASP " +" (ERROR"+"A7"+")";
					else
						document.getElementById('otaprocessstatusid').value = "OTASP "+" (ERROR"+resStr+")";
					*/
					document.getElementById("contactstateid").value = _("ota otacontract1");
					StopTheClock();
					setDisableElements(false);				
				}
			}
			else if(res.search("OTASP:")!=-1)
			{
				otasp_s=0;
				//alert( res.substr(6));
				InitializeTimer();;
			}			
		} 
		else 
		{
			;//alert('There was a problem with the request.');
		}
	}
}

function timerHandler()
{
	reflashOtastatus();
}

function initTranslation()
{
	$("#OTATitle").html(_("ota title")); 
	$("#OTAIntroduction").html(_("ota introduction")); 
	$("#OTAStateSetup").html(_("ota statussetup")); 
	$("#OTAcontactState").html(_("ota contactState")); 
	$("#OTAstatus").html(_("ota otastatus")); 
	$("#OTAsimtypesetup").html(_("ota OTAsimtypesetup")); 
	$("#OTAsimtypesetupth").html(_("ota OTAsimtypesetupth")); 
	$("#OTAsimtypeIN").html(_("ota OTAsimtypeIN")); 
	$("#OTAsimtypeEX").html(_("ota OTAsimtypeEX")); 
	$("#OTAcontractSetup").html(_("ota otacontractSetup")); 
	$("#OTAcontractotasp").html(_("ota otacontractotasp")); 
	$("#OTAspwarning1").html(_("ota otacontractotasp warning1")); 
	$("#OTAspwarning2").html(_("ota otacontractotasp warning2")); 
	$("#btnRefresh").val( _("ota refresh")); 
	$("#btnRefreshSP").val( _("ota refreshsp"));
	$("#manSimApply").val( _("admin apply"));	
	$("#manSimCancel").val( _("admin cancel"));
	$("#contactstateid").val(_("ota otacontract1"));	
}


function setDisableElements(disable)
{
	if(disable==true)
	{
		document.getElementById("manSimApply").disabled=true;	
		document.getElementById("manSimCancel").disabled=true;	
		document.getElementById("OTAsimtype").disabled=true;
		document.getElementById("btnRefreshSP").disabled=true;	
		document.getElementById("btnRefreshSP").className = "btn_white_d";
	}
	else
	{
		document.getElementById("manSimApply").disabled=false;	
		document.getElementById("manSimCancel").disabled=false;	
		document.getElementById("OTAsimtype").disabled=false;
		document.getElementById("btnRefreshSP").disabled=false;	
		document.getElementById("btnRefreshSP").className = "btn_white";

	}
}	

function SetOtasp()
{
	var now = confirm(_("ota otacontractotasp warning1"));
	if(now == true)
	{
		otasp_s=1;
		document.getElementById("btnRefresh").disabled=false;
		document.getElementById("btnRefresh").className = "btn_white";
		
		StopTheClock();
		setDisableElements(true);
		makeRequest("/goform/setOTAsp", "n/a", alertContents);
	}
}

function SIMFormCheck()
{
	if(simtype=="1")
	{
		if(document.SimCfg.OTAsimtype.options.selectedIndex == 0)
			return false;
	}
	else if(simtype=="2")
	{
		if(document.SimCfg.OTAsimtype.options.selectedIndex == 1)
			return false;
	}

	return true;
}

function reflashOtastatus()
{
	makeRequest("/goform/getOTAstatusF", "n/a", alertContents);
}

function getOTAstatusasp()
{
        document.getElementById('otaprocessstatusid').value = "------";
}

function getContractstatus()
{
	setDisableElements(true);
	document.getElementById("btnRefresh").disabled=true;
	document.getElementById("btnRefresh").className = "btn_white_d";

	document.getElementById('contactstateid').value =_("ota otacontract0");
	makeRequest("/goform/getOTAcontract", "n/a", handlerContractstatus);
}

function handlerContractstatus()
{
	if(otasp_s==1)
	{
		document.getElementById("btnRefresh").disabled=false;
		document.getElementById("btnRefresh").className = "btn_white";
	}
	setDisableElements(false);
	
	if (http_request.readyState == 4) 
	{
		if (http_request.status == 200)
		{
			var res = http_request.responseText;
			if(res.search("OtaCont:")!=-1)
			{
				var ota = res.substr(8);

				if(ota == "0") 
				{
					document.getElementById("contactstateid").value = _("ota otacontract1");
				}
				else if(ota == "1")
				{
					document.getElementById("contactstateid").value = _("ota otacontract2");
					document.getElementById("btnRefreshSP").disabled=true;
					document.getElementById("btnRefreshSP").className = "btn_white_d";
				}
				else if(ota == "2")
				{
					document.getElementById("contactstateid").value = _("ota otacontract3");
					document.getElementById("btnRefreshSP").disabled=true;	
					document.getElementById("btnRefreshSP").className = "btn_white_d";
				}
				else
				{
					document.getElementById("contactstateid").value = _("ota otacontract1");	
				}
			}
		} 
	}
}

function initValue()
{
	getContractstatus();
	getOTAstatusasp();

	if(simtype=="1")
		document.SimCfg.OTAsimtype.options.selectedIndex =0;
	else if(simtype=="2")
		document.SimCfg.OTAsimtype.options.selectedIndex =1;
	else
		document.SimCfg.OTAsimtype.options.selectedIndex =0;

}
</script>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("kddi_ota.asp"); </script>

	<h1 id = "OTATitle"> OTA </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "OTAIntroduction"> OTA Introduction</font> 
	</div>
	<div id = "blank"> </div>
	
	<div id = "OTAsimtypetr">
	<form method = post name = "SimCfg" action = "/goform/setsimtype" onSubmit = "return SIMFormCheck()">
	<table>
	<caption id = "OTAsimtypesetup"> SIM Type Select </caption>
	<tr>
		<th id = "OTAsimtypesetupth"> SIM Type </th>
		<td>
			<select id="OTAsimtype" name="OTAsimtype">
			<option  id="OTAsimtypeIN"  value="1">INTERNER SIM</option>
			<option  id="OTAsimtypeEX" value="2">EXTERNER SIM</option>
			</select>
		</td>
	</tr>
	</table>
	<div id = "blank"> </div>
	<input class = "btn" type = "submit" value = "Apply" id = "manSimApply" name = "SimApply">
	<input class = "btn" type = "reset" value = "Cancel" id = "manSimCancel" name = "SimCancel" onClick="window.location.reload()">
	</form>
	</div>
	

	<div id = "blank"> </div>
	<form method = post name = "OTACfg" action = "" onSubmit = "">
	<table>
	<caption id = "OTAStateSetup"> Current State </caption>
	<tr>
		<th id="OTAcontactState"> Contact State </th>
		<td>
			<input type = "text" id="contactstateid" name="contactstate" size=16 maxlength=16 disabled>
		</td>
	</tr>
	<tr>
		<th id="OTAstatus"> OTA Status </th>
		<td>
			<input type = "text" id="otaprocessstatusid" name="otaprocessstatus" size=32 maxlength=32 disabled>
			<input type="button" class=btn_white  id="btnRefresh" name="Refresh" value="Refresh"  onClick = "reflashOtastatus();">
		</td>
	</tr>
	</table>
	<div id = "blank"> </div>

	<div id = "otacontractSetuptr">
	<table>
	<caption> <label class="caption" id="OTAcontractSetup"> Contract OTA </label> <br>
	<label class="caption1" id = "OTAspwarning1">You can check the network data usage.. </label><br>
	<label class="caption1" id = "OTAspwarning2">You can check the network data usage.. </label><br>&nbsp;		
	</caption>
	
	<tr>
		<th id="OTAcontractotasp"> OTASP </th>
		<td>
			<input type="button" class=btn_white  id="btnRefreshSP" name="RefreshSP" value="OTASP ON"  onClick="SetOtasp();">
		</td>
	</tr>
	</table>
	<div id = "blank"> </div>
	</div>

	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

