<html>
<head>
<title><% getModelName(); %> Management</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>

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
    font-weight: normal;
    font-size:12px;
    float:left;
}
input {
	text-align:right;
	padding-left:5px;
	padding-right:5px;
	margin: 2px;
}
input.btn {
	text-align:center;
	padding-left:5px;
	padding-right:5px;
	margin: 2px;
}

th {
	font-size: 12px;
	border: 1px solid #e0e0e0;
	margin: 10px 10px;
	background-color: #f7f7f7;
	width: 280px;
	text-align: left;
	padding: 5px 10px;
}
</style>

<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("admin");

$(document).ready(function(){
	initTranslation();
	PageInit(); 
	} 
);

function initTranslation()
{
 	$("#statisticTitle").html(_("statistic title"));
 	$("#statisticIntroduction").html(_("statistic introduction"));
 	$("#statisticMM").html(_("statistic memory"));
 	$("#statisticMMTotal").html(_("statistic memory total"));
 	$("#statisticMMLeft").html(_("statistic memory left"));
 	$("#statisticWANLAN").html(_("statistic wanlan"));
 	$("#statisticWANRxPkt").html(_("statistic wan rx pkt"));
 	$("#statisticWANRxBytes").html(_("statistic wan rx bytes"));
 	$("#statisticWANTxPkt").html(_("statistic wan tx pkt"));
 	$("#statisticWANTxBytes").html(_("statistic wan tx bytes"));
 	$("#statisticLANRxPkt").html(_("statistic lan rx pkt"));
 	$("#statisticLANRxBytes").html(_("statistic lan rx bytes"));
 	$("#statisticLANTxPkt").html(_("statistic lan tx pkt"));
 	$("#statisticLANTxBytes").html(_("statistic lan tx bytes"));
 	$("#statisticAllIF").html(_("statistic all interface"));		
}

function PageInit()
{
	initTranslation();
}
</script>

</head>
<body >
<script language = "JavaScript" type = "text/javascript"> printContentHead("statistic.asp"); </script>

	<h1 id="statisticTitle">Statistic</h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "statisticIntroduction">Take a look at the Ralink SoC statistics </font> 
	</div>
	<div id = "blank"> </div>

	<table>
	<!-- =================  MEMORY  ================= -->
	<caption id = "statisticMM"> Memory </caption>
	<tr>
		<th id="statisticMMTotal">Memory total: </th>
		<td> <% getMemTotalASP(); %></td>
	</tr>
	<tr>
		<th id="statisticMMLeft">Memory left: </th>
		<td> <% getMemLeftASP(); %></td>
	</tr>
	</table>

	<div id = "blank"> </div>
	<table>
	<!-- =================  WAN/LAN  ================== -->
	<caption id = "statisticWANLAN"> WAN/LAN </caption>
	<tr>
		<th id="statisticWANRxPkt">WAN Rx packets: </th>
		<td> <% getWANRxPacketASP(); %></td>
	</tr>
	<tr>
		<th id="statisticWANRxBytes">WAN Rx bytes: </th>
		<td> <% getWANRxByteASP(); %></td>
	</tr>
	<tr>
		<th id="statisticWANTxPkt">WAN Tx packets: </th>
		<td> <% getWANTxPacketASP(); %></td>
	</tr>
	<tr>
		<th id="statisticWANTxBytes">WAN Tx bytes: </th>
		<td> <% getWANTxByteASP(); %></td>
	</tr>
	<tr>
		<th id="statisticLANRxPkt">LAN Rx packets: &nbsp; &nbsp; &nbsp; &nbsp;</th>
		<td> <% getLANRxPacketASP(); %></td>
	</tr>
	<tr>
		<th id="statisticLANRxBytes">LAN Rx bytes: </th>
		<td> <% getLANRxByteASP(); %></td>
	</tr>
	<tr>
		<th id="statisticLANTxPkt">LAN Tx packets: </th>
		<td> <% getLANTxPacketASP(); %></td>
	</tr>
	<tr>
		<th class="head" id="statisticLANTxBytes">LAN Tx bytes: </th>
		<td> <% getLANTxByteASP(); %></td>
	</tr>
	</table>

	<div id = "blank"> </div>
	<table>
	<caption id = "statisticAllIF"> All interfaces </caption>
	<!-- =================  ALL  ================= -->

	<script type="text/javascript">
	var i;
	var a = new Array();
	a = [<% getAllNICStatisticASP(); %>];
	for(i=0; i<a.length; i+=5){
		// name
		document.write("<tr> <th> Name </th><th>");
		document.write(a[i]);
		document.write("</th></tr>");

		// Order is important! rxpacket->rxbyte->txpacket->txbyte
		// rxpacket
		document.write("<tr> <th> Rx Packet </th><td>");
		document.write(a[i+1]);
		document.write("</td></tr>");

		// rxbyte
		document.write("<tr> <th> Rx Byte </th><td>");
		document.write(a[i+2]);
		document.write("</td></tr>");

		// txpacket
		document.write("<tr> <th> Tx Packet </th><td>");
		document.write(a[i+3]);
		document.write("</td></tr>");

		// txbyte
		document.write("<tr> <th> Tx Byte </th><td>");
		document.write(a[i+4]);
		document.write("</td></tr>");
	}
	</script>

	</table>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body></html>

