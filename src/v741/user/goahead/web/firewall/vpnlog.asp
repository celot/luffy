<html>
<head>
<title id = "mainTitle"> <% getModelName(); %> Management </title>
<meta http-equiv="content-type" content="text/html" charset="UTF-8">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate, no-store"> 
<meta http-equiv="Pragma" content = "No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"> </script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>

<style>
  textarea { width: 600px; height: 380px; border: 1px solid #333; padding: 4px; }
</style>
 
<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("firewall");

$(document).ready(function(){ 
	initTranslation();

	$.get("/goform/getVpnLogData", function(args){
			if(args.length>0) {
				if(args == "-1") $("#vpnlog").val("");
				else $("#vpnlog").val(args);
			}
		}
	);

	$('#logTable').css('width', '100%');
	$('#logTable').height($(window).height()-$("#logTable").offset().top);
	$(window).resize(function(){
		$('#logTable').height($(window).height()-$("#logTable").offset().top);
	});
});

function initTranslation()
{
	$("#vpnLogTitle").html(_("vpn log title"));
	$("#vpnLogIntro").html(_("vpn log intro"));
	$("#vpnBMlogC").val(_("vpn clear log"));
}

function clear_vpnlog()
{
	$.get("/goform/clearVpnLog", function(args){
			if(args.length>0) {
				if(args == "OK") $("#vpnlog").val("");
			}
		}
	);
}
</script>

<body class="inner_body">
	<div id = "blank"> </div>
	<h1 id = "vpnLogTitle"> VPN Log </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "vpnLogIntro"> Show VPN Logs</font> 
	</div>
	
	<div id="blank3">
	<input class = "btn_white" type = "button" id="vpnBMlogC" value = "Clear"  onClick = "clear_vpnlog()"> &nbsp;
	</div>
	<table id="logTable">
	<tr>
		<td>
			<textarea style=font-size:9pt name="vpnlog" id="vpnlog" cols="80" rows="23" wrap="off" readonly="1"></textarea>
		</td>
	</tr>	
	</table>	 
</body>
</html>
