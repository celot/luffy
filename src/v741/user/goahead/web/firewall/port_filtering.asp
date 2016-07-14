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


<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("firewall");

var rules_num = <% getIPPortRuleNumsASP(); %>;
var MAX_RULES = 32;
var port_enable = "<% getCfgGeneral(1, "IPPortFilterEnable"); %>";

$(document).ready(function(){  
	initTranslation();
	init();

	var validateRule = $("#ipportFilter").validate({
		rules: {
			mac_address: {
				required : "#scr_macip1:checked",
				MACChecker : true
			},
			sip_address: {
				required: {
					depends:function(){
						if($("#dip_address").val()=="") return true;
						else return false;
					}
				},	
				IP4Checker : true
			},
			dip_address: {
				required: {
					depends:function(){
						if(($("#scr_macip1").is(":checked") && $("#mac_address").val()=="")
							|| ($("#scr_macip2").is(":checked") && $("#sip_address").val()=="")) return true;
						else return false;
					}
				},
				IP4Checker: true
			},
			sFromPort: {
				required:  true,
				number: true,
				min : 1,
				max : function() { return parseInt($("#sToPort").val());}
			},
			sToPort: {
				required:  true,
				number: true,
				min : function() { return parseInt($("#sFromPort").val());},
				max : 65535
			},
			dFromPort:{
				required: true,
				number: true,
				min : 1,
				max : function() { return parseInt($("#dToPort").val());}
			},
			dToPort:{
				required: true,
				number: true,
				min : function() { return parseInt($("#dFromPort").val());},
				max : 65535
			},
			comment: {
				required : { depends:function(){return $("f_comment").length>0; }},
				maxString : {	param : 15 }
			}
		},

		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=add] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=add] span").show();
			} else {
				$("div.error[name=add] span").hide();
			}
		},

		submitHandler :function(form){
			if(rules_num >= (MAX_RULES) ){
				$("div.error[name=add] span").html(_("alert rule number exceeded")+ MAX_RULES +".");
				$("div.error[name=add] span").show();
			}
			else
			{
				if(this.numberOfInvalids())
				{
					return;
				}
				else
				{
					$("div.error[name=add] span").hide();
					form.submit();
				}
			}
		}
	});

	$('#portBasicReset').click(function() { 
		initDefault();
	});
	
	$('#portFilterReset').click(function() { 
		validateRule.resetForm(); 
		$("div.error[name=add] span").hide();
		initRule();
	});

	$("form[name=ipportFilterDelete]").submit(function() { 
		if($("input:checkbox[name^=delRule]:checked").length==0){
			$("div.error[name=delete] span").html(_("alert select rule to be delete"));
			$("div.error[name=delete] span").show();
			return false;
		}
		$("div.error[name=delete] span").hide();
		return true;
	});
	
	$('#portCurrentFilterReset').click(function() { 
		$("div.error[name=delete] span").hide();
	});

	$("input:checkbox[name^=delRule]").bind('click', function() {
		$("div.error[name=delete] span").hide();
	});
	
	$("table[name=portRules] tr td").width(function(index) {
			if(index%7==0) return 40; 
			else if(index%7==1) return 96; 
			else if(index%7==2) return 80; 
			else if(index%7==3) return 80; 
			else if(index%7==4) return 42 
			else if(index%7==5) return 60; 
			else return 100;
	});
	
	$("table[name=portRules]").createScrollableTable();
});


