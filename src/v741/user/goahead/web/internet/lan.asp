<html>
<head>
<title id = "mainTitle"> <% getModelName(); %> Management </title>
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
Butterlate.setTextDomain("internet");

$(document).ready(function(){ 
	initTranslation();
	initValue(); 

	var validateRule = $("#lanCfg").validate({
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
			dhcpLease: {
				required : true,
				number: true,
				min : 1,
				max : 99999999
			},			
			hostname : {
				required: {
					depends:function(){
						$(this).val($.trim($(this).val()));
						return true;
					}
				},
				minlength : 1
			},			
			lanIp : {
				required : true,
				IP4Checker: true
			}, 
			lanNetmask : {
				required : true,
				IP4Checker: true
			}, 
			lanGateway : {
				required : function() { return ($("#brGateway").css("display") != "none") && ($("#lanGateway").val() != ""); },
				IP4Checker: true
			},
			lanPriDns :{
				required : function() { return ($("#brPriDns").css("display") != "none") && ($("#lanPriDns").val() != ""); },
				IP4Checker: true
			},
			lanSecDns :{
				required : function() { return ($("#brSecDns").css("display") != "none") && ($("#lanSecDns").val() != ""); },
				IP4Checker: true
			},		
			dhcpStart : {
				required : function() { return ($("#lanDhcpType").val() == "SERVER"); },
				IP4Checker: true
			},
			dhcpEnd : {
				required : function() { return ($("#lanDhcpType").val() == "SERVER"); },
				IP4Checker: true
			},
			dhcpMask : {
				required : function() { return ($("#lanDhcpType").val() == "SERVER"); },
				IP4Checker: true
			},			
			dhcpPriDns : {
				required : function() { return ($("#lanDhcpType").val() == "SERVER") && ($("#dhcpPriDns").val() !=""); },
				IP4Checker: true
			}, 
			dhcpSecDns : {
				required : function() { return ($("#lanDhcpType").val() == "SERVER") && ($("#dhcpSecDns").val() !=""); },
				IP4Checker: true
			}, 
			dhcpGateway : {
				required : function() { return ($("#lanDhcpType").val() == "SERVER"); },
				IP4Checker: true
			}		
		},		
		submitHandler :function(form){
			var errors = this.numberOfInvalids();
			if (errors) {
				$("div.error[name=add] span").html(_("alert rule number exceeded"));
				$("div.error[name=add] span").show();
			} else {
				$("div.error[name=add] span").hide();
				if($("#dhcpStatic1Mac").val() != "") $("#dhcpStatic1").val($("#dhcpStatic1Mac").val()+';'+$("#dhcpStatic1Ip").val());
				if($("#dhcpStatic2Mac").val() != "") $("#dhcpStatic2").val($("#dhcpStatic2Mac").val()+';'+$("#dhcpStatic2Ip").val());
				if($("#dhcpStatic3Mac").val() != "") $("#dhcpStatic3").val($("#dhcpStatic3Mac").val()+';'+$("#dhcpStatic3Ip").val());
				if($("#dhcpStatic4Mac").val() != "") $("#dhcpStatic4").val($("#dhcpStatic4Mac").val()+';'+$("#dhcpStatic4Ip").val());
				if($("#dhcpStatic5Mac").val() != "") $("#dhcpStatic5").val($("#dhcpStatic5Mac").val()+';'+$("#dhcpStatic5Ip").val());
				if($("#dhcpStatic6Mac").val() != "") $("#dhcpStatic6").val($("#dhcpStatic6Mac").val()+';'+$("#dhcpStatic6Ip").val());
				if($("#dhcpStatic7Mac").val() != "") $("#dhcpStatic7").val($("#dhcpStatic7Mac").val()+';'+$("#dhcpStatic7Ip").val());
				if($("#dhcpStatic8Mac").val() != "") $("#dhcpStatic8").val($("#dhcpStatic8Mac").val()+';'+$("#dhcpStatic8Ip").val());
				
				form.submit();
			}			
		}
	});	

		
	var macCheckRules = $(':regex(id, ^dhcpStatic[1-8]Mac)');
	macCheckRules.each( function(index, element) { 
		$(element).rules( "add", {
			required: function() { 
				var ip = "#"+$(element).attr('id').replace(/Mac/g, 'Ip');
				return ($("#lanDhcpType").val() == "SERVER") && (($(element).val() !="") || ($(ip).val() != "")); 
			} ,
			MACChecker: true
		});
	});	

	var lanIpCheckRules = $(':regex(id, ^dhcpStatic[1-8]Ip)');
	lanIpCheckRules.each( function(index, element) { 
		$(element).rules( "add", {
			required:  function() {
				var mac = "#"+$(element).attr('id').replace(/Ip/g, 'Mac');
				return ($("#lanDhcpType").val() == "SERVER")  && (($(element).val() !="") || ($(mac).val() != "")); 
			},
			IP4Checker: true
		});
	});	

	$('#lCancel').click(function() { 
		validateRule.resetForm(); 
		$("div.error[name=add] span").hide();
		initValue();
	});

	$('#lCancelSpeed').click(function() { 
		//validateRule.resetForm(); 
		$("div.error[name=add] span").hide();
		initLanSpeed();
	});
} );

