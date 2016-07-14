<html>
<head>
<title><% getModelName(); %> Management</title>
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

var webUrlFilterLength = <% getWebUrlFilterLengthASP(); %>;
var webHostFilterLength = <% getWebHostFilterLengthASP(); %>;
var MAX_LENGTH = 1024;

var URLFilterNum = 0;
var HostFilterNum = 0;

$(document).ready(function(){ 
	initTranslation();
	initWebContents();
	initFilterTables();

	var validateWebContent = $("#websURLFilter").validate({
		rules: {
			addURLFilter: {
				required : true,
				maxString : {	param : 32 }
			}
		},
		
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addWebHost] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addWebHost] span").show();
			} else {
				$("div.error[name=addWebHost] span").hide();
			}
		},

		submitHandler :function(form){
			if(this.numberOfInvalids())
			{
				return;
			}
			else
			{
				var checkLength = webUrlFilterLength + document.websURLFilter.addURLFilter.value.length;
				if (checkLength >= MAX_LENGTH -2)
				{
					$("div.error[name=addWebHost] span").html(_("alert can not add"));
					$("div.error[name=addWebHost] span").show();
					return;
				}
				
				$("div.error[name=addWebHost] span").hide();
				form.submit();
			}
		}
	});

	var validateWebHost = $("#websHostFilter").validate({
		rules: {
			addHostFilter: {
				required : true,
				maxString : {	param : 32 }
			}
		},
		
		invalidHandler: function(event, validator) {
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addHostFilter] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addHostFilter] span").show();
			} else {
				$("div.error[name=addHostFilter] span").hide();
			}
		},

		submitHandler :function(form){
			if(this.numberOfInvalids())
			{
				return;
			}
			else
			{
				var checkLength = webHostFilterLength + document.websHostFilter.addHostFilter.value.length;
				if (checkLength >= MAX_LENGTH -2)
				{
					$("div.error[name=addHostFilter] span").html(_("alert can not add"));
					$("div.error[name=addHostFilter] span").show();
					return;
				}
				
				$("div.error[name=addHostFilter] span").hide();
				form.submit();
			}
		}
	});

	$("table[name=tableWebsURLFilterDelete] tr td").width(function(index) {
		if(index%3==0) return 50; 
		else if(index%3==1) return 160; 
		else return 368;
	});

	$("table[name=tableWebsURLFilterDelete]").createScrollableTable();
	

	$("form[name=websURLFilterDelete] input:checkbox[name^=DR]").bind('click', function() {
		$("div.error[name=delWebContent] span").hide();
	});

	$('#WebURLFilterReset').click(function() { 
		$("div.error[name=delWebContent] span").hide();
		initWebContents();
	});

	$('#addUrlDomain').change(function() { 
		validateWebContent.resetForm(); 
		$("div.error[name=addWebHost] span").hide();
	});

	$('#WebURLFilterAddReset').click(function() { 
		validateWebContent.resetForm(); 
		$("div.error[name=addWebHost] span").hide();
	});

	
	$("table[name=tableWebsHostFilterDelete] tr td").width(function(index) {
		if(index%3==0) return 50; 
		if(index%3==1) return 160; 
		else return 368;
	});
	$("table[name=tableWebsHostFilterDelete]").createScrollableTable();

	$("form[name=websHostFilterDelete] input:checkbox[name^=DR]").bind('click', function() {
		$("div.error[name=delWebHost] span").hide();
	});

	$('#WebsHostFilterReset').click(function() { 
		$("div.error[name=delWebHost] span").hide();
	});

	$('#addHostDomain').change(function() { 
		validateWebHost.resetForm(); 
		$("div.error[name=addHostFilter] span").hide();
	});

	$('#WebsHostFilterAddReset').click(function() { 
		validateWebHost.resetForm(); 
		$("div.error[name=addHostFilter] span").hide();
	});
});

function deleteClick()
{
    return true;
}

function formCheck()
{
	if((document.webContentFilter.websFilterProxy.value != "1")&&
		(document.webContentFilter.websFilterJava.value != "1")&&
		(document.webContentFilter.websFilterActivex.value != "1"))
	{
    		return false;
	}
	
   return true;
}

