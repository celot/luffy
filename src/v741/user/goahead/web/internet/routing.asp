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
<script type="text/javascript" src="/js/scrolltable.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<style type='text/css'>
td.route {
	font-size: 12px;
	background-color: #E8F8FF;
	text-align: center;
	padding: 5px 2px 5px 2px;
}
td.route2 {
	font-size: 11px;
	text-align: center;
	padding: 8px 2px 5px 2px;
}
</style>

<script language = "JavaScript" type = "text/javascript">
var http_request = false;
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("internet");

$(document).ready(function(){ 	
	initTranslation();
	initValue(); 
	
	var validateRule = $("#addrouting").validate({
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
			dest: {
				required : true,
				IP4Checker : true
			},
			gateway: {
				required : true,
				IP4Checker : true
			},
			netmask : {
				required : function() { return ($("#hostnet option").index($("#hostnet option:selected")) == 1);},
				IP4Checker : true
			},
			comment: {
				required : { depends:function(){return $("r_comment").length>0; }},
				maxString : {	param : 15 }
			}
		},			
		submitHandler :function(form){
			var errors = this.numberOfInvalids();
			if (errors) {
				$("div.error[name=add] span").html(_("alert rule number exceeded"));
				$("div.error[name=add] span").show();
			} else {
				$("div.error[name=add] span").hide();
				form.submit();
			}			
		}
	});
	

	$('#routingReset').click(function() { 
		validateRule.resetForm(); 
		$("div.error[name=add] span").hide();
	});

	$("form[name=delRouting]").submit(function() { 
		if($("input:checkbox[name^=DR]:checked").length==0){
			$("div.error[name=delete] span").html(_("alert select rule to be delete"));
			$("div.error[name=delete] span").show();
			return false;
		}
		$("div.error[name=delete] span").hide();
		return true;
	});

		
	$('#routingDelReset').click(function() { 
		$("div.error[name=delete] span").hide();
	});

	$("input:checkbox[name^=DR]").bind('click', function() {
		$("div.error[name=delete] span").hide();
	});	

	$("table[name=tableRotingList] tr td").width(function(index) {
			if(index%10==0) return 44; 
			else if(index%10==1) return 80; 
			else if(index%10==2) return 80; 
			else if(index%10==3) return 80; 
			else if(index%10==4) return 30; 
			else if(index%10==5) return 30; 
			else if(index%10==6) return 30; 
			else if(index%10==7) return 30; 
			else if(index%10==8) return 70; 
			else return 120;
	});
	
	$("table[name=tableRotingList]").createScrollableTable();
} );



var opmode = "<% getCfgZero(1, "OperationMode"); %>";

var destination = new Array();
var gateway = new Array();
var netmask = new Array();
var flags = new Array();
var convertFlags = new Array();
var metric = new Array();
var ref = new Array();
var use = new Array();
var true_interface = new Array();
var category = new Array();
var interface = new Array();
var idle = new Array();
var comment = new Array();

function initTranslation()
{
	$("#routingTitle").html(_("routing title"));
	$("#routingIntroduction").html(_("routing Introduction"));
	$("#routingAddRule").html(_("routing add rule"));
	$("#routingDest").html(_("routing routing dest"));
	$("#routingRange").html(_("routing range"));
	$("#routingNetmask").html(_("routing netmask"));
	$("#routingGateway").html(_("routing gateway"));
	$("#routingInterface").html(_("routing interface"));
	$("#routingComment").html(_("routing comment"));
	$("#routingSubmit").val(_("routing submit"));
	$("#routingReset").val(_("routing reset"));
	$("#routingCurrentRoutingTableRules").html(_("routing del title"));
	$("#routingNo").html(_("routing Number"));
	$("#routingDelDest").html(_("routing del dest"));
	$("#routingDelNetmask").html(_("routing del netmask"));
	$("#routingDelGateway").html(_("routing del gateway"));
	$("#routingDelFlags").html(_("routing del flags"));
	$("#routingDelMetric").html(_("routing del metric"));
	$("#routingDelRef").html(_("routing del ref"));
	$("#routingDelUse").html(_("routing del use"));
	$("#routingDelInterface").html(_("routing del interface"));
	$("#routingDelComment").html(_("routing del comment"));
	$("#routingHost").html(_("routing host"));
	$("#routingNet").html(_("routing net"));
	$("#routing LAN").html(_("routing LAN"));
	$("#dynamicRoutingTitle").html(_("routing dynamic Title"));
	$("#RIPDisable").html(_("routing dynamic rip disable"));
	$("#RIPEnable").html(_("routing dynamic rip enable"));
	$("#dynamicRoutingApply").val(_("routing dynamic rip apply"));
	$("#dynamicRoutingReset").val(_("routing reset"));
	$("#routingWWAN1").html(_("routing wwan1"));
	$("#routingWWAN2").html(_("routing wwan2"));
	$("#routingDel").val(_("routing del"));
	$("#routingDelReset").val(_("routing reset"));
}