function dhcpTypeSwitch()
{
	$("#start").hide();
	$("#end").hide();
	$("#mask").hide();
	$("#pridns").hide();
	$("#secdns").hide();
	$("#gateway").hide();
	$("#lease").hide();
	$("#staticlease1").hide();
	$("#staticlease2").hide();
	$("#staticlease3").hide();
	$("#staticlease4").hide();
	$("#staticlease5").hide();
	$("#staticlease6").hide();
	$("#staticlease7").hide();
	$("#staticlease8").hide();
		
	if (document.lanCfg.lanDhcpType.options.selectedIndex == 1)
	{
		$("#start").show();
		$("#end").show();
		$("#mask").show();
		$("#pridns").show();
		$("#secdns").show();
		$("#gateway").show();
		$("#lease").show();
		$("#staticlease1").show();
		$("#staticlease2").show();
		$("#staticlease3").show();
		$("#staticlease4").show();
		$("#staticlease5").show();
		$("#staticlease6").show();
		$("#staticlease7").show();
		$("#staticlease8").show();
	}
}

function initTranslation()
{
	$("#lTitle").html(_("lan title"));
	$("#lIntroduction").html(_("lan introduction"));
	$("#lSetup").html(_("lan setup"));
	$("#lHostname").html(_("inet hostname"));
	$("#lIp").html(_("inet ip"));
	$("#lNetmask").html(_("inet netmask"));
	$("#lGateway").html(_("inet gateway"));
	$("#lPriDns").html(_("inet pri dns"));
	$("#lSecDns").html(_("inet sec dns"));
	$("#lMac").html(_("inet lan mac"));
	$("#lanComSpeedSet").html(_("lan communication setting"));
	$("#lanCommunicationSpeed").html(_("lan communication speed"));
	//$("#lDhcpType").html(_("lan dhcp type"));
	$("#lDhcpTypeD").html(_("inet disable"));
	$("#lDhcpTypeS").html(_("lan dhcp type server"));
	$("#lDhcpStart").html(_("lan dhcp start"));
	$("#lDhcpEnd").html(_("lan dhcp end"));
	$("#lDhcpNetmask").html(_("inet netmask"));
	$("#lDhcpPriDns").html(_("inet pri dns"));
	$("#lDhcpSecDns").html(_("inet sec dns"));
	$("#lDhcpGateway").html(_("inet gateway"));
	$("#lDhcpLease").html(_("lan dhcp lease"));
	$("#lDhcpStatic1").html(_("lan dhcp static"));
	$("#lDhcpStatic2").html(_("lan dhcp static"));
	$("#lDhcpStatic3").html(_("lan dhcp static"));
	$("#lDhcpStatic4").html(_("lan dhcp static"));
	$("#lDhcpStatic5").html(_("lan dhcp static"));
	$("#lDhcpStatic6").html(_("lan dhcp static"));
	$("#lDhcpStatic7").html(_("lan dhcp static"));
	$("#lDhcpStatic8").html(_("lan dhcp static"));
	$("#OptionFeature").html(_("lan option feature"));
	$("#lStp").html(_("lan stp"));
	$("#lStpD").html(_("inet disable"));
	$("#lStpE").html(_("inet enable"));
	$("#lLltd").html(_("lan lltd"));
	$("#lLltdD").html(_("inet disable"));
	$("#lLltdE").html(_("inet enable"));
	$("#lIgmpp").html(_("lan igmpp"));
	$("#lIgmppD").html(_("inet disable"));
	$("#lIgmppE").html(_("inet enable"));
	$("#lUpnp").html(_("lan upnp"));
	$("#lUpnpD").html(_("inet disable"));
	$("#lUpnpE").html(_("inet enable"));
	$("#lRadvd").html(_("lan radvd"));
	$("#lRadvdD").html(_("inet disable"));
	$("#lRadvdE").html(_("inet enable"));
	$("#lPppoer").html(_("lan pppoer"));
	$("#lPppoerD").html(_("inet disable"));
	$("#lPppoerE").html(_("inet enable"));
	$("#lDnsp").html(_("lan dnsp"));
	$("#lDnspD").html(_("inet disable"));
	$("#lDnspE").html(_("inet enable"));
	$("#seconds").html(_("inet seconds"));

	$("#lApply").val(_("inet apply"));
	$("#lCancel").val(_("inet cancel"));
	$("#lApplySpeed").val(_("inet apply"));
	$("#lCancelSpeed").val(_("inet cancel"));

	$("[id=lDhcpType]").each( function (index, item) { $(item).html( _("lan dhcp type")); } );
}