function initTranslation()
{
	$("#ContentFilterTitle").html(_("content filter title"));
	$("#ContentFilterIntrodution").html(_("content filter introduction"));
	$("#WebsContentFilter").html(_("content filter webs content filter"));
	$("#WebsContentFilterFilter").html(_("content filter webs content filter filter"));
	$("#WebsContentFilterFilter_d2").html(_("content filter webs content filter filter_d2"));
	$("#WebsContentFilterApply").val(_("content filter webs content filter apply"));
	$("#WebsContentFilterReset").val(_("firewall reset"));
	$("#WebURLFilterTitle").html(_("content filter webs URL filter title"));
	$("#WebURLFilterCurrent").html(_("content filter webs url filter current"));
	$("#WebURLFilterNo").html(_("content filter webs url fitler No"));
	$("#WebURLFilterInterface").html(_("port filter interface"));
	$("#WebURLFilterURL").html(_("content filter webs url fitler url"));
	$("#WebURLFilterDel").val(_("content filter webs url fitler del"));
	$("#WebURLFilterReset").val(_("content filter webs url fitler reset"));
	$("#WebURLFilterAddTitle").html(_("content filter webs url fitler add title"));
	$("#WebURLFilterAdd").val(_("content filter webs url fitler add"));
	$("#WebURLFilterAddReset").val(_("content filter webs url fitler reset"));
	$("#WebsHostFilterTitle").html(_("content filter webs host fitler title"));
	$("#WebsHostFilterCurrent").html(_("content filter webs host fitler current"));
	$("#WebsHostFilterNo").html(_("content filter webs host fitler no"));
	$("#WebsHostFilterInterface").html(_("port filter interface"));
	$("#WebsHostFilterHost").html(_("content filter webs host fitler host"));
	$("#WebsHostFilterDel").val(_("content filter webs host fitler del"));
	$("#WebsHostFilterReset").val(_("content filter webs host fitler reset"));
	$("#WebsHostFilterAddTitle").html(_("content filter webs host fitler add title"));
	$("#WebsHostFilterKeyword").html(_("content filter webs host fitler keyword"));
	$("#WebsHostFilterAdd").val(_("content filter webs host fitler add"));
	$("#WebsHostFilterAddReset").val(_("content filter webs host fitler reset"));

	$("#thAddUrlDomain").html(_("port filter interface"));
	$("#addUrlWWAN1").html(_("port filter wwan1"));
	$("#addUrlWWAN2").html(_("port filter wwan2"));
	$("#thAddHostDomain").html(_("port filter interface"));
	$("#addHostWWAN1").html(_("port filter wwan1"));
	$("#addHostWWAN2").html(_("port filter wwan2"));

}

function initWebContents()
{
	var wfp = "<% getCfgZero(1, "websFilterProxy"); %>";
	var wfj = "<% getCfgZero(1, "websFilterJava"); %>";
	var wfa = "<% getCfgZero(1, "websFilterActivex"); %>";
	var wfp2 = "<% getCfgZero(1, "websFilterProxy_d2"); %>";
	var wfj2 = "<% getCfgZero(1, "websFilterJava_d2"); %>";
	var wfa2 = "<% getCfgZero(1, "websFilterActivex_d2"); %>";

	$("[name=websFilterProxy]").val(wfp); $("[name=websFilterProxy]").attr("checked", wfp==1); 
	$("[name=websFilterJava]").val(wfj); $("[name=websFilterJava]").attr("checked", wfj==1);
	$("[name=websFilterActivex]").val(wfa); $("[name=websFilterActivex]").attr("checked", wfa==1);

	$("[name=websFilterProxy_d2]").val(wfp2); $("[name=websFilterProxy_d2]").attr("checked", wfp2==1);
	$("[name=websFilterJava_d2]").val(wfj2); $("[name=websFilterJava_d2]").attr("checked", wfj2==1);
	$("[name=websFilterActivex_d2]").val(wfa2); $("[name=websFilterActivex_d2]").attr("checked", wfa2==1);
}

function initFilterTables()
{
	if(webUrlFilterLength==0) $("#divWebURLFilter").hide();
	if(webHostFilterLength==0) $("#divWebsHostFilterDelete").hide();
}

function webContentFilterClick()
{
	$("[name=websFilterProxy]").val($("[name=websFilterProxy]").is(":checked")?1:0);
	$("[name=websFilterJava]").val($("[name=websFilterJava]").is(":checked")?1:0);
	$("[name=websFilterActivex]").val($("[name=websFilterActivex]").is(":checked")?1:0);
	$("[name=websFilterProxy_d2]").val($("[name=websFilterProxy_d2]").is(":checked")?1:0);
	$("[name=websFilterJava_d2]").val($("[name=websFilterJava_d2]").is(":checked")?1:0);
	$("[name=websFilterActivex_d2]").val($("[name=websFilterActivex_d2]").is(":checked")?1:0);
	
	return true;
}

