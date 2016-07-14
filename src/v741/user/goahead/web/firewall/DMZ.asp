<html>
<head>
<title><% getModelName(); %> Management</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate_celot.min.js"></script>
<script type="text/javascript" src="/menu/menu.js"></script>

<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("firewall");

var superdmzbuilt = "<% getSuperDMZBuilt(); %>";

var dmz_enable = "<% getCfgGeneral(1, "DMZEnable"); %>";
var dmz_address = "<% getCfgGeneral(1, "DMZAddress"); %>";
var dmz_tcpport80 = "<% getCfgGeneral(1, "DMZAvoidTCPPort80"); %>";

$(document).ready(function(){ 
	initTranslation();
	init(); 

	var validateRule = $("#DMZ").validate({
		rules: {
			DMZAddress: {
				required : function() {
					var dmzEnable = $("#DMZEnabled").val();
					if(dmzEnable=="1" ||dmzEnable=="2") return true;
					return false;
				},
				IP4Checker : 	{
					depends: function() { 
						var dmzEnable = $("#DMZEnabled").val();
						if(dmzEnable=="1") return true;
						return false;
					}
				},
				MACChecker :	{
					depends: function() { 
						var dmzEnable = $("#DMZEnabled").val();
						if(dmzEnable=="2") return true;
						return false;
					}
				}
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
			if (this.numberOfInvalids()) {
				return;
			} else {
				$("div.error[name=add] span").hide();
				document.DMZ.DMZTCPPort80.value = document.DMZ.DMZTCPPort80.checked ? "1": "0";
				form.submit();
			}
		}
	});

	$('#dmzReset').click(function() { 
		validateRule.resetForm(); 
		$("div.error[name=add] span").hide();
		init();
	});

	$('#DMZEnabled').change(function() { 
		selectChange();
		validateRule.resetForm(); 
		$("div.error[name=add] span").hide();
	});
});


function checkRange(str, num, min, max)
{
	d = atoi(str,num);
	if(d > max || d < min)
		return false;
	return true;
}

function atoi(str, num)
{
	i=1;
	if(num != 1 ){
		while (i != num && str.length != 0){
			if(str.charAt(0) == '.'){
				i++;
			}
			str = str.substring(1);
		}
	  	if(i != num )
			return -1;
	}
	
	for(i=0; i<str.length; i++){
		if(str.charAt(i) == '.'){
			str = str.substring(0, i);
			break;
		}
	}
	if(str.length == 0)
		return -1;
	return parseInt(str, 10);
}

function isAllNum(str)
{
	for (var i=0; i<str.length; i++) {
		if ((str.charAt(i) >= '0' && str.charAt(i) <= '9') || (str.charAt(i) == '.' ))
			continue;
		return 0;
	}
	return 1;
}

function checkIPAddr(value)
{
	if(value == "") return false;
	if ( isAllNum(field.value) == 0) return false;
	
	if( (!checkRange(value,1,0,255)) ||
		(!checkRange(value,2,0,255)) ||
		(!checkRange(value,3,0,255)) ||
		(!checkRange(value,4,1,254)) ){
		return false;
	}
	return true;
}

function checkMac(str){
    var len = str.length;
    if(len!=17)
        return false;

    for (var i=0; i<str.length; i++) {
        if((i%3) == 2){
            if(str.charAt(i) == ':')
                continue;
        }else{
            if (    (str.charAt(i) >= '0' && str.charAt(i) <= '9') ||
                    (str.charAt(i) >= 'a' && str.charAt(i) <= 'f') ||
                    (str.charAt(i) >= 'A' && str.charAt(i) <= 'F') )
                continue;
        }
        return false;
    }
    return true;
}


function initTranslation()
{
	$("#dmzTitle").html(_("dmz title"));
	$("#dmzIntroduction").html(_("dmz introduction"));

	$("#dmzSetting").html(_("dmz setting"));
	$("#dmzSet").html(_("dmz setting"));
	$("#dmzDisable").html(_("firewall disable"));
	$("#dmzEnable").html(_("firewall enable"));
	$("#superdmzEnable").html(_("firewall enable")+"(SuperDMZ)");
	$("#dmzTCPPort80Str").html(_("dmz tcpport80"));
	$("#dmzApply").val(_("firewall apply"));
	$("#dmzReset").val(_("firewall cancel"));
}

function init()
{
	document.DMZ.DMZTCPPort80.checked = false;
	document.DMZ.DMZTCPPort80.value = "0";
	if(dmz_enable == "0"){
		document.DMZ.DMZEnabled.options.selectedIndex = 0;
		$("#DMZAddress").attr("disabled",true);
		$("#DMZTCPPort80").attr("disabled",true);
		
		$("#dmz_ipaddr").hide();
		$("#dmz_port80").hide();
	}
	else
	{
		$("#DMZAddress").attr("disabled",false);
		$("#DMZTCPPort80").attr("disabled",false);
		$("#dmz_ipaddr").show();
		$("#dmz_port80").show();
		
		document.DMZ.DMZAddress.value = dmz_address;

		if(dmz_enable == "1"){
			document.DMZ.DMZEnabled.options.selectedIndex = 1;
			$("#dmzAddr").html(_("dmz ipaddr"));
		}else if(dmz_enable == "2"){
			document.DMZ.DMZEnabled.options.selectedIndex = 2;
			$("#dmzAddr").html(_("dmz macaddr"));
		}	
		
		if(dmz_tcpport80 != "" &&dmz_tcpport80 != "0"){
			document.DMZ.DMZTCPPort80.value = "1";
			document.DMZ.DMZTCPPort80.checked = true;
		}
	}

	if(superdmzbuilt != "1")
		document.DMZ.DMZEnabled.options[2] = null;
}

function selectChange()
{
	document.DMZ.DMZAddress.value = "";
	if(document.DMZ.DMZEnabled.options.selectedIndex == 0){
		$("#DMZAddress").attr("disabled",true);
		$("#DMZTCPPort80").attr("disabled",true);

		$("#dmz_ipaddr").hide();
		$("#dmz_port80").hide();
		
	}
	else
	{
		$("#DMZAddress").attr("disabled",false);
		$("#DMZTCPPort80").attr("disabled",false);

		$("#dmz_ipaddr").show();
		$("#dmz_port80").show();

		if(document.DMZ.DMZEnabled.options.selectedIndex == 1){
			if(checkIPAddr(dmz_address)) document.DMZ.DMZAddress.value = dmz_address; 
			$("#dmzAddr").html(_("dmz ipaddr"));
		}else if(document.DMZ.DMZEnabled.options.selectedIndex == 2){
			$("#dmzAddr").html(_("dmz macaddr"));
			if(checkMac(dmz_address)) document.DMZ.DMZAddress.value = dmz_address; 
		}
	}
}
</script>
</head>


<!--     body      -->
<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("DMZ.asp"); </script>

	<h1 id="dmzTitle"> DMZ Settings </h1>
	<div align="left">
	&nbsp;&nbsp; <font id = "dmzIntroduction"> You may setup a De-militarized Zone(DMZ) to separate internal network and Internet.</font> 
	</div>
	<div id = "blank"> </div>


	<form method=post name="DMZ"  id="DMZ" action=/goform/DMZ>
	<table>
	<caption id = "dmzSetting">DMZ Settings</caption>
	<tr>
		<th id="dmzSet"> DMZ Settings </th>
		<td>
			<select name="DMZEnabled" id="DMZEnabled" size="1">
			<option value=0 id="dmzDisable">Disable DMZ</option>
			<option value=1 id="dmzEnable">Enable DMZ</option>
			<option value=2 id="superdmzEnable">Enable SuperDMZ</option>
		</td>
	</tr>

	<tr id = "dmz_ipaddr">
		<th id="dmzAddr"> DMZ IP/MAC Address </th>
		<td>
	  		<input type="text" size="24" name="DMZAddress" id="DMZAddress" >
		</td>
	</tr>
	
	<tr id = "dmz_port80">
		<th id="dmzTCPPort80Str"> </th>
		<td>
	  		<input type=checkbox name="DMZTCPPort80" id="DMZTCPPort80" value="0">
		</td>
	</tr>
	</table>
	
	<div id = "blank" class="error" name="add" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "dmzApply" name="addDMZ">
	<input class = "btn" type = "button" value = "Reset" id = "dmzReset"  name="reset">
	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>
