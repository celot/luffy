<html>
<head>
<title id = "mainTitle"> <% getModelName(); %> Management </title>
<meta http - equiv = "Content-type" content = "text/html" charset = "UTF-8">
<meta http - equiv = "Cache-Control" content = "No-Cache"> <meta http - equiv = "Pragma" content = "No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type = "text/javascript" src = "/lang/b28n.js"> </script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate_celot.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<script language = "JavaScript" type = "text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("wireless");

$(document).ready(function(){ 
	initTranslation();
	initValue(); 

	var validateRule = $("#wireless_basic").validate({
		rules: {
			mssid_0: {
				required : true,
				minlength : 1
			}
		},
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=info] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=info] span").show();
			} else {
				$("div.error[name=info] span").hide();
			}
		},

		submitHandler :function(form){
			if(this.numberOfInvalids())
			{
				return;
			}
			else
			{
				$("div.error[name=info] span").hide();
				form.submit();
			}
		}
	});	
	
	$('#basicCancel').click(function() { 
		validateRule.resetForm(); 
		$("div.error[name=info] span").hide();
		initBasic();
	});

	var validateHotspotRule = $("#hotspot").validate({
		rules: {
			hotspotRadiusServer1: {
				required : true,
				minlength : 1
			},
			hotspotRadiusSecret: {
				required : true,
				minlength : 1
			},
			hotspotUamServer: {
				required : true,
				minlength : 1
			},
			hotspotUamSecret: {
				required : true,
				minlength : 1
			},
			hotspotDns1: {
				required : true,
				minlength : 1
			}
			
		},
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=hotspot] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=hotspot] span").show();
			} else {
				$("div.error[name=hotspot] span").hide();
			}
		},

		submitHandler :function(form){
			if(this.numberOfInvalids())
			{
				return;
			}
			else
			{
				$("div.error[name=hotspot] span").hide();
				form.submit();
			}
		}
	});	

	$('#hotspotCancel').click(function() { 
		validateHotspotRule.resetForm(); 
		$("div.error[name=hotspot] span").hide();
		initHotspot();
	});

});	

function initTranslation()
{
	$("#basicTitle").html(_("basic title"));
	$("#basicIntroduction").html(_("basic introduction"));
	$("#basicWirelessNet").html(_("basic wireless network"));
	$("#basicWiFiButton").html(_("basic wifi button"));
	$("#wifiStatus").html(_("basic wifi status"));
	$("#basicNetMode").html(_("basic network mode"));
	$("#basicSSID").html(_("basic ssid"));
	$("#basicHSSID0").html(_("basic hssid"));
	$("#basicFreqB").html(_("basic frequency"));
	$("#basicFreqG").html(_("basic frequency"));
	$("#advCountryCode").html(_("adv country code"));
	$("#advCountryCodeKR").html(_("adv country code kr"));
	$("#advCountryCodeUS").html(_("adv country code us"));
	$("#advCountryCodeJP").html(_("adv country code jp"));
	$("#advCountryCodeFR").html(_("adv country code fr"));
	$("#advCountryCodePL").html(_("adv country code pl"));
	$("#advCountryCodeTW").html(_("adv country code tw"));
	$("#advCountryCodeIE").html(_("adv country code ie"));
	$("#advCountryCodeHK").html(_("adv country code hk"));
	$("#advCountryCodeNONE").html(_("wireless none"));
	
	$("#basicHTAllowTKIPDisable").html(_("wireless disable"));
	$("#basicHTAllowTKIPEnable").html(_("wireless enable"));

	$("#basicHTAllowTKIP").html(_("wireless TKIP"));
	$("#basicBandWidth").html(_("wireless band width title"));
	$("#basicGuardInterval").html(_("wireless guard interval title"));



	$("#wirelessIsolation").html(_("wireless isolation title"));
	$("#basicIsolationEnable").html(_("wireless enable"));
	$("#basicIsolationDisable").html(_("wireless disable"));
	$("#wirelessMaxStation").html(_("wireless max station title"));

	
	$("#basicApply").val(_("wireless apply"));
	$("#basicCancel").val(_("wireless cancel"));




	$("#basicHotSpotSet").html(_("wireless hotspot title"));
	$("#thHotspotEnable").html(_("wireless hotspot enable"));
	//$("#thHotspotOutInterface").html(_("wireless hotspot out interface"));
	$("#thHotspotRadiusServer1").html(_("wireless hotspot radius server 1"));
	$("#thHotspotRadiusSecret").html(_("wireless hotspot radius secret"));
	$("#thHotspotUamServer").html(_("wireless hotspot uam server"));
	$("#thHotspotUamSecret").html(_("wireless hotspot uam secret"));
	$("#thHotspotDns1").html(_("wireless hotspot dns 1"));


	$("#thHotspotAdvUrl").html(_("wireless hotspot adv url"));
	$("#thHotspotDefaultUrl").html(_("wireless hotspot default url"));
	$("#thHotspotTimeOut").html(_("wireless hotspot timeout"));

	
	$("#hotspotApply").val(_("wireless apply"));
	$("#hotspotCancel").val(_("wireless cancel"));
	
}

