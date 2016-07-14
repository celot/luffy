<html>
<head>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<META http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate_celot.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>

<title><% getModelName(); %> Management</title>

<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("admin");

$(document).ready(function(){  
	PageInit(); 

	var validateSettingRule = $("#ImportSettings").validate({		
		rules: {
			filename : {
				required: true, 
				minlength : 1
			}
		},		
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=add] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=add] span").show();
			} else {
				$("div.error[name=add] span").hide();
			}
		},
		submitHandler :function(form){
			var errors = this.numberOfInvalids();
			if (errors) {
				$("div.error[name=add] span").html(_("alert rule number exceeded"));
				$("div.error[name=add] span").show();
			} else {
				$("div.error[name=add] span").hide();
				form.submit();
			}			
		}
	});

	$('#setmanImpSetCancel').click(function() { 
		validateSettingRule.resetForm(); 
		$("div.error[name=add] span").hide();
		$("#filename").val("");
	});
} );

function initTranslation()
{
	$("#setmanTitle").html(_("setman title")); 
	$("#setmanIntroduction").html(_("setman introduction")); 
	$("#setmanIntroduction2").html(_("setman introduction2")); 
	$("#setmanExpSet").html(_("setman export setting")); 
	$("#setmanExpSetButton").html(_("setman export setting button")); 
	$("#setmanExpSetExport").val( _("setman export setting export")); 
	$("#setmanImpSet").html(_("setman import setting")); 
	$("#setmanImpSetFileLocation").html(_("setman import setting file location")); 
	$("#setmanImpSetImport").val( _("setman import setting import"));
	$("#setmanImpSetCancel").val( _("admin cancel"));
	$("#setmanLoadFactDefault").html(_("setman load factory default")); 
	$("#setmanLoadFactDefaultButton").html(_("setman load factory default button")); 
	$("#setmanLoadDefault").val( _("setman load default"));
}


function LoadDefaultCheck()
{
	var answer = confirm(_("setman load default quest"));
	if(answer)
	{
		return true;	
	}
	return false;
}

function PageInit()
{
	initTranslation();
}
</script>

</head>
<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("settings.asp"); </script>

	<h1 id="setmanTitle">Settings Management</h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "setmanIntroduction"> You might save system settings by exporting them to a configuration file, restore them by importing the file, or reset them to factory default. </font> 
	</div>
	<div id = "blank"> </div>

	<!-- ================= Export ================= -->
	<form method="post" name="ExportSettings" action="/cgi-bin/ExportSettings.sh">
	<table>
	<tr>
	<caption id = "setmanExpSet"> Export Settings</caption>
	<tr>
		<th id="setmanExpSetButton">Export Button</th>
		<td><input class=btn2_white value="Export" id="setmanExpSetExport" name="Export" style="{width:120px;}" type="submit"></td>
	</tr>
	</table>
	</form>

	<div id = "blank"> </div>
	<!-- ================= Import ================= -->
	<form method="post" name="ImportSettings" id="ImportSettings" action="/cgi-bin/upload_settings.cgi" enctype="multipart/form-data">
	<table>
	<caption id = "setmanImpSet"> Settings</caption>
	<tr>
		<th id="setmanImpSetFileLocation">Settings file location</th>
		<td><input type="File" name="filename" id="filename" size="20" maxlength="256"></td>
	</tr>
	</table>
	<div id = "blank" class="error" name="add" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Import" id = "setmanImpSetImport" name = "setmanImpSetImport">
	<input class = "btn" type = "button" value = "Cancel" id = "setmanImpSetCancel" name = "setmanImpSetCancel">

	</form>
	
	<div id = "blank"> </div>
	<!-- ================= Load FactoryDefaults  ================= -->
	<form method="post" name="LoadDefaultSettings" action="/goform/LoadDefaultSettings">
	<table>
	<caption id = "setmanLoadFactDefault"> Load Factory Defaults</caption>
	<tr>
		<th id="setmanLoadFactDefaultButton">Load Default Button</th>
		<td><input class=btn2_white  value="Load Default" id="setmanLoadDefault" name="LoadDefault" type="submit" onClick="return LoadDefaultCheck()"></td>
	</tr>
	</table>
	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body></html>
