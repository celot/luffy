<html>
<head>
<title id = "mainTitle"> <% getModelName(); %> Management </title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate_celot.min.js"></script>
<script type="text/javascript" src="/js/scrolltable.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>

<style type='text/css'>
div.second {
   padding-top:3px;
}
</style>

<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("mobile");

var rules_num_center_push = <% getCenterPushRuleNumsASP(); %> ;

$(document).ready(function(){  
	initTranslation();
	init();

	// basic set
	$('#SetcenterPushResetBtn').click(function() { 
		init();
	});

	// add phone number
	var validateAddRule = $("#AddCenterPush").validate({
		rules: {
			centerPushPhoneNumber:{
				required: true,
				number: true
			},
			CenterPushComment: {
				required : { depends:function(){return $("CenterPushComment").length>0; }},
				maxString : {	param : 15 }
			}
		},
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addCenterPushContent] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addCenterPushContent] span").show();
			} else {
				$("div.error[name=addCenterPushContent] span").hide();
			}
		},

		submitHandler :function(form){
			var errors = this.numberOfInvalids();
			if (errors) {
				$("div.error[name=addCenterPushContent] span").html(_("alert rule number exceeded"));
				$("div.error[name=addCenterPushContent] span").show();
			} else {
				$("div.error[name=addCenterPushContent] span").hide();
				form.submit();
			}			
		}
	});

	$('#addCenterPushResetBtn').click(function() { 
		validateAddRule.resetForm(); 
		$("div.error[name=addCenterPushContent] span").hide();
		initAddCenterPush();
	});

	// delete table
	$("table[name=tableDeleteCenterPushDelete] tr td").width(function(index) {
			if(index%4==0) return 40; 
			else if(index%4==1) return 196; 
			else if(index%4==2) return 180; 
			else if(index%4==3) return 180; 
			else return 100;
	});
	
	$("table[name=tableDeleteCenterPushDelete]").createScrollableTable();

	$("form[name=DeleteCenterPush]").submit(function() { 
		if($("form[name=DeleteCenterPush] input:checkbox[name^=delRule]:checked").length==0){
			$("div.error[name=delCenterPush] span").html(_("mobile alert select rule to be delete"));
			$("div.error[name=delCenterPush] span").show();
			return false;
		}
		$("div.error[name=delCenterPush] span").hide();
		return true;
	});
	
});

function initAddCenterPush()
{
	$("#AddCenterPush").initForm([0, 1, "", ""]);	
	changePhoneNumber();
}

function updateState()
{
	if( document.SetCenterPush.setCenterPushEnabled.options.selectedIndex == 1)
	{
		//$("#divDeleteCenterPush").show();
		$("#divAddCenterPush").show();

		if( rules_num_center_push > 0 ) $("#divDeleteCenterPush").show();
		else $("#divDeleteCenterPush").hide();
	}
	else
	{
		$("#divAddCenterPush").hide();
		$("#divDeleteCenterPush").hide();
	}
}

function changePhoneNumber()
{
	if ($("#selDesignation").val() == 0) // phone number
	{
		$("#divSecond").show();
	}
	else // any
	{
		$("#divSecond").hide();
	}
}

function initTranslation()
{
	$("#lTitle").html(_("mobile center push title"));
	$("#lIntroduction").html(_("mobile center push inst"));
	$("#centerPushSet").html(_("mobile center push set"));
	$("#pushEnable").html(_("mobile center push set"));
	$("#centerPushDisable").html(_("mobile center push disable"));
	$("#centerPushEnable").html(_("mobile center push enable"));
	$("#capAddCenterPush").html(_("mobile center push add phone number"));	
	$("#thInterface").html(_("mobile center push interface"));
	$("#centerPushWWAN1").html(_("mobile mode wwan1"));
	$("#centerPushWWAN2").html(_("mobile mode wwan2"));
	$("#thPhoneNumber").html(_("mobile center push phone number"));	
	$("#Designation").html(_("mobile center push designate"));
	$("#Any").html(_("mobile center push not specified"));
	$("#thCenterPushComment").html(_("mobile center push comment"));
	$("#capDeleteCenterPushDelete").html(_("mobile center push phone list"));
	$("#DeleteCenterPushDeleteNo").html(_("mobile center push phone list order"));
	$("#DeleteCenterPushInterface").html(_("mobile center push interface"));
	$("#DeleteCenterPushPhoneNumber").html(_("mobile center push phone number"));
	$("#DeleteCenterPushComment").html(_("mobile center push comment"));
	$("#SetCenterPushApplyBtn").val(_("mobile apply"));
	$("#SetcenterPushResetBtn").val(_("mobile cancel"));
	$("#addCenterPushApplyBtn").val(_("mobile apply"));
	$("#addCenterPushResetBtn").val(_("mobile cancel"));
	$("#DelCenterPushBtn").val(_("mobile delete"));
	$("#DelCenterPushResetBtn").val(_("mobile cancel"));
	
	$("[id=ifaceWWAN1]").each( function (index, item) { $(item).html( _("mobile mode wwan1")); } );	
	$("[id=ifaceWWAN2]").each( function (index, item) { $(item).html( _("mobile mode wwan2")); } );	
}