function initContryCode()
{
	var countrycode = '<% getCfgGeneral(1, "CountryCode"); %>';
	if(countrycode.length)
	{
		try { $("#country_code").val(countrycode); }
		catch(e) { $("#country_code").val("NONE"); }
	}
	else
	{
		$("#country_code").val("NONE");
	}
}

function initValue()
{
	initBasic();
	initHotspot();
}

function initBasic()
{
	var CurrChLen;
	var i = 0;
	var wifi_off = '<% getCfgZero(1, "WiFiOff"); %>';
	var PhyMode  = '<% getCfgZero(1, "WirelessMode"); %>';
	var HiddenSSID  = '<% getCfgZero(1, "HideSSID"); %>';
	var ChIdx  = '<% getWlanChannel(); %>';
	var ht_disallow_tkip = '<% getCfgZero(1, "HT_DisallowTKIP"); %>';
	var n_bandwidth = '<% getCfgZero(1, "HT_BW"); %>';
	var n_guard_interval = '<% getCfgZero(1, "HT_GI"); %>';

	var n_isolatation = '<% getCfgZero(1, "NoForwarding"); %>';
	var n_max_station = '<% getCfgZero(1, "MaxStaNum"); %>';
	
	$("#div_11b_channel").hide();
	$("#div_11g_channel").hide();
	$("#sz11bChannel").attr("disabled",true);
	$("#sz11gChannel").attr("disabled",true);

	PhyMode = 1*PhyMode;
	if ((PhyMode == 0) || (PhyMode == 4) || (PhyMode == 9) || (PhyMode == 6))
	{
		if (PhyMode == 0)
			document.wireless_basic.wirelessmode.options.selectedIndex = 0;
		else if (PhyMode == 4)
			document.wireless_basic.wirelessmode.options.selectedIndex = 2;
		else if (PhyMode == 9)
			document.wireless_basic.wirelessmode.options.selectedIndex = 3;
		else if (PhyMode == 6)
			document.wireless_basic.wirelessmode.options.selectedIndex = 4;

		$("#div_11g_channel").show();
		$("#sz11gChannel").attr("disabled",false);
	}
	else if (PhyMode == 1)
	{
		document.wireless_basic.wirelessmode.options.selectedIndex = 1;
		$("#div_11b_channel").show();
		$("#sz11bChannel").attr("disabled",false);
	}
	else
	{
		$("#div_11g_channel").show();
		$("#sz11gChannel").attr("disabled",false);
	}

	ChIdx = 1*ChIdx;
	if ((PhyMode == 0) || (PhyMode == 4) || (PhyMode == 9) || (PhyMode == 6))
	{
		document.wireless_basic.sz11gChannel.options.selectedIndex = ChIdx;
		CurrChLen = document.wireless_basic.sz11gChannel.options.length;
		if ((ChIdx + 1) > CurrChLen)
			document.wireless_basic.sz11gChannel.options.selectedIndex = 0;
	}
	else if (PhyMode == 1)
	{
		document.wireless_basic.sz11bChannel.options.selectedIndex = ChIdx;
		CurrChLen = document.wireless_basic.sz11bChannel.options.length;
		if ((ChIdx + 1) > CurrChLen)
			document.wireless_basic.sz11bChannel.options.selectedIndex = 0;
	}
	
	if (1*wifi_off == 1)
	{
		$("#wifiStatusValue").html(_("basic wifi off"));
		$("#WiFiButton").val(_("basic btn WiFi ON"));
	}
	else
	{
		$("#wifiStatusValue").html(_("basic wifi on"));
		$("#WiFiButton").val(_("basic btn WiFi OFF"));
	}

	$("#mssid_0").val("<% getCfgToHTML(1, "SSID1"); %>");
	document.wireless_basic.hssid.checked = false;
	if(HiddenSSID.length>0)
	{
		var hssid0 = HiddenSSID.substr(0,1);
		if(hssid0=="1")
		{
			document.wireless_basic.hssid.checked = true;
		}
	}

	document.wireless_basic.isolated_ssid.checked = false;
	if(n_isolatation.length>0)
	{
		var isolatation = n_isolatation.substr(0,1);
		if(isolatation=="1")
		{
			document.wireless_basic.isolated_ssid.checked = true;
		}
	}
	
	if (1*ht_disallow_tkip == 1)
		document.wireless_basic.n_disallow_tkip[1].checked = true;
	else
		document.wireless_basic.n_disallow_tkip[0].checked = true;

	if (1*n_bandwidth == 1)
		document.wireless_basic.n_bandwidth[1].checked = true;
	else
		document.wireless_basic.n_bandwidth[0].checked = true;

	if (1*n_guard_interval == 1)
		document.wireless_basic.n_gi[1].checked = true;
	else
		document.wireless_basic.n_gi[0].checked = true;


	if((PhyMode == 9) || (PhyMode == 6))
	{
		$("#htmode_tkip").show();
		$("#htmode_bandwidth").show();
		$("#htmode_guard_interval").show();	
	}
	else
	{
		$("#htmode_tkip").hide();
		$("#htmode_bandwidth").hide();
		$("#htmode_guard_interval").hide();	
	}
	
	initContryCode();
}