function deleteWebsURLClick()
{
	for(i=0; i< URLFilterNum; i++){
		var tmp = eval("document.websURLFilterDelete.DR"+i);
		if(tmp.checked == true)
			return true;
	}
	
	$("div.error[name=delWebContent] span").html(_("alert select rule to be delete"));
	$("div.error[name=delWebContent] span").show();
	return false;
}

function deleteWebsHostClick()
{
	for(i=0; i< HostFilterNum; i++){
		var tmp = eval("document.websHostFilterDelete.DR"+i);
		if(tmp.checked == true)
			return true;
	}
	$("div.error[name=delWebHost] span").html(_("alert select rule to be delete"));
	$("div.error[name=delWebHost] span").show();
	return false;
}

</script>
</head>

<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("content_filtering.asp"); </script>

	<h1 id="ContentFilterTitle">Content Filter  Settings </h1>
	<% checkIfUnderBridgeModeASP(); %>
	<div align="left">
	&nbsp;&nbsp; <font id = "ContentFilterIntrodution"> </font> 
	</div>
	<div id = "blank"> </div>

	<form method=post name="webContentFilter" action=/goform/webContentFilter>
	<table>
	<caption id = "WebsContentFilter">Webs Content Filter</caption>
	<tr>
		<th  id="WebsContentFilterFilter"> Filter: </th>
		<td>
			<input type=checkbox name=websFilterProxy id="filterProxy" value=0 > <label for="filterProxy"> Proxy </label>
			<input type=checkbox name=websFilterJava id="filterJava" value=0 > <label for="filterJava"> Java </label>
			<input type=checkbox name=websFilterActivex id="filterActiveX" value=0 > <label for="filterActiveX"> ActiveX </label>
		</td>
	</tr>
	<tr>
		<th  id="WebsContentFilterFilter_d2"> Filter: WWAN2 </th>
		<td>
			<input type=checkbox name=websFilterProxy_d2 id="filterProxy_d2"  value=0 > <label for="filterProxy_d2"> Proxy </label>
			<input type=checkbox name=websFilterJava_d2 id="filterJava_d2" value=0 > <label for="filterJava_d2"> Java </label>
			<input type=checkbox name=websFilterActivex_d2 id="filterActiveX_d2" value=0 > <label for="filterActiveX_d2"> ActiveX </label>
		</td>
	</tr>
	</table>
	
	<div id = "blank" class="error" name="addWebContent" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "WebsContentFilterApply" name="addFilterPort" onClick=" return webContentFilterClick()">
	<input class = "btn" type = "button" value = "Reset" id = "WebsContentFilterReset"  name="reset" onClick="initWebContents();">
	</form>

	<div id = "blank"> </div>

	<h1 id="WebURLFilterTitle">Webs URL Filter Settings </h1>
	<div id="divWebURLFilter">
	<form action=/goform/websURLFilterDelete method=POST name="websURLFilterDelete">
	<table name="tableWebsURLFilterDelete">	
	<caption id = "WebURLFilterCurrent">Current Webs URL Filters:</caption>
	<thead>
	<tr>
		<td bgcolor=#E8F8FF  id="WebURLFilterNo"> No.</td>
		<td bgcolor=#E8F8FF id="WebURLFilterInterface"> Interface</td>
		<td bgcolor=#E8F8FF id="WebURLFilterURL"> URL</td>
	</tr>
	</thead>
	<tbody>
	<script language="JavaScript" type="text/javascript">
	var i;
	var entries = new Array();
	var fields = new Array();
	var all_str = "<% getCfgGeneral(1, "websURLFilters"); %>";

	if(all_str.length)
	{
		entries = all_str.split(";");
		for(i=0; i<entries.length; i++)
		{
			fields = entries[i].split(",");
			if(fields.length ==2)
			{
				document.write("<tr><td>");
				document.write(i+1);
				document.write("<input type=checkbox name=DR"+i+"></td>");

				if (fields[1] == "WWAN1") fields[1] = _("port filter wwan1");
				else if (fields[1] == "WWAN2") fields[1] = _("port filter wwan2");

				document.write("<td>"+ fields[1] +"</td>");
				document.write("<td>"+ fields[0] +"</td>");				
				document.write("</tr>\n");
			}
		}

		URLFilterNum = entries.length;
	}
	</script>
	</tbody>
	</table>

	<div id = "blank" class="error" name="delWebContent" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Delete" id = "WebURLFilterDel" name="deleteSelPortForward" onClick=" return deleteWebsURLClick()">
	<input class = "btn" type = "reset" value = "Reset" id = "WebURLFilterReset"  name="reset" >
	</form>
	<div id = "blank"> </div>
	</div>

	<form action=/goform/websURLFilter method=POST name="websURLFilter" id="websURLFilter">
	<table>	
	<caption id = "WebURLFilterAddTitle">Add a URL Filter: </caption>
	<tr id="trAddUrlDomain">
		<th  id="thAddUrlDomain"> Interface </th>
		<td>
			<select  id="addUrlDomain" name="addUrlDomain" size="1">
			<option value="WWAN1" id="addUrlWWAN1">WWAN1</option>
			<option value="WWAN2" id="addUrlWWAN2">WWAN2</option>
			<option value="ALL" id="addUrlAll">ALL</option>
			</select>
		</td>
	</tr>
	<tr>
		<th>URL: </th>
		<td> <input name="addURLFilter" id="addURLFilter" size="32" maxlength="32" type="text"> </td>
	</tr>
	</table>

	<div id = "blank" class="error" name="addWebHost" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Add" id = "WebURLFilterAdd" name="addwebsurlfilter">
	<input class = "btn" type = "reset" value = "Reset" id = "WebURLFilterAddReset"  name="reset" >
	</form>
	
	<div id = "blank"> </div>
	
	<h1 id="WebsHostFilterTitle">Webs Host Filter Settings </h1>
	<div id="divWebsHostFilterDelete">
	<form action=/goform/websHostFilterDelete method=POST name="websHostFilterDelete">
	<table name="tableWebsHostFilterDelete">	
	<caption id = "WebsHostFilterCurrent">Current Website Host Filters: </caption>
	<thead>
	<tr>
		<td class=th bgcolor=#E8F8FF id="WebsHostFilterNo"> No.</td>
		<td bgcolor=#E8F8FF id="WebsHostFilterInterface"> Interface</td>
		<td bgcolor=#E8F8FF id="WebsHostFilterHost"> Host(Keyword)</td>
	</tr>
	</thead>
	<tbody>
	<script language="JavaScript" type="text/javascript">
	var i;
	var entries = new Array();
	var fields = new Array();
	var all_str = "<% getCfgGeneral(1, "websHostFilters"); %>";

	if(all_str.length)
	{
		entries = all_str.split(";");

		for(i=0; i<entries.length; i++)
		{
			fields = entries[i].split(",");
			if(fields.length ==2)
			{
				document.write("<tr><td>");
				document.write(i+1);
				document.write("<input type=checkbox name=DR"+i+"></td>");

				if (fields[1] == "WWAN1") fields[1] = _("port filter wwan1");
				else if (fields[1] == "WWAN2") fields[1] = _("port filter wwan2");

				document.write("<td>"+ fields[1] +"</td>");
				document.write("<td>"+ fields[0] +"</td>");
				document.write("</tr>\n");
			}
		}

		HostFilterNum = entries.length;
	}
	</script>
	</tbody>
	</table>

	<div id = "blank" class="error" name="delWebHost" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Delete" id = "WebsHostFilterDel" name="deleteSelPortForward" onClick=" return deleteWebsHostClick()">
	<input class = "btn" type = "reset" value = "Reset" id = "WebsHostFilterReset"  name="reset" >
	</form>
	<div id = "blank"> </div>
	</div>

	<form action=/goform/websHostFilter method=POST name="websHostFilter" id="websHostFilter">

	<table>	
	<caption id = "WebsHostFilterAddTitle">Add a Host(keyword) Filter: </caption>
	<tr id="trAddHostDomain">
		<th  id="thAddHostDomain"> Interface </th>
		<td>
			<select  id="addHostDomain" name="addHostDomain" size="1">
			<option value="WWAN1" id="addHostWWAN1">WWAN1</option>
			<option value="WWAN2" id="addHostWWAN2">WWAN2</option>
			<option value="ALL" id="addHostAll">ALL</option>
			</select>
		</td>
	</tr>
	<tr>
		<th id="WebsHostFilterKeyword">Keyword: </th>
		<td> <input name="addHostFilter" id = "addHostFilter" size="32" maxlength="32" type="text"> </td>
	</tr>
	</table>

	<div id = "blank" class="error" name="addHostFilter" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Add" id = "WebsHostFilterAdd" name="addwebscontentfilter">
	<input class = "btn" type = "reset" value = "Reset" id = "WebsHostFilterAddReset"  name="reset" >
	</form>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>

</html>