function initValue()
{
	var opmode = "<% getCfgZero(1, "OperationMode"); %>";
	var dhcp = <% getCfgZero(1, "dhcpEnabled"); %>;
	var stp = <% getCfgZero(1, "stpEnabled"); %>;
	var lltd = <% getCfgZero(1, "lltdEnabled"); %>;
	var igmp = <% getCfgZero(1, "igmpEnabled"); %>;
	var upnp = <% getCfgZero(1, "upnpEnabled"); %>;
	var radvd = <% getCfgZero(1, "radvdEnabled"); %>;
	var pppoe = <% getCfgZero(1, "pppoeREnabled"); %>;
	var dns = <% getCfgZero(1, "dnsPEnabled"); %>;
	var wan = "<% getCfgZero(1, "wanConnectionMode"); %>";
	var lltdb = "<% getLltdBuilt(); %>";
	var igmpb = "<% getIgmpProxyBuilt(); %>";
	var upnpb = "<% getUpnpBuilt(); %>";
	var radvdb = "<% getRadvdBuilt(); %>";
	var pppoeb = "<% getPppoeRelayBuilt(); %>";
	var dnsp = "<% getDnsmasqBuilt(); %>";

	document.lanCfg.lanDhcpType.options.selectedIndex = 1*dhcp;
	dhcpTypeSwitch();
	document.lanCfg.stpEnbl.options.selectedIndex = 1*stp;
	document.lanCfg.lltdEnbl.options.selectedIndex = 1*lltd;
	document.lanCfg.igmpEnbl.options.selectedIndex = 1*igmp;
	document.lanCfg.upnpEnbl.options.selectedIndex = 1*upnp;
	document.lanCfg.radvdEnbl.options.selectedIndex = 1*radvd;
	document.lanCfg.pppoeREnbl.options.selectedIndex = 1*pppoe;
	document.lanCfg.dnspEnbl.options.selectedIndex = 1*dns;	

	initLanSpeed();
	initCfgValue();

	//gateway, dns only allow to configure at bridge mode
	if (opmode != "0") {
		$("#brGateway").hide();
		$("#brPriDns").hide();
		$("#brSecDns").hide();
	}

	if (lltdb == "0") {
		$("#lltd").hide();
		document.lanCfg.lltdEnbl.options.selectedIndex = 0;
	}
	if (igmpb == "0") {
		$("#igmpProxy").hide();
		document.lanCfg.igmpEnbl.options.selectedIndex = 0;
	}
	if (upnpb == "0") {
		$("#upnp").hide();
		document.lanCfg.upnpEnbl.options.selectedIndex = 0;
	}
	if (radvdb == "0") {
		$("#radvd").hide();
		document.lanCfg.radvdEnbl.options.selectedIndex = 0;
	}
	if (pppoeb == "0") {
		$("#pppoerelay").hide();
		document.lanCfg.pppoeREnbl.options.selectedIndex = 0;
	}
	if (dnsp == "0") {
		$("#dnsproxy").hide();
		document.lanCfg.dnspEnbl.options.selectedIndex = 0;
	}
}