function initHotspot()
{
	var hotspotBuilt = "<% getHotSpotBuilt(); %>"; 

	var hotspotEnable = '<% getCfgZero(1, "hotspotEnable"); %>';
	//var hotspotOutInterface = '<% getCfgZero(1, "hotspotOutInterface"); %>';
	var hotspotRadiusServer1 = '<% getCfgGeneral(1, "hotspotRadiusServer1"); %>';
	var hotspotRadiusSecret = '<% getCfgGeneral(1, "hotspotRadiusSecret"); %>';
	var hotspotDhcpif = '<% getCfgGeneral(1, "hotspotDhcpif"); %>';
	var hotspotUamServer = '<% getCfgGeneral(1, "hotspotUamServer"); %>';
	var hotspotUamSecret = '<% getCfgGeneral(1, "hotspotUamSecret"); %>';
	var hotspotUamAllowed = '<% getCfgGeneral(1, "hotspotUamAllowed"); %>';
	var hotspotDns1 = '<% getCfgGeneral(1, "hotspotDns1"); %>';

	var hotspotAdvUrl = '<% getCfgGeneral(1, "hotspotAdvUrl"); %>';
	var hotspotDefaultUrl = '<% getCfgGeneral(1, "hotspotDefaultUrl"); %>';
	var hotspotTimeOut = '<% getCfgZero(1, "hotspotTimeOut"); %>';

	
	if (hotspotBuilt == "1")
	{
		if (hotspotEnable == "1")
			document.hotspot.hotspotEnable[1].checked = true;
		else
			document.hotspot.hotspotEnable[0].checked = true;
			
		//$("#hotspotOutInterface").val(hotspotOutInterface); 
		$("#hotspotRadiusServer1").val(hotspotRadiusServer1); 
		$("#hotspotRadiusSecret").val(hotspotRadiusSecret); 
		$("#hotspotUamServer").val(hotspotUamServer); 
		$("#hotspotUamSecret").val(hotspotUamSecret); 
		$("#hotspotDns1").val(hotspotDns1); 

		$("#trHotspotAdvUrl").hide();
		$("#trHotspotDefaultUrl").hide();
		$("#trHotspotTimeOut").hide();
		
	}
	else if (hotspotBuilt == "2")
	{
		if (hotspotEnable == "1")
			document.hotspot.hotspotEnable[1].checked = true;
		else
			document.hotspot.hotspotEnable[0].checked = true;
			
		//$("#hotspotOutInterface").val(hotspotOutInterface); 
		$("#hotspotRadiusServer1").val(hotspotRadiusServer1); 
		$("#hotspotRadiusSecret").val(hotspotRadiusSecret); 
		$("#hotspotUamServer").val(hotspotUamServer); 
		$("#hotspotUamSecret").val(hotspotUamSecret); 
		$("#hotspotDns1").val(hotspotDns1); 

		$("#hotspotAdvUrl").val(hotspotAdvUrl); 
		$("#hotspotDefaultUrl").val(hotspotDefaultUrl); 
		$("#hotspotTimeOut").val(hotspotTimeOut); 


		$("#trHotspotRadiusServer1").hide(); 
		$("#trHotspotRadiusSecret").hide();
		//$("#trHotspotUamServer").hide();
		$("#trHotspotUamSecret").hide();
		//$("#trHotspotDns1").hide();
		$("#trHotspotAdvUrl").hide();
	}
	else
	{
		$("#div_hotspot").hide();
	}

	
}


