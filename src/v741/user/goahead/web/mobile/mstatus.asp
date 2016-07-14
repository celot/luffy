<html>
<head>
<title><% getModelName(); %> Management</title>
<meta http-equiv="Content-type" content="text/html" charset="UTF-8">
<meta http-equiv="Cache-Control" content="No-Cache"><meta http-equiv="Pragma" content="No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("mobile");

$(document).ready(function(){ initValue(); } );

var timer = setInterval(function () {
			timerHandler();
		    }, 1000);

function timerHandler()
{
	$.get("/goform/getModuleStatusF", function(args){
			if(args.length>0) updateStatusInfo(args);
		}
	);
}

function initTranslation()
{
	$("#moduleStatus").html(_("mobile overview title"));
	$("#statusIntro").html(_("mobile overview intro"));
	$("#statusModule").html(_("mobile module title"));
	$("#statusModuleBand").html(_("mobile module band"));
	$("#statusModuleService").html(_("mobile module service"));
	$("#statusModuleCell").html(_("mobile module cell"));
	if( "<% getModuleBuilt(); %>" =="0")
		$("#statusModuleRssi2").html(_("mobile module rssi2"));
	else 
		$("#statusModuleRssi2").html(_("mobile module rssi"));
}

function updateStatusInfo(res)
{
	if(res.length>0)
	{
		var resArry = res.split(";");
		var i;
		for (i=0;i<resArry.length;i++)
		{
			var result= resArry[i];
			if(result.search("band:")!=-1)
			{
				$("#band").html(result.substr(5,result.length));
			}
			else if(result.search("service:")!=-1)
			{
				$("#serive").html(result.substr(8,result.length));
			}
			else if(result.search("cell:")!=-1)
			{
				$("#cell").html(result.substr(5,result.length));
			}
			else if(result.search("signal:")!=-1)
			{
				$("#signal").html(result.substr(7,result.length));
			}
		}
	}
}

function initValue() 
{
	var statusInfo = "<% getModuleStatusA(); %>";
	initTranslation();
	updateStatusInfo(statusInfo);
}
</script>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("mstatus.asp"); </script>

	<H1 id="moduleStatus">Module Status</H1>
	<div align="left">
	&nbsp;&nbsp; <font id = "statusIntro"> </font> 
	</div>
	<div id = "blank"> </div>
	<table>
	<caption id="statusModule">Module Infomation</caption>
	<tr>
		<th id="statusModuleBand">Band Info.</th>
		<td id="band"></td>
	</tr>
	<tr>
		<th id="statusModuleService">Service Info.</th>
		<td id="serive"></td>
	</tr>
	<tr>
		<th id="statusModuleCell">Cell Info.</th>
		<td id="cell"></td>
	</tr>
	<tr>
		<th id="statusModuleRssi2">RSSI Info.</th>
		<td id="signal"></td>
	</tr>
	</table>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>
