<html>
<head>
<title id = "mainTitle"> <% getModelName(); %> Management </title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate_celot.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>

<style type='text/css'>
div.second {
   padding-top:3px;
}
</style>

<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("service");

$(document).ready(function(){  
	initTranslation();
	init();

	var gpsAuthBackupId = '<% getGpsPPPID(); %>';
	var gpsInputPasswordBackupText = '<% getGpsPPPPwText(); %>';
	var gpsInputPasswordBackupBinary = '<% getGpsPPPPwBinary(); %>';

	// gsp basic setting
	var validateBasicSetRule = $("#SetGpsFunction").validate({
		rules: {
			MeasuringCycle:{
				required: true,
				number: true,
				min: 1,
				max:1800
			},
			gpsAuthId:{
				required: true
			},
			gpsInputPasswordText:{
				required: true
			},
			gpsInputPasswordBinary:{
				required : {
					depends:function(){
						return (($("#gpsInputPasswordBinary").val() != "") || (gpsInputPasswordBackupBinary.length > 0));
					}
				},
 				HexChecker : {
					depends:function(){
						return $("#gpsInputPasswordBinary").val() != "";
					}
				},
				MustLengthEven : {
					depends:function(){
						return $("#gpsInputPasswordBinary").val() != "";
					}
				}
			}
		},
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addGpsBasicSet] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addGpsBasicSet] span").show();
			} else {
				$("div.error[name=addGpsBasicSet] span").hide();
			}
		},

		submitHandler :function(form){
			var errors = this.numberOfInvalids();
			if (errors) {
				$("div.error[name=addGpsBasicSet] span").html(_("alert rule number exceeded"));
				$("div.error[name=addGpsBasicSet] span").show();
			} else {
				$("div.error[name=addGpsBasicSet] span").hide();
				form.submit();
			}			
		}
	});

	$('#SetGpsResetBtn').click(function() { 
		validateBasicSetRule.resetForm(); 
		$("div.error[name=addGpsBasicSet] span").hide();
		loadBasicGpsSetting();
		updateBasicState();
	});

	
	// lan output mode
	var validateLanOutputModeRule = $("#SetGpsLANOutputMode").validate({
		rules: {
			LanModeCutExpectation:{
				required: true,
				number: true,
				min: 0,
				max:600
			},
			LanModeGpsWatingTime:{
				required: true,
				number: true,
				min: 0,
				max:600
			},
			LanModeObjectIP:{
				required: {
					depends:function(){
						return $("#LanModeObjectIP").val() != "" ;
					}
				},				
				IP4Checker: {
					depends:function(){
						return $("#LanModeObjectIP").val() != "" ;
					}
				}
			},
			LanModeObjectPort:{
				required: true,
				number: true,
				min: 1,
				max:65535
			},
			LanModeObjectReceiptPort:{
				required: true,
				number: true,
				min: 1,
				max:65535
			}
		},
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addGpsLanOutputMode] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addGpsLanOutputMode] span").show();
			} else {
				$("div.error[name=addGpsLanOutputMode] span").hide();
			}
		},

		submitHandler :function(form){
			var errors = this.numberOfInvalids();
			if (errors) {
				$("div.error[name=addGpsLanOutputMode] span").html(_("alert rule number exceeded"));
				$("div.error[name=addGpsLanOutputMode] span").show();
			} else {
				$("div.error[name=addGpsLanOutputMode] span").hide();
				form.submit();
			}			
		}
	});

	$('#setGpsLanOutputModeResetBtn').click(function() { 
		validateLanOutputModeRule.resetForm(); 
		$("div.error[name=addGpsLanOutputMode] span").hide();
		loadLanOutputMode();
		updateLanOutputMode();
	});
	
	// wan output mode
	var validateWanOutputModeRule = $("#SetGpsWANOutputMode").validate({
		rules: {
			WanModeCutExpectation:{
				required: true,
				number: true,
				min: 0,
				max:600
			},
			WanModeGpsWatingTime:{
				required: true,
				number: true,
				min: 0,
				max:600
			},
			WanModeObjectIP:{
				required: {
					depends:function(){
						return $("#WanModeObjectIP").val() != "" ;
					}
				},
				maxlength: 64
				// IpOrUrlChecker: true
			},
			WanModeObjectPort:{
				required: true,
				number: true,
				min: 1,
				max:65535
			},
			WanModeObjectReceiptPort:{
				required: true,
				number: true,
				min: 1,
				max:65535
			}
		},
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addGpsWanOutputMode] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addGpsWanOutputMode] span").show();
			} else {
				$("div.error[name=addGpsWanOutputMode] span").hide();
			}
		},

		submitHandler :function(form){
			var errors = this.numberOfInvalids();
			if (errors) {
				$("div.error[name=addGpsWanOutputMode] span").html(_("alert rule number exceeded"));
				$("div.error[name=addGpsWanOutputMode] span").show();
			} else {
				$("div.error[name=addGpsWanOutputMode] span").hide();
				form.submit();
			}			
		}
	});

	$('#setGpsWanOutputModeResetBtn').click(function() { 
		validateWanOutputModeRule.resetForm(); 
		$("div.error[name=addGpsLanOutputMode] span").hide();
		loadWanOutputMode();
		updateWanOutputMode();
	});
});

