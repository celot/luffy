<html>
<head>
<title id = "mainTitle"> <% getModelName(); %> Management </title>
<meta http-equiv="content-type" content="text/html" charset="UTF-8">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate, no-store"> 
<meta http-equiv="Pragma" content = "No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type = "text/javascript" src = "/lang/b28n.js"> </script>
<script type="text/javascript" src="/menu/menu.js"></script>

<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("service");

var http_request = false;

function makeRequest(url, content) {
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
        alert('Giving up :( Cannot create an XMLHTTP instance');
        return false;
    }
    http_request.onreadystatechange = alertContents;
    http_request.open('POST', url, true);
    http_request.send(content);
}

function alertContents() 
{
	if (http_request.readyState == 4) 
	{
		if (http_request.status == 200) 
		{
		} 
		else 
		{
			alert('There was a problem with the request.');
		}
	}
}

function initTranslation()
{
	var e = document.getElementById("upsLogTitle");
	e.innerHTML = _("ups log title");
	e = document.getElementById("upsLogIntro");
	e.innerHTML = _("ups log intro");
	e = document.getElementById("upsLogNo");
	e.innerHTML = _("ups log no");
	e = document.getElementById("upsLogDT");
	e.innerHTML = _("ups log date");
	e = document.getElementById("upsLogSt");
	e.innerHTML = _("ups log status");
	e = document.getElementById("upsLogMa");
	e.innerHTML = _("ups log mail");
	e = document.getElementById("upsBMlogC");
	e.value = _("ups mail clear log");

}

function initValue()
{
	initTranslation();
}

function parse_log()
{
	var byteArray = new Array(<% getUpsLogData(); %>);
	var len = byteArray.length/3;
	var total = len|0;
	for (var i = total-1; i >=0; i--) 
	{
		var status = byteArray[i*3];
		var timeValue = byteArray[i*3+1];
		var date = new Date(timeValue*1000);
		var mail = byteArray[i*3+2];

		var eventLevel = "UPS warning"; 
		switch(status)
		{
			case 1:
				eventLevel = "Low Level 1";
				break;
			case 2:
				eventLevel = "Low Level 2";
				break;
			case 3:
				eventLevel = "Low Level 3";
				break;
			case 4:
				eventLevel = "Bad Battery";
				break;
			case 8:
				eventLevel = "External Off";
				break;
			case 9:
				eventLevel = "External On";
				break;
			case 10:
				eventLevel = "Warning Voltage";
				break;
		}

		var eventResult = "Unkown"; 
		switch(mail)
		{
			case 0:
				eventResult = "Over Event";
				break;
			case 1:
				eventResult = "Mail Send Ok";
				break;
			case 2:
				eventResult = "Mail Send Fail";
				break;
		}

		document.write("<tr>\n");
		document.write("<td class=inner>" + (i+1) +"</td>\n");
		document.write("<td>" + date.toLocaleString() +"</td>\n");
		document.write("<td class=inner>" + eventLevel +"</td>\n");
		document.write("<td class=inner>" + eventResult +"</td>\n");
		document.write("</tr>\n");
	}
}

function clear_upslog()
{
	var table = document.getElementById("logTable");
	var rowCount = table.rows.length;	
	for(var i=0; i<rowCount-1; i++) table.deleteRow(1);
	
	makeRequest("/goform/clearUpsLog", "n/a");
}
</script>

<body class="inner_body" onLoad="initValue()">
	<div id = "blank"> </div>
	<h1 id = "upsLogTitle"> UPS Mail Log </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "upsLogIntro"> Show Ups Logs</font> 
	</div>
	
	<div id="blank3">
	<input class = "btn_white" type = "button" id="upsBMlogC" value = "Clear"  onClick = "clear_upslog()"> &nbsp;
	</div>
	<table id="logTable">
	<tr>
		<td bgcolor=#E8F8FF class="inner" id="upsLogNo"> No.</td>
		<td bgcolor=#E8F8FF id="upsLogDT"> Date </td>
		<td bgcolor=#E8F8FF class="inner"  id="upsLogSt"> Status </td>
		<td bgcolor=#E8F8FF class="inner" id="upsLogMa"> Mail</td>
	</tr>
	<script language="JavaScript" type="text/javascript">parse_log(); </script>
	</table>	 
</body>
</html>
