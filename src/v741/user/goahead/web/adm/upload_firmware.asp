<html>
<head>
<title><% getModelName(); %> Management</title>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<META http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate_celot.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>


<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("admin");

$(document).ready(function(){ 
	initTranslation();
	PageInit(); 

	var validateFirmwareRule = $("#UploadFirmware").validate({		
		rules: {
			filename : {
				required: true, 
				minlength : 1
			}
		},		
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addFirmware] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addFirmware] span").show();
			} else {
				$("div.error[name=addFirmware] span").hide();
			}
		},
		submitHandler :function(form){
			var errors = this.numberOfInvalids();

			var checkFile_errCode = checkSize(1024*1024*4, 1);

			if(checkFile_errCode == 1)
			{
				$("div.error[name=addFirmware] span").html(_("alert rule filesize limit 4MB exceeded"));
				$("div.error[name=addFirmware] span").show();
				return;
			}else if(checkFile_errCode == 2)
			{
				$("div.error[name=addFirmware] span").html(_("alert rule filesize exceeded"));
				$("div.error[name=addFirmware] span").show();
				return;
			}

			if (errors) {
				$("div.error[name=addFirmware] span").html(_("alert rule number exceeded"));
				$("div.error[name=addFirmware] span").show();
			} else {
				$("div.error[name=addFirmware] span").hide();
				form.submit();
			}
		}
	});

	var validateSystemRule = $("#UploadSystem").validate({		
		rules: {
			filename : {
				required: true, 
				minlength : 1
			}
		},		
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addSystem] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addSystem] span").show();
			} else {
				$("div.error[name=addSystem] span").hide();
			}
		},
		submitHandler :function(form){
			var errors = this.numberOfInvalids();

			var checkFile_errCode = checkSize(1024*1024*7.5, 2);
			if(checkFile_errCode == 1)
			{
				$("div.error[name=addSystem] span").html(_("alert rule filesize limit 7MB exceeded"));
				$("div.error[name=addSystem] span").show();
				return;
			}else if(checkFile_errCode == 2)
			{
				$("div.error[name=addSystem] span").html(_("alert rule filesize exceeded"));
				$("div.error[name=addSystem] span").show();
				return;
			}

			if (errors) {
				$("div.error[name=addSystem] span").html(_("alert rule number exceeded"));
				$("div.error[name=addSystem] span").show();
			} else {
				$("div.error[name=addSystem] span").hide();
				form.submit();
			}			
		}
	});

	var validateBootloaderRule = $("#UploadBootloader").validate({		
		rules: {
			filename : {
				required: true, 
				minlength : 1
			}
		},		
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addBootloader] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addBootloader] span").show();
			} else {
				$("div.error[name=addBootloader] span").hide();
			}
		},
		submitHandler :function(form){
			var errors = this.numberOfInvalids();
			if (errors) {
				$("div.error[name=addBootloader] span").html(_("alert rule number exceeded"));
				$("div.error[name=addBootloader] span").show();
			} else {
				$("div.error[name=addBootloader] span").hide();
				form.submit();
			}			
		}
	});
	
} );
	
function initTranslation()
{
	$("#uploadTitle").html(_("upload title"));	
	$("#uploadIntroduction1").html(_("upload introduction1"));	
	$("#uploadIntroduction2").html(_("upload introduction2"));	
	$("#uploadFW").html(_("upload firmware"));
	$("#uploadFWLocation").html(_("upload firmware location"));	
	$("#uploadFWApply").val(_("admin apply"));
	$("#uploadSys").html(_("upload system"));	
	$("#uploadSysLocation").html(_("upload system location"));	
	$("#uploadSysApply").val(_("admin apply"));		
	$("#uploadBoot").html(_("upload bootloader"));
	$("#uploadBootLocation").html(_("upload bootloader location"));	
	$("#uploadBootApply").val(_("admin apply"));
}

