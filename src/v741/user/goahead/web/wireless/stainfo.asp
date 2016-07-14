<html>
<head>
<title id = "mainTitle"> <% getModelName(); %> Management </title>
<meta http - equiv = "Content-type" content = "text/html" charset = "UTF-8">
<meta http - equiv = "Cache-Control" content = "No-Cache"> <meta http - equiv = "Pragma" content = "No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type = "text/javascript" src = "/lang/b28n.js"> </script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("wireless");

$(document).ready(function(){ 
	initTranslation();
	PageInit();

	$("table[name=tableStations] tr td").width(function(index) {
		if(index%7==0 ) return 120; 
		else if(index%7==1) return 100; 
		else if(index%7==2) return 60; 
		else return 50;
	});

} );	

function initTranslation()
{
	$("#stalistTitle").html(_("stalist title"));
	$("#stalistIntroduction").html(_("stalist introduction"));
	$("#stalistWirelessNet").html(_("stalist wireless network"));
	$("#stalistMacAddr").html(_("stalist macaddr"));
	$("#stalistConnectTime").html(_("stalist connect time"));
}

function PageInit()
{
}
</script>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("stainfo.asp"); </script>


	<h1 id="stalistTitle">Station List</h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "stalistIntroduction">You could monitor stations which associated to this AP here.</font> 
	</div>
	<div id = "blank"> </div>

	<table name=tableStations>
	<caption id = "stalistWirelessNet"> Wireless Network</caption>
	<tr id="div_info_normal">
		<td bgcolor=#E8F8FF id="stalistMacAddr">MAC Address</td>
		<td bgcolor=#E8F8FF id="stalistConnectTime">>Connect Time</td>
		<td bgcolor=#E8F8FF>RSSI</td>
		<td bgcolor=#E8F8FF>PSM</td>
		<td bgcolor=#E8F8FF>MimoPS</td>
		<td bgcolor=#E8F8FF>MCS</td>
		<td bgcolor=#E8F8FF>BW</td>
	</tr>
 
	<% getWlanStaInfo(); %>
	</table>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

