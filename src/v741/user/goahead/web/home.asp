<html>
<head>
<title><% getModelName(); %> Management</title>
<meta http-equiv="Content-type" content="text/html" charset="UTF-8">
<meta http-equiv="Cache-Control" content="No-Cache"><meta http-equiv="Pragma" content="No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("main");

$(document).ready(function(){ 
		initTranslation();
		initValue(); 
		$.get("/goform/getModuleImsiF", function(args){
				if(args.length>0) $("#phoneImsi").html(args);
			}
		);
	} 
);

var timer = setInterval(function () {
			$.get("/goform/getModuleImsiF", function(args){
					if(args.length>0) $("#phoneImsi").html(args);
				}
			);
		    }, 3000);


function initTranslation()
{
	//$("#ovLangApply").html(_("main apply"));
	$("[id=ovLangApply]").each( function (index, item) { $(item).val( _("main apply")); } );	
	
	$("#titleOV").html(_("treeapp overview"));
	$("#swVer").html(_("main sw ver"));

	Butterlate.setTextDomain("admin");
	$("#selectLang").html(_("man select language"));
	$("#thLang").html(_("man language"));
	$("#statusOPMode").html(_("status operate mode"));
	$("#statusInternetConfig").html(_("status internet config"));
	$("#statusWanMode").html(_("status wan mode"));
	$("#statusConnectedType").html(_("status connect type"));
	$("#statusCurrentWan").html(_("status current wan"));
	$("#statusWANIPAddr").html(_("status wan ipaddr"));
	$("#statusWANMAC").html(_("status mac"));
	$("#statusCNUM").html(_("status Phone number"));
	$("#statusLocalNet").html(_("status local network"));
	$("#statusLANIPAddr").html(_("status lan ipaddr"));
	$("#statusLocalNetmask").html(_("status local netmask"));
	$("#statusLANMAC").html(_("status mac"));
	Butterlate.setTextDomain("main");
}

function initValue() 
{
	var lang_element = $("#langSelection");
	var lang_en = "<% getLangBuilt("en"); %>";
	var lang_jp = "<% getLangBuilt("jp"); %>";	
	var lang_kor = "<% getLangBuilt("kor"); %>";
	
	var lang = $.cookie('language');
	if(lang != "jp" && lang != "en" && lang != "kor" ) lang = "jp"; 
	
	if (lang_jp == "1") lang_element.append("<option value='jp'>&#26085;&#26412;&#35486;</option>");
	if (lang_en == "1") lang_element.append("<option value='en'>English</option>");
	if (lang_kor == "1") lang_element.append("<option value='kor'>&#54620;&#44397;&#50612;</option>");
	if(lang_element.size()==0) lang_element.append("<option value='jp'>&#26085;&#26412;&#35486;</option>");
	lang_element.val(lang);	
	$.cookie('language', lang, { expires:+365000, path: '/'});

	$("#tblWIFIMode").hide();
}

function showCurrentWanMode()
{
	var currentWanMode = "<% getCurrentWan(); %>";
	if (currentWanMode=="WWAN1") document.write(_("main current wwan1"));
	else if (currentWanMode=="WWAN2") document.write(_("main current wwan2"));
	else document.write(currentWanMode);
}

function showWanMode()
{
	var mode = "<% getCfgGeneral(1, "wanMode"); %>";
	if (mode == "1") document.write("WAN");
	else if (mode == "2") document.write("WAN & WWAN");
	else document.write("WWAN");
}

function showOpMode()
{
	var apclient = 1* <% getCfgZero(1, "ApCliEnable"); %>;
	if (apclient == 1) document.write("AP Client Mode");
	else document.write("AP Mode");
}

function setLanguage()
{
	$.cookie('language', $("#langSelection").val(), { expires:+365000, path: '/'});
	return true;
}
</script>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("home.asp"); </script>

	<H1 id="titleOV">OverView</H1>
	<div align="right">
			<b>[ <font id="swVer"> SW VER : </font> <% getSwVersion(); %> ]</b>&nbsp;
	</div>


	<!-- ----------------- Langauge Settings ----------------- -->
	<form method="post" name="Lang" action="/goform/setSysLang">
	<table summary="table_Select_Language">
	<caption id="selectLang">Select Language</caption>

	<tr>
		<th id="thLang">Language</th>
		<td>
			<select name="langSelection" id="langSelection">
			<!-- added by initValue -->
			</select>&nbsp;&nbsp;
			<input class="btn" type=submit  value="Apply" id="ovLangApply" name="ovLangApply" onClick="return setLanguage()">
		</td>
	</tr>
	</table>
	</form>
	<div id ="blank"></div>

	<table>
	<caption id="statusInternetConfig">Internet Configurations</caption>
	<tr>
		<th id="statusWanMode">WAN Mode</th>
		<td><script type="text/javascript">showWanMode();</script></td>
	</tr>
	<tr>
		<th id="statusConnectedType">Connected Type</th>
		<td><% getWanConnectionType(); %></td>
	</tr>
	<tr>
		<th id="statusCurrentWan">Current WAN</th>
		<td><script type="text/javascript">showCurrentWanMode();</script></td>
	</tr>
	<tr>
		<th class="" id="statusWANIPAddr">WAN IP Address</th>
		<td><% getWanIp(); %></td>
	</tr	
	<tr>
		<th id="statusWANMAC">MAC Address</th>
		<td><% getWanMac(); %></td>
	</tr>
	<tr>
		<th id="statusCNUM">Phone Number</th>
		<td id="phoneImsi">  </td>
	</tr>	
	</table>
	<br />

	<table>
	<caption id="statusLocalNet">Local Network</caption>
	<tr>
		<th id="statusLANIPAddr">Local IP Address</th>
		<td><% getLanIp(); %></td>
	</tr>
	<tr>
		<th id="statusLocalNetmask">Local Netmask</th>
		<td><% getLanNetmask(); %></td>
	</tr>
	<tr>
		<th id="statusLANMAC">MAC Address</th>
		<td><% getLanMac(); %></td>
	</tr>
	</table>

	
	<div id ="blank"></div>
	<table id="tblWIFIMode">
	<caption>WIFI</caption>
	<tr>
		<th id="statusOPMode">Operation Mode</th>
		<td><script type="text/javascript">showOpMode();</script></td>
	</tr>
	<tr id="apcliSatus">
		<th>Ap Client IP</th>
		<td> <% getApCliStatus(); %> </td>
	</tr>
	</table>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

