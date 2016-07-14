<html>
<head>
<title> <% getModelName(); %> Management </title>
<meta http - equiv = "Content-type" content = "text/html" charset = "utf-8">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<meta http - equiv = "Cache-Control" content = "No-Cache"> <meta http - equiv = "Pragma" content = "No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate_celot.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<script language = "JavaScript" type = "text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("service");

$(document).ready(function(){ 
	initTranslation();
	PageInit(); 

	var validateRule = $("#nmsCfg").validate({
		invalidHandler: function(e, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=add] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=add] span").show();
			} else {
				$("div.error[name=add] span").hide();
			}
		},		
		rules: {
			nmsReportTime: {
				required :  function() { 
					return ($("#nmsReport").val() == "Enable"); 
				},
				number : true,
				minlength : 1,
				min : 1
			},
			nmsReportServer: {
				required :  function() { 
					return ($("#nmsReport").val() == "Enable");
				},
				IP4Checker: true
			},
			nmsReportPort: {
				required :  function() { 
					return ($("#nmsReport").val() == "Enable"); 
				},
				number : true,
				minlength : 1,
				min : 1,
				notEqualTo : {
					param : "#nmsRemotePort",
					depends : function() { 			
						return  ($("#nmsReport").val() == "Enable") &&  ($("#nmsRemote").val() == "Enable");
					}
				}
			},
			nmsRemotePort: {
				required :  function() { 
					return ($("#nmsRemote").val() == "Enable"); 
				},
				number : true,
				minlength : 1,
				min : 1
			},
			nmsRemoteUser : {
				required :  function() { 
					return ($("#nmsRemote").val() == "Enable"); 
				},
				minlength : 8,
				maxlength : 8
			}
		},
		errorPlacement: function (error, element) { 
			if ($(element).attr('id') =="nmsReportPort"  && ($("#nmsReport").val() == "Enable") 
			     &&  ($("#nmsRemote").val() == "Enable") && ( $("#nmsReportPort").val() == $("#nmsRemotePort").val()))
			{
				error.insertAfter(element); 
			}
		},
		submitHandler :function(form){
			var errors = this.numberOfInvalids();
			if (errors) {
				$("div.error[name=add] span").html(_("alert rule number exceeded"));
				$("div.error[name=add] span").show();
			} else {
				$("div.error[name=add] span").hide();

				$("#nmsRmtMethod1").val("1"); // not support sms, must be network
				form.submit();
			}			
		}
	});		

	jQuery.extend(jQuery.validator.messages, {
		required : ""
	});

	$('#Cancel').click(function() { 
		validateRule.resetForm(); 
		PageInit();
		$("div.error[name=add] span").hide();
	});
} );

function nmsReportSwitch()
{
	if (document.nmsCfg.nmsReport.options.selectedIndex == 0)
	{
		$("#trReportTime").show();
		$("#trReportInterface").show();
		$("#trReportServer").show();
		$("#trReportPort").show();
	}
	else
	{
		$("#trReportTime").hide();
		$("#trReportInterface").hide();
		$("#trReportServer").hide();
		$("#trReportPort").hide();
	}
}

function nmsRemoteSwitch()
{
	if (document.nmsCfg.nmsRemote.options.selectedIndex == 0)
	{
		$("#trRemoteInterface").show();
		$("#trRemoteMethod").show();
		$("#trRemotePort").show();
		$("#trRemoteUser").show();
	}
	else
	{
		$("#trRemoteInterface").hide();
		$("#trRemoteMethod").hide();
		$("#trRemotePort").hide();
		$("#trRemoteUser").hide();
	}
}

function initWanMode()
{
	var mode = "<% getCfgGeneral(1, "wanMode"); %>";
	var realWWANmode = "<% getCfgGeneral(1, "realWwanMode"); %>";
	
	if (mode == "0")
	{
		if (realWWANmode == "0")
		{
			$("#nmsReportInterface").html(_("WWAN1")); //document.nmsCfg.nmsReportInterface.options.selectedIndex = 0; // wwan1
			$("#nmsRemoteInterface").html(_("WWAN1")); //document.nmsCfg.nmsReportInterface.options.selectedIndex = 0; // wwan1			
		}
		else if (realWWANmode == "1") 
		{
			$("#nmsReportInterface").html(_("WWAN2")); //document.nmsCfg.nmsReportInterface.options.selectedIndex = 1; // wwan2
			$("#nmsRemoteInterface").html(_("WWAN2")); //document.nmsCfg.nmsRemoteInterface.options.selectedIndex = 1; // wwan2			
			
		}
	}
	else if (mode == "1")
	{
		$("#nmsReportInterface").html(_("WAN")); //document.nmsCfg.nmsReportInterface.options.selectedIndex = 2; 	// wan
		$("#nmsRemoteInterface").html(_("WAN")); //document.nmsCfg.nmsRemoteInterface.options.selectedIndex = 2; 	// wan

	}
	else if (mode == "2") 
	{
		$("#nmsReportInterface").html(_("WWAN&WAN")); //document.nmsCfg.nmsReportInterface.options.selectedIndex = 3; 	// wwan&wan
		$("#nmsRemoteInterface").html(_("WWAN&WAN")); //document.nmsCfg.nmsRemoteInterface.options.selectedIndex = 3; 	// wwan&wan			
	}
}

