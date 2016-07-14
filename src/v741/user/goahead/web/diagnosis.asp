<html>
<head>
<title id = "mainTitle"> <% getModelName(); %> Management </title>
<meta http - equiv = "Content-type" content = "text/html" charset = "UTF-8">
<meta http - equiv = "Cache-Control" content = "No-Cache"> <meta http - equiv = "Pragma" content = "No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"> </script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
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

function getDiagnosis(all_str)
{
	var i=0, j=0, realId = 0;
	var entries = new Array();
	var ramInfo = new Array();
	var romInfo;
	var networkInfo = new Array();
	var firmwareInfo = new Array();
	var moduleInfo = new Array();

	entries = all_str.split(";");	
	ramInfo = entries[0].split("?");
	romInfo = entries[1];
	networkInfo = entries[2].split("?");
	firmwareInfo = entries[3].split("?");
	moduleInfo = entries[4].split("?");
	
	// ram Info
	var eachRamInfo = new Array();
	for (i=0; i<ramInfo.length;i++)
	{
		eachRamInfo = ramInfo[i].split(":");
		var id = "td[id=tdRam" + i + "]";
		$(id).html(eachRamInfo[1]);
	}

	// rom Info
	var eachRomInfo = romInfo.split(":");
	var id = "td[id=tdRom" + 0 + "]";
	$(id).html(eachRomInfo[1]);

	// network Info
	var eachNetWorkInfo = new Array();
	for (i=0; i<networkInfo.length;i++)
	{
		eachNetWorkInfo = networkInfo[i].split(":");
		var id = "td[id=tdNetwork" + i + "]";
		$(id).html(eachNetWorkInfo[1]);
	}

	// firmware Info
	realId = 0;
	var eachFirmwareInfo = new Array();
	var eachRealFrimwareInfo = new Array();
	for (i=0; i<firmwareInfo.length; i++)
	{		
		eachFirmwareInfo = firmwareInfo[i].split(",");
		for (j=0; j<eachFirmwareInfo.length;j++)
		{
			if (i==0 || i==9) // 0: os info, 9: uptime, idletime. see [firmware_info.cpp]
			{
				eachRealFrimwareInfo = eachFirmwareInfo[j].split("-");
			}
			else
			{
				eachRealFrimwareInfo = eachFirmwareInfo[j].split(":");
			}			

			var id = "td[id=tdFirmware" + realId + "]";
			$(id).html(eachRealFrimwareInfo[1]);
			//$(id).replace(/./g, ',');
			realId++;
		}
	}
	
	// module Info
	realId = 0;
	var eachModuleInfo = new Array();
	var eachRealModuleInfo = new Array();
	for (i=0; i<moduleInfo.length; i++)
	{
		eachModuleInfo = moduleInfo[i].split(",");
		
		for (j=0; j<eachModuleInfo.length;j++)
		{
			 if (i==0)
			 {
			 	eachRealModuleInfo = eachModuleInfo[j].split("@");
			 }
			 else if ( i ==1)
			{
				eachRealModuleInfo = eachModuleInfo[j].split("-");
			}
			else
			{
				eachRealModuleInfo = eachModuleInfo[j].split(":");
			}
			
			var id = "td[id=tdModule" + realId + "]";
			$(id).html(eachRealModuleInfo[1]);
			realId++;
		}
		
	}
}

function initTranslation()
{	
}

function initValue()
{
	$.get("/goform/getDiagnosis", function(args){
				if(args.length>0) getDiagnosis(args);
			}
		);
}

