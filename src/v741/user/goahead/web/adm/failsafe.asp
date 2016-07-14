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

<style type='text/css'>
div.second {
   padding-top:3px;
}
</style>

<script language = "JavaScript" type = "text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("mobile");

$(document).ready(function(){ 
	initTranslation();
	initValue();
	
	var validateRule = $("[name=mobileFailSafe]").validate({
		rules: {
			fsSvrAddr: {
				required : { depends: function() {return $("#fsSvrCheck").val()!="0";} },
				IP4Checker: true
			},
			fsConnCycle: {
				required : { depends: function() {return $("#fsSvrCheck").val()!="0";} },
				min : 20,
				max : 120
			},
			fsLogSize: {
				required : true,
				number : true,
				min : 256,
				max : 1024
			}
		},
		
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addFSErr] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addFSErr] span").show();
			} else {
				$("div.error[name=addFSErr] span").hide();
			}
		},

		submitHandler :function(form){
			if(this.numberOfInvalids())
			{
				return;
			}
			else
			{
				$("div.error[name=addFSErr] span").hide();
				$("#fsDataUpload").val($("#fsDataUpload").is(":checked")?1:0);
				$("#fsDataDnload").val($("#fsDataDnload").is(":checked")?1:0);
				form.submit();
			}
		}
	});

	$('#btnReset').click(function() { 
		validateRule.resetForm();
		$("div.error[name=addFSErr] span").hide();
		initValue();
	});
});

function initTranslation()
{
	$("#fsTitle").html(_("fs title"));
	$("#fsIntro").html(_("fs intro"));
	$("#capConfiguration").html(_("fs configuration"));
	$("#thCallConnect").html(_("fs call connection"));
	$("#fsConnectA").html(_("fs connnect a"));
	$("#fsConnect1").html(_("fs connnect 1"));
	$("#fsConnect2").html(_("fs connnect 2"));
	$("#fsConnect3").html(_("fs connnect 3"));
	$("#fsConnect4").html(_("fs connnect 4"));
	$("#thDataUsage").html(_("fs data mon"));
	$("#fsUpload").html(_("fs data up"));
	$("#fsDownload").html(_("fs data dn"));
	$("#fsSeconds").html(_("fs seconds"));
	$("#fsMinutes").html(_("fs minutes"));
	$("#thConnection").html(_("fs con mon"));
	$("#fsAddress").html(_("fs address"));
	$("#fsCCycle").html(_("fs conn cycle"));
	$("#thReBoot").html(_("fs reboot"));
	
	$("#thLog").html(_("fs fs log"));
	$("#kbyte").html(_("fs kbytes"));
	$("#fsbtlog").val(_("fs view log"));
	$("#btnApply").val(_("fs apply"));
	$("#btnReset").val(_("fs cancel"));
	$("#fsCheckD").html(_("fs disable"));
	$("#fsRebootD").html(_("fs disable"));

	$("#fsRebootH1").html(_("fs reboot 1h"));
	$("#fsRebootH2").html(_("fs reboot 2h"));
	$("#fsRebootH3").html(_("fs reboot 3h"));
	$("#fsRebootH4").html(_("fs reboot 4h"));
	$("#fsRebootH5").html(_("fs reboot 5h"));
	$("#fsRebootH6").html(_("fs reboot 6h"));
	$("#fsRebootH7").html(_("fs reboot 7h"));
	$("#fsRebootH8").html(_("fs reboot 8h"));
	$("#fsRebootH9").html(_("fs reboot 9h"));
	$("#fsRebootH10").html(_("fs reboot 10h"));
	$("#fsRebootH11").html(_("fs reboot 11h"));
	$("#fsRebootH12").html(_("fs reboot 12h"));
	$("#fsRebootH13").html(_("fs reboot 13h"));
	$("#fsRebootH14").html(_("fs reboot 14h"));
	$("#fsRebootH15").html(_("fs reboot 15h"));
	$("#fsRebootH16").html(_("fs reboot 16h"));
	$("#fsRebootH17").html(_("fs reboot 17h"));
	$("#fsRebootH18").html(_("fs reboot 18h"));
	$("#fsRebootH19").html(_("fs reboot 19h"));
	$("#fsRebootH20").html(_("fs reboot 20h"));
	$("#fsRebootH21").html(_("fs reboot 21h"));
	$("#fsRebootH22").html(_("fs reboot 22h"));
	$("#fsRebootH23").html(_("fs reboot 23h"));
	$("#fsRebootH24").html(_("fs reboot 24h"));
}

function initValue()
{
	var fs_ca = "<% getCfgGeneral(1, "FsWWANConnectMode"); %>";
	var fs_dm = "<% getCfgGeneral(1, "FsTransactionCheckEnable"); %>";
	var fs_csm = "<% getCfgGeneral(1, "FsWWANServerCheckEnable"); %>";
	var fs_csma = "<% getCfgGeneral(1, "FsWWANServerCheckTrgIP"); %>";
	var fs_csmc = "<% getCfgGeneral(1, "FsWWANServerCheckCycle"); %>";
	var fs_pr = "<% getCfgGeneral(1, "FsAutoResetElapsedEnable"); %>";
	var fs_prt= "<% getCfgGeneral(1, "FsAutoResetElapsedTimer"); %>";
	var fs_log_size = "<% getCfgGeneral(1, "FsMaintenanceLogSize"); %>";

	if(fs_ca*1 >0) $("#fsCallConnect").val(fs_ca);
	else $("#fsCallConnect").val("0");

	document.mobileFailSafe.fsDataUpload.checked = ((fs_dm&0x1)==0x1);
	document.mobileFailSafe.fsDataDnload.checked = ((fs_dm&0x2)==0x2);

	if($.trim(fs_csm).length>0) $("#fsSvrCheck").val(fs_csm);
	else $("#fsSvrCheck").val("0");
	if($.trim(fs_csma).length<=0)  fs_csma = "8.8.8.8";
	$("#fsSvrAddr").val(fs_csma);
	if($.trim(fs_csmc).length<=0)  fs_csmc = 20;
	$("#fsConnCycle").val(fs_csmc);

	if($.trim(fs_pr).length>0 && (fs_pr=="1") && $.trim(fs_prt).length>0 )
	{
		$("#fsReboot").val(fs_prt);
	}
	else $("#fsReboot").val("0");

	if($.trim(fs_log_size).length<=0)  fs_log_size = 1024;
	$("#fsLogSize").val(fs_log_size);

	onChangeFsSvrCheck();
}

