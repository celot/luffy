<html>
<head>
<title id = "mobileDialTitle"> <% getModelName(); %> Management </title>
<meta http - equiv = "Content-type" content = "text/html" charset = "UTF-8">
<meta http - equiv = "Cache-Control" content = "No-Cache"> <meta http - equiv = "Pragma" content = "No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"> </script>
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
	initValue(); 
	jQuery.validator.addMethod("checkDevice", function(value, element, param) {
		var parity = document.getElementById('SerialParity');
		var data = document.getElementById('SerialData');
		var retValue = 0;
		if(parity.options.selectedIndex == 3 && data.options.selectedIndex == 1)
		{
			return false;
		}
		return true;
	});
	
	var validateRule = $("#ModbusCfg").validate({
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
			ModbusBridgeTimeout: {
				required :  true,
				number : true,
				min : 1,
				max : 10000
			},
			ModbusBridgePort: {
				required :  true,
				number : true,
				min : 1,
				max : 65535
			},
			SerialData: {
				required : true,
				checkDevice : true
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

	$('#lCancel').click(function() { 
		validateRule.resetForm(); 
		$("div.error[name=add] span").hide();
		initValue();
	});

} );

function initTranslation()
{
	$("#ModbusTitle").html(_("service modbus title"));
	$("#ModbusIntroduction").html(_("service modbus subtitle"));
	$("#ModbusSetupCaption").html(_("service modbus setup caption"));
	$("#ModbusModTitle").html(_("service modbus mode title")); // auto start

	$("#ModbusBridge").html(_("service modbus mode bridge"));
	$("#ModbusDisable").html(_("service modbus mode disable"));

	$("#ModbusBridgeTimeoutTh").html(_("service modbus timeout"));
	$("#ModbusBridgePortTh").html(_("service modbus port"));


	$("#SerialBaudRateTh").html(_("service modbus boadrate"));
	$("#SerialDataTh").html(_("service modbus data"));
	$("#SerialParityTh").html(_("service modbus parity"));
	$("#SerialStopTh").html(_("service modbus stop"));
	$("#SerialFlowTh").html(_("service modbus flow"));




	$("#btnRefresh").val(_("service refresh"));
	$("#lApply").val(_("service apply"));
	$("#lCancel").val(_("service cancel"));
}

function initValue()
{
	getModbusData();
	statusSwitch();
	
	
}

function statusSwitch()
{
	$("#ModbusBridgeTimeoutTr").hide();
	$("#ModbusBridgePortTr").hide();
	$("#SerialBaudRateTr").hide();
	$("#SerialDataTr").hide();
	$("#SerialParityTr").hide();
	$("#SerialStopTr").hide();
	$("#SerialFlowTr").hide();

	if (document.ModbusCfg.AutoStart.options.selectedIndex == 1)
	{
		$("#ModbusBridgeTimeoutTr").show();
		$("#ModbusBridgePortTr").show();
		$("#SerialBaudRateTr").show();
		$("#SerialDataTr").show();
		$("#SerialParityTr").show();
		$("#SerialStopTr").show();
		$("#SerialFlowTr").show();
	} else if (document.ModbusCfg.AutoStart.options.selectedIndex == 0)
	{
		$("#ModbusBridgeTimeoutTr").hide();
		$("#ModbusBridgePortTr").hide();
		$("#SerialBaudRateTr").hide();
		$("#SerialDataTr").hide();
		$("#SerialParityTr").hide();
		$("#SerialStopTr").hide();
		$("#SerialFlowTr").hide();
	}
}



function getModbusData()
{
	var ModbusGwAutoStart =  "<% getCfgGeneral(1, "ModbusGwAutoStart"); %>";
	document.ModbusCfg.AutoStart.options.selectedIndex = parseInt(ModbusGwAutoStart,10);

	var ModbusGwTcpTmoResp =  "<% getCfgGeneral(1, "ModbusGwTcpTmoResp"); %>";
	if(ModbusGwTcpTmoResp == "")
	{
		document.ModbusCfg.ModbusBridgeTimeout.value = "1000";
	}
	else
	{
		document.ModbusCfg.ModbusBridgeTimeout.value = ModbusGwTcpTmoResp;
	}
	
	var ModbusGwTcpListenPort =  "<% getCfgGeneral(1, "ModbusGwTcpListenPort"); %>";
	if(ModbusGwTcpListenPort == "")
	{
		document.ModbusCfg.ModbusBridgePort.value = "502";
	}
	else
	{
		document.ModbusCfg.ModbusBridgePort.value = ModbusGwTcpListenPort;
	}


	var ModbusGwRtuBps = "<% getCfgGeneral(1, "ModbusGwRtuBps"); %>";
	if (ModbusGwRtuBps == "230400") 
	{
		document.ModbusCfg.SerialBaudRate.options.selectedIndex = 8;
	} 	
	else if (ModbusGwRtuBps == "115200") 
	{
		document.ModbusCfg.SerialBaudRate.options.selectedIndex = 7;
	} 
	else if (ModbusGwRtuBps == "57600") 
	{
		document.ModbusCfg.SerialBaudRate.options.selectedIndex = 6;
	}
	else if (ModbusGwRtuBps == "38400") 
	{
		document.ModbusCfg.SerialBaudRate.options.selectedIndex = 5;
	}
	else if (ModbusGwRtuBps == "19200") 
	{
		document.ModbusCfg.SerialBaudRate.options.selectedIndex = 4;
	}
	else if (ModbusGwRtuBps == "9600") 
	{
		document.ModbusCfg.SerialBaudRate.options.selectedIndex = 3;
	}
	else if (ModbusGwRtuBps == "4800") 
	{
		document.ModbusCfg.SerialBaudRate.options.selectedIndex = 2;
	}
	else if (ModbusGwRtuBps == "2400") 
	{
		document.ModbusCfg.SerialBaudRate.options.selectedIndex = 1;
	}
	else if (ModbusGwRtuBps == "1200") 
	{
		document.ModbusCfg.SerialBaudRate.options.selectedIndex = 0;
	}
	else 
	{
		document.ModbusCfg.SerialBaudRate.options.selectedIndex = 3;
	}

	var ModbusGwRtuDatabit = "<% getCfgGeneral(1, "ModbusGwRtuDatabit"); %>";
	if (ModbusGwRtuDatabit == "7") 
	{
		document.ModbusCfg.SerialData.options.selectedIndex = 0;
	} 	
	else if (ModbusGwRtuDatabit == "8") 
	{
		document.ModbusCfg.SerialData.options.selectedIndex = 1;
	} 
	else 
	{
		document.ModbusCfg.SerialData.options.selectedIndex = 1;
	}

	var ModbusGwRtuParity = "<% getCfgGeneral(1, "ModbusGwRtuParity"); %>";
	if (ModbusGwRtuParity == "0") 
	{
		document.ModbusCfg.SerialParity.options.selectedIndex = 0;
	} 	
	else if (ModbusGwRtuParity == "1") 
	{
		document.ModbusCfg.SerialParity.options.selectedIndex = 1;
	}
	else if (ModbusGwRtuParity == "2") 
	{
		document.ModbusCfg.SerialParity.options.selectedIndex = 2;
	} 
	else if (ModbusGwRtuParity == "3") 
	{
		document.ModbusCfg.SerialParity.options.selectedIndex = 3;
	} 
	else 
	{
		document.ModbusCfg.SerialParity.options.selectedIndex = 0;
	}

	var ModbusGwRtuStopbit = "<% getCfgGeneral(1, "ModbusGwRtuStopbit"); %>";
	if (ModbusGwRtuStopbit == "1") 
	{
		document.ModbusCfg.SerialStop.options.selectedIndex = 0;
	} 	
	else if (ModbusGwRtuStopbit == "2") 
	{
		document.ModbusCfg.SerialStop.options.selectedIndex = 1;
	} 
	else 
	{
		document.ModbusCfg.SerialStop.options.selectedIndex = 0;
	}

	var ModbusGwRtuFlow = "<% getCfgGeneral(1, "ModbusGwRtuFlow"); %>";
	if (ModbusGwRtuFlow == "0") 
	{
		document.ModbusCfg.SerialFlow.options.selectedIndex = 0;
	} 	
	else if (ModbusGwRtuFlow == "1") 
	{
		document.ModbusCfg.SerialFlow.options.selectedIndex = 1;
	} 
	else if (ModbusGwRtuFlow == "2") 
	{
		document.ModbusCfg.SerialFlow.options.selectedIndex = 2;
	} 
	else 
	{
		document.ModbusCfg.SerialFlow.options.selectedIndex = 0;
	}
	

		
	
}

	
</script>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("modbus.asp"); </script>

	<h1 id = "ModbusTitle"> Modbus function</h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "ModbusIntroduction"> </font> 
	</div>
	<div id = "blank"> </div>

	<form method = post name = "ModbusCfg" id = "ModbusCfg" action = "/goform/setModbus">
		<table id="ModbusBridgeSetupTbl">
			<caption id = "ModbusSetupCaption"> Modbus Gatway Setup </caption>

			<tr>
				<th id="ModbusModTitle"> Auto Start </th>
				<td>
					<select name="AutoStart" id="AutoStart"  size="1" onChange="statusSwitch();">
					<option value="0" id="ModbusDisable">Disable</option>
					<option value="1" id="ModbusBridge">Auto Start</option>
					</select>
				</td>
			</tr>
			<tr id="ModbusBridgeTimeoutTr">
				<th id="ModbusBridgeTimeoutTh"> Receive Timeout </th>
				<td> <input type = "text" id= "ModbusBridgeTimeout" name = "ModbusBridgeTimeout" size=5 maxlength = 5>&nbsp<label for="ModbusBridgeTimeout"  id="ModbusBridgeTimeoutLb">[ms]</label> &nbsp;</td>
			</tr>
			<tr id="ModbusBridgePortTr">
				<th id="ModbusBridgePortTh"> Receive Port </th>
				<td> <input type = "text" id= "ModbusBridgePort" name = "ModbusBridgePort" size=5 maxlength = 5> </td>
			</tr>
			
			<tr id="SerialBaudRateTr">
				<th id="SerialBaudRateTh">Baudrate</th>
				<td>
					<select name="SerialBaudRate" id="SerialBaudRate" size="1">
					<option value="1200" id="B1200">1200</option>
					<option value="2400" id="B2400">2400</option>
					<option value="4800" id="B4800">4800</option>
					<option value="9600" id="B9600">9600</option>
					<option value="19200" id="B19200">19200</option>
					<option value="38400" id="B38400">38400</option>
					<option value="57600" id="B57600">57600</option>
					<option value="115200" id="B115200">115200</option>
					<option value="230400" id="B230400">230400</option>
					</select>
					<label for="SerialBaudRate"  id="SerialBaudRateLb">[bps]</label> &nbsp;
				</td>
			</tr>
			<tr  id="SerialParityTr">
				<th id="SerialParityTh"> Parity </th>
				<td>
					<select name="SerialParity" id="SerialParity" size="1">
					<option value="0" id="PNone">none</option>
					<option value="1" id="POdd">odd</option>
					<option value="2" id="PEven">even</option>
					<option value="3" id="PSpace">space</option>
					</select>
				</td>
			</tr>
			<tr id="SerialDataTr">
				<th id="SerialDataTh"> Data </th>
				<td>
					<select name="SerialData" id="SerialData" size="1">
					<option value="7" id="Data7">7 bit</option>
					<option value="8" id="Data8">8 bit</option>
					</select>
				</td>
			</tr>
			<tr id="SerialStopTr">
				<th id="SerialStopTh"> Stop </th>
				<td>
					<select name="SerialStop" id="SerialStop" size="1">
					<option value="1" id="S1bit">1 bit</option>
					<option value="2" id="S2bit">2 bit</option>
					</select>
				</td>
			</tr>
			<tr id="SerialFlowTr">
				<th id="SerialFlowTh"> Flow Control </th>
				<td>
					<select name="SerialFlow" id="deviceFlow" size="1">
					<option value="0" id="Fnone">none</option>
					<option value="1" id="Fonoff">Xon/Xoff</option>
					<option value="2" id="Fhardware">hardware</option>
					</select>
				</td>
			</tr>
		</table>
	<div id = "blank" class="error" name="add" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "lApply">
	<input class = "btn" type = "button" value = "Cancel" id = "lCancel">
	</form>



	
<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

