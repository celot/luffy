<html>
<head>
<title id = "mainTitle"> <% getModelName(); %> Management </title>
<meta http - equiv = "Content-type" content = "text/html" charset = "UTF-8">
<meta http - equiv = "Cache-Control" content = "No-Cache"> <meta http - equiv = "Pragma" content = "No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"> </script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/scrolltable.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<script language = "JavaScript" type = "text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("internet");

$(document).ready(function(){
	initValue(); 

	$("table[name=tableDhcpAssign] tr td").width(function(index) {
		return 140;
	});
	$("table[name=tableDhcpAssign]").createScrollableTable();

} );

function initValue()
{
	$("#dTitle").html(_("dhcp title"));
	$("#dIntroduction").html(_("dhcp introduction"));
	$("#dClients").html(_("dhcp clients"));
	$("#dHostname").html(_("inet hostname"));
	$("#dMac").html(_("inet lan mac"));
	$("#dIp").html(_("inet ip"));
	$("#dExpr").html(_("dhcp expire"));
}
</script>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("dhcpcliinfo.asp"); </script>


	<h1 id="dTitle"> DHCP Client List </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "dIntroduction"> </font> 
	</div>
	<div id = "blank"> </div>


	<table name="tableDhcpAssign">
	<caption id = "dClients"> DHCP Clients </caption>
	<thead>
	<tr>
		<td width=180 bgcolor=#E8F8FF id="dHostname">Hostname</td>
		<td width=220 bgcolor=#E8F8FF id="dMac">MAC Address</td>
		<td width=160 bgcolor=#E8F8FF id="dIp">IP Address</td>
		<td width=110 bgcolor=#E8F8FF id="dExpr">Expires in</td>
	</tr>
	</thead>
	<tbody>
	<% getDhcpCliList(); %>
	</tbody>
	</table>

	<div id = "blank"> </div>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