function initLanSpeed()
{
	var lanComSpeed = "<% getLanCommunicationSpeed(); %>";	
	document.lanCfg.lanComSpeed.options.selectedIndex = 1*lanComSpeed;
}

function initCfgValue()
{
	var hostName = "<% getCfgGeneral(1, "HostName"); %>";
	var lanIP = "<% getLanIp(); %>";
	var lanNetMask = "<% getLanNetmask(); %>";
	var lanGateWay = "<% getWanGateway(); %>";
	var lanPriDNS = "<% getDns(1); %>";
	var lanSecDNS = "<% getDns(2); %>";
	var macADDress = "<% getLanMac(); %>";
	var dhcpSTART = "<% getCfgGeneral(1, "dhcpStart"); %>";
	var dhcpEND = "<% getCfgGeneral(1, "dhcpEnd"); %>";
	var dhcpMASK = "<% getCfgGeneral(1, "dhcpMask"); %>";
	var dhcpPriDNS = "<% getCfgGeneral(1, "dhcpPriDns"); %>";
	var dhcpSecDNS = "<% getCfgGeneral(1, "dhcpSecDns"); %>";
	var dhcpGateWay = "<% getCfgGeneral(1, "dhcpGateway"); %>";
	var dhcpLEASE = "<% getCfgGeneral(1, "dhcpLease"); %>";
	
	var dhcpStatic1MAC = "<% getCfgNthGeneral(1, "dhcpStatic1", 0); %>";
	var dhcpStatip1IP = "<% getCfgNthGeneral(1, "dhcpStatic1", 1); %>";
	var dhcpStatic2MAC = "<% getCfgNthGeneral(1, "dhcpStatic2", 0); %>";
	var dhcpStatip2IP = "<% getCfgNthGeneral(1, "dhcpStatic2", 1); %>";
	var dhcpStatic3MAC = "<% getCfgNthGeneral(1, "dhcpStatic3", 0); %>";
	var dhcpStatip3IP = "<% getCfgNthGeneral(1, "dhcpStatic3", 1); %>";
	var dhcpStatic4MAC = "<% getCfgNthGeneral(1, "dhcpStatic4", 0); %>";
	var dhcpStatip4IP = "<% getCfgNthGeneral(1, "dhcpStatic4", 1); %>";
	var dhcpStatic5MAC = "<% getCfgNthGeneral(1, "dhcpStatic5", 0); %>";
	var dhcpStatip5IP = "<% getCfgNthGeneral(1, "dhcpStatic5", 1); %>";
	var dhcpStatic6MAC = "<% getCfgNthGeneral(1, "dhcpStatic6", 0); %>";
	var dhcpStatip6IP = "<% getCfgNthGeneral(1, "dhcpStatic6", 1); %>";
	var dhcpStatic7MAC = "<% getCfgNthGeneral(1, "dhcpStatic7", 0); %>";
	var dhcpStatip7IP = "<% getCfgNthGeneral(1, "dhcpStatic7", 1); %>";
	var dhcpStatic8MAC = "<% getCfgNthGeneral(1, "dhcpStatic8", 0); %>";
	var dhcpStatip8IP = "<% getCfgNthGeneral(1, "dhcpStatic8", 1); %>";

	$("#hostname").val(hostName);
	$("#lanIp").val(lanIP);
	$("#lanNetmask").val(lanNetMask);
	$("#lanGateway").val(lanGateWay);
	$("#lanPriDns").val(lanPriDNS);
	$("#lanSecDns").val(lanSecDNS);
	$("td[id=macAddress]").html(macADDress);
	$("#dhcpStart").val(dhcpSTART);
	$("#dhcpEnd").val(dhcpEND);
	$("#dhcpMask").val(dhcpMASK);
	$("#dhcpPriDns").val(dhcpPriDNS);
	$("#dhcpSecDns").val(dhcpSecDNS);
	$("#dhcpGateway").val(dhcpGateWay);
	$("#dhcpLease").val(dhcpLEASE);

	$("#dhcpStatic1Mac").val(dhcpStatic1MAC);
	$("#dhcpStatic1Ip").val(dhcpStatip1IP);
	$("#dhcpStatic2Mac").val(dhcpStatic2MAC);
	$("#dhcpStatic2Ip").val(dhcpStatip2IP);
	$("#dhcpStatic3Mac").val(dhcpStatic3MAC);
	$("#dhcpStatic3Ip").val(dhcpStatip3IP);
	$("#dhcpStatic4Mac").val(dhcpStatic4MAC);
	$("#dhcpStatic4Ip").val(dhcpStatip4IP);
	$("#dhcpStatic5Mac").val(dhcpStatic5MAC);
	$("#dhcpStatic5Ip").val(dhcpStatip5IP);
	$("#dhcpStatic6Mac").val(dhcpStatic6MAC);
	$("#dhcpStatic6Ip").val(dhcpStatip6IP);
	$("#dhcpStatic7Mac").val(dhcpStatic7MAC);
	$("#dhcpStatic7Ip").val(dhcpStatip7IP);
	$("#dhcpStatic8Mac").val(dhcpStatic8MAC);
	$("#dhcpStatic8Ip").val(dhcpStatip8IP);	
}


