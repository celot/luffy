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

var MAX_RULES = 3;
var rules_num = <% getEMGRuleNumsASP(); %> ;

$(document).ready(function(){  
	initTranslation();
	PageInit(); 
	initAddPage();
	
	var validateCfg = $("#emgNotifierCfg").validate({
		rules: {
			eEmgNotifierCode: {
				required : true,
				hexString : {	param : 16 }
				
			}
		},
		invalidHandler: function(event, validator) {

			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=setEMGf] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=setEMGf] span").show();
			} else {
				$("div.error[name=setEMGf] span").hide();
			}
		}
	});

	var validateRule = $("#emgNotifierAdd").validate({
		rules: {
			emgNotifierTargetIP: {
				required: true,
				IP4Checker : true
			},
			emgNotifierTargetPort: {
				required: true,
				number: true,
				min : 1,
				max : 65535
			},
			emgNotifierTargetComment: {
				required : {
					depends:function(){
						return ($("emgNotifierTargetComment").length>0);
					}
				},	
				maxString : {	param : 15 }
			}
		},

		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addEMGf] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addEMGf] span").show();
			} else {
				$("div.error[name=addEMGf] span").hide();
			}
		},
		
		submitHandler :function(form){
		
			if(rules_num >= (MAX_RULES) ){
				$("div.error[name=addEMGf] span").html(_("service emg rule number exceeded")+ MAX_RULES +".");
				$("div.error[name=addEMGf] span").show();
			}
			else
			{
				if(this.numberOfInvalids())
				{
					return;
				}
				else
				{
					$("div.error[name=addEMGf] span").hide();
					form.submit();
				}
			}
		}
	});

	$("form[name=emgDeleteTargetServer]").submit(function() { 
		if($("input:checkbox[name^=delRule]:checked").length==0){
			$("div.error[name=delete] span").html(_("service select rule to be delete"));
			$("div.error[name=delete] span").show();
			return false;
		}
		$("div.error[name=delete] span").hide();
		return true;
	});
	
	$('#resetRules').click(function() { 
		$("div.error[name=delete] span").hide();
	});

	
	$('#setCancel').click(function() { 
		validateCfg.resetForm(); 
		PageInit();
		$("div.error[name=setEMGf] span").hide();
	});

	$('#addCancel').click(function() { 
		validateRule.resetForm(); 
		initAddPage();
		$("div.error[name=addEMGf] span").hide();
	});

	$("input:checkbox[name^=delRule]").bind('click', function() {
		$("div.error[name=delete] span").hide();
	});
	
	$("table[name=tableEmgSendTargetServer] tr td").width(function(index) {
			if(index%5==0) return 40; 
			else if(index%5==1) return 160; 
			else if(index%5==2) return 130; 
			else if(index%5==3) return 100; 
			else if(index%5==4) return 100 
			else return 100;
	});
});




function PageInit()
{
	var vEmgNotiEnable = "<% getCfgGeneral(1, "emgNotiEnable"); %>";
	var vEmgNotiTimes = "<% getCfgGeneral(1, "emgNotiTimes"); %>";
	var vEmgNotiInterval = "<% getCfgGeneral(1, "emgNotiInterval"); %>";
	var vEmgNotiCode = "<% getCfgGeneral(1, "emgNotiCode"); %>";

	if (vEmgNotiEnable == "1") document.emgNotifierCfg.sEmgNotifierEnable.options.selectedIndex = 1;
	else
	{
		vEmgNotiEnable = 0;
		document.emgNotifierCfg.sEmgNotifierEnable.options.selectedIndex = 0;
	}


	if (vEmgNotiTimes == "1") 
		document.emgNotifierCfg.sEmgNotifierTimes.options.selectedIndex = 0;
	else if (vEmgNotiTimes == "2") 
		document.emgNotifierCfg.sEmgNotifierTimes.options.selectedIndex = 1;
	else
	{
		vEmgNotiTimes = 3;
		document.emgNotifierCfg.sEmgNotifierTimes.options.selectedIndex = 2;
	}

	if (vEmgNotiInterval == "1000") 
		document.emgNotifierCfg.sEmgNotifierInterval.options.selectedIndex = 1;
	else if (vEmgNotiInterval == "3000") 
		document.emgNotifierCfg.sEmgNotifierInterval.options.selectedIndex = 2;
	else
	{
		vEmgNotiInterval = 500;
		document.emgNotifierCfg.sEmgNotifierInterval.options.selectedIndex = 0;
	}


	$("#sEmgNotifierEnable").val(vEmgNotiEnable);
	$("#sEmgNotifierTimes").val(vEmgNotiTimes);
	$("#sEmgNotifierInterval").val(vEmgNotiInterval);
	$("#eEmgNotifierCode").val(vEmgNotiCode);

	
	emgNotifierSwitch();


}