function initTranslation()
{	
	$("#portTitle").html(_("port title"));
	$("#portIntroduction").html(_("port introduction"));

	$("#portBasicSet").html(_("port basic setting"));
	$("#portBasicFilter").html(_("port basic filter"));
	$("#portBasicDisable").html(_("firewall disable"));
	$("#portBasicEnable").html(_("firewall enable"));
	$("#portBasicDefaultPolicy").html(_("port basic default policy"));
	$("#portBasicDefaultPolicyAccept").html(_("port basic default policy accepted"));
	$("#portBasicDefaultPolicyDrop").html(_("port basic default policy dropped"));
	$("#portBasicApply").val(_("firewall apply"));
	$("#portBasicReset").val(_("firewall cancel"));

	$("#portFilterSet").html(_("port filter setting"));
	$("#portFilterMac").html(_("port filter macaddr"));
	$("#portFilterSIPAddr").html(_("port filter ipaddr"));
	$("#portFilterSPortRange").html(_("port filter source port range"));
	$("#portFilterDIPAddr").html(_("port filter destipaddr"));
	$("#portFilterDPortRange").html(_("port filter dest port range"));
	$("#portFilterProtocol").html(_("firewall protocol"));
	$("#portFilterAction").html(_("port filter action"));
	$("#portFilterActionDrop").html(_("port filter action drop"));
	$("#portFilterActionAccept").html(_("port filter action accept"));
	$("#portFilterComment").html(_("firewall comment"));
	$("#portFilterApply").val(_("firewall apply"));
	$("#portFilterReset").val(_("firewall cancel"));
	$("#maxRuleCnt").html(_("firewall max rule"));
	$("#maxRuleCnt2").html(_("firewall max rule"));
	$("#portCurrentFilter").html(_("port current filter"));


	$("#portFilteringInterface").html(_("port filter interface"));
	$("#filterWWAN1").html(_("port filter wwan1"));
	$("#filterWWAN2").html(_("port filter wwan2"));


	$("#portCurrentFilterNo").html(_("firewall no"));
	$("#portCurrentFilterInterface").html(_("port filter interface"));
	$("#portCurrentFilterSInfo").html(_("port filter source ipaddr"));
	$("#portCurrentFilterDInfo").html(_("port filter dest ipaddr"));
	$("#portCurrentFilterProtocol").html(_("firewall protocol"));
	$("#portCurrentFilterAction").html(_("port filter action"));
	$("#portCurrentFilterComment").html(_("firewall comment"));
		
	$("#portCurrentFilterDel").val(_("firewall del select"));
	$("#portCurrentFilterReset").val(_("firewall cancel"));

	for(var i=0; i<$("table[name=portRules] tr").size(); i++)
	{
		if($("#portFilterActionDrop"+i).length){
			$("#portFilterActionDrop"+i).html(_("port filter action drop"));
		}
		if($("#portFilterActionAccept"+i).length){
			$("#portFilterActionAccept"+i).html(_("port filter action accept"));
		}
	}
	
	$("[id=ifaceWWAN1]").each( function (index, item) { $(item).html( _("port filter wwan1")); } );	
	$("[id=ifaceWWAN2]").each( function (index, item) { $(item).html( _("port filter wwan2")); } );	
}


function defaultPolicyChanged()
{
	if( document.BasicSettings.defaultFirewallPolicy.options.selectedIndex == 0){
		document.ipportFilter.action.options.selectedIndex = 0;
	}else
		document.ipportFilter.action.options.selectedIndex = 1;
}

function initDefault()
{
	var defaultPolicy = "<% getCfgGeneral(1, "DefaultFirewallPolicy"); %>";
	$("#BasicSettings").initForm([(port_enable == "1")?1:0, (defaultPolicy == "1")?1:0]);
	if(port_enable == "1")
	{
		$("#filterrules").show();
		$("#trDefaultPolicy").show();
	}
	else
	{
		$("#filterrules").hide();
		$("#trDefaultPolicy").hide();
	}
	(rules_num >0 )? $("#rulesdel").show():$("#rulesdel").hide();
}	

function initRule()
{
	var defaultPolicy = "<% getCfgGeneral(1, "DefaultFirewallPolicy"); %>";
	$("#ipportFilter").initForm([0, 0, "", 1, "", 1, 65535, "", 1, 65535, 0, (defaultPolicy == "1")?1:0, ""]);
	$("#mac_address").attr("disabled",true);
	$("#filterRulAction").attr("disabled",true);
	$("#dFromPort").attr("disabled",true);
	$("#dToPort").attr("disabled",true);
	$("#sFromPort").attr("disabled",true);
	$("#sToPort").attr("disabled",true);
}	

function init()
{
	initRule();
	initDefault();
}