var oldIp;
function recIpCfg()
{
	oldIp = document.lanCfg.lanIp.value;
}

/*
 * Try to modify dhcp server configurations:
 *   dhcp start/end ip address to the same as new lan ip address
 */
function modDhcpCfg()
{
	var i, j;
	var mask = document.lanCfg.lanNetmask.value;
	var newNet = document.lanCfg.lanIp.value;

	//support simple subnet mask only
	if (mask == "255.255.255.0")
		mask = 3;
	else if (mask == "255.255.0.0")
		mask = 2;
	else if (mask == "255.0.0.0")
		mask = 1;
	else
		return;

	//get the old subnet
	for (i=0, j=0; i<oldIp.length; i++) {
		if (oldIp.charAt(i) == '.') {
			j++;
			if (j != mask)
				continue;
			oldIp = oldIp.substring(0, i);
			break;
		}
	}

	//get the new subnet
	for (i=0, j=0; i<newNet.length; i++) {
		if (newNet.charAt(i) == '.') {
			j++;
			if (j != mask)
				continue;
			newNet = newNet.substring(0, i);
			break;
		}
	}

	document.lanCfg.dhcpStart.value = document.lanCfg.dhcpStart.value.replace(oldIp, newNet);
	document.lanCfg.dhcpEnd.value = document.lanCfg.dhcpEnd.value.replace(oldIp, newNet);
	document.lanCfg.dhcpPriDns.value = document.lanCfg.dhcpPriDns.value.replace(oldIp, newNet);
	document.lanCfg.dhcpGateway.value = document.lanCfg.dhcpGateway.value.replace(oldIp, newNet);
}

 function onlyNumberAllow(event) {
	var key = window.event ? event.keyCode : event.which;    

	if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
		|| key  == 35 || key  == 36 || key  == 37 || key  == 39  // ¹æÇâÅ° ÁÂ¿ì,home,end  
		|| key  == 8  || key  == 46 ) // del, back space
	) {
		return true;
	}else {
		return false;
	}    
};

 function changeComSpeed()
 {
 }