function wirelessModeChange()
{
	var wmode;

	$("#div_11b_channel").hide();
	$("#div_11g_channel").hide();
	$("#sz11bChannel").attr("disabled",true);
	$("#sz11gChannel").attr("disabled",true);

	wmode = document.wireless_basic.wirelessmode.options.selectedIndex;
	wmode = 1*wmode;
	if (wmode == 0)
	{
		document.wireless_basic.wirelessmode.options.selectedIndex = 0;
		$("#div_11g_channel").show();
		$("#sz11gChannel").attr("disabled",false);
	}	
	else if (wmode == 1)
	{
		document.wireless_basic.wirelessmode.options.selectedIndex = 1;
		$("#div_11b_channel").show();
		$("#sz11bChannel").attr("disabled",false);
	}
	else if (wmode == 2)
	{
		document.wireless_basic.wirelessmode.options.selectedIndex = 2;
		$("#div_11g_channel").show();
		$("#sz11gChannel").attr("disabled",false);
	}
	else if ((wmode == 3) || (wmode == 4))
	{
		if (wmode == 4)
			document.wireless_basic.wirelessmode.options.selectedIndex = 4;
		else
			document.wireless_basic.wirelessmode.options.selectedIndex = 3;

		$("#div_11g_channel").show();
		$("#sz11gChannel").attr("disabled",false);
	}


	if(wmode == 3 || wmode == 4)
	{
		$("#htmode_tkip").show();
		$("#htmode_bandwidth").show();
		$("#htmode_guard_interval").show();	
	}
	else
	{
		$("#htmode_tkip").hide();
		$("#htmode_bandwidth").hide();
		$("#htmode_guard_interval").hide();	
	}
}

