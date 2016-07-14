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
Butterlate.setTextDomain("admin");

$(document).ready(function(){ 
	initTranslation();
	initValue();
	
	var validateRule = $("[name=domainWL]").validate({
		rules: {
			dwlRec1: {
				required : { depends: function() {return $("#dwlFunc").val()=="1";} },
				max : 64
			},
			dwlRec2: {
				required : { depends: function() {return $("#dwlFunc").val()=="1";} },
				max : 64
			},
		},
		
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addDwlErr] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addDwlErr] span").show();
			} else {
				$("div.error[name=addDwlErr] span").hide();
			}
		},

		submitHandler :function(form){
			if(this.numberOfInvalids())
			{
				return;
			}
			else
			{
				$("div.error[name=addDwlErr] span").hide();
				form.submit();
			}
		}
	});

	$('#btnReset').click(function() { 
		validateRule.resetForm();
		$("div.error[name=addDwlErr] span").hide();
		initValue();
	});
});

function initTranslation()
{
	$("#dwlTitle").html(_("dwl title"));
	$("#dwlIntro").html(_("dwl introduction"));
	$("#capDwl").html(_("dwl fucnc cap"));
	$("#thDwlFunc").html(_("dwl fucnc"));
	$("#thRec1").html(_("dwl rec1"));
	$("#thRec2").html(_("dwl rec2"));

	$("#dwlDisable").html(_("admin disable"));
	$("#dwlEnable").html(_("admin enable"));
	$("#btnApply").val(_("admin apply"));
	$("#btnReset").val(_("admin cancel"));
}

function initValue()
{
	var dwlEnable = "<% getCfgGeneral(1, "DwlFuncEnable"); %>";
	var dwlRec1 = "<% getCfgGeneral(1, "DwlRec01"); %>";
	var dwlRec2 = "<% getCfgGeneral(1, "DwlRec02"); %>";

	if($.trim(dwlEnable).length>0) $("#dwlFunc").val(dwlEnable);
	else $("#dwlFunc").val("0");

	$("#dwlRec1").val(dwlRec1);
	$("#dwlRec2").val(dwlRec2);
}
</script>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("domain_wl.asp"); </script>

	<h1 id = "dwlTitle"> Domain White List </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "dwlIntro"> </font> 
	</div>
	<div id = "blank"> </div>

	<form method = post name = "domainWL" action = "/goform/setDomainWL">
	<table>
	<caption id = "capDwl">  Domain White List </caption>
	<tr>
		<th id="thDwlFunc">Domain White List</th>
		<td>
			<select name="dwlFunc" id="dwlFunc" size="1">
			<option value="0" id="dwlDisable">Disable</option>
			<option value="1" id="dwlEnable">Enable</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="thRec1"> Record 1</th>
		<td> <input type=text name=dwlRec1 id=dwlRec1 size=32 maxlength=64></td>
	</tr>
	<tr>
		<th id="thRec2"> Record 2</th>
		<td> <input type=text name=dwlRec2 id=dwlRec2 size=32 maxlength=64></td>
	</tr>
	</table>
	
	<div id = "blank" class="error" name="addDwlErr" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "btnApply">
	<input class = "btn" type = "button" value = "Cancel" id = "btnReset" >
	</form>	

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