function emgNotifierSwitch()
{
	if (document.emgNotifierCfg.sEmgNotifierEnable.options.selectedIndex == 1)
	{
		$("#trEmgNotifierTimes").show();
		$("#trEmgNotifierInterval").show();
		$("#trEmgNotifierCode").show();
		
		$("#divEmgTargetServerSetup").show();
		$("#divEmgSendTargetServerTable").show();
	}
	else
	{
		$("#trEmgNotifierTimes").hide();
		$("#trEmgNotifierInterval").hide();
		$("#trEmgNotifierCode").hide();
		
		$("#divEmgTargetServerSetup").hide();
		$("#divEmgSendTargetServerTable").hide();
	}
}

function initAddPage()
{
	
	document.emgNotifierAdd.sEmgNotifierTargetInterface.options.selectedIndex = 1;
	
	$("#emgNotifierTargetIP").val("");
	$("#emgNotifierTargetPort").val("");
	$("#emgNotifierTargetComment").val("");
}

function initTranslation()
{
	$("#emgNotifierTitle").html(_("service emg title"));
	$("#emgNotifierIntroduction").html(_("service emg introduction"));

	$("#capEmgNotifierSetup").html(_("service emg cap notifier setup"));
	$("#thEmgNotifierEnable").html(_("service emg notifier enable"));
	$("#thEmgNotifierTimes").html(_("service emg notifier count"));

	$("#emgNotifierDisable").html(_("service disable"));
	$("#emgNotifierEnable").html(_("service enable"));
	$("#emgNotifierTimes1").html(_("service emg notifier cnt 1"));
	$("#emgNotifierTimes2").html(_("service emg notifier cnt 2"));
	$("#emgNotifierTimes3").html(_("service emg notifier cnt 3"));
	$("#thEmgNotifierInterval").html(_("service emg notifier interval"));
	$("#thEmgNotifierCode").html(_("service emg notifier code"));


	$("#capEmgNotifierTargetSetup").html(_("service emg cap notifier add setup"));
	$("#thEmgNotifierTargetInterface").html(_("service emg notifier interface"));
	$("#thEmgNotifierTargetIP").html(_("service emg notifier ip"));
	$("#thEmgNotifierTargetPort").html(_("service emg notifier port"));
	$("#thEmgNotifierTargetComment").html(_("service emg notifier comment"));
	$("#timesMaxRuleCnt").html(_("service emg notifier rules cnt"));


	$("#capEmgSendTargetServer").html(_("service emg cap send target"));
	$("#tdEmgSendTargetServerNo").html(_("service emg notifier target no"));
	$("#tdEmgSendTargetServerInterface").html(_("service emg notifier target interface"));
	$("#tdEmgSendTargetServerAddress").html(_("service emg notifier target address"));
	$("#tdEmgSendTargetServerPort").html(_("service emg notifier target port"));
	$("#tdEmgSendTargetServerComment").html(_("service emg notifier target comment"));

	$("#setApply").val(_("service apply"));
	$("#setCancel").val(_("service cancel"));
	$("#addApply").val(_("service apply"));
	$("#addCancel").val(_("service cancel"));	
	$("#deleteRules").val(_("service delete rules"));
	$("#resetRules").val(_("service cancel rules")); 

}