function initValue()
{
	document.addrouting.hostnet.selectedIndex = 0;

	document.addrouting.netmask.readOnly = true;
	$("#routingNetmaskRow").hide();

	document.addrouting.interface.selectedIndex = 0;
	document.addrouting.custom_interface.value = "";
	document.addrouting.custom_interface.readOnly = true;

	if (<% getCfgZero(1, "RIPEnable"); %>) 
	{
		document.dynamicRouting.RIPSelect.selectedIndex = <% getCfgZero(1, "RIPEnable"); %>;
	}

}

function wrapDel(str, idle)
{
	if(idle == 1){
		document.write("<del>" + str + "</del>");
	}else
		document.write(str);
}

function hostnetChange()
{
	if(document.addrouting.hostnet.selectedIndex == 1){
		$("#routingNetmaskRow").show();
		document.addrouting.netmask.readOnly = false;
		document.addrouting.netmask.focus();

	}else{
		document.addrouting.netmask.value = "";
		document.addrouting.netmask.readOnly = true;
		$("#routingNetmaskRow").hide();
	}
}

function interfaceChange()
{
	if(document.addrouting.interface.selectedIndex == 2){
		document.addrouting.custom_interface.readOnly = false;
		document.addrouting.custom_interface.focus();
	}else{
		document.addrouting.custom_interface.value = "";
		document.addrouting.custom_interface.readOnly = true;
	}
}
</script>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("routing.asp"); </script>

	<h1 id="routingTitle"> Wide Area Network (WAN) Settings </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "routingIntroduction"> </font> 
	</div>
	<div id = "blank"> </div>

	<form method = post name = "addrouting" id="addrouting" action = "/goform/addRouting">
	<table>
	<caption id = "routingAddRule"> Add a routing rule </caption>
	<tr>
		<th id = "routingDest"> Destination </th>
		<td>
			<input size="16" name="dest" id="dest" class="tbox_120" type="text">
		</td>
	</tr>
	<tr>
		<th id = "routingRange"> Host/Net </th>
		<td>
			<select name="hostnet" id="hostnet" onChange="hostnetChange()">
            		<option select="" value="host" id="routingHost">Host</option>
            		<option value="net"  id="routingNet">Net</option>
            		</select>
		</td>
	</tr>
	<tr id="routingNetmaskRow">
		<th id = "routingNetmask"> Sub Netmask </th>
		<td>
			<input size="16" name="netmask" id="netmask" class="tbox_120" type="text">
		</td>
	</tr>
	<tr>
		<th id = "routingGateway"> Gateway </th>
		<td>
			<input size="16" name="gateway" id="gateway" class="tbox_120" type="text">
		</td>
	</tr>
	<tr>
		<th id = "routingInterface"> Interface </th>
		<td>
			<select name="interface" id="interface"  size="1" onChange="interfaceChange()"> 
			<option value="LAN" id="routing LAN">LAN</option>		
			<option value="WWAN1" id="routingWWAN1">WWAN1</option>
			<option value="WWAN2" id="routingWWAN2">WWAN2</option>
            		</select>
            		<input alias="right" size="16" name="custom_interface" class="tbox_120"  type="text">
		</td>
	</tr>
	<tr>
		<th id = "routingComment"> Comment </th>
		<td>
			<input name="comment" id="r_comment" size="16" maxlength="15" class="tbox_120" type="text">
		</td>
	</tr>
	</table>	

	<div id = "blank" class="error" name="add" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "routingSubmit"  name="addFilterPort">
	<input class = "btn" type = "reset" value = "Reset" id = "routingReset" name="reset">
	</form>
	<div id = "blank"> </div>

	<form action="/goform/delRouting" method="post" name="delRouting" id="delRouting">
	<table name=tableRotingList>
	<caption id = "routingCurrentRoutingTableRules"> Current Routing table in the system: </caption>
	<thead>
	<tr>
		<td class="route"><font id="routingNo">No.</font></td>
		<td class="route"><font id="routingDelDest">Destination</font></td>
		<td class="route"><font id="routingDelNetmask">Netmask</font></td>
		<td class="route"><font id="routingDelGateway">Gateway</font></td>
		<td class="route"><font id="routingDelFlags">Flags</font></td>
		<td class="route"><font id="routingDelMetric">Metric</font></td>
		<td class="route"><font id="routingDelRef">Ref</font></td>
		<td class="route"><font id="routingDelUse">Use</font></td>
		<td class="route"><font id="routingDelInterface">Interface</font></td>
		<td class="route"><font id="routingDelComment">Comment</font></td>
	</tr>
	</thead>
	<tbody>
	<script language="JavaScript" type="text/javascript">
            	var i;
            	var entries = new Array();
            	var all_str = <% getRoutingTable(); %>;
            
            	entries = all_str.split(";");
            	for(i=0; i<entries.length; i++)
		{
            		var one_entry = entries[i].split(",");
            
            		true_interface[i] = one_entry[0];
            		destination[i] = one_entry[1];
            		gateway[i] = one_entry[2];
            		netmask[i] = one_entry[3];
            		flags[i] = one_entry[4];
            		ref[i] = one_entry[5];
            		use[i] = one_entry[6];
            		metric[i] = one_entry[7];
            		category[i] = parseInt(one_entry[8]);
            		interface[i] = one_entry[9];
            		idle[i] = parseInt(one_entry[10]);
            		comment[i] = one_entry[11];
            		if(comment[i] == " " || comment[i] == "")
            			comment[i] = "&nbsp";

			convertFlags[i] = '';
			if(flags[i] & 1) convertFlags[i] += 'U';
			if(flags[i] & 2) convertFlags[i] += 'G';
			if(flags[i] & 4) convertFlags[i] += 'H';
            	}
            
            	for(i=0; i<entries.length; i++)
		{
            		if(category[i] > -1)
			{
            			document.write("<tr>");
            			document.write("<td class=route2>");
            			document.write("<label for=\"DR"+category[i]+"\">" + (i+1) + "</label>");		
            			document.write("<input type=checkbox name=DR"+ category[i] + " id=\"DR" + category[i] + "\"" + 
            				" value=\""+ destination[i] + " " + netmask[i] + " " + true_interface[i] +"\">");
            			document.write("</td>");
            		}
			else
			{
            			document.write("<tr>");
            			document.write("<td class=route2>"); 	document.write(i+1);			 	document.write("</td>");
            		}
            
            		document.write("<td class=route2>"); 	wrapDel(destination[i], idle[i]); 	document.write("</td>");
            		document.write("<td class=route2>"); 	wrapDel(netmask[i], idle[i]);		document.write("</td>");
            		document.write("<td class=route2>"); 	wrapDel(gateway[i], idle[i]); 		document.write("</td>");
            		document.write("<td class=route2>"); 	wrapDel(convertFlags[i], idle[i]);	document.write("</td>");
            		document.write("<td class=route2>"); 	wrapDel(metric[i], idle[i]);		document.write("</td>");
            		document.write("<td class=route2>"); 	wrapDel(ref[i], idle[i]);			document.write("</td>");
            		document.write("<td class=route2>"); 	wrapDel(use[i], idle[i]);			document.write("</td>");
            
            		if(interface[i] == "LAN")
            			interface[i] = _("routing LAN");
            		else if(interface[i] == "WAN")
            			interface[i] = _("routing WAN");
            		else if(interface[i] == "Custom")
            			interface[i] = _("routing custom");
			else if(interface[i] == "WWAN1")
            			interface[i] = _("routing wwan1");
			else if(interface[i] == "WWAN2")
            			interface[i] = _("routing wwan2");
            
            		document.write("<td class=route2>"); 	wrapDel(interface[i] + "(" +true_interface[i] + ")", idle[i]);		document.write("</td>");
            		document.write("<td class=route2>"); 	wrapDel(comment[i], idle[i]);		document.write("</td>");
            		document.write("</tr>\n");
            	}
	</script>
	</tbody>
	</table>
	
	<div id = "blank" class="error" name="delete" align="center">	<span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Delete" id = "routingDel">
	<input class = "btn" type = "reset" value = "Reset" id = "routingDelReset">
	</form>

	<div id = "blank"> </div>
	<form action="/goform/dynamicRouting" method="post" name="dynamicRouting">
	<table>
	<caption id = "dynamicRoutingTitle"> Dynamic routing </caption>
	<tr>
		<th id = "RIP"> RIP </th>
		<td>
			<select name="RIPSelect" size="1">
                    	<option value=0 id="RIPDisable">Disable</option>
                    	<option value=1 id="RIPEnable">Enable</option>
                    	</select>
		</td>
	</tr>
	
	</table>
	
	<div id = "blank"> </div>
	<input class = "btn" type = "submit" value = "Apply" id = "dynamicRoutingApply" name="dynamicRoutingApply">
	<input class = "btn" type = "reset" value = "Cancel" id = "dynamicRoutingReset" name="dynamicRoutingReset">
	</form>
	
<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