function loadBasicGpsSetting()
{
	var gpsEnable = '<% getGpsEnable(); %>';
	var gpsType = '<% getGpsType(); %>';
	var gpsMeasuringCycle = '<% getGpsMeasuringCycle(); %>';
	var gpsInfoForm = '<% getGpsInfoForm(); %>';
	var gpsDatum = '<% getGpsDatum(); %>';
	var gpsPositionUnit = '<% getGpsPositionUnit(); %>';
	var gpsAuthId = '<% getGpsPPPID(); %>';
	var gpsPasswordType = '<% getGpsPPPPwType(); %>';
	var gpsInputPasswordText = '<% getGpsPPPPwText(); %>';
	var gpsInputPasswordBinary = '<% getGpsPPPPwBinary(); %>';

	$("#setGpsEnabled").val(gpsEnable); // select 버튼은 val의 값으로 선택할 수 있다.
	$("#gpsType").val(gpsType);	
	$("#MeasuringCycle").val(gpsMeasuringCycle);
	$("#gpsInfoForm").val(gpsInfoForm);
	$("#gpsDatum").val(gpsDatum);
	$("#gpsPositionUnit").val(gpsPositionUnit);
	$("#gpsAuthId").val(gpsAuthId);
	$("#gpsPasswordType").val(gpsPasswordType);
	$("#gpsInputPasswordText").val(gpsInputPasswordText);
	$("#gpsInputPasswordBinary").val(gpsInputPasswordBinary);
}

function loadLanOutputMode()
{
	var gpsLanOutputMode = '<% getGpsLanOutputMode(); %>';
	var gpsLanModeCutExpectation = '<% getGpsLanTcpCutExpectation(); %>';
	var gpsLanModeGpsWatingTime = '<% getGpsLanWatingTime(); %>';
	var gpsLanModeObjectIP = '<% getGpsLanIP(); %>';
	var gpsLanModeObjectPort = '<% getGpsLanObjectPort(); %>';
	var gpsLanModeObjectReceiptPort = '<% getGpsLanObjectReceiptPort(); %>';

	$("#LanOutputMode").val(gpsLanOutputMode);
	$("#LanModeCutExpectation").val(gpsLanModeCutExpectation);
	$("#LanModeGpsWatingTime").val(gpsLanModeGpsWatingTime);
	$("#LanModeObjectIP").val(gpsLanModeObjectIP);
	$("#LanModeObjectPort").val(gpsLanModeObjectPort);
	$("#LanModeObjectReceiptPort").val(gpsLanModeObjectReceiptPort);
}

