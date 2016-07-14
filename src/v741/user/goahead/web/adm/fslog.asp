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
Butterlate.setTextDomain("mobile");

$(document).ready(function(){ 
	initTranslation();

	$.get("/goform/getFSLogData", function(args){
			if(args.length>0) {
				if(args == "-1") $("#fslog").val("");
				else $("#fslog").val(args);
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
	$("#fsLogTitle").html(_("fs log title"));
	$("#fsLogIntro").html(_("fs log intro"));
	$("#fsBMlogE").val(_("fs export log"));
	$("#fsBMlogC").val(_("fs clear log"));
}

function clear_fslog()
{
	$.get("/goform/clearFSLog", function(args){
			if(args.length>0) {
				if(args == "OK") $("#fslog").val("");
			}
		}
	);
}
</script>

<body class="inner_body">
	<div id = "blank"> </div>
	<h1 id = "fsLogTitle"> Fail Safe Log </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "fsLogIntro"> Show Fail Safe Logs</font> 
	</div>

	<form method="post" name="exportfslog" action="/cgi-bin/exportfslog.sh">		
	<div id="blank3">
	<input class = "btn_white" type = "submit" id="fsBMlogE" value = "Export"> &nbsp;
	<input class = "btn_white" type = "button" id="fsBMlogC" value = "Clear"  onClick = "clear_fslog()"> &nbsp;
	</div>
	<table id="logTable">
	<tr>
		<td>
			<textarea style=font-size:9pt name="fslog" id="fslog" cols="80" rows="23" wrap="off" readonly="1"></textarea>
		</td>
	</tr>	
	</table>	 
	</form>
</body>
</html>
