<html>
<head>
<title><% getModelName(); %> Management</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate_celot.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("admin");

$(document).ready(function(){  
	initTranslation();
	init();

	var validateAddRule = $("#nttConfig").validate({
		rules: {
			inputSubnetMask : {
				Netmask : function() { 
					return ($("#inputSubnetMask").length > 0); 
				}
			}
		},
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addNttConfigContent] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addNttConfigContent] span").show();
			} else {
				$("div.error[name=addNttConfigContent] span").hide();
			}
		},

		submitHandler :function(form){
			var errors = this.numberOfInvalids();
			if (errors) {
				$("div.error[name=addNttConfigContent] span").html(_("alert rule number exceeded"));
				$("div.error[name=addNttConfigContent] span").show();
			} else {
				$("div.error[name=addNttConfigContent] span").hide();
				form.submit();
			}			
		}
	});

	$('#SetNttConfigResetBtn').click(function() { 
		validateAddRule.resetForm(); 
		$("div.error[name=addNttConfigContent] span").hide();
		init();
	});
});

function interfaceChange()
{
	var tmp = $("#NttSubnetInterface").val();
	
	$.get( "/goform/getNttSubnetMask", { wantedInterface : tmp } ).done(
		function( args ) {
			if(args.length>0) 
			{
				$("#inputSubnetMask").val(args);
			}
			else
			{
				$("#inputSubnetMask").val("");
			}
	});
}

function loadNetwork()
{
	var wanTransStandard = '<% getWanTransStandard(); %>';
	$("#nttWanTransStandard").val(wanTransStandard);
}

function loadUSB0Address()
{
	var usb0Address = '<% getUSB0Address(); %>';
	var entries = new Array();
	var nttInterface = '<% getNttConfigInterface(); %>';
	var subnetmask = '<% getNttConfigSubnet(); %>';

	entries = usb0Address.split(":");

	$("#NttSubnetInterface").val(nttInterface);
	$("#usb0IpAddress").html(entries[0]);
	$("#usb0BcAddress").html(entries[1]);
	$("#usb0Netmask").html(entries[2]);
	$("#inputSubnetMask").val(subnetmask);
}

function init()
{
	 loadNetwork();
	 loadUSB0Address();	 
}

function initTranslation()
{
	$("#lTitle").html(_("ntt hidden config"));
	$("#lIntroduction").html(_("ntt hidden config introduction"));
	$("#capNttCommunicationSpeed").html(_("ntt hidden communication speed"));
	$("#thNttCommunicationSpeed").html(_("ntt hidden change communication speed"));
	$("#nttCurrentSubnet").html(_("ntt hidden change subnet"));
	$("#thNttSubnetInterface").html(_("ntt hidden interface"));
	$("#nttInterfaceWWAN1").html(_("ntt hidden wwan1"));
	$("#nttInterfaceWWAN2").html(_("ntt hidden wwan2"));
	$("#IpAddress").html(_("ntt hidden ip address"));
	$("#BroadcastAddress").html(_("ntt hidden broardcast address"));
	$("#SubnetMask").html(_("ntt hidden subnet mask"));
	$("#changeSubnetMask").html(_("ntt hidden change subnet mask"));
	$("#SetNttConfigApplyBtn").val(_("admin apply"));
	$("#SetNttConfigResetBtn").val(_("admin reset"));
}
</script>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("center_push.asp"); </script>
<h1 id="lTitle"> NTT Config </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "lIntroduction"> </font> 
	</div>
	<div id = "blank"> </div>

	<form method=post name="nttConfig" id="nttConfig" action=/goform/setNttConfig>
	<!-- network -->
	<table>
	<caption id = "capNttCommunicationSpeed"> NTT Communication </caption>
	
	<tr>
		<th id="thNttCommunicationSpeed"> Wan Trans Standard</th>
		<td>
			<select name="nttWanTransStandard" id="nttWanTransStandard"  size="1">
			<option value="LTE" id="wanTransStandardLTE">LTE</option>
			<option value="3G" id="wanTransStandard3G">3G</option>
			</select>
		</td>
	</tr>
	</table>
	<div id = "blank"> </div>

	<!-- subnet -->
	<table>
	<caption id = "nttCurrentSubnet"> Current subnet </caption>
		<tr>
			<th id="thNttSubnetInterface"> Interface </th>
			<td>
			<select name="NttSubnetInterface" id="NttSubnetInterface" onChange="interfaceChange();">
			<option value="WWAN1" id="nttInterfaceWWAN1">WWAN1</option>
			<option value="WWAN2" id="nttInterfaceWWAN2">WWAN2</option>
			</select>

			</td>
		</tr>
		<tr>
			<th id="IpAddress"> IP Address </th>
			<td id="usb0IpAddress" name="usb0IpAddress"></td>
		</tr>
		<tr>
			<th id="BroadcastAddress"> Broadcast Address </th>
			<td id="usb0BcAddress" name="usb0BcAddress"></td>
		</tr>
		<tr>
			<th id="SubnetMask"> Netmask </th>
			<td id="usb0Netmask" name="usb0Netmask"></td>
		</tr>
		<tr>
			<th id="changeSubnetMask"> Chagne Subnet mask </th>
			<td>
				<input type="text" name="inputSubnetMask" id="inputSubnetMask" size="16" maxlength="15">
			</td>
		</tr>
	</table>

	<div id = "blank" class="error" name="addNttConfigContent" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "SetNttConfigApplyBtn" name="SetNttConfigApplyBtn">
	<input class = "btn" type = "button" value = "Reset" id = "SetNttConfigResetBtn"  name="SetNttConfigResetBtn" >
	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>
