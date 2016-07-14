<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>

<title id = "mainTitle"> <% getModelName(); %> Management </title>
<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>

Butterlate.setTextDomain("wireless");

var timer = setInterval(function () {
	$.get("/goform/getApStatsForApstatistics", function(args){
				if(args.length>0) getApstatics(args);
			}
		);
	}, 3000);

$(document).ready(function(){ 
	PageInit();
} );	

function initTranslation()
{
	$("#apStatisticTitle").html(_("statistic title"));
	$("#apStatisticIntroduction").html(_("statistic introduction"));
	$("#statisticTx").html(_("statistic tx"));
	$("#statisticTx_Success").html(_("statistic tx success"));
	$("#statisticTx_Retry_Cnt").html(_("statistic retry cnt"));
	$("#statisticTx_Fail_After_Cnt").html(_("statistic fail after cnt"));
	$("#statisticTx_RTS_Success").html(_("statistic rts success"));
	$("#statisticTx_RTS_Fail").html(_("statistic rts fail"));
	
	$("#statisticRx").html(_("statistic rx"));
	$("#statisticRx_Success").html(_("statistic rx success"));
	$("#statisticRx_FCS").html(_("statistic rx fcs"));
	$("#apStatResetCounter").val(_("statistic reset counter"));
}

function getApstatics(all_str)
{
	var i;
	var entries = new Array();

	entries = all_str.split(";");
	for(i=0; i<entries.length; i++)
	{
		var id = "td[id=statistic_" + i + "]";
		if(entries[i] == "Read failed.") $(id).html(_("statistic read failed"));
		else $(id).html(entries[i]);
	}
}

function initFirstValue()
{
	var statisticTx_Success = "<% getApStats("TxSucc"); %>";
	var statisticTx_Retry_Cnt = "<% getApStats("TxRetry"); %>";
	var statisticTx_Fail_After_Cnt = "<% getApStats("TxFail"); %>";
	var statisticTx_RTS_Success = "<% getApStats("RTSSucc"); %>";
	var statisticTx_RTS_Fail = "<% getApStats("RTSFail"); %>";
	var statisticRx_Success = "<% getApStats("RxSucc"); %>";
	var statisticRx_FCS = "<% getApStats("FCSError"); %>";
	var SNR0 = "<% getApSNR(0); %>";
	var SNR1 = "<% getApSNR(1); %>";	
	
	$("td[id=statistic_0]").html(statisticTx_Success);
	$("td[id=statistic_1]").html(statisticTx_Retry_Cnt);
	$("td[id=statistic_2]").html(statisticTx_Fail_After_Cnt);
	$("td[id=statistic_3]").html(statisticTx_RTS_Success);
	$("td[id=statistic_4]").html(statisticTx_RTS_Fail);
	$("td[id=statistic_5]").html(statisticRx_Success);
	$("td[id=statistic_6]").html(statisticRx_FCS);
	$("td[id=statistic_7]").html(SNR0 + ", " + SNR1);
}

function PageInit()
{
	var txbf = "<% getTxBfBuilt(); %>";

	initTranslation();
	initFirstValue();

	if (txbf != "1") $("#div_stats_txbf").hide();
}
</script>
</head>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("apstatistics.asp"); </script>

	<h1 id="apStatisticTitle">AP Wireless Statistics</h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "apStatisticIntroduction">Wireless TX and RX Statistics</font> 
	</div>
	<div id = "blank"> </div>


	<table>
	<caption id = "statisticTx"> Transmit Statistics</caption>
	<tr>
		<th id = "statisticTx_Success"> Tx Success </th>
		<td id="statistic_0"></td>
	</tr>
	<tr>
		<th id = "statisticTx_Retry_Cnt"> Tx Retry Count </th>
		<td id="statistic_1"></td>
	</tr>
	<tr>
		<th id ="statisticTx_Fail_After_Cnt" >Tx Fail after retry</th>
		<td id="statistic_2"></td>
	</tr>
	<tr>
		<th id="statisticTx_RTS_Success">RTS Successfully Receive CTS</th>
		<td id="statistic_3"></td>
	</tr>
	<tr>
		<th id="statisticTx_RTS_Fail">RTS Fail To Receive CTS</th>
		<td id="statistic_4"></td>
	</tr>
	</table>
	<br>
	
	<table>
	<caption id = "statisticRx"> Receive Statistics</caption>
	<tr>
		<th id = "statisticRx_Success">Frames Received Successfully</th>
		<td id="statistic_5"></td>
	</tr>
	<tr>
		<th id = "statisticRx_FCS">Frames Received With CRC Error</th>
		<td id="statistic_6"></td>
	</tr>
	</table>
	<br>
	
	<table>
	<caption id = "statisticSNR"> SNR</caption>
	<tr>
		<th id="statisticSNR">SNR</th>
		<td id="statistic_7"></td>
	</tr>
	</table>

	<table id="div_stats_txbf">
	<% getApTxBFStats(); %>
	</table>

	<form method="post" name="ap_statistics" action="/goform/resetApCounters">
	<div id = "blank"> </div>
	<input class = "btn2" id = "apStatResetCounter" type="submit" value = "Reset Counters">
	<input type=hidden name=dummyData value="1">
	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>