</script>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("lan.asp"); </script>

	<h1 id="lTitle"> Diagnosis </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "diagnosisIntroduction"> You can check the router status.. </font> 
	</div>
	<div id = "blank"> </div>
	
	<form method = post name = "diagnosis" action = "/goform/diagnosis">
	<!-- Ram Info -->
	<table>
	<caption id = "cRamInfo"> Ram Info  </caption>
	<tr>
		<th id="thRamTotal"> Ram Total  </th>
		<td id="tdRam0"></td>
	</tr>
	<tr>
		<th id="thRamLeft"> Ram Left </th>
		<td id="tdRam1"></td>
	</tr>
	<tr>
		<th id="thRamRead"> Ram Read </th>
		<td id="tdRam2"></td>
	</tr>
	</table>
	<div id = "blank"> </div>

	<!-- Rom Info -->
	<table>
	<caption id = "cRomInfo"> Rom Info  </caption>
	<tr>
		<th id="thRomTotal"> Rom Total  </th>
		<td id="tdRom0"></td>
	</tr>
	</table>
	<div id = "blank"> </div>

	<!-- Network Info -->
	<table>
	<caption id = "cInterfaceInfo"> Interface Info  </caption>
	<tr>
		<th id="thNetworkAllNicStatics"> All Nic Statics  </th>
		<td id="tdNetwork0"></td>
	</tr>
	<tr>
		<th id="thNetworkEth1Status"> Eth1 Status  </th>
		<td id="tdNetwork1"></td>
	</tr>
	<tr>
		<th id="thNetworkEth2Status"> Eth2 Status  </th>
		<td id="tdNetwork2"></td>
	</tr>
	<tr>
		<th id="thNetworkLanName"> Lan Name  </th>
		<td id="tdNetwork3"></td>
	</tr>
	<tr>
		<th id="thNetworkLanIP"> Lan IP  </th>
		<td id="tdNetwork4"></td>
	</tr>
	<tr>
		<th id="thNetworkWanName"> Wan Name  </th>
		<td id="tdNetwork5"></td>
	</tr>
	<tr>
		<th id="thNetworkWanIP"> Wan IP  </th>
		<td id="tdNetwork6"></td>
	</tr>
	<tr>
		<th id="thNetworkLanPing"> Lan Ping Test  </th>
		<td id="tdNetwork7"></td>
	</tr>
	<tr>
		<th id="thNetworkWanPing"> Wan Ping Test  </th>
		<td id="tdNetwork8"></td>
	</tr>
	</table>

	<!-- Firmware  Info -->
	<div id = "blank"> </div>
	<table>
	<caption id = "cFirmwareInfo"> Firmware Info  </caption>
		<!-- status -->
		<tr> 
			<th> Name </th>
			<th>	 OS Info </th>
		</tr>	
		<tr>
			<th id="thFirmwareOSType"> OS Type </th>
			<td id="tdFirmware0"></td>
		</tr>
		<tr>
			<th id="thFirmwareOSVersion"> OS Version </th>
			<td id="tdFirmware1"></td>
		</tr>
		<tr>
			<th id="thFirmwareOSType"> OS Release </th>
			<td id="tdFirmware2"></td>
		</tr>

		<!-- cpu info -->
		<tr> 
			<th> Name </th>
			<th>	 Cpu Info </th>
		</tr>	
		<tr>
			<th id="thFirmwareSystemType"> System Type  </th>
			<td id="tdFirmware3"></td>
		</tr>
		<tr>
			<th id="thFirmwareProcessor"> Processor  </th>
			<td id="tdFirmware4"></td>
		</tr>
		<tr>
			<th id="thFirmwareCpuModel"> Cpu Model  </th>
			<td id="tdFirmware5"></td>
		</tr>
		<tr>
			<th id="thFirmwareBogoMIPS"> BogoMIPS  </th>
			<td id="tdFirmware6"></td>
		</tr>
		<tr>
			<th id="thFirmwareWaitInstruction"> Wait Instruction  </th>
			<td id="tdFirmware7"></td>
		</tr>
		<tr>
			<th id="thFirmwareMicrosecondTimers"> Microsecond Timers  </th>
			<td id="tdFirmware8"></td>
		</tr>
		<tr>
			<th id="thFirmwareTlbEntries"> tlb_entries  </th>
			<td id="tdFirmware9"></td>
		</tr>
		<tr>
			<th id="thFirmwareExtraInterruptVector"> Extra Interrupt Vector  </th>
			<td id="tdFirmware10"></td>
		</tr>
		<tr>
			<th id="thFirmwareHardwareWatchpoint"> Hardware Watchpoint  </th>
			<td id="tdFirmware11"></td>
		</tr>
		<tr>
			<th id="thFirmwareASEsImplemented"> ASEs Implemented  </th>
			<td id="tdFirmware12"></td>
		</tr>
		<tr>
			<th id="thFirmwareVCEDexceptions"> VCED Exceptions  </th>
			<td id="tdFirmware13"></td>
		</tr>
		<tr>
			<th id="thFirmwareVCEI Exceptions"> VCEI Exceptions  </th>
			<td id="tdFirmware14"></td>
		</tr>
		
		<!-- Devices -->
		<tr> 
			<th> Name </th>
			<th>	 Device </th>
		</tr>	
		<tr>
			<th id="thFirmwareSystemType"> Character devices  </th>
			<td id="tdFirmware15" style="word-break:break-all; word-wrap:break-word"></td>
		</tr>
		<tr>
			<th id="thFirmwareSystemType"> Block devices  </th>
			<td id="tdFirmware16"></td>
		</tr>

		<!-- External Status -->
		<tr> 
			<th> Name </th>
			<th>	 External Power Status </th>
		</tr>	
		<tr>
			<th id="thFirmwareExternalStatus"> Status  </th>
			<td id="tdFirmware17"></td>
		</tr>

		<!-- Serial Info -->
		<tr> 
			<th> Name </th>
			<th>	 Serial Info</th>
		</tr>	
		<tr>
			<th id="thFirmwareSerialSerInfo"> Ser Info </th>
			<td id="tdFirmware18"></td>
		</tr>
		<tr>
			<th id="thFirmwareSerial0"> Info(0)  </th>
			<td id="tdFirmware19"></td>
		</tr>
		<tr>
			<th id="thFirmwareSerial1"> Info(1)  </th>
			<td id="tdFirmware20"></td>
		</tr>

		<!-- USB Info -->
		<tr> 
			<th> Name </th>
			<th>	 USB Info</th>
		</tr>	
		<tr>
			<th id="thFirmwareUSBSerInfo"> Ser Info </th>
			<td id="tdFirmware21"></td>
		</tr>
		<tr>
			<th id="thFirmwareDriver"> Driver  </th>
			<td id="tdFirmware22"></td>
		</tr>

		<!-- Host Name -->
		<tr> 
			<th> Name </th>
			<th>	 Host Name</th>
		</tr>	
		<tr>
			<th id="thFirmwareHostName"> Host  </th>
			<td id="tdFirmware23"></td>
		</tr>

		<!-- Domain Name -->
		<tr> 
			<th> Name </th>
			<th>	 Domain Name</th>
		</tr>	
		<tr>
			<th id="thFirmwareDomainName"> Domain  </th>
			<td id="tdFirmware24"></td>
		</tr>

		<!-- Partitions -->
		<tr> 
			<th> Name </th>
			<th>	 Partitions Info (major, minor, blocks)</th>
		</tr>	
		<tr>
			<th id="thFirmwarePartition"> mtdblock0  </th>
			<td id="tdFirmware25"></td>
		</tr>
		<tr>
			<th id="thFirmwarePartition"> mtdblock1  </th>
			<td id="tdFirmware26"></td>
		</tr>
		<tr>
			<th id="thFirmwarePartition"> mtdblock2  </th>
			<td id="tdFirmware27"></td>
		</tr>
		<tr>
			<th id="thFirmwarePartition"> mtdblock3  </th>
			<td id="tdFirmware28"></td>
		</tr>
		<tr>
			<th id="thFirmwarePartition"> mtdblock4  </th>
			<td id="tdFirmware29"></td>
		</tr>
		<tr>
			<th id="thFirmwarePartition"> mtdblock5  </th>
			<td id="tdFirmware30"></td>
		</tr>
		<tr>
			<th id="thFirmwarePartition"> mtdblock6  </th>
			<td id="tdFirmware31"></td>
		</tr>
		<tr>
			<th id="thFirmwarePartition"> mtdblock7  </th>
			<td id="tdFirmware32"></td>
		</tr>

		<!-- Uptime -->
		<tr> 
			<th> Name </th>
			<th>	 Time</th>
		</tr>	
		<tr>
			<th id="thFirmwareUptime"> Uptime  </th>
			<td id="tdFirmware33"></td>
		</tr>
		<tr>
			<th id="thFirmwareIdletime"> Idle time  </th>
			<td id="tdFirmware34"></td>
		</tr>

		<!-- Major Process -->
		<tr> 
			<th> Name </th>
			<th>	 Major Process</th>
		</tr>	
		<tr>
			<th id="thFirmwareProcess"> mod_man  </th>
			<td id="tdFirmware35"></td>
		</tr>
		<tr>
			<th id="thFirmwareProcess"> nvram_daemon  </th>
			<td id="tdFirmware36"></td>
		</tr>
		<tr>
			<th id="thFirmwareProcess"> goahead  </th>
			<td id="tdFirmware37"></td>
		</tr>
		<tr>
			<th id="thFirmwareProcess"> ct_daemon  </th>
			<td id="tdFirmware38"></td>
		</tr>

		
	</table>

	<!-- Module  Info -->
	<div id = "blank"> </div>
	<table>
	<caption id = "cModuleInfo"> Module Info  </caption>
		<!-- status -->
		<tr> 
			<th> Name </th>
			<th>	 Status </th>
		</tr>	
		<tr>
			<th id="thModuleBand"> Band  </th>
			<td id="tdModule0"></td>
		</tr>
		<tr>
			<th id="thModuleService"> Service  </th>
			<td id="tdModule1"></td>
		</tr>
		<tr>
			<th id="thModuleSignal"> Signal  </th>
			<td id="tdModule2"></td>
		</tr>
		<!-- sys info -->
		<tr> 
			<th> Name </th>
			<th>	 Sys Info </th>
		</tr>	
		<tr>
			<th id="thModuleManufature"> Band  </th>
			<td id="tdModule3"></td>
		</tr>
		<tr>
			<th id="thModuleModel"> Service  </th>
			<td id="tdModule4"></td>
		</tr>
		<tr>
			<th id="thModuleSWVersion"> S/W Ver  </th>
			<td id="tdModule5"></td>
		</tr>
		<tr>
			<th id="thModuleHWVersion"> H/W Ver  </th>
			<td id="tdModule6"></td>
		</tr>	

		<!-- phone number -->
		<tr> 
			<th> Name </th>
			<th>	 Phone Number </th>
		</tr>	
		<tr>
			<th id="thModulePhoneNumber"> Number  </th>
			<td id="tdModule7"></td>
		</tr>

		<!-- pin status-->
		<tr> 
			<th> Name </th>
			<th>	 Pin Status</th>
		</tr>	
		<tr>
			<th id="thModulePhoneNumber"> Status  </th>
			<td id="tdModule8"></td>
		</tr>

		<!-- call status-->
		<tr> 
			<th> Name </th>
			<th>	 Call Status</th>
		</tr>	
		<tr>
			<th id="thModuleCallStatus"> Status  </th>
			<td id="tdModule9"></td>
		</tr>

		<!-- ota status-->
		<tr> 
			<th> Name </th>
			<th>	 OTA Status</th>
		</tr>	
		<tr>
			<th id="thModuleOTAStatus"> Status  </th>
			<td id="tdModule10"></td>
		</tr>

		<!-- imei  -->
		<tr> 
			<th> Name </th>
			<th>	 Imei </th>
		</tr>	
		<tr>
			<th id="thModuleImei"> Number </th>
			<td id="tdModule11"></td>
		</tr>

		<!-- iccid -->
		<tr> 
			<th> Name </th>
			<th>	 Iccid </th>
		</tr>	
		<tr>
			<th id="thModuleIccid"> Number  </th>
			<td id="tdModule12"></td>
		</tr>
		
	</table>

	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>