function init()
{
	var centerPushEnable = "<% getCfgGeneral(1, "centerPushEnable"); %>";
	
	if (centerPushEnable == 0) 
	{
		document.SetCenterPush.setCenterPushEnabled.options.selectedIndex = 0;
	}
	else
	{
		document.SetCenterPush.setCenterPushEnabled.options.selectedIndex = 1;
	}

	document.AddCenterPush.selDesignation.options.selectedIndex = 1;
	
	updateState();
	changePhoneNumber();
}

</script>
</head>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("center_push.asp"); </script>

	<h1 id="lTitle"> Local Area Network (LAN) Settings </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "lIntroduction"> </font> 
	</div>
	<div id = "blank"> </div>

	<!-- ====================   CenterPush  form  ==================== -->
	<form method=post name="SetCenterPush" id="SetCenterPush" action=/goform/SetCenterPush>
	<table>
	<caption id = "centerPushSet"> Center Push Settings </caption>
	<tr>
		<th id="pushEnable"> Center Push </th>
		<td>
			<select onChange="updateState()" name="setCenterPushEnabled" id="setCenterPushEnabled"  size="1">
			<option value=0 id="centerPushDisable">Disable</option>
			<option value=1 id="centerPushEnable">Enable</option>
			</select>
		</td>
	</tr>
	</table>

	<div id = "blank"> </div>
	<input class = "btn" type = "submit" value = "Apply" id = "SetCenterPushApplyBtn" name="SetCenterPushApplyBtn">
	<input class = "btn" type = "button" value = "Reset" id = "SetcenterPushResetBtn"  name="SetcenterPushResetBtn" >
	</form>

	<div id="divAddCenterPush">
	<div id = "blank"> </div>
	<!-- ====================   add phone number form   ==================== -->
	<form method=post name="AddCenterPush" id="AddCenterPush" action=/goform/AddCenterPush>
	<table>
	<caption id = "capAddCenterPush"> Add Phone number set </caption>
	<tr>
		<th id = "thInterface"> Interface </th>
		<td>
			<select name="centerPushInterface">
			<option value="WWAN1" id="centerPushWWAN1">WWAN1</option>
			<option value="WWAN2" id="centerPushWWAN2">WWAN2</option>
            		</select>
		</td>
	</tr>
	
	<tr>
		<th id="thPhoneNumber" > Phone Number  </th>  
		<td>
			<select name="selDesignation" id="selDesignation" onChange="changePhoneNumber()">
			<option value="0" id="Designation">Designation</option>
			<option value="1" id="Any">Any</option>
			</select> 
			<div class = "second" id="divSecond" >
			<input type="text" size="16" id="centerPushPhoneNumber" name="centerPushPhoneNumber" maxlength="16">
			</div>
		</td>
	</tr>
	
	<tr>
		<th id="thCenterPushComment"> Comment </th>
		<td>
			<input type="text" name="CenterPushComment" id="CenterPushComment" size="32" maxlength="15">
		</td>
	</tr>
	</table>

	<div id = "blank" class="error" name="addCenterPushContent" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "addCenterPushApplyBtn" name="addCenterPushApplyBtn">
	<input class = "btn" type = "button" value = "Reset" id = "addCenterPushResetBtn"  name="addCenterPushResetBtn" >
	</form>
	</div>

	<!-- Delete -->
	<div id="divDeleteCenterPush" >
	<div id = "blank"> </div>
	<form method=post name="DeleteCenterPush" id="DeleteCenterPush" action=/goform/DeleteCenterPush>

	<table name="tableDeleteCenterPushDelete">	
	<caption id = "capDeleteCenterPushDelete"> Phone List</caption>
	<thead>
	<tr>
		<td bgcolor=#E8F8FF id="DeleteCenterPushDeleteNo"> No.</td>
		<td bgcolor=#E8F8FF id="DeleteCenterPushInterface"> Interface </td>
		<td bgcolor=#E8F8FF id="DeleteCenterPushPhoneNumber"> Phone Number</td>
		<td bgcolor=#E8F8FF id="DeleteCenterPushComment"> Comment</td>
	</tr>
	</thead>
	<tbody>
	<% showCenterPushRulesASP(); %>
	</tbody>
	</table>	

	<div id = "blank" class="error" name="delCenterPush" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Del Selected" id = "DelCenterPushBtn" name="DelCenterPushBtn">
	<input class = "btn" type = "reset" value = "Reset" id = "DelCenterPushResetBtn"  name="DelCenterPushResetBtn">
	</form>
	</div>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