function updateState()
{
	if( document.BasicSettings.portFilterEnabled.options.selectedIndex == 1)
	{
		$("#filterrules").show();
		$("#trDefaultPolicy").show();
	}
	else
	{
		$("#filterrules").hide();
		$("#trDefaultPolicy").hide();
	}
}


function protocolChange()
{
	if( document.ipportFilter.protocol.options.selectedIndex == 1 ||
		document.ipportFilter.protocol.options.selectedIndex == 2){
		$("#dFromPort").attr("disabled",false);
		$("#dToPort").attr("disabled",false);
		$("#sFromPort").attr("disabled",false);
		$("#sToPort").attr("disabled",false);
	}else{
		$("#dFromPort").attr("disabled",true);
		$("#dToPort").attr("disabled",true);
		$("#sFromPort").attr("disabled",true);
		$("#sToPort").attr("disabled",true);
		$("#dFromPort").val(1);
		$("#dToPort").val(65535);
		$("#sFromPort").val(1);
		$("#sToPort").val(65535);
	}
}

function scrMacIpClick(type)
{
	if(type==1)
	{
		$("#sip_address").removeClass('error');
		$("#mac_address").attr("disabled",false);
		$("#sip_address").attr("disabled",true);
		$("#sip_address").val("");
		$("#scr_macip2").attr("checked",false);
	}
	else
	{
		$("#mac_address").removeClass('error');
		$("#mac_address").attr("disabled",true);
		$("#sip_address").attr("disabled",false);
		$("#mac_address").val("");
		$("#scr_macip1").attr("checked",false);
	}	
}
function showOtherAction()
{
	if(rules_num >0 )
	{
		var defaultPolicy = "<% getCfgGeneral(1, "DefaultFirewallPolicy"); %>";
		document.write("<div align=left style=\"padding:5px 10px\">");
		if(defaultPolicy==0) document.write(_("firewall default accept"));
		else document.write(_("firewall default drop"));
		document.write("</div>");
	}
}
</script>
</head>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("port_filtering.asp"); </script>

	<h1 id="portTitle"> MAC/IP/Port Filtering Settings </h1>
	<% checkIfUnderBridgeModeASP(); %>
	<div align="left">
	&nbsp;&nbsp; <font id = "portIntroduction"> </font> 
	</div>
	<div id = "blank"> </div>
	

	<!-- ====================   BASIC  form  ==================== -->
	<form method=post name="BasicSettings" id="BasicSettings" action=/goform/BasicSettings>
	<table>
	<caption id = "portBasicSet"> Basic Settings </caption>

	<tr>
		<th id="portBasicFilter"> MAC/IP/Port Filtering </th>
		<td>
			<select onChange="updateState()" name="portFilterEnabled" size="1">
			<option value=0 id="portBasicDisable">Disable</option>
			<option value=1 id="portBasicEnable">Enable</option>
			</select>
		</td>
	</tr>

	<tr id="trDefaultPolicy">
		<th class="head" id="portBasicDefaultPolicy"> Default Policy -- The packet that don't match with any rules would be: </th>
		<td>
			<select onChange="defaultPolicyChanged()" name="defaultFirewallPolicy">
			<option value=0 id="portBasicDefaultPolicyAccept">Accepted.</option>
			<option value=1 id="portBasicDefaultPolicyDrop">Dropped.</option>
		</select>
		</td>
	</tr>
	</table>

	<div id = "blank"> </div>
	<input class = "btn" type = "submit" value = "Apply" id = "portBasicApply" name="applyBasic">
	<input class = "btn" type = "button" value = "Reset" id = "portBasicReset"  name="reset" >
	</form>

	<div id="filterrules">
	<div id = "blank"> </div>
	<!-- ====================   MAC/IP/Port form   ==================== -->
	<form method=post name="ipportFilter" id="ipportFilter" action=/goform/ipportFilter>
	<table>
	<caption id = "portFilterSet"> IP/Port Filter Settings </caption>

	<tr>
		<th id = "portFilteringInterface"> Interface </th>
		<td>
			<select name="portFilterInterface">
			<option select="" value="WWAN1" id="filterWWAN1">WWAN1</option>
			<option select="" value="WWAN2" id="filterWWAN2">WWAN2</option>
            		</select>
		</td>
	</tr>

	<tr>
		<th><input type="radio" id="scr_macip1"  name="scr_macip1" value="on"  onClick="scrMacIpClick(1)"> <font id="portFilterMac"> Mac address </font></th>
		<td> <input type="text" size="18" id="mac_address" name="mac_address"> </td>
	</tr>
	<tr>
		<th><input type="radio" id="scr_macip2"  name="scr_macip2" value="off" onClick="scrMacIpClick(0)">  <font id="portFilterSIPAddr"> Source IP Address </font></th>
		<td> <input type="text" size="16" id="sip_address"  name="sip_address" > </td>
	</tr>
	<tr>
		<th id="portFilterSPortRange"> Src Port Range</th>
		<td>
			<input type="text" size="5" name="sFromPort" id="sFromPort">-
			<input type="text" size="5" name="sToPort" id="sToPort">
		</td>
	</tr>
	<tr>
		<th id="portFilterDIPAddr"> Dest IP Address </th>
		<td > <input type="text" size="16" id="dip_address" name="dip_address">
		</td>
	</tr>
	<tr>
		<th id="portFilterDPortRange"> Dest. Port Range </th>
		<td>
			<input type="text" size="5" name="dFromPort" id="dFromPort">-
			<input type="text" size="5" name="dToPort" id="dToPort">
		</td>
	</tr>
	<tr>
		<th id="portFilterProtocol"> Protocol </th>
		<td>
			<select onChange="protocolChange()" name="protocol" id="procotol">
			<option value="None">ALL</option>
			<option value="TCP">TCP</option>
			<option value="UDP">UDP</option>
			<option value="ICMP">ICMP</option>
			</select>&nbsp;&nbsp;
		</td>
	</tr>
	<tr>
		<th id="portFilterAction"> Action </th>
		<td>
			<select name="action" name="filterRulAction" id="filterRulAction">
			<option value="Drop" id="portFilterActionDrop">Drop</option>
			<option value="Accept" id="portFilterActionAccept">Accept</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="portFilterComment"> Comment </th>
		<td>
			<input type="text" name="comment" id="f_comment" size="32" maxlength="15">
		</td>
	</tr>
	</table>
	(<font id="maxRuleCnt">The maximum rule:</font>
		<script> document.write(MAX_RULES);</script>
	)
	
	<div id = "blank" class="error" name="add" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "portFilterApply" name="addFilterPort">
	<input class = "btn" type = "button" value = "Reset" id = "portFilterReset"  name="reset" >
	</form>

	<div id="rulesdel">
	<div id = "blank"> </div>
	<!-- =========================  delete rules  ========================= -->
	<form action=/goform/ipportFilterDelete method=POST name="ipportFilterDelete" id="ipportFilterDelete">

	<table name="portRules">	
	<caption id = "portCurrentFilter"> Current IP/Port filtering rules in system: </caption>
	<thead>
	<tr>
		<td bgcolor=#E8F8FF id="portCurrentFilterNo"> No.</td>
		<td bgcolor=#E8F8FF id="portCurrentFilterInterface"> Interface </td>
		<td bgcolor=#E8F8FF id="portCurrentFilterSInfo"> Src Mac/IP/Port </td>
		<td bgcolor=#E8F8FF id="portCurrentFilterDInfo"> Dest IP/Port </td>
		<td bgcolor=#E8F8FF id="portCurrentFilterProtocol"> Protocol</td>
		<td bgcolor=#E8F8FF id="portCurrentFilterAction"> Action</td>
		<td bgcolor=#E8F8FF id="portCurrentFilterComment"> Comment</td>
	</tr>
	</thead>
	<tbody>
	<% showIPPortFilterRulesASP(); %>
	</tbody>
	</table>
	<script language="JavaScript" type="text/javascript"> showOtherAction(); </script>

	<div id = "blank" class="error" name="delete" align="center">	<span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Del Selected"  id = "portCurrentFilterDel" name="deleteSelFilterPort">
	<input class = "btn" type = "reset" value = "Reset" id = "portCurrentFilterReset"  name="reset">
	</form>
	</div>
	</div>
 
<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>
