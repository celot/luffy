<html>
<head>
<title><% getModelName(); %> Management</title>
<meta http-equiv="Content-type" content="text/html" charset="UTF-8">
<meta http-equiv="Cache-Control" content="No-Cache"><meta http-equiv="Pragma" content="No-Cache">
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">
<script type="text/javascript" src="/lang/b28n.js"></script>

<script type="text/javascript" src="/menu/menu.js"></script>
</head>

<script language = "JavaScript" type = "text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("main");

function initTranslation()
{
	var e = document.getElementById("titleSaving");
	e.innerHTML = _("main save title");
	e = document.getElementById("configSaved");
	e.innerHTML = _("main save saved");
	e = document.getElementById("waiting");
	e.innerHTML = _("main save waiting");
	e = document.getElementById("waitSec");
	e.innerHTML = _("main save sec");
}

function initHiddenFrame()
{
	var parse_location = "";
	var retPageTmp="";
	var val2="";
	parse_location = parse_location + this.location;
	parse_location = parse_location.split("?");
	parse_location = parse_location[parse_location.length -1];

	initTranslation();

	arr = parse_location.split("&");
	arr_length = arr.length;

	for(i=0; i<arr_length; i++)
	{
		arr[i] = arr[i].split("=");
	}

	if(arr_length >= 1)
	{
		retPageTmp = arr[0][1];
	}
	if(arr_length >= 2)
	{
		val2 = arr[1][1];
	}

	if(retPageTmp)
	{
		switch(retPageTmp) 
		{
			case 'config.asp': 
				try
				{
					if(arr[1][0] == "restart")
					{
						if(arr[1][1] == "1") hidden_frame.location.href="/goform/apply_wwan"; 
					}
					else if(arr[1][0] == "result") 
					{
						var e = document.getElementById("waiting");
						e.innerHTML = "Modem  "+arr[1][1].replace(/%20/g," ");
					}
				}
				catch(ex){}
				break;
		}
	}
}

var counter= 40;
var retPage="home.asp";
var returnPage="/home.asp";
function initValue()
{
	var parse_location = "";
	
	parse_location = parse_location + this.location;
	parse_location = parse_location.split("?");
	parse_location = parse_location[parse_location.length -1];

	arr = parse_location.split("&");
	arr_length = arr.length;

	for(i=0; i<arr_length; i++)
	{
		arr[i] = arr[i].split("=");
	}

	if(arr_length >= 1)
	{
		retPage = arr[0][1];
		returnPage = "/mobile/"+retPage;
	}
	
	for(i=0; i<arr_length; i++)
	{
		if(arr[i][0]=="pageNo")
		{
			returnPage = "/mobile/"+retPage+"?page="+arr[i][1];
		}
	}

	if(retPage)
	{
		switch(retPage) 
		{
			case 'config.asp': 
				try
				{
					counter= 5;
					if((arr[1][0] == "restart") && (arr[1][1] == "1")) counter= 25;
				}
				catch(e){}
				break;
		}
	}

	ID = window.setTimeout("Update();", 1000);
}

function Update()
{
	counter--;
	if(counter < 0)	counter = 0;
	document.save.time_left.value = counter;

	if(counter <= 0)
	{
		window.location.href=returnPage;
	}
	else
	{
		ID = window.setTimeout("Update();", 1000);
	}
}
</script>

<body onload="initHiddenFrame()">
<script language = "JavaScript" type = "text/javascript"> initValue();printContentHead(retPage); </script>
	<H1 id="titleSaving">Recongfiguration</H1>
	
	<form name="save" method="post">
	<div id="wizard_main">
	<div id="wizard_start"></div>
	<div id="wizard_body">
		<div id = "blank"></div>
		<div id = "blank"></div>
		<p>&nbsp;&nbsp;<font id="configSaved"> New settings are saved.</font></p>
		<div id = "blank"></div>
		<p align="center">&nbsp;&nbsp;&nbsp;
		<font id="waiting">Please wait...</font>
		<div id = "blank"></div>
		<input class="noboard" type="text" style="width:20px;" name="time_left" readonly><font id="waitSec">secs</font> 
		</p>
		<div id = "blank"></div>
		<div id = "blank"></div>
		<div id = "blank"></div>
	</div>
	<div id="wizard_end"></div>
	</div>
	</form>
	<iframe name="hidden_frame" style="display:none"></iframe>
	
<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>


