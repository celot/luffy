<html>
<head>
<title><% getModelName(); %> Management</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>

<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("admin");

$(document).ready(function(){ 
	initTranslation();
	pageInit(); 
} );

function uploadLogField(str)
{
	if(str == "-1"){
		document.getElementById("syslog").value =
		"Not support.\n(Busybox->\n  System Logging Utilitie ->\n    syslogd\n    Circular Buffer\n    logread"
	}else
		document.getElementById("syslog").value = str;
}

function updateLog()
{
	$.get("/goform/syslog", function(args){
			if(args.length>0) uploadLogField(args);
		}
	);
}

function initTranslation()
{
	$("#syslogTitle").html(_("syslog title"));	
	$("#syslogIntroduction").html(_("syslog introduction"));	
	$("#syslogSysLog").html(_("syslog system log"));	
	$("#syslogSysLogRefresh").val( _("syslog refresh"));
	$("#syslogSysLogClear").val( _("syslog clear"));
}

function pageInit()
{	
	updateLog();
}

function clearlogclick()
{
	$("#syslog").val("");
	return ture;
}

function refreshlogclick()
{
	updateLog();
	return true;
}

</script>

</head>
<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("syslog.asp"); </script>

	<h1 id="syslogTitle">System Log</h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "syslogIntroduction"> Syslog:  </font> 
	</div>
	<div id = "blank"> </div>

	<form method="post" name ="SubmitClearLog" action="/goform/clearlog">
		<input class=btn type="button" value="Refresh" id="syslogSysLogRefresh" name="refreshlog" onclick="refreshlogclick();">
		<input class=btn type="submit" value="Clear" id="syslogSysLogClear" name="clearlog" onclick="clearlogclick();">
	</form>

	<!-- ================= System log ================= -->
	<table>
	<caption id = "syslogSysLog"> System Log: </caption>
	<tr>
		<td>
			<textarea style=font-size:9pt name="syslog" id="syslog" cols="80" rows="25" wrap="off" readonly="1">
			</textarea>
		</td>
	</tr>
	</table>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body></html>