function uploadFirmwareCheck()
{
	if(document.UploadFirmware.filename.value == "")
	{
		alert("Firmware Upgrade: Please specify a file.");
		return false;
	}
	return true;
}


function uploadSystemCheck()
{
	if(document.UploadSystem.filename.value == "")
	{
		alert(_("alert specify a file"));
		return false;
	}
	return true;
}
function formBootloaderCheck()
{
	ret = confirm(_("alert for engineer only"));
	if(!ret)
		return false;

	if(document.UploadBootloader.filename.value == ""){
		alert("Bootloader Upgrade: Please specify a file.");
		return false;
	}

	return true;
}

function PageInit()
{
	var blEnable = "<% getCfgZero(1, "bootLoadEnabled"); %>";	
	var sysEnable = "<% enableUploadSystem(); %>";	
	
	if (blEnable != 1) 
	{
		$("#uploadBootTable").hide();
		$("#uploadBootApply").hide();		
	}

	if (sysEnable != 1) 
	{
		$("#divUploadSystem").hide();		
	}
}

function checkSize(max_img_size, mode)
{
	
	var input;
	if (window.ActiveXObject) { // not check file size IE browser(8,9) not suported
		return 0;
	}

	if(mode == 1)
	{
		input= document.UploadFirmware.filename;
	}else if(mode == 2)
	{
		input= document.UploadSystem.filename;
	}
	// check for browser support (may need to be modified)
	if(input.files && input.files.length == 1)
	{           
		if (input.files[0].size > max_img_size) 
		{
			return 1;
		}else if(input.files[0].size == 0)
		{
			return 2;
		}else
		{
			return 0;
		}
	}
	return 2;
}

</script>
</head>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("upload_firmware.asp"); </script>

	<h1 id="uploadTitle">Upgrade Firmware</h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "uploadIntroduction1"> Upgrade firmware to obtain new functionality. </font> 
	<font id = "uploadIntroduction2" color="#ff0000"> It takes about 1 minute to upload &amp; upgrade flash and be patient please. Caution! A corrupted image will hang up the system. </font> 
	</div>
	<div id = "blank"> </div>

	<!-- ================= UploadFirmware ================= -->
	<form method="post" name="UploadFirmware" id="UploadFirmware" action="/cgi-bin/upload.cgi" enctype="multipart/form-data">
	<table>
	<caption id = "uploadFW"> Update Firmware</caption>
	<tr>
		<th id="uploadFWLocation">Location:</th>
		<td> <input name="filename" id="filename" size="50" maxlength="256" type="file"> </td>
	</tr>
	</table>
	<div id = "blank" class="error" name="addFirmware" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "uploadFWApply" name="uploadFWApply">
	</form>


	<!-- ================= UploadSystem ================= -->
	<div id=divUploadSystem>
	<form method="post" name="UploadSystem" id="UploadSystem" action="/cgi-bin/upload_system.cgi" enctype="multipart/form-data">
	<table>
	<caption id = "uploadSys"> Update UserImage</caption>
	<tr>
		<th id="uploadSysLocation">Location:</th>
		<td> <input name="filename" id="filename" size="50" maxlength="256" type="file"> </td>
	</tr>
	</table>
	<div id = "blank" class="error" name="addSystem" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "uploadSysApply" name="uploadSysApply">
	</form>
	</div>
	
	<!-- ================= UploadBootloader ================= -->
	<form method="post" name="UploadBootloader" id="UploadBootloader" action="/cgi-bin/upload_bootloader.cgi" enctype="multipart/form-data">
	<table name="uploadBootTable" id="uploadBootTable">
	<caption id = "uploadBoot"> Update Bootloader</caption>
	<tr>
		<th id="uploadBootLocation">Location:</th>
		<td> <input name="filename" id="filename" size="50" maxlength="256" type="file"> </td>
	</tr>
	</table>
	
	<div id = "blank" class="error" name="addBootloader" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "uploadBootApply" name="uploadBootApply">
	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body></html>