function loadWanOutputMode()
{
	var gpsWanOutputMode = '<% getGpsWanOutputMode(); %>';
	var gpsWanModeCutExpectation = '<% getGpsWanTcpCutExpectation(); %>';
	var gpsWanModeGpsWatingTime = '<% getGpsWanWatingTime(); %>';
	var getGpsWanInterface = '<% getGpsWanInterface(); %>';
	var gpsWanModeObjectIP = '<% getGpsWanIP(); %>';
	var gpsWanModeObjectPort = '<% getGpsWanObjectPort(); %>';
	var gpsWanModeObjectReceiptPort = '<% getGpsWanObjectReceiptPort(); %>';

	$("#WanOutputMode").val(gpsWanOutputMode);
	$("#WanModeCutExpectation").val(gpsWanModeCutExpectation);
	$("#WanModeGpsWatingTime").val(gpsWanModeGpsWatingTime);
	$("#WanModeInterface").val(getGpsWanInterface);	
	$("#WanModeObjectIP").val(gpsWanModeObjectIP);
	$("#WanModeObjectPort").val(gpsWanModeObjectPort);
	$("#WanModeObjectReceiptPort").val(gpsWanModeObjectReceiptPort);
}

function loadGpsValue()
{
	// basic setting
	loadBasicGpsSetting();
	// lan output mode
	loadLanOutputMode();
	// wan output mode
	loadWanOutputMode();
}

function hideAllGpsBasic()
{
	$("#trGpsType").hide();		
	$("#trGpsInfoForm").hide();
	$("#trMeasuringCycle").hide();
	$("#trGpsDatum").hide();
	$("#trGpsPositionUnit").hide();
	$("#trGpsPPPAuthId").hide();
	$("#trGPSPPPpassWordGroup").hide();
}

function changePasswordType()
{
	if ($("#gpsPasswordType").val() == 0) // text
	{
		$("#gpsInputPasswordText").show();
		$("#gpsInputPasswordBinary").hide();
	}
	else // binary
	{
		$("#gpsInputPasswordText").hide();
		$("#gpsInputPasswordBinary").show();
	}
}

function changeGpsType()
{
	hideAllGpsBasic();
	$("#trGpsType").show(); // 타입
	$("#trMeasuringCycle").show(); // 측정 주기

	// 0 : A-GPS（SET Based）
	// 1 : A-GPS（Auto）
	// 2 : A-GPS（SET Assisted）
	// 3 : Standalone

	
	if( $("#gpsType").val() == 2) // SET Assisted
	{
		$("#trGpsDatum").show(); // 측지계
		$("#trGpsPositionUnit").show(); // 위도 경도 서식
		$("#trGpsPPPAuthId").show(); // ppp 인증 id
		$("#trGPSPPPpassWordGroup").show(); // ppp 비밀번호
	}
	else if( $("#gpsType").val() == 0) // SET Based
	{
		$("#trGpsInfoForm").show();  // 출력 포멧
		$("#trGpsPPPAuthId").show(); // ppp 인증 id
		$("#trGPSPPPpassWordGroup").show(); // ppp 비밀번호
		
	}
	else if( $("#gpsType").val() == 3) // Standalone
	{
		$("#trGpsInfoForm").show();  // 출력 포멧
	}
	else // Auto
	{
		$("#trGpsPPPAuthId").show(); // ppp 인증 id
		$("#trGPSPPPpassWordGroup").show(); // ppp 비밀번호
	}

	if ($("#gpsType").val() != 3)
	{
		changePasswordType();
	}	
}

function updateBasicState()
{
	if( document.SetGpsFunction.setGpsEnabled.options.selectedIndex == 1)
	{
		// basic
		changeGpsType();
		// lan output mode
		$("#divSetGpsLANOutputMode").show();
		$("#divSetGpsWANOutputMode").show();
	}
	else
	{
		// basic
		hideAllGpsBasic();		
		// lan output mode
		$("#divSetGpsLANOutputMode").hide();
		$("#divSetGpsWANOutputMode").hide();
	}
}