function WiFiStatusChange()
{
	var wifi_off = '<% getCfgZero(1, "WiFiOff"); %>';

	if (wifi_off == 1) {
		$("#wifiStatusValue").html(_("basic wifi on"));
		$("#WiFiButton").val(_("basic btn WiFi OFF"));
		$("#wifihiddenButton").val(1);
	}
	else {
		$("#wifiStatusValue").html(_("basic wifi off"));
		$("#WiFiButton").val(_("basic btn WiFi ON"));
		$("#wifihiddenButton").val(0);
	}
}
</script>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("basic.asp"); </script>

	<h1 id="basicTitle"> Basic Wireless Settings </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "basicIntroduction"> </font> 
	</div>
	<div id = "blank"> </div>

	<form method=post name=wireless_basic id="wireless_basic" action="/goform/wirelessBasicad">

	<table>
	<caption id = "basicWirelessNet"> Wireless Network </caption>
	<tr>
		<th id = "basicWiFiButton"> WiFi UP/DOWN </th>
		<td>
			 <input class = "btn2_white" type="button" name="WiFiButton"  id="WiFiButton" value="WiFi ON"
                    onClick="WiFiStatusChange(); document.wireless_basic.submit();"> &nbsp; &nbsp;
                    <input type=hidden name=wifihiddenButton id="wifihiddenButton" value="2">
                     &nbsp; &nbsp; <font id="wifiStatus"> Current Status : </font> &nbsp; <font id="wifiStatusValue"> On </font>
		</td>
	</tr>
	<tr>
		<th id = "basicNetMode"> Network Mode </th>
		<td>
			<select name="wirelessmode" id="wirelessmode" size="1" onChange="wirelessModeChange()">
                        <option value=0>11b/g mixed mode</option>
                        <option value=1>11b only</option>
                        <option value=4>11g only</option>
                        <option value=9>11b/g/n mixed mode</option>
                        <option value=6>11n only(2.4G)</option>
			</select>
		</td>
	</tr>
	<input type="hidden" name="bssid_num" id="bssid_num" value="1">
	<tr>
		<th id = "basicSSID"> Network Name(SSID) </th>
		<td>
			<input type=text name=mssid_0 id="mssid_0" size=20 maxlength=32>
                    &nbsp;&nbsp;&nbsp;<label for=hssid id="basicHSSID0">Hidden</label>
                    <input type=checkbox name=hssid id="hssid" value="0">
                    &nbsp;&nbsp; &nbsp;&nbsp;<label for=isolated_ssid id="wirelessIsolation">Isolation</label>
                    <input type=checkbox name=isolated_ssid id="isolated_ssid" value="0">
		</td>
	</tr>
 	<tr  id="div_11b_channel" name="div_11b_channel">
		<th id = "basicFreqB"> Frequency (Channel) </th>
		<td>
			<select id="sz11bChannel" name="sz11bChannel" size="1">
                        <option value=0 id="basicFreqBAuto">AutoSelect</option>
                        <% getWlan11bChannels(); %>
                    </select>
		</td>
	</tr>	
 	<tr  id="div_11g_channel" name="div_11g_channel">
		<th id = "basicFreqG"> Frequency (Channel) </th>
		<td>
			<select id="sz11gChannel" name="sz11gChannel" size="1">
                        <option value=0 id="basicFreqGAuto">AutoSelect</option>
                        <% getWlan11gChannels(); %>
                    </select>
		</td>
	</tr>
	<tr>
		<th id = "advCountryCode"> Country Code</th>
		<td>
			<select name="country_code" id="country_code">
				<option value="JP" id="advCountryCodeJP">JP (Japan)</option>
				<option value="US" id="advCountryCodeUS">US (United States)</option>
				<option value="KR" id="advCountryCodeKR">KR (Korea)</option>
				<option value="FR" id="advCountryCodeFR">FR (France)</option>
				<option value="PL" id="advCountryCodePL">PL (Poland)</option>
				<option value="RU" id="advCountryCodeRU">RU (Russia)</option>
				<option value="TW" id="advCountryCodeTW">TW (Taiwan)</option>
				<option value="IE" id="advCountryCodeIE">IE (Ireland)</option>
				<option value="HK" id="advCountryCodeHK">HK (Hong Kong)</option>
				<option value="NONE" selected id="advCountryCodeNONE">NONE</option>
                    </select>
		</td>
	</tr>	


	  <tr id="htmode_tkip">
	    <th id="basicHTAllowTKIP">HT Disallow TKIP</th>
	    <td>
	      <input type=radio name=n_disallow_tkip id="n_disallow_tkip0" value="0" checked><label for=n_disallow_tkip0 id="basicHTAllowTKIPDisable">Disable&nbsp;</label>
	      <input type=radio name=n_disallow_tkip id="n_disallow_tkip1" value="1"><label for=n_disallow_tkip1 id="basicHTAllowTKIPEnable">Enable</label>
	    </td>
	  </tr>

	  <tr  id="htmode_bandwidth">
	    <th id="basicBandWidth">Band Width</th>
	    <td>
	      <input type=radio name=n_bandwidth id="n_bandwidth0" value="0" checked><label for=n_bandwidth0 id="basicBandWidth20M">20 MHz&nbsp;</label>
	      <input type=radio name=n_bandwidth id="n_bandwidth1" value="1"><label for=n_bandwidth1 id="basicBandWidth2040M">20/40 MHz</label>
	    </td>
	  </tr>

	  <tr  id="htmode_guard_interval">
	    <th id="basicGuardInterval">Guard Interval</th>
	    <td>
	      <input type=radio name=n_gi id="n_gi0" value="0" checked><label for=n_gi0 id="basicGuardIntervalLong">Long&nbsp;</label>
	      <input type=radio name=n_gi id="n_gi1" value="1"><label for=n_gi1 id="basicGuardIntervalAudo">Auto</label>
	    </td>
	  </tr>
	
	</table>

	<div id = "blank" class="error" name="info" align="center">	<span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "basicApply">
	<input class = "btn" type = "button" value = "Cancel" id = "basicCancel">
	</form>

	<!-- ================= HOTSPOT  ================= -->
	<div id="div_hotspot">
	<div id = "blank"> </div>
	<form method="post" name="hotspot" id="hotspot" action="/goform/setHotSpot" >
	<table >
	<caption id = "basicHotSpotSet"> Hotspot Set </caption>

	<tr>
		<th id="thHotspotEnable"></th>
		<td>
			<input type="radio" name="hotspotEnable" id="hotspotEnable" value="0"><label for="hotspotEnable" id="hotspotEnable">Disable </label>&nbsp;&nbsp;
			<input type="radio" name="hotspotEnable" id="hotspotEnable1" value="1"><label for="hotspotEnable1" id="hotspotDisable">Enable</label>&nbsp;&nbsp;
		</td>
	</tr>

	<!--
	<tr>
		<th id="thHotspotOutInterface"></th>
		<td>
			<select name="hotspotOutInterface" id="hotspotOutInterface" size="1">
                        <option value="eth2.2">WAN</option>
                        <option value="usb0">WWAN</option>
			</select>
		</td>
	</tr>
	-->
	<tr id="trHotspotRadiusServer1">
		<th id="thHotspotRadiusServer1"></th>
		<td><input size="60" maxlength="100" id="hotspotRadiusServer1" name="hotspotRadiusServer1"type="text"> </td>
	</tr>

	<tr id="trHotspotRadiusSecret">
		<th id="thHotspotRadiusSecret"></th>
		<td><input size="60" maxlength="100" id="hotspotRadiusSecret" name="hotspotRadiusSecret"type="text"> </td>
	</tr>

	<tr id="trHotspotUamServer">
		<th id="thHotspotUamServer"></th>
		<td><input size="60" maxlength="100" id="hotspotUamServer" name="hotspotUamServer"type="text"> </td>
	</tr>
	<tr id="trHotspotUamSecret">
		<th id="thHotspotUamSecret"></th>
		<td><input size="60" maxlength="100" id="hotspotUamSecret" name="hotspotUamSecret"type="text"> </td>
	</tr>
	<tr id="trHotspotDns1">
		<th id="thHotspotDns1"></th>
		<td><input size="60" maxlength="100" id="hotspotDns1" name="hotspotDns1"type="text"> </td>
	</tr>

	<div id="div_hotspot_local">
		<!--
		<tr id="trHotspotAdvUrl">
			<th id="thHotspotAdvUrl"></th>
			<td><input size="60" maxlength="100" id="hotspotAdvUrl" name="hotspotAdvUrl"type="text"> </td>
		</tr>
		-->
		<tr id="trHotspotDefaultUrl">
			<th id="thHotspotDefaultUrl"></th>
			<td><input size="60" maxlength="100" id="hotspotDefaultUrl" name="hotspotDefaultUrl"type="text"> </td>
		</tr>
		
		<tr id="trHotspotTimeOut">
			<th id="thHotspotTimeOut"></th>
			<td><input size="60" maxlength="100" id="hotspotTimeOut" name="hotspotTimeOut"type="text"> </td>
		</tr>
	</div>		
	</table>

	<div id = "blank" class="error" name="hotspot" align="center">	<span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "hotspotApply">
	<input class = "btn" type = "button" value = "Cancel" id = "hotspotCancel">
	</form>
	</div>	


<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>	

