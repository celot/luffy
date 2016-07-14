<html>
<head>
<script src="/js/jquery-1.6.4.min.js"></script>
<title id = "powerControllerTitle"> <% getModelName(); %> Management </title>
<meta http - equiv = "Content-type" content = "text/html" charset = "UTF-8">
<meta http - equiv = "Cache-Control" content = "No-Cache"> <meta http - equiv = "Pragma" content = "No-Cache">
<script type = "text/javascript" src = "/lang/b28n.js"> </script>
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<script language = "JavaScript" type = "text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("service");



$(document).ready(function(){ 
		initTranslation();
		initValue(); 
	} 
);

function initTranslation()
{

	$("#powerControlDeviceTitle").html(_("service power_controller title"));
	$("#powerControllerIntroduction").html(_("service power_controller introduction"));
	
	$("#powerControllerSetup").html(_("service power_controller statussetup"));
	$("#powerControllerStatus").html(_("service power_controller currentstatus"));


	
	$("#powerControllerExecute").html(_("service power_controller execute"));
	$("#powerControllerDevice").html(_("service power_controller deviceSetup"));
	$("#powerControllerWork").html(_("service power_controller workSetup"));

	$("[id=lApply]").each( function (index, item) { $(item).val( _("service apply")); } );
	$("[id=lCancel]").each( function (index, item) { $(item).val( _("service cancel")); } );


}

function initValue()
{
	var pwrCtrlEnable = 1* <% getCfgZero(1, "enableExPwrDev"); %>;

	if(pwrCtrlEnable == 1)
	{
		document.powerControllerCfg.statusSet.options.selectedIndex = 0;
		$("#dev_work_setup").show();
	}
	else
	{
		document.powerControllerCfg.statusSet.options.selectedIndex = 1;	
		$("#dev_work_setup").hide();
	}

	document.powerControllerExe.deviceSet.options.selectedIndex = 0;
	document.powerControllerExe.workSet.options.selectedIndex = 0;
	
	statusSwitch();
}

function statusSwitch()
{
	if (document.powerControllerCfg.statusSet.options.selectedIndex == 0)
	{
		//$("#dev_work_setup").show();
	}
	else
	{
		//$("#dev_work_setup").hide();
	}
}

function deviceSwitch()
{
	if (document.powerControllerExe.deviceSet.options.selectedIndex == 0)
	{
	}
	else
	{
	}
}

function workSwitch()
{
	if (document.powerControllerExe.workSet.options.selectedIndex == 0)
	{
	}
	else
	{
	}
}

function CheckValue()
{
	
	return true;
}


var onGoingSubmit = false;
function CheckPowerValue()
{
	if(onGoingSubmit == true)
		return false;
	
	onGoingSubmit = true;
	return true;
}

</script>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("power_controller.asp"); </script>

	<h1 id = "powerControlDeviceTitle"> Power Controller</h1>
	
	<div align="left">
	&nbsp;&nbsp; <font id = "powerControllerIntroduction"> </font> 
	</div>
	<div id = "blank"> </div>
	
	<form method = "post" name = "powerControllerCfg" action = "/goform/setPowerController" >
	<table>
	<caption id = "powerControllerSetup"> Status Setup </caption>

	<tr>
		<th id="powerControllerStatus"> Power Controller Status </th>
		<td>
			<select name="statusSet" id="statusSet"  size="1" onChange="statusSwitch();">
			<option value="Enable" id="statusEnable">Enable</option>
			<option value="Disable" id="statusDisable">Disable</option>
			</select>
		</td>
	</tr>
	</table>
	<div id = "blank"> </div>
	<input class = "btn" type = "submit" value = "Apply" id = "lApply" onclick = "return CheckValue()">
	<input class = "btn" type = "reset" value = "Cancel" id = "lCancel" onClick = "window.location.reload()">
	</form>

	<br>

	<div id = "dev_work_setup">
	<div id = "blank"> </div>
	<form method = "post" name = "powerControllerExe" action = "/goform/resetExDevPower" >
	
	<table>
	<caption id = "powerControllerExecute"> Power Control </caption>
		<tr>
			<th id="powerControllerDevice"> Power Controller Device </th>
			<td>
				<select name="deviceSet" id="deviceSet"  size="1" onChange="deviceSwitch();">
				<option value="uartf" id="deviceUartF">UART</option>
				<option value="usb" id="deviceUSB">USB</option>
				<option value="i2c" id="deviceI2C">I2C</option>
				</select>
			</td>
		</tr>


		<tr>
			<th id="powerControllerWork"> Power Controller Work </th>
			<td>
				<select name="workSet" id="workSet"  size="1" onChange="workSwitch();">
				<option value="0" id="workReset">Power 1 RESET</option>
				<option value="1" id="workReset">Power 2 RESET</option>
				</select>
			</td>
		</tr>
	</table>
	<div id = "blank"> </div>
	<input class = "btn" type = "submit" value = "Apply" id = "lApply" onclick = "return CheckPowerValue()">
	<input class = "btn" type = "reset" value = "Cancel" id = "lCancel" onClick = "window.location.reload()">
	</form>
	
	</div>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