function PageInit()
{
	var nmsReport = "<% getCfgGeneral(1, "nmsReport"); %>";
	var nmsRemote = "<% getCfgGeneral(1, "nmsRemote"); %>";
	var nmsReportInterface = "<% getCfgGeneral(1, "nmsReportInterface"); %>";
	var nmsRemoteInterface = "<% getCfgGeneral(1, "nmsRemoteInterface"); %>";
	
	if (nmsReport == "Enable") document.nmsCfg.nmsReport.options.selectedIndex = 0;
	else document.nmsCfg.nmsReport.options.selectedIndex = 1;

	if (nmsRemote == "Enable") document.nmsCfg.nmsRemote.options.selectedIndex = 0;
	else document.nmsCfg.nmsRemote.options.selectedIndex = 1;

	if (nmsReportInterface !="") document.nmsCfg.nmsReportInterface.options.selectedIndex =  parseInt(nmsReportInterface);
	else document.nmsCfg.nmsReportInterface.options.selectedIndex = 0;

	if (nmsRemoteInterface !="") document.nmsCfg.nmsRemoteInterface.options.selectedIndex = parseInt(nmsRemoteInterface);
	else document.nmsCfg.nmsRemoteInterface.options.selectedIndex = 0;
	//initWanMode();
	initCfgValue();
	nmsReportSwitch();
	nmsRemoteSwitch();

	$("input:checkbox[name=nmsRmtMethod1]").attr("checked", true);
	$("input:checkbox[name=nmsRmtMethod1]").attr("disabled",true);

	//$("#trReportInterface").hide();
	//$("#trRemoteInterface").hide();

	//$("[id=nmsReportInterface]").attr("disabled",true);
	//$("[id=nmsRemoteInterface]").attr("disabled",true);	
}

function initTranslation()
{
	$("#nmsTitle").html(_("service nms title"));
	$("#nmsIntroduction").html(_("service nms introduction"));
	$("#capNmsReportSetup").html(_("service nms report setup"));
	$("#thNmsReport").html(_("service nms report enable"));
	$("#thReportTime").html(_("service nms report time"));
	$("#thReportServer").html(_("service nms report server"));
	$("#thReportPort").html(_("service nms report port"));
	$("#thReportInterface").html(_("service directserial interface"));
	$("#nmsReportInterface0").html(_("service interface0"));
	$("#nmsReportInterface1").html(_("service interface1"));
	$("#nmsReportInterface2").html(_("service interface2"));
	$("#nmsReportInterface3").html(_("service interface3"));
	$("#nmsReportInterface4").html(_("service interface4"));
	$("#nmsReportInterface5").html(_("service interface5"));
	$("#nmsDisable").html(_("service disable"));
	$("#nmsEnable").html(_("service enable"));
	$("#nmsrDisable").html(_("service disable"));
	$("#nmsrEnable").html(_("service enable"));
	$("#nmsRmtMethod1String").html(_("service rmtMethod1"));
	$("#capNmsRemoteSetup").html(_("service nms remote setup"));
	$("#thNmsRemoteControl").html(_("service nms remote control"));
	$("#thNmsServerInterworkingMethod").html(_("service nms server method"));
	$("#thNmsRemoteInputPort").html(_("service nms remote input port"));
	$("#thNmsRemoteUser").html(_("service nms remote user"));
	$("#thRemoteInterface").html(_("service directserial interface"));
	$("#nmsRemoteInterface0").html(_("service interface0"));
	$("#nmsRemoteInterface1").html(_("service interface1"));
	$("#nmsRemoteInterface2").html(_("service interface2"));
	$("#nmsRemoteInterface3").html(_("service interface3"));
	$("#nmsRemoteInterface4").html(_("service interface4"));
	$("#nmsRemoteInterface5").html(_("service interface5"));
	$("#Apply").val(_("service apply"));
	$("#Cancel").val(_("service cancel"));
}

