<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>WiFi認証ページ</title>

    <style type="text/css" media="screen">
		* {
		    margin: 0px 0px 0px 0px;
		    padding: 0px 0px 0px 0px;
		}

		body, html {
		    padding: 3px 3px 3px 3px;

		    background-color: #D8DBE2;

		    font-family: Verdana, sans-serif;
		    font-size: 11pt;
		    text-align: center;
		}

		div.main_page {
		    position: relative;
		    display: table;

		    width: 800px;

		    margin-bottom: 3px;
		    margin-left: auto;
		    margin-right: auto;
		    padding: 0px 0px 0px 0px;

		    border-width: 2px;
		    border-color: #212738;
		    border-style: solid;

		    background-color: #FFFFFF;

		    text-align: center;
		}

		div.page_header {
		    height: 99px;
		    width: 100%;

		    background-color: #F5F6F7;
		}

		div.page_header span {
		    margin: 15px 0px 0px 50px;

		    font-size: 180%;
		    font-weight: bold;
		}

		div.page_header img {
		    margin: 3px 0px 0px 40px;

		    border: 0px 0px 0px;
		}

		div.table_of_contents {
		    clear: left;

		    min-width: 200px;

		    margin: 3px 3px 3px 3px;

		    background-color: #FFFFFF;

		    text-align: left;
		}

		div.table_of_contents_item {
		    clear: left;

		    width: 100%;

		    margin: 4px 0px 0px 0px;

		    background-color: #FFFFFF;

		    color: #000000;
		    text-align: left;
		}

		div.table_of_contents_item a {
		    margin: 6px 0px 0px 6px;
		}

		div.content_section {
		    margin: 3px 3px 3px 3px;

		    background-color: #FFFFFF;

		    text-align: left;
    		    width: 97%;
		}

		div.content_section_text {
		    padding: 4px 8px 4px 8px;

		    color: #000000;
		    font-size: 100%;
		}

		div.content_section_text pre {
		    margin: 8px 0px 8px 0px;
		    padding: 8px 8px 8px 8px;

		    border-width: 1px;
		    border-style: dotted;
		    border-color: #000000;

		    background-color: #F5F6F7;

		    font-style: italic;
		    height: 360px;
		}

		div.content_section_text p {
		    margin-bottom: 6px;
		}

		div.content_section_text ul, div.content_section_text li {
		    padding: 4px 8px 4px 16px;
		}

		div.section_header {
		    padding: 3px 6px 3px 6px;

		    background-color: #8E9CB2;

		    color: #FFFFFF;
		    font-weight: bold;
		    font-size: 112%;
		    text-align: center;
		}

		div.section_header_red {
		    background-color: #CD214F;
		}

		div.section_header_grey {
		    background-color: #9F9386;
		}

		.floating_element {
		    position: relative;
		    float: left;
		}

		div.table_of_contents_item a,
		div.content_section_text a {
		    text-decoration: none;
		    font-weight: bold;
		}

		div.table_of_contents_item a:link,
		div.table_of_contents_item a:visited,
		div.table_of_contents_item a:active {
		    color: #000000;
		}

		div.table_of_contents_item a:hover {
		    background-color: #000000;

		    color: #FFFFFF;
		}

		div.content_section_text a:link,
		div.content_section_text a:visited,
		div.content_section_text a:active {
		    background-color: #DCDFE6;

		    color: #000000;
		}

		div.content_section_text a:hover {
		    background-color: #000000;

		    color: #DCDFE6;
		}

		div.validator {
		}
	</style>
</head>

<script language = "JavaScript" type = "text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("wireless");

$(document).ready(function(){ 
	initTranslation();
	initValue(); 

	
});	

function initTranslation()
{
}

function initValue()
{
}

function style_display_on()
{
	if (window.ActiveXObject)
	{ // IE
		return "block";
	}
	else if (window.XMLHttpRequest)
	{ // Mozilla, Safari,...
		return "table-row";
	}
}

var gUserUrl = "http://www.google.com";
var gTimeOut = "86400";

function parseURI()
{
	var userurl;
	var timeout;
	var res;
	var query = window.location.search.substring(1);

	var vars = query.split("&");

	for (var i=0;i<vars.length;i++) {
		var pair = vars[i].split("=");
		
		if(pair[0] == "res")
		{	
			res = pair[1];
		}
		else if(pair[0] == "timeout")
		{	
			timeout = pair[1];
			gTimeOut = timeout;
		}
		else if(pair[0] == "userurl")
		{
			userurl = decodeURIComponent(pair[1]);
			gUserUrl = userurl;
		}
		
	}

	if(res == "notyet")
	{
	}	
	else if(res == "success")
	{
		window.location.href=userurl;

	}
	else if(res == "logoff")
	{
		window.location.href="http://192.168.182.1/chilli/logoff.asp";
	}
	else
	{
	}
	
}

function gotoLoginPage()
{
	var url;
	var hotspotTimeOut = '<% getCfgZero(1, "hotspotTimeOut"); %>';
	var hotspotDefaultUrl = '<% getCfgZero(1, "hotspotDefaultUrl"); %>';
	
	var logSend = "<% loginHotSpot(); %>"; 

	if(hotspotTimeOut.length < 2)
		hotspotTimeOut=gTimeOut;
	
	if(hotspotDefaultUrl.length < 2)
		hotspotDefaultUrl=gUserUrl;
	
		
	url="http://192.168.182.1:3990/logon?timeout=";
	url+=hotspotTimeOut;
	url+="&userurl=";
	url+=hotspotDefaultUrl;
	
	window.location.href=url;
}

</script>

<body onload=parseURI()>
	<br>
	<div id="login_page_div">

		<div class="main_page">
			<br>
			<div class="page_header floating_element">
	        		<img src="./img_logo.png" alt="Logo" class="floating_element"/ width=120 height=60>
			        <span class="floating_element">
			          	WiFi Hotspot Authorization Page
			        </span>
			</div>


			<div class="content_section floating_element">
				<!--
				<div class="section_header section_header_red">
	          			<div id="about"></div>
					It works!
				</div>
				-->
	        		<div class="content_section_text">
			                <p>
			                	WiFi Hotspot Zoneへようこそ。「インターネットの使用に同意」ボタンをクリックして、インターネットを使用してください
			                	<!--
				                This is the default welcome page used to WiFi Hotspot.
				                Enjoy your internet after click "Go to the internet" button.
				                -->
			                </p>
			                <br>
				</div>
				
				<div class="section_header">
					<div id="changes"></div>
					広告ページ
				</div>

				<div class="content_section_text">
					<p>
					例の広告ページです。
					</p>

					<pre>
						例の広告ページです。
						<!--
						<iframe src="<% getCfgZero(1, "hotspotAdvUrl"); %>" frameborder=0 width=750 height=450 align=left allowtransparency="true"></iframe>
						-->
					</pre>

				</div>

				
			</div>
		</div>	
		
		<input type="button"  style="width: 200px; height: 50px" name="btnLogin"  id="btnLogin" value="インターネットの使用に同意" onClick="gotoLoginPage();"> 

	</div>
	
	<!--
	<div id="loading_page_div">
		<center>
		<h1 id="hotspotLoading"> Loading ..</h1>
		</center>
	</div>
	-->


</body>
</html>	

