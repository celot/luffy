<html>
<head>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<META http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="/lang/b28n.js"></script>
<link rel="stylesheet" href="/style/normal_ws.css" type="text/css">

<title>Ralink Wireless Station Site Survey</title>
<script language="JavaScript" type="text/javascript">
<% loadDefaultCfg(); %>
Butterlate.setTextDomain("wireless");


function initTranslation()
{
}

function PageInit()
{
	initTranslation();
}
</script>
</head>


<body onload="PageInit()">
<table class="body"><tr><td>

<h1 id="scanTitle">Station Site Survey</h1>
<p id="scanIntroduction">Site survey page shows information of APs nearby. You may choose one of these APs connecting or adding it to profile.</p>
<hr />

<form method=post name="sta_site_survey">
<table width="540" border="1" cellpadding="2" cellspacing="1">
  <tr>
    <td class="title" colspan="8" id="scanSiteSurvey">Site Survey</td>
  </tr>
  <tr>
    <td bgcolor="#E8F8FF" id="scanSelect">&nbsp;</td>
    <td bgcolor="#E8F8FF" id="scanSSID">SSID</td>
    <td bgcolor="#E8F8FF" id="scanBSSID">BSSID</td>
    <td bgcolor="#E8F8FF" id="scanRSSI">RSSI</td>
    <td bgcolor="#E8F8FF" id="scanChannel">Channel</td>
    <td bgcolor="#E8F8FF" id="scanEncryp">Encryption</td>
    <td bgcolor="#E8F8FF" id="scanAuth">Authentication</td>
    <td bgcolor="#E8F8FF" id="scanNetType">Network Type</td>
  </tr>
  <% getAPList(); %>

</table>
</form>


</td></tr></table>
</body>
</html>