</script>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("lan.asp"); </script>


	<h1 id="lTitle"> Local Area Network (LAN) Settings </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "lIntroduction"> </font> 
	</div>
	<div id = "blank"> </div>

	<form method = post name = "lanCfg" id = "lanCfg" action = "/goform/setLan">

	<table>
	<caption id = "lSetup"> LAN Interface Setup </caption>
	<tr <% var hashost = getHostSupp(); if (hashost != "1") write("style=\"visibility:hidden;display:none\""); %>>
		<th id = "lHostname"> Hostname </th>
		<td>
			 <input name="hostname" id="hostname" class = "tbox_120" maxlength=16>
		</td>
	</tr>
	<tr>
		<th id = "lIp"> IP Address </th>
		<td>
			<input name="lanIp" id="lanIp" class = "tbox_120" maxlength=15 onFocus="recIpCfg()" onBlur="modDhcpCfg()">
		</td>
	</tr>
	<tr>
		<th id = "lNetmask"> Subnet Mask </th>
		<td>
			<input name="lanNetmask" id="lanNetmask" class = "tbox_120" maxlength=15>
		</td>
	</tr>
	<tr id="brGateway">
		<th id = "lGateway"> Default Gateway </th>
		<td>
			<input name="lanGateway" id="lanGateway" class = "tbox_120" maxlength=15>
		</td>
	</tr>
	<tr id="brPriDns">
		<th id = "lPriDns"> Primary DNS Server </th>
		<td>
			<input name="lanPriDns" id="lanPriDns" class = "tbox_120" maxlength=15>
		</td>
	</tr>
	<tr id="brSecDns">
		<th id = "lSecDns"> Secondary DNS Server </th>
		<td>
			<input name="lanSecDns" id="lanSecDns" class = "tbox_120" maxlength=15>
		</td>
	</tr>
	<tr>
		<th id = "lMac"> MAC Address </th>
		<td id = "macAddress"></td>
	</tr>	
	<tr>
		<th id = "lanCommunicationSpeed"> Lan Com Speed </th>
		<td>
			<select name="lanComSpeed" id="lanComSpeed" size="1" onChange="changeComSpeed()">
				<option value="0" id="comSpeed0"> 10base/half </option>
				<option value="1" id="comSpeed1"> 10base/full </option>
				<option value="2" id="comSpeed2"> 100base/half </option>
				<option value="3" id="comSpeed3"> 100base/full </option>
				<option value="4" id="comSpeed4"> auto </option>
			</select>
		</td>
	</tr>
	</table>
	<div id = "blank"> </div>

	<table>
	<caption id = "lDhcpType"> DHCP Type </caption>
	<tr>
		<th id = "lDhcpType"> DHCP Type </th>
		<td>
			<select name="lanDhcpType" id="lanDhcpType"size="1" onChange="dhcpTypeSwitch();">
                        <option value="DISABLE" id="lDhcpTypeD">Disable</option>
                        <option value="SERVER" id="lDhcpTypeS">Server</option>
                    	</select>
		</td>
	</tr>
	<tr id="start">
		<th id = "lDhcpStart" align="right"> DHCP Start IP </th>
		<td>
			<input name="dhcpStart" id="dhcpStart" class = "tbox_120" maxlength=15>
		</td>
	</tr>
	<tr id="end">
		<th id = "lDhcpEnd" align="right"> DHCP End IP </th>
		<td>
			<input name="dhcpEnd" id="dhcpEnd" class = "tbox_120" maxlength=15>
		</td>
	</tr>
	<tr id="mask">
		<th id = "lDhcpNetmask" align="right"> DHCP Subnet Mask </th>
		<td>
			<input name="dhcpMask" id="dhcpMask" class = "tbox_120" maxlength=15>
		</td>
	</tr>
	<tr id="pridns">
		<th id = "lDhcpPriDns" align="right"> DHCP Primary DNS </th>
		<td>
			<input name="dhcpPriDns" id="dhcpPriDns" class = "tbox_120" maxlength=15>
		</td>
	</tr>
	<tr id="secdns">
		<th  id = "lDhcpSecDns" align="right"> DHCP Secondary DNS </th>
		<td>
			<input name="dhcpSecDns" id="dhcpSecDns" class = "tbox_120" maxlength=15>
		</td>
	</tr>
	<tr id="gateway">
		<th id = "lDhcpGateway" align="right"> DHCP Default Gateway</th>
		<td>
			<input name="dhcpGateway" id="dhcpGateway" class = "tbox_120" maxlength=15>
		</td>
	</tr>
	<tr id="lease">
		<th id = "lDhcpLease" align="right"> DHCP Lease Time</th>
		<td>
			<input name="dhcpLease" id="dhcpLease" style="ime-mode:disabled;" onpaste="return false;" onkeydown="return onlyNumberAllow(event)" class = "tbox_60" maxlength=8>
			&nbsp;<font id="seconds"> seconds </font>
		</td>
	</tr>
	<tr id="staticlease1">
		<th id = "lDhcpStatic1" align="right"> Statically Assigned</th>
		<td>
			<input type=hidden name=dhcpStatic1 id="dhcpStatic1" value="">
                      MAC: <input name="dhcpStatic1Mac" id="dhcpStatic1Mac" class = "tbox_120" maxlength=17 size=17> &nbsp&nbsp&nbsp
                      IP: <input name="dhcpStatic1Ip" id="dhcpStatic1Ip" class = "tbox_120" maxlength=15 size=15>
		</td>
	</tr>
	<tr id="staticlease2">
		<th id = "lDhcpStatic2" align="right"> Statically Assigned</th>
		<td>
			<input type=hidden name=dhcpStatic2 id="dhcpStatic2" value="">
                      MAC: <input name="dhcpStatic2Mac" id="dhcpStatic2Mac" class = "tbox_120" maxlength=17 size=17> &nbsp&nbsp&nbsp
                      IP: <input name="dhcpStatic2Ip" id="dhcpStatic2Ip" class = "tbox_120" maxlength=15 size=15>
		</td>
	</tr>
	<tr id="staticlease3">
		<th id = "lDhcpStatic3" align="right"> Statically Assigned</th>
		<td>
			<input type=hidden name=dhcpStatic3 id="dhcpStatic3" value="">
                      MAC: <input name="dhcpStatic3Mac" id="dhcpStatic3Mac" class = "tbox_120" maxlength=17 size=17> &nbsp&nbsp&nbsp
                      IP: <input name="dhcpStatic3Ip" id="dhcpStatic3Ip" class = "tbox_120" maxlength=15 size=15>
		</td>
	</tr>
	<tr id="staticlease4">
		<th id = "lDhcpStatic4" align="right"> Statically Assigned</th>
		<td>
			<input type=hidden name=dhcpStatic4 id="dhcpStatic4" value="">
                      MAC: <input name="dhcpStatic4Mac" id="dhcpStatic4Mac" class = "tbox_120" maxlength=17 size=17> &nbsp&nbsp&nbsp
                      IP: <input name="dhcpStatic4Ip" id="dhcpStatic4Ip" class = "tbox_120" maxlength=15 size=15>
		</td>
	</tr>
	<tr id="staticlease5">
		<th id = "lDhcpStatic5" align="right"> Statically Assigned</th>
		<td>
			<input type=hidden name=dhcpStatic5 id="dhcpStatic5"  value="">
                      MAC: <input name="dhcpStatic5Mac" id="dhcpStatic5Mac" class = "tbox_120" maxlength=17 size=17> &nbsp&nbsp&nbsp
                      IP: <input name="dhcpStatic5Ip" id="dhcpStatic5Ip" class = "tbox_120" maxlength=15 size=15>
		</td>
	</tr>
	<tr id="staticlease6">
		<th id = "lDhcpStatic6" align="right"> Statically Assigned</th>
		<td>
			<input type=hidden name=dhcpStatic6 id="dhcpStatic6" value="">
                      MAC: <input name="dhcpStatic6Mac" id="dhcpStatic6Mac"  class = "tbox_120" maxlength=17 size=17> &nbsp&nbsp&nbsp
                      IP: <input name="dhcpStatic6Ip" id="dhcpStatic6Ip" class = "tbox_120" maxlength=15 size=15>
		</td>
	</tr>
	<tr id="staticlease7">
		<th id = "lDhcpStatic7" align="right"> Statically Assigned</th>
		<td>
			<input type=hidden name=dhcpStatic7 id="dhcpStatic7" value="">
                      MAC: <input name="dhcpStatic7Mac" id="dhcpStatic7Mac" class = "tbox_120" maxlength=17 size=17> &nbsp&nbsp&nbsp
                      IP: <input name="dhcpStatic7Ip" id="dhcpStatic7Ip" class = "tbox_120" maxlength=15 size=15>
		</td>
	</tr>
	<tr id="staticlease8">
		<th id = "lDhcpStatic8" align="right"> Statically Assigned</th>
		<td>
			<input type=hidden name=dhcpStatic8 id="dhcpStatic8" value="">
                      MAC: <input name="dhcpStatic8Mac" id="dhcpStatic8Mac" class = "tbox_120" maxlength=17 size=17> &nbsp&nbsp&nbsp
                      IP: <input name="dhcpStatic8Ip" id="dhcpStatic8Ip" class = "tbox_120" maxlength=15 size=15>
		</td>
	</tr>	
	</table>
	<div id = "blank"> </div>
	
	<table>
	<caption id = "OptionFeature"> Option Feature </caption>
	<tr>
		<th id = "lStp" align="right"> 802.1d Spanning Tree</th>
		<td>
			<select name="stpEnbl" size="1">
                        <option value="0" id="lStpD">Disable</option>
                        <option value="1" id="lStpE">Enable</option>
                    </select>
	</tr>
	<tr id="lltd">
		<th id = "lLltd" align="right"> LLTD</th>
		<td>
			<select name="lltdEnbl" size="1">
                        <option value="0" id="lLltdD">Disable</option>
                        <option value="1" id="lLltdE">Enable</option>
                    </select>
	</tr>
	<tr id="igmpProxy">
		<th id = "lIgmpp" align="right"> IGMP proxy</th>
		<td>
			<select name="igmpEnbl" size="1">
                        <option value="0" id="lIgmppD">Disable</option>
                        <option value="1" id="lIgmppE">Enable</option>
                    </select>
	</tr>
	<tr id="upnp">
		<th id = "lUpnp" align="right"> UPNP</th>
		<td>
			<select name="upnpEnbl" size="1">
                        <option value="0" id="lUpnpD">Disable</option>
                        <option value="1" id="lUpnpE">Enable</option>
                    </select>
	</tr>
	<tr id="radvd">
		<th id = "lRadvd" align="right"> Router Advertisement </th>
		<td>
			<select name="radvdEnbl" size="1">
                        <option value="0" id="lRadvdD">Disable</option>
                        <option value="1" id="lRadvdE">Enable</option>
                    </select>
	</tr>
	<tr id="pppoerelay">
		<th id = "lPppoer" align="right"> PPPOE relay </th>
		<td>
			<select name="pppoeREnbl" size="1">
                        <option value="0" id="lPppoerD">Disable</option>
                        <option value="1" id="lPppoerE">Enable</option>
                    </select>
	</tr>
	<tr id="dnsproxy">
		<th id = "lDnsp" align="right"> DNS proxy </th>
		<td>
			<select name="dnspEnbl" size="1">
                        <option value="0" id="lDnspD">Disable</option>
                        <option value="1" id="lDnspE">Enable</option>
                    </select>
	</tr>
	</table>

	<div id = "blank" class="error" name="add" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "lApply" >
	<input class = "btn" type = "reset" value = "Cancel" id = "lCancel" onClick="window.location.reload()">
	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