function initCfgValue()
{
	var nmsReportTIME = "<% getCfgGeneral(1, "nmsReportTime"); %>";
	var nmsReportSERVER = "<% getCfgGeneral(1, "nmsReportServer"); %>";
	var nmsReportPORT = "<% getCfgGeneral(1, "nmsReportPort"); %>";
	var nmsRemotePORT = "<% getCfgGeneral(1, "nmsRemotePort"); %>";
	var nmsRemoteUSER = "<% getCfgGeneral(1, "nmsRemoteUser"); %>"

	$("#nmsReportTime").val(nmsReportTIME);
	$("#nmsReportServer").val(nmsReportSERVER);
	$("#nmsReportPort").val(nmsReportPORT);
	$("#nmsRemotePort").val(nmsRemotePORT);
	$("#nmsRemoteUser").val(nmsRemoteUSER);
}

</script>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("nms.asp"); </script>

	<h1 id="nmsTitle"> NMS(Network Management System) </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "nmsIntroduction"> Statement information for Remote control can be set by NMS.</font> 
	</div>
	<div id = "blank"> </div>
	
	<form method="post" name="nmsCfg" id="nmsCfg" action="/goform/setNms">
	<table>
	<caption id="capNmsReportSetup"> NMS Report Setup </caption> 
	<tr>
		<th id="thNmsReport" > NMS Report </th> 
		<td>
			<select name="nmsReport" id="nmsReport"  size="1" onChange="nmsReportSwitch();">
			<option value="Enable"  id="nmsEnable">Enable</option>
			<option value="Disable" id="nmsDisable">Disable</option>
			</select>
		</td>
	</tr>
	<tr id="trReportTime"> 
		<th id="thReportTime">Period Setup</th>
		<td>
			<input type="text" name="nmsReportTime" id="nmsReportTime" size="5" maxlength="5"> 
		</td>
	</tr>
	<tr id = "trReportInterface">
		<th id="thReportInterface"> Interface </th>  
		<td>
			<select name="nmsReportInterface" id="nmsReportInterface"  size="1" >
			<option value="0" id="nmsReportInterface0">WWAN(Domain. 1)/WAN</option>
			<option value="1" id="nmsReportInterface1">WWAN(Domain. 2)</option>
			</select>
		</td>
	</tr>	
	<tr id="trReportServer">
		<th id="thReportServer"> Server Addr </th>
		<td> <input type = "text" name = "nmsReportServer" id = "nmsReportServer" size=32 maxlength = 128> </td>
	</tr>
	<tr id="trReportPort">
		<th id="thReportPort"> Server Port </th>
		<td> <input type = "text" name = "nmsReportPort" id = "nmsReportPort" size=5 maxlength = 5> </td>
	</tr>
	</table>
	
	<div id = "blank"> </div>
	<table>
	<caption id="capNmsRemoteSetup"> NMS Control Setup </caption> 
	<tr>
		<th id="thNmsRemoteControl"> NMS Control </th>
		<td>
			<select name="nmsRemote" id="nmsRemote"  size="1" onChange="nmsRemoteSwitch();">
			<option value="Enable" id="nmsrEnable">Enalbe</option>
			<option value="Disable" id="nmsrDisable">Disable</option>
			</select>
		</td>
	</tr>

	<tr id = "trRemoteMethod">
		<th id="thNmsServerInterworkingMethod"> Server Interworking Method  </th> 
		<td>
			<input name="nmsRmtMethod1" id="nmsRmtMethod1" value="1" type="checkbox" onClick="">&nbsp;<font id="nmsRmtMethod1String">Network Interworking</font>
		 </td>
	</tr>
	<tr id = "trRemoteInterface">
		<th id="thRemoteInterface"> Interface </th>  
		<td>
			<select name="nmsRemoteInterface" id="nmsRemoteInterface"  size="1" >
			<option value="0" id="nmsRemoteInterface0">WWAN(Domain. 1)/WAN</option>
			<option value="1" id="nmsRemoteInterface1">WWAN(Domain. 2)</option>
			</select>
			</select>
		</td>
	</tr>
	<tr id="trRemotePort">
		<th id="thNmsRemoteInputPort"> Input Port </th>
		<td> <input type = "text" name = "nmsRemotePort" id = "nmsRemotePort" size=5 maxlength = 5> </td>
	</tr>
	<tr id="trRemoteUser">
		<th id="thNmsRemoteUser"> Serucity Code </th>
		<td> <input type = "text" name = "nmsRemoteUser" id = "nmsRemoteUser" size=8 maxlength = 8>&nbsp;</td>
	</tr>
	</table>
	
	<div id = "blank" class="error" name="add" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id="Apply">
	<input class = "btn" type = "button" value = "Cancel" id="Cancel">
	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