function updateLanOutputMode()
{
	$("#trLanModeCutExpectation").hide();
	$("#trLanModeGpsWatingTime").hide();
	$("#trLanModeObjectIP").hide();
	$("#trLanModeObjectPort").hide(); 
	$("#trLanModeObjectReceiptPort").hide();
	
	if ($("#LanOutputMode option:selected ").val()  == 1 || $("#LanOutputMode option:selected ").val()  == 2)
	{
		$("#trLanModeCutExpectation").show();
	}

	if ($("#LanOutputMode option:selected ").val()  != 0) 
	{
		$("#trLanModeGpsWatingTime").show();
	}

	if ($("#LanOutputMode option:selected ").val()  == 1 || $("#LanOutputMode option:selected ").val()  == 3)
	{
		$("#trLanModeObjectIP").show();
		$("#trLanModeObjectPort").show();
	}
	else if ($("#LanOutputMode option:selected ").val() == 2) 
	{
		$("#trLanModeObjectReceiptPort").show();
	}
}

function updateWanOutputMode()
{
	$("#trWanModeCutExpectation").hide();
	$("#trWanModeGpsWatingTime").hide();
	$("#trWanModeInterface").hide();
	$("#trWanModeObjectIP").hide();
	$("#trWanModeObjectPort").hide();
	$("#trWanModeObjectReceiptPort").hide();

	if ($("#WanOutputMode option:selected ").val()  == 1 || $("#WanOutputMode option:selected ").val()  == 2)
	{
		$("#trWanModeCutExpectation").show();
	}

	if ($("#WanOutputMode option:selected ").val()  != 0)
	{
		$("#trWanModeGpsWatingTime").show();
	}

	if ($("#WanOutputMode option:selected ").val()  == 1 || $("#WanOutputMode option:selected ").val()  == 3)
	{
		$("#trWanModeInterface").show();
		$("#trWanModeObjectIP").show();
	}

	if ($("#WanOutputMode option:selected ").val()  == 1 || $("#WanOutputMode option:selected ").val()  == 3)
	{
		$("#trWanModeObjectIP").show();
		$("#trWanModeObjectPort").show();
	}
	else if ($("#WanOutputMode option:selected ").val() == 2) 
	{
		$("#trWanModeObjectReceiptPort").show();
	}
}

function init()
{
	// get nv value
	loadGpsValue();
	// basic set
	updateBasicState();
	// lan output mode set
	updateLanOutputMode();
	// wan output mode set
	updateWanOutputMode();
}

