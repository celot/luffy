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

	$('#clearStatics').click(function() { 
		clearStatics();
	});
} );

function clearStatics()
{
}

function initTranslation()
{
	$("#kddiTrafficTitle").html(_("kddi traffic title"));
	$("#trafficIntroduction1").html(_("kddi traffic introduction1"));
	$("#capTraffic").html(_("kddi traffic table"));
	$("#trafficIntroduction2").html(_("kddi traffic introduction2"));
	$("#trafficIntroduction3").html(_("kddi traffic introduction3"));
	$("#thTrafficWWAN1").html(_("kddi traffic wwan1"));
	$("#thTrafficWWAN2").html(_("kddi traffic wwan2"));
	$("#ntForwardingWWAN1").html(_("kddi traffic send"));
	$("#ntReceiveWWAN1").html(_("kddi traffic receive"));
	$("#ntForwardingWWAN2").html(_("kddi traffic send"));
	$("#ntReceiveWWAN2").html(_("kddi traffic receive"));
	$("#clearStatics").val(_("kddi traffic clear"));
}

function PageInit()
{
	var rxByteWWAN1 = <% getWWAN1RxByteASP(); %>;
	var txByteWWAN1 = <% getWWAN1TxByteASP(); %>;
	var rxByteWWAN2 = <% getWWAN2RxByteASP(); %>;
	var txByteWWAN2 = <% getWWAN2TxByteASP(); %>;
 
	var result = '<% getWWanUsageInfoAsp(); %>';
	var entries = new Array();

	entries = result.split(' ');	
	
	$("#ntReceiveWWAN1Usage").val(entries[1]);
	$("#ntForwardingWWAN1Usage").val(entries[0]);
	$("#ntReceiveWWAN1Usage").attr("readonly",true);
	$("#ntForwardingWWAN1Usage").attr("readonly",true);

	$("#ntReceiveWWAN2Usage").val(entries[3]);
	$("#ntForwardingWWAN2Usage").val(entries[2]);
	$("#ntReceiveWWAN2Usage").attr("readonly",true);
	$("#ntForwardingWWAN2Usage").attr("readonly",true);	
}

function resetWwanSubmit()
{
	$.get("/goform/resetWwanUageInfo", 
		function(args)
		{
			if (args == "resetWwanInfo") 
			{
				window.location.reload();
			}
		}
	);
}

</script>
</head>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("statistic_KDDI.asp"); </script>
	<h1 id="kddiTrafficTitle">Network Data Info</h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "trafficIntroduction1">You can check the network data usage.. </font> 
	</div>
	<div id = "blank"> </div>

	<table>
	<caption> <label class="caption" id="capTraffic"> Trrafic </label> <br>
		<label class="caption1" id = "trafficIntroduction2">You can check the network data usage.. </label><br>
		<label class="caption1" id = "trafficIntroduction3">You can check the network data usage.. </label>
	</caption>
	<tr>
		<th id="thTrafficWWAN1"> traffic WWAN1 </th>
		<td> 
			<label id="ntForwardingWWAN1"> forwarding </label>&nbsp;&nbsp;
			<input name="ntForwardingWWAN1Usage" id="ntForwardingWWAN1Usage" maxlength="8" size=15 value="">&nbsp;
			<font id="wwanKB"> KB</font>
			<div id="divNt"></div>
			<label id="ntReceiveWWAN1"> receive </label>&nbsp;&nbsp;
			<input name="ntReceiveWWAN1Usage" id="ntReceiveWWAN1Usage" maxlength="8" size=15 value="">&nbsp;
			<font id="wwanKB"> KB</font>
		</td>	
	</tr>
	<tr>
		<th id="thTrafficWWAN2"> traffic WWAN2 </th>
		<td> 
			<label id="ntForwardingWWAN2"> forwarding </label>&nbsp;&nbsp;
			<input name="ntForwardingWWAN2Usage" id="ntForwardingWWAN2Usage" maxlength="8" size=15 value="">&nbsp;
			<font id="wwanKB"> KB</font>
			<div id="divNt"></div>
			<label id="ntReceiveWWAN2"> receive </label>&nbsp;&nbsp;
			<input name="ntReceiveWWAN2Usage" id="ntReceiveWWAN2Usage" maxlength="8" size=15 value="">&nbsp;
			<font id="wwanKB"> KB</font>
		</td>	
	</tr>
	</table>

	<div id = "blank"> </div>
	<input class = "btn" type = "button" value = "clear" id = "clearStatics"  name="clearStatics" onclick="resetWwanSubmit();">
	</table>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body></html>