function onChangeFsSvrCheck()
{
	if ($("#fsSvrCheck").val() == "0")
	{
		$("#idCheckAddr").hide();
	}
	else
	{
		$("#idCheckAddr").show();
	}
}

function open_fslog_window()
{
	window.open("fslog.asp","FSLog","toolbar=no, location=yes, scrollbars=yes, resizable=no, width=640, height=480")
}

</script>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("failsafe.asp"); </script>

	<h1 id = "fsTitle"> Connection Fail Safe </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "fsIntro"> </font> 
	</div>
	<div id = "blank"> </div>

	<form method = post name = "mobileFailSafe" action = "/goform/mobileFailSafe">
	<table>
	<caption id = "capConfiguration">  Configuration </caption>
	<tr>
		<th id="thCallConnect">Call Connection Attempt</th>
		<td>
			<select name="fsCallConnect" id="fsCallConnect" size="1">
			<option value="0" id="fsConnectA">Always</option>
			<option value="1" id="fsConnect1">RSSI 1</option>
			<option value="2" id="fsConnect2">RSSI 2</option>
			<option value="3" id="fsConnect3">RSSI 3</option>
			<option value="4" id="fsConnect4">RSSI 4</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="thDataUsage">Data Usage Monitor</th>
		<td>
			<input type=checkbox name=fsDataUpload id="fsDataUpload" value=1> <label for="fsDataUpload" id="fsUpload"> Upload </label>
			<input type=checkbox name=fsDataDnload id="fsDataDnload" value=1> <label for="fsDataDnload" id="fsDownload"> Download </label>
		</td>
	</tr>	
	<tr>
		<th id="thConnection"> Connection Monitor</th>
		<td>
			<select name="fsSvrCheck" id="fsSvrCheck" size="1" onChange="onChangeFsSvrCheck()">
			<option value="0" id="fsCheckD">Disable</option>
			<option value="1" id="fsCheckPing">Ping</option>
			<option value="2" id="fsCheckWeb">Web(80)</option>
			</select>
			<div class = "second" id="idCheckAddr" style="display:none">
			<label id="fsAddress">Address :</label> <input name="fsSvrAddr" id="fsSvrAddr" type="text" maxlength="64" size=32>
			<div class = "second">
			<label id="fsCCycle">Check Cycle :</label> 
				<input name="fsConnCycle" id="fsConnCycle" type="text" maxlength="3" size=6><font id="fsSeconds"> seconds </font>
			</div>
			</div>
		</td>
	</tr>
	<tr>
		<th id="thReBoot">Periodic Reboot</th>
		<td>
			<select name="fsReboot" id="fsReboot" size="1">
			<option value="0" id="fsRebootD"> Disable </option>
			<option value="1" id="fsRebootH1">1 H</option>
			<option value="2" id="fsRebootH2">2 H</option>
			<option value="3" id="fsRebootH3">3 H</option>
			<option value="4" id="fsRebootH4">4 H</option>
			<option value="5" id="fsRebootH5">5 H</option>
			<option value="6" id="fsRebootH6">6 H</option>
			<option value="7" id="fsRebootH7">7 H</option>
			<option value="8" id="fsRebootH8">8 H</option>
			<option value="9" id="fsRebootH9">9 H</option>
			<option value="10" id="fsRebootH10">10 H</option>
			<option value="11" id="fsRebootH11">11 H</option>
			<option value="12" id="fsRebootH12">12 H</option>
			<option value="13" id="fsRebootH13">13 H</option>
			<option value="14" id="fsRebootH14">14 H</option>
			<option value="15" id="fsRebootH15">15 H</option>
			<option value="16" id="fsRebootH16">16 H</option>
			<option value="17" id="fsRebootH17">17 H</option>
			<option value="18" id="fsRebootH18">18 H</option>
			<option value="19" id="fsRebootH19">19 H</option>
			<option value="20" id="fsRebootH20">20 H</option>
			<option value="21" id="fsRebootH21">21 H</option>
			<option value="22" id="fsRebootH22">22 H</option>
			<option value="23" id="fsRebootH23">23 H</option>
			<option value="24" id="fsRebootH24">24 H</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="thLog"> Fail Safe Log</th>
		<td>
			<input type=text name=fsLogSize id=fsLogSize size=6 maxlength=4> <font id="kbyte">KBytes</font>
			<div class = "second" id="idViewLog">
			<input class = "btn_white" type = "button" id="fsbtlog" value = "View Log" onClick = "open_fslog_window()">
			</div>
		</td>
	</tr>
	</table>
	
	<div id = "blank" class="error" name="addFSErr" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "btnApply">
	<input class = "btn" type = "button" value = "Cancel" id = "btnReset" >
	</form>	

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