</script>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("emg_notifier.asp"); </script>

	<h1 id="emgNotifierTitle"> EMG Notifier </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "emgNotifierIntroduction"> This system can send EMG Message to Server by UDP.</font> 
	</div>
	<div id = "blank"> </div>
	
	<form method="post" name="emgNotifierCfg" id="emgNotifierCfg" action="/goform/setEmgNotifierConfig">
	<table>
	<caption id="capEmgNotifierSetup"> EMG Notifier </caption> 
	<tr>
		<th id="thEmgNotifierEnable" > EMG Notifier </th> 
		<td>
			<select name="sEmgNotifierEnable" id="sEmgNotifierEnable"  size="1" onChange="emgNotifierSwitch();">
			<option value="0" id="emgNotifierDisable">Disable</option>
			<option value="1" id="emgNotifierEnable">Enable</option>
			</select>
		</td>
	</tr>
	
	<tr id="trEmgNotifierTimes"> 
		<th id="thEmgNotifierTimes">Send Times Setup</th>
		<td>
			<select name="sEmgNotifierTimes" id="sEmgNotifierTimes"  size="1" >
			<option value="1"  id="emgNotifierTimes1">1</option>
			<option value="2" id="emgNotifierTimes2">2</option>		
			<option value="3" id="emgNotifierTimes3">3</option>		
		</td>
	</tr>

	<tr id="trEmgNotifierInterval"> 
		<th id="thEmgNotifierInterval">Send Interval Setup</th>
		<td>
			<select name="sEmgNotifierInterval" id="sEmgNotifierInterval"  size="1" >
			<option value="500"  id="emgNotifierInterval500">500ms</option>
			<option value="1000" id="emgNotifierInterval1000">1000ms</option>		
			<option value="3000" id="Interval3000">3000ms</option>		
		</td>
	</tr>

	<tr id="trEmgNotifierCode">
		<th id="thEmgNotifierCode"> Code </th>
		<td> <input type = "text" name = "eEmgNotifierCode" id = "eEmgNotifierCode" size=16 maxlength = 16>&nbsp;</td>
	</tr>	

	</table>
	
	<div id = "blank" class="error" name="setEMGf" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "setApply" id="setApply">
	<input class = "btn" type = "button" value = "setCancel" id="setCancel">
	
	</form>	

	<div id="divEmgTargetServerSetup" >
	<form method="post" name="emgNotifierAdd" id="emgNotifierAdd" action="/goform/addEmgNotifierTargetServer">
	<table>
	<caption id="capEmgNotifierTargetSetup"> EMG Notifier Target Setup </caption> 
	<tr id = "trEmgNotifierTargetInterface">
		<th id="thEmgNotifierTargetInterface"> Interface </th>  
		<td>
			<select name="sEmgNotifierTargetInterface" id="sEmgNotifierTargetInterface"  size="1" >
			<option value="LAN" id="emgNotifierTargetInterface0">LAN</option>
			<option value="WWAN1" id="emgNotifierTargetInterface1">WWAN(Domain. 1)/WAN</option>
			<option value="WWAN2" id="emgNotifierTargetInterface2">WWAN(Domain. 2)</option>
			</select>
		</td>
	</tr>	
	
	<tr id="trEmgNotifierTargetIP">
		<th id="thEmgNotifierTargetIP"> Server Addr </th>
		<td> <input type = "text" name = "emgNotifierTargetIP" id = "emgNotifierTargetIP" size=28 maxlength = 128> </td>
	</tr>
	
	<tr id="trEmgNotifierTargetPort">
		<th id="thEmgNotifierTargetPort"> Server Port </th>
		<td> <input type = "text" name = "emgNotifierTargetPort" id = "emgNotifierTargetPort" size=28 maxlength = 5> </td>
	</tr>
	
	<tr id="trEmgNotifierTargetComment">
		<th id="thEmgNotifierTargetComment"> Comment </th>
		<td> <input type = "text" name = "emgNotifierTargetComment" id = "emgNotifierTargetComment" size=28 maxlength = 15>&nbsp;</td>
	</tr>	
	</table>

	<div id = "blank" class="error" name="addEMGf" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "addApply" id="addApply">
	<input class = "btn" type = "button" value = "addCancel" id="addCancel">
	</form>
	</div>

	<div id="divEmgSendTargetServerTable" >
	<div id = "blank"> </div>
	<form action="/goform/deleteEmgNotifierTargetServer" method=POST name="emgDeleteTargetServer" id="emgDeleteTargetServer">

	<table name="tableEmgSendTargetServer">	
	<caption id = "capEmgSendTargetServer"> EMG Message Target Server List to Send </caption>
	<thead>
	<tr>
		<td bgcolor=#E8F8FF id="tdEmgSendTargetServerNo"> No.</td>
		<td bgcolor=#E8F8FF id="tdEmgSendTargetServerInterface"> Interface </td>
		<td bgcolor=#E8F8FF id="tdEmgSendTargetServerAddress"> Public  IP Address </td>
		<td bgcolor=#E8F8FF id="tdEmgSendTargetServerPort"> Port </td>
		<td bgcolor=#E8F8FF id="tdEmgSendTargetServerComment"> Comment </td>
	</tr>
	</thead>
	<tbody>
	<% showEmgSendTargetServerRulesASP(); %>
	</tbody>
	</table>	

	<br>
	<div id="divMaxRuleCnt">
	<font id="timesMaxRuleCnt">The maximum rule:</font>
	</div>	
	
	<div id = "blank" class="error" name="delete" align="center">	<span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Delete" id = "deleteRules" name="deleteRules">
	<input class = "btn" type = "reset" value = "Reset" id = "resetRules"  name="resetRules">
	</form>
	</div>


<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