function initTranslation()
{
	$("#lTitle").html(_("gps function title"));
	$("#lIntroduction").html(_("gps function introduction"));
	$("#capGpsBasicSet").html(_("gps function"));
	// basic
	$("#thGpsEnable").html(_("gps function"));	
	$("#gpsDisable").html(_("gps function disable"));
	$("#gpsEnable").html(_("gps function enable"));
	$("#thGpsInfoForm").html(_("gps info form"));
	$("#infoFormKLW").html(_("gps info form klw"));
	$("#infoFormNMEA").html(_("gps info form nmea"));
	$("#thMeasuringCycle").html(_("gps measuring cycle"));
	$("#thGpsType").html(_("gps type"));
	$("#thGpsDatum").html(_("gps datum"));
	$("#thGpsPositionUnit").html(_("gps position unit"));
	$("#thGpsPPPAuthId").html(_("gps ppp auth id"));
	$("#thGPSPPPpassWordGroup").html(_("gps ppp password"));
	$("#PositionUnitDms").html(_("gps dms"));
	$("#PositionUnitDegree").html(_("gps degree"));
	// lan output mode
	$("#capSetGpsLANOutputMode").html(_("gps lan output mode caption"));
	$("#thLanOutputMode").html(_("gps lan output mode"));	
	$("#lanOutuptDisable").html(_("gps lan output disable"));
	$("#lanOutputTcpClient").html(_("gps tcp client"));
	$("#lanOutputTcpServer").html(_("gps tcp server"));
	$("#lanOutputUdp").html(_("gps udp"));
	$("#thLanModeCutExpectation").html(_("gps cut expectation"));
	$("#thLanModeGpsWatingTime").html(_("gps wating time"));
	$("#thLanModeObjectIP").html(_("gps object ip"));
	$("#thLanModeObjectPort").html(_("gps object port"));
	$("#thLanModeObjectReceiptPort").html(_("gps object receipt port"));
	// wan output mode
	$("#capSetGpsWANOutputMode").html(_("gps wan output mode caption"));
	$("#thWanOutputMode").html(_("gps lan output mode"));	
	$("#wanOutuptDisable").html(_("gps lan output disable"));
	$("#wanOutputTcpClient").html(_("gps tcp client"));
	$("#wanOutputTcpServer").html(_("gps tcp server"));
	$("#wanOutputUdp").html(_("gps udp"));	
	$("#thWanModeCutExpectation").html(_("gps cut expectation"));
	$("#thWanModeGpsWatingTime").html(_("gps wating time"));
	$("#thWanModeInterface").html(_("gps interface"));
	$("#wanModeWWAN1").html(_("service interface0"));
	$("#wanModeWWAN2").html(_("service interface1"));
	$("#thWanModeObjectIP").html(_("gps object ip or host"));
	$("#thWanModeObjectPort").html(_("gps object port"));
	$("#thWanModeObjectReceiptPort").html(_("gps object receipt port"));

	$("#SetGpsApplyBtn").val(_("service apply"));
	$("#SetGpsResetBtn").val(_("service cancel"));
	$("#setGpsLanOutputModeApplyBtn").val(_("service apply"));
	$("#setGpsLanOutputModeResetBtn").val(_("service cancel"));
	$("#setGpsWanOutputModeApplyBtn").val(_("service apply"));
	$("#setGpsWanOutputModeResetBtn").val(_("service cancel"));

	$("[id=gpsSetSec]").each( function (index, item) { $(item).html( _("gps set seconds")); } );
}

</script>
</head>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("gps_set.asp"); </script>

	<h1 id="lTitle"> GPS Function </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "lIntroduction"> </font> 
	</div>
	<div id = "blank"> </div>

	<!-- ====================   GPS set form  ==================== -->
	<form method=post name="SetGpsFunction" id="SetGpsFunction" action=/goform/SetGpsFunction>
	<table>
	<caption id = "capGpsBasicSet"> GPS Function </caption>
	<tr>
		<th id="thGpsEnable"> GPS Function </th>
		<td>
			<select onChange="updateBasicState()" name="setGpsEnabled" id="setGpsEnabled"  size="1">
			<option value=0 id="gpsDisable">Disable</option>
			<option value=1 id="gpsEnable">Enable</option>
			</select>
		</td>
	</tr>
	<tr id="trGpsType">
		<th id="thGpsType"> GPS Type </th>
		<td>
			<select onChange="changeGpsType()" name="gpsType" id="gpsType"  size="1">
			<option value=0 id="gpsTypeSetBased">A-GPS (MSB)</option>
			<option value=1 id="gpsTypeAuto">A-GPS (auto)</option>
			<!-- <option value=2 id="gpsTypeSetAssisted">A-GPS (MSA)</option> -->
			<option value=3 id="gpsTypeStandalone">StandAlone</option>
			</select>
		</td>
	</tr>
	<!-- 1. 측정 주기 -->
	<tr id="trMeasuringCycle">
		<th id="thMeasuringCycle"> Measuring Cycle </th>
		<td>
			<input type="text" name="MeasuringCycle" id="MeasuringCycle" size="4" maxlength="4"> &nbsp; <font id="gpsSetSec"> sec. </font>
		</td>
	</tr>	
	<!-- 2. 출력 형식  -->
	<tr id="trGpsInfoForm">
		<th id="thGpsInfoForm"> GPS Info Form </th>
		<td>
			<select name="gpsInfoForm" id="gpsInfoForm"  size="1">
			<option value=0 id="infoFormKLW">CPRN-KLW</option>
			<option value=1 id="infoFormNMEA">NMEA</option>
			</select>
		</td>
	</tr>
	<!--  3. 측지계-->
	<tr id="trGpsDatum">
		<th id="thGpsDatum"> GPS Datum </th>
		<td>
			<select name="gpsDatum" id="gpsDatum"  size="1">
			<option value=0 id="datumWGS84">WGS-84</option>
			<option value=1 id="datumTokyo">Tokyo</option>
			</select>
		</td>
	</tr>
	<!-- 4. 위도 경도 서식 -->
	<tr id="trGpsPositionUnit">
		<th id="thGpsPositionUnit"> GPS PositionUnit </th>
		<td>
			<select name="gpsPositionUnit" id="gpsPositionUnit"  size="1">
			<option value=0 id="PositionUnitDms">Dms</option>
			<option value=1 id="PositionUnitDegree">Degree</option>
			</select>
		</td>
	</tr>
	<!--  5. PPP 인증 ID-->
	<tr id="trGpsPPPAuthId">
		<th id="thGpsPPPAuthId"> PPP authentication ID </th>
		<td>
			<input type="text" name="gpsAuthId" id="gpsAuthId" size="36" maxlength="36">
		</td>
	</tr>
	<!--  6.7 PPP 비밀 번호-->
	<tr id="trGPSPPPpassWordGroup">
		<th id="thGPSPPPpassWordGroup" >PPP Password </th>
		<td>
			<select onChange="changePasswordType()" name="gpsPasswordType" id="gpsPasswordType" size="1">
			<option value="0" id="passwordText">Text</option>
			<option value="1" id="passwordBinary">Binary</option>
			</select>
			<div class = "second">
			<input name="gpsInputPasswordText" id="gpsInputPasswordText" type="text" maxlength="16" size="16">
			<div class = "second">
			<input name="gpsInputPasswordBinary" id="gpsInputPasswordBinary" type="text" maxlength="32" size="32">
			</div>
		</td>
	</tr>	
	</table>

	<div id = "blank" class="error" name="addGpsBasicSet" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "SetGpsApplyBtn" name="SetGpsApplyBtn">
	<input class = "btn" type = "button" value = "Reset" id = "SetGpsResetBtn"  name="SetGpsResetBtn" >
	</form>

	<!-- LAN output mode -->
	<div id="divSetGpsLANOutputMode">
	<div id = "blank"> </div>
	<form method=post name="SetGpsLANOutputMode" id="SetGpsLANOutputMode" action=/goform/SetGpsLANOutputMode>
	<table>
	<caption id = "capSetGpsLANOutputMode"> Output Mode (LAN) </caption>
	<tr>
		<th id = "thLanOutputMode"> Output Mode </th>
		<td>
			<select name="LanOutputMode" id="LanOutputMode" onChange="updateLanOutputMode()">
			<option value=0 id="lanOutuptDisable">Disable</option>
			<option value=1 id="lanOutputTcpClient">TCP Client</option>
			<option value=2 id="lanOutputTcpServer">TCP Server</option>
			<option value=3 id="lanOutputUdp">UDP</option>
            		</select>
		</td>
	</tr>


	<tr id="trLanModeCutExpectation">
		<th id="thLanModeCutExpectation"> Cut Expectation </th>
		<td>
			<input type="text" name="LanModeCutExpectation" id="LanModeCutExpectation" size="4" maxlength="3"> &nbsp; <font id="gpsSetSec"> sec. </font>
		</td>
	</tr>

	<tr id="trLanModeGpsWatingTime">
		<th id="thLanModeGpsWatingTime"> GPS Wating Time </th>
		<td>
			<input type="text" name="LanModeGpsWatingTime" id="LanModeGpsWatingTime" size="4" maxlength="3"> &nbsp; <font id="gpsSetSec"> sec. </font>
		</td>
	</tr>

	<tr id="trLanModeObjectIP">
		<th id="thLanModeObjectIP"> IP </th>
		<td>
			<input type="text" name="LanModeObjectIP" id="LanModeObjectIP" size="32" maxlength="15">
		</td>
	</tr>

	<tr id="trLanModeObjectPort">
		<th id="thLanModeObjectPort"> Port </th>
		<td>
			<input type="text" name="LanModeObjectPort" id="LanModeObjectPort" size="6" maxlength="5">
		</td>
	</tr>

	<tr id="trLanModeObjectReceiptPort">
		<th id="thLanModeObjectReceiptPort"> Receipt Port </th>
		<td>
			<input type="text" name="LanModeObjectReceiptPort" id="LanModeObjectReceiptPort" size="6" maxlength="5">
		</td>
	</tr>

	</table>

	<div id = "blank" class="error" name="addGpsLanOutputMode" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "setGpsLanOutputModeApplyBtn" name="setGpsLanOutputModeApplyBtn">
	<input class = "btn" type = "button" value = "Reset" id = "setGpsLanOutputModeResetBtn"  name="setGpsLanOutputModeResetBtn" >
	</form>
	</div>

	<!-- WAN output mode -->
	<div id="divSetGpsWANOutputMode">
	<div id = "blank"> </div>
	<form method=post name="SetGpsWANOutputMode" id="SetGpsWANOutputMode" action=/goform/SetGpsWANOutputMode>
	<table>
	<caption id = "capSetGpsWANOutputMode"> Output Mode (WAN) </caption>
	<tr>
		<th id = "thWanOutputMode"> Output Mode </th>
		<td>
			<select name="WanOutputMode" id="WanOutputMode" onChange="updateWanOutputMode()">
			<option value=0 id="wanOutuptDisable">Disable</option>
			<option value=1 id="wanOutputTcpClient">TCP Client</option>
			<option value=2 id="wanOutputTcpServer">TCP Server</option>
			<option value=3 id="wanOutputUdp">UDP</option>
            		</select>
		</td>
	</tr>


	<tr id="trWanModeCutExpectation">
		<th id="thWanModeCutExpectation"> Cut Expectation </th>
		<td>
			<input type="text" name="WanModeCutExpectation" id="WanModeCutExpectation" size="4" maxlength="3"> &nbsp; <font id="gpsSetSec"> sec. </font>
		</td>
	</tr>

	<tr id="trWanModeGpsWatingTime">
		<th id="thWanModeGpsWatingTime"> GPS Wating Time </th>
		<td>
			<input type="text" name="WanModeGpsWatingTime" id="WanModeGpsWatingTime" size="4" maxlength="3"> &nbsp; <font id="gpsSetSec"> sec. </font>
		</td>
	</tr>

	<tr id="trWanModeInterface">
		<th id = "thWanModeInterface"> Interface </th>
		<td>
			<select name="WanModeInterface" id="WanModeInterface">
			<option value="WWAN1" id="wanModeWWAN1">WWAN1</option>
			<option value="WWAN2" id="wanModeWWAN2">WWAN2</option>
            		</select>
		</td>
	</tr>

	<tr id="trWanModeObjectIP">
		<th id="thWanModeObjectIP"> IP </th>
		<td>
			<input type="text" name="WanModeObjectIP" id="WanModeObjectIP" size="32" maxlength="64">
		</td>
	</tr>

	<tr id="trWanModeObjectPort">
		<th id="thWanModeObjectPort"> Port </th>
		<td>
			<input type="text" name="WanModeObjectPort" id="WanModeObjectPort" size="6" maxlength="5">
		</td>
	</tr>

	<tr id="trWanModeObjectReceiptPort">
		<th id="thWanModeObjectReceiptPort"> Receipt Port </th>
		<td>
			<input type="text" name="WanModeObjectReceiptPort" id="WanModeObjectReceiptPort" size="6" maxlength="5">
		</td>
	</tr>

	</table>

	<div id = "blank" class="error" name="addGpsWanOutputMode" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "setGpsWanOutputModeApplyBtn" name="setGpsWanOutputModeApplyBtn">
	<input class = "btn" type = "button" value = "Reset" id = "setGpsWanOutputModeResetBtn"  name="setGpsWanOutputModeResetBtn" >
	</form>
	</div>

	<!-- <caption id = "gpsDegus"> GPS Process : <% getGpsProcessCount(); %> </caption> -->

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>
