<html>
<head>
<title><% getModelName(); %> Management</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta http-equiv="pragma" content="no-cache">
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

var MAX_RULES = 32;
var rules_num = <% getPortForwardRuleNumsASP(); %> ;
var rules_num_singleport = <% getSinglePortForwardRuleNumsASP(); %> ;
var rules_num_snat = <% getSNatRuleNumsASP(); %> ;
var rules_num_restricted_corn_nat = <% getRestrictedCornNATRuleNumsASP(); %> ;
var port_enable = "<% getCfgGeneral(1, "PortForwardEnable"); %>";
var singleport_enable = "<% getCfgGeneral(1, "SinglePortForwardEnable"); %>";
var sNat_enable = "<% getCfgGeneral(1, "PortForwardSNatEnable"); %>";
var restrictedCornNATEnable = '<% getPortForwardRestrictedCornNATPolicyASP(); %>';

$(document).ready(function(){  
	initTranslation();
	onInit(); 

	var validatePortRule = $("#portForward").validate({
		rules: {
			ip_address: {
				required: {
					depends:function(){
						return ($("#portForwardEnabled").val()=="1"
							&&($("#fromPort").val().trim()!="" 
							||$("#toPort").val().trim()!=""));  
					}
				},	
				IP4Checker : true
			},
			fromPort: {
				required: {
					depends:function(){
						return ($("#portForwardEnabled").val()=="1"
							&&($("#pf_ip_address").val().trim()!="" 
							||$("#toPort").val().trim()!=""));  
					}
				},	
				number : true,
				min : 1,
				max : function() { 
					if($("#toPort").val().length > 0) parseInt($("#toPort").val());
					else return 65535;
				}
			},
			toPort: {
				required : {
					depends:function(){
						return ($("#portForwardEnabled").val()=="1"
							&&($("#pf_ip_address").val().trim()!="" 
							||$("#fromPort").val().trim()!="" )); 
					}
				},
				number : true,
				min : function() { 
					if($("#fromPort").val().length > 0) return  parseInt($("#fromPort").val());
					else return 0;
				},
				max : 65535
			},
			comment: {
				required : {
					depends:function(){
						return ($("#portForwardEnabled").val()=="1"
							&&($("#pf_ip_address").val().trim()!="" 
							||$("#fromPort").val().trim()!=""  
							||$("#toPort").val().trim()!="")
							&& $("pf_comment").length>0);
					}
				},	
				maxString : {	param : 15 }
			}
		},
		
		invalidHandler: function(event, validator) {
			if($("#portForwardEnabled").val()=="0")
			{
				$("div.error[name=addPf] span").hide();
				return;
			}	
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addPf] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addPf] span").show();
			} else {
				$("div.error[name=addPf] span").hide();
			}
		},

		submitHandler :function(form){
			if($("#portForwardEnabled").val()=="0")
			{
				$("div.error[name=addPf] span").hide();
				form.submit();
				return;
			}
			
			if($("#portForwardEnabled").val()=="1"
				&&($("#pf_ip_address").val().trim()=="" 
				&&$("#fromPort").val().trim()==""  
				&&$("#toPort").val().trim()==""))
			{
				form.submit();
				return;	
			}
			
			if(rules_num >= (MAX_RULES) ){
				$("div.error[name=addPf] span").html(_("alert rule number exceeded")+ MAX_RULES +".");
				$("div.error[name=addPf] span").show();
			}
			else
			{
				if(this.numberOfInvalids())
				{
					return;
				}
				else
				{
					$("div.error[name=addPf] span").hide();
					form.submit();
				}
			}
		}
	});

	var validateVirtualRule = $("#singlePortForward").validate({
		rules: {
			ip_address: {
				required: {
					depends:function(){
						return ($("#singlePortForwardEnabled").val()=="1"
							&&($("#publicPort").val().trim()!="" 
							||$("#privatePort").val().trim()!=""));  
					}
				},	
				IP4Checker : true
			},
			publicPort: {
				required: {
					depends:function(){
						return ($("#singlePortForwardEnabled").val()=="1"
							&&($("#vs_ip_address").val().trim()!="" 
							||$("#privatePort").val().trim()!=""));  
					}
				},
				number: true,
				min : 1,
				max : 65535
			},
			privatePort: {
				required: {
					depends:function(){
						return ($("#singlePortForwardEnabled").val()=="1"
							&&($("#vs_ip_address").val().trim()!="" 
							||$("#publicPort").val().trim()!=""));  
					}
				},
				number: true,
				min : 1,
				max : 65535
			},
			comment: {
				required : {
					depends:function(){
						return ($("#singlePortForwardEnabled").val()=="1"
							&&($("#vs_ip_address").val().trim()!="" 
							||$("#publicPort").val().trim()!=""  
							||$("#privatePort").val().trim()!="")
							&& $("vs_comment").length>0);
					}
				},	
				maxString : {	param : 15 }
			}
		},

		invalidHandler: function(event, validator) {
			if($("#singlePortForwardEnabled").val()=="0")
			{
				$("div.error[name=addVs] span").hide();
				return;
			}
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addVs] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addVs] span").show();
			} else {
				$("div.error[name=addVs] span").hide();
			}
		},

		submitHandler :function(form){
			if($("#singlePortForwardEnabled").val()=="0")
			{
				$("div.error[name=addVs] span").hide();
				form.submit();
				return;
			}

			if($("#singlePortForwardEnabled").val()=="1"
				&&($("#vs_ip_address").val().trim()=="" 
				&&$("#publicPort").val().trim()==""  
				&&$("#privatePort").val().trim()==""))
			{
				form.submit();
				return;	
			}
			
			if(rules_num_singleport >= (MAX_RULES) ){
				$("div.error[name=addVs] span").html(_("alert rule number exceeded")+ MAX_RULES +".");
				$("div.error[name=addVs] span").show();
			}
			else
			{
				if(this.numberOfInvalids())
				{
					return;
				}
				else
				{
					$("div.error[name=addVs] span").hide();
					form.submit();
				}
			}
		}
	});


	var validateSNatRule = $("#staticNAT").validate({
		rules: {
			PortForwardSNatPbulicIPAddr: {
				required : {
					depends:function(){
						return ($("#PortForwardSNatEnable").val()=="1"
							&& $("#PortForwardSNatPrivateIPAddr").val().trim()!=""); 
					}
				},
				IP4Checker : true
			},
			PortForwardSNatPrivateIPAddr: {
				required : {
					depends:function(){
						return ($("#PortForwardSNatEnable").val()=="1"
							&& $("#PortForwardSNatPbulicIPAddr").val().trim()!=""); 
					}
				},	
				IP4Checker : true
			},
			PortForwardSNatComment: {
				required : {
					depends:function(){
						return ($("#PortForwardSNatEnable").val()=="1"
							&&($("#PortForwardSNatPrivateIPAddr").val().trim()!="" 
							||$("#PortForwardSNatPbulicIPAddr").val().trim()!="")  
							&& $("PortForwardSNatComment").length>0);
					}
				},
				maxString : {	param : 42 }
			}
		},

		invalidHandler: function(event, validator) {
			if($("#PortForwardSNatEnable").val()=="0")
			{
				$("div.error[name=addSNat] span").hide();
				form.submit();
				return;
			}
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addSNat] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addSNat] span").show();
			} else {
				$("div.error[name=addSNat] span").hide();
			}
		},

		submitHandler :function(form){
			if($("#PortForwardSNatEnable").val()=="0")
			{
				$("div.error[name=addSNat] span").hide();
				form.submit();
				return;
			}

			if($("#PortForwardSNatEnable").val()=="1"
				&&($("#PortForwardSNatPbulicIPAddr").val().trim()=="" 
				&&$("#PortForwardSNatPrivateIPAddr").val().trim()==""))  
			{
				form.submit();
				return;	
			}
			
			if(rules_num_singleport >= (MAX_RULES) ){
				$("div.error[name=addSNat] span").html(_("alert rule number exceeded")+ MAX_RULES +".");
				$("div.error[name=addSNat] span").show();
			}
			else
			{
				if(this.numberOfInvalids())
				{
					return;
				}
				else
				{
					$("div.error[name=addSNat] span").hide();
					form.submit();
				}
			}
		}
	});

	var validateRCNATlRule = $("#restrictedCornNAT").validate({
		rules: {
			fromRCNATPublicIP: {
				required : {
					depends:function(){
						return ($("#PortForwardRCNATEnable").val()=="1"
							&& $("#toRCNATPublicIP").val().trim()!=""); 
					}
				},
				IP4Checker : true
			},
			toRCNATPublicIP: {
				required : {
					depends:function(){
						return ($("#PortForwardRCNATEnable").val()=="1"
							&& $("#fromRCNATPublicIP").val().trim()!=""); 
					}
				},
				IP4Checker : true
			},
			RCNATcomment: {
				required : {
					depends:function(){
						return ($("#PortForwardRCNATEnable").val()=="1"
							&&($("#fromRCNATPublicIP").val().trim()!="" 
							||$("#toRCNATPublicIP").val().trim()!="")  
							&& $("RCNATcomment").length>0);
					}
				},
				maxString : {	param : 42 }
			}
		},

		invalidHandler: function(event, validator) {
			if($("#PortForwardRCNATEnable").val()=="0")
			{
				$("div.error[name=addRCNAT] sp an").hide();
				return;
			}
			var errors = validator.numberOfInvalids();
			if (errors) {
				$("div.error[name=addRCNAT] span").html($.tr("jquery msg invalid input"));
				$("div.error[name=addRCNAT] span").show();
			} else {
				$("div.error[name=addRCNAT] span").hide();
			}
		},

		submitHandler :function(form){
			if($("#PortForwardRCNATEnable").val()=="0")
			{
				$("div.error[name=addRCNAT] span").hide();
				form.submit();
				return;
			}
			
			if($("#PortForwardRCNATEnable").val()=="1"
				&&($("#fromRCNATPublicIP").val().trim()=="" 
				&&$("#toRCNATPublicIP").val().trim()==""))  
			{
				form.submit();
				return;	
			}
			if(rules_num_restricted_corn_nat >= (MAX_RULES) ){
				$("div.error[name=addRCNAT] span").html(_("alert rule number exceeded")+ MAX_RULES +".");
				$("div.error[name=addRCNAT] span").show();
			}
			else
			{
				if(this.numberOfInvalids())
				{
					return;
				}
				else
				{
					$("div.error[name=addRCNAT] span").hide();
					form.submit();
				}
			}
		}
	});	

	//================================================
	// Port Forward
	//================================================
	$('#portForwardEnabled').change(function() { 
		$("div.error[name=addPf] span").hide();
		validatePortRule.resetForm(); 
		updatePortForward();
	});

	$('#forwardVirtualSrvReset').click(function() { 
		validatePortRule.resetForm(); 
		$("div.error[name=addPf] span").hide();
		initPortForward();
	});
	

	$("table[name=tablePortForRules] tr td").width(function(index) {
		if(index%6==0) return 46; 
		else if(index%6==1) return 84; 
		else if(index%6==2) return 90; 
		else if(index%6==3) return 90; 
		else if(index%6==4) return 80; 
		else return 128;
	});
	$("table[name=tablePortForRules]").createScrollableTable();

	$("form[name=portForwardDelete] input:checkbox[name^=delRule]").bind('click', function() {
		$("div.error[name=delPf] span").hide();
	});

	$("form[name=portForwardDelete]").submit(function() { 
		if($("form[name=portForwardDelete] input:checkbox[name^=delRule]:checked").length==0){
			$("div.error[name=delPf] span").html(_("alert select rule to be delete"));
			$("div.error[name=delPf] span").show();
			return false;
		}
		$("div.error[name=delPf] span").hide();
		return true;
	});

	$('#forwardCurrentVirtualSrvReset').click(function() { 
		validatePortRule.resetForm(); 
		$("div.error[name=delPf] span").hide();
	});

	
	//================================================
	// Single Server Port
	//================================================
	$('#singlePortForward').change(function() { 
		$("div.error[name=addVs] span").hide();
		validateVirtualRule.resetForm(); 
		updateSinglePortForward();
	});

	$('#singlePortVirtualSrvReset').click(function() { 
		validateVirtualRule.resetForm(); 
		$("div.error[name=addVs] span").hide();
		initSinglePortForward();
	});

	$("table[name=tableSinglePortForwardDelete] tr td").width(function(index) {
		if(index%7==0) return 46; 
		else if(index%7==1) return 84; 
		else if(index%7==2) return 90; 
		else if(index%7==3) return 54; 
		else if(index%7==4) return 64; 
		else if(index%7==5) return 70; 
		else return 90;
	});
	$("table[name=tableSinglePortForwardDelete]").createScrollableTable();

	$("form[name=singlePortForwardDelete] input:checkbox[name^=delRule]").bind('click', function() {
		$("div.error[name=delVPf] span").hide();
	});
	
	$("form[name=singlePortForwardDelete]").submit(function() { 
		if($("form[name=singlePortForwardDelete] input:checkbox[name^=delRule]:checked").length==0){
			$("div.error[name=delVPf] span").html(_("alert select rule to be delete"));
			$("div.error[name=delVPf] span").show();
			return false;
		}
		$("div.error[name=delVPf] span").hide();
		return true;
	});

	$('#singlePortCurrentVirtualSrvReset').click(function() { 
		validateVirtualRule.resetForm(); 
		$("div.error[name=delVPf] span").hide();
	});

	//================================================
	// SNAT
	//================================================
	$('#PortForwardSNatEnable').change(function() { 
		$("div.error[name=addSNat] span").hide();
		validateVirtualRule.resetForm(); 
		updateStaticNat();
	});

	$('#resetSNat').click(function() { 
		validateSNatRule.resetForm(); 
		$("div.error[name=addSNat] span").hide();
		initSNat();
	});

	$("table[name=tablePortForwardSNatDelete] tr td").width(function(index) {
		if(index%5==0) return 46; 
		else if(index%5==1) return 84; 
		else if(index%5==2) return 120; 
		else if(index%5==3) return 120; 
		else return 168;
	});
	$("table[name=tablePortForwardSNatDelete]").createScrollableTable();

	$("form[name=portForwardSNatDelete] input:checkbox[name^=delRule]").bind('click', function() {
		$("div.error[name=delSNat] span").hide();
	});

	$("form[name=portForwardSNatDelete]").submit(function() { 
		if($("form[name=portForwardSNatDelete] input:checkbox[name^=delRule]:checked").length==0){
			$("div.error[name=delSNat] span").html(_("alert select rule to be delete"));
			$("div.error[name=delSNat] span").show();
			return false;
		}
		$("div.error[name=delSNat] span").hide();
		return true;
	});

	$('#singlePortSnatReset').click(function() { 
		validateSNatRule.resetForm(); 
		$("div.error[name=delSNat] span").hide();
	});

	//================================================
	// Restricted Corn Nat
	//================================================
	$('#PortForwardRCNATEnable').change(function() { 
		$("div.error[name=addRCNAT] span").hide();
		validateRCNATlRule.resetForm();
		updateRrestrictedCornNat();
	});

	$('#resetRCNAT').click(function() { 
		validateRCNATlRule.resetForm(); 
		$("div.error[name=delRCNAT] span").hide();
		initRCNat();
	});

	$("table[name=tablePortForwardRCNATDelete] tr td").width(function(index) {
		if(index%4==0) return 46; 
		else if(index%4==1) return 140; 
		else if(index%4==2) return 240; 
		else return 160;
	});
	$("table[name=tablePortForwardRCNATDelete]").createScrollableTable();

	$("form[name=portForwardRCNATDelete]").submit(function() { 
		if($("form[name=portForwardRCNATDelete] input:checkbox[name^=delRule]:checked").length==0){
			$("div.error[name=delRCNAT] span").html(_("alert select rule to be delete"));
			$("div.error[name=delRCNAT] span").show();
			return false;
		}
		$("div.error[name=delRCNAT] span").hide();
		return true;
	});
} );


function initTranslation()
{
	$("#forwardTitle").html(_("forward title"));
	$("#forwardIntroduction").html(_("forward introduction"));
		
	$("#forwardVirtualSrv").html(_("forward virtual server"));
	$("#forwardVirtualSrvSet").html(_("forward virtual server setting"));
	$("#forwardVirtualSrvDisable").html(_("firewall disable"));
	$("#forwardVirtualSrvEnable").html(_("firewall enable"));
	$("#portForwardingInterface").html(_("port forward interface"));
	$("#filterWWAN1").html(_("port filter wwan1"));
	$("#filterWWAN2").html(_("port filter wwan2"));
	$("#forwardVirtualSrvIPAddr").html(_("forward virtual server ipaddr"));
	$("#forwardVirtualSrvPortRange").html(_("forward virtual server port range"));
	$("#forwardVirtualSrvProtocol").html(_("firewall protocol"));
	$("#forwardVirtualSrvComment").html(_("firewall comment"));
	$("#maxRuleCnt").html(_("firewall max rule"));
	$("#forwardVirtualSrvApply").val(_("firewall apply"));
	$("#forwardVirtualSrvReset").val(_("firewall cancel"));

	$("#forwardCurrentVirtualSrv").html(_("forward current virtual server"));
	$("#forwardCurrentVirtualSrvNo").html(_("firewall no"));
	$("#forwardCurrentVirtualSrvInterface").html(_("port forward interface"));
	$("#forwardCurrentVirtualSrvIP").html(_("forward virtual server ipaddr"));
	$("#forwardCurrentVirtualSrvPort").html(_("forward virtual server port range"));
	$("#forwardCurrentVirtualSrvProtocol").html(_("firewall protocol"));
	$("#forwardCurrentVirtualSrvComment").html(_("firewall comment"));
	$("#forwardCurrentVirtualSrvDel").val(_("firewall del select"));
	$("#forwardCurrentVirtualSrvReset").val(_("firewall cancel"));

		
	$("#singlePortVirtualSrv").html(_("forward single port virtual server"));
	$("#singlePortVirtualSrvSet").html(_("forward single port virtual server setting"));
	$("#singlePortVirtualSrvDisable").html(_("firewall disable"));
	$("#singlePortVirtualSrvEnable").html(_("firewall enable"));
	$("#singlePortInterface").html(_("port forward interface"));
	$("#singlePortWWAN1").html(_("port filter wwan1"));
	$("#singlePortWWAN2").html(_("port filter wwan2"));
	$("#singlePortVirtualSrvIPAddr").html(_("forward virtual server ipaddr"));
	$("#singlePortVirtualSrvPublicPort").html(_("forward virtual server public port"));
	$("#singlePortVirtualSrvPrivatePort").html(_("forward virtual server private port"));
	$("#singlePortVirtualSrvProtocol").html(_("firewall protocol"));
	$("#singlePortVirtualSrvComment").html(_("firewall comment"));
	$("#maxRuleCnt2").html(_("firewall max rule"));
	$("#singlePortVirtualSrvApply").val(_("firewall apply"));
	$("#singlePortVirtualSrvReset").val(_("firewall cancel"));

	$("#singlePortCurrentVirtualSrv").html(_("forward current single port virtual server"));
	$("#singlePortCurrentVirtualSrvNo").html(_("firewall no"));
	$("#singlePortCurrentVirtualSrvInterface").html(_("port forward interface"));
	$("#singlePortCurrentVirtualSrvIP").html(_("forward virtual server ipaddr"));
	$("#singlePortCurrentVirtualSrvPublicPort").html(_("forward virtual server public port"));
	$("#singlePortCurrentVirtualSrvPrivatePort").html(_("forward virtual server private port"));
	$("#singlePortCurrentVirtualSrvProtocol").html(_("firewall protocol"));
	$("#singlePortCurrentVirtualSrvComment").html(_("firewall comment"));
	$("#singlePortCurrentVirtualSrvDel").val(_("firewall del select"));
	$("#singlePortCurrentVirtualSrvReset").val(_("firewall cancel"));


	$("#portForwardSNat").html(_("port forward snat"));
	$("#thPortForwardSNatEnable").html(_("port snat enable"));
	$("#forwardStaticNatDisable").html(_("firewall disable"));
	$("#forwardStaticNatEnable").html(_("firewall enable"));	
	$("#thPortForwardSNatInterface").html(_("port forward interface"));
	$("#sNatWWAN1").html(_("port filter wwan1"));
	$("#sNatWWAN2").html(_("port filter wwan2"));
	$("#thPortForwardSNatPbulicIPAddr").html(_("port snat public ip addr"));
	$("#thPortForwardSNatPrivateIPAddr").html(_("port snat private ip addr"));
	$("#thPortForwardSNatComment").html(_("port snat comment"));
	$("#maxRuleCnt3").html(_("firewall max rule"));
	
	$("#capPortForwardSNatDelete").html(_("port snat delete"));
	$("#portForwardSNatDeleteInterface").html(_("snat delete interface"));
	$("#portForwardSNatDeletePublicAddress").html(_("snat delete public address"));
	$("#portForwardSNatDeletePrivateAddress").html(_("snat delete private address"));
	$("#portForwardSNatDeleteComment").html(_("snat delete comment"));
	$("#singlePortSnatDel").val(_("firewall del select"));
	$("#singlePortSnatReset").val(_("firewall cancel"));
	
	$("#forwardDynamicNatDisable").html(_("firewall disable"));
	$("#forwardDynamicNatEnable").html(_("firewall enable"));
	$("#applySNat").val(_("firewall apply"));
	$("#resetSNat").val(_("firewall cancel"));

	$("#RCNATDisabled").html(_("firewall disable"));
	$("#RCNATEnabled").html(_("firewall enable"));
	$("#thPortForwardRCNATPublicIP").html(_("forward public ip this is not list"));
	$("#RCNATPIPNotTrans").html(_("forward rc corn not trans"));
	$("#RCNATPIPWWAN1").html(_("forward rc corn wwan1"));
	$("#RCNATPIPWWAN2").html(_("forward rc corn wwan2"));
	$("#thPortForwardRCNATInterface").html(_("forward rc corn interface"));
	$("#RCNATIPWWAN1").html(_("forward rc corn wwan1"));
	$("#RCNATIPWWAN2").html(_("forward rc corn wwan2"));
	$("#thPortForwardRCNATRange").html(_("forward rc corn public ip range"));
	$("#thPortForwardRCNATComment").html(_("forward rc corn comment"));
	$("#maxRuleCnt4").html(_("firewall max rule"));
	$("#applyRCNAT").val(_("firewall apply"));
	$("#resetRCNAT").val(_("firewall cancel"));
	
	$("#capPortForwardRCNATDelete").html(_("forward rc corn nat delete"));
	$("#tportForwardRCNATPublicTarget").html(_("forward rc corn public ip target"));
	$("#tportForwardRCNATFromPublicAddress").html(_("forward rc corn public ip addr"));
	$("#tPortForwardRCNATInterface").html(_("forward rc corn interface"));
	$("#tportForwardRCNATComment").html(_("forward rc corn comment"));
	$("#RCNATDel").val(_("firewall del select"));
	$("#RCNATReset").val(_("firewall cancel"));

	$("[id=ifaceWWAN1]").each( function (index, item) { $(item).html( _("port filter wwan1")); } );	
	$("[id=ifaceWWAN2]").each( function (index, item) { $(item).html( _("port filter wwan2")); } );	
}


function initPortForward()
{
	$("#portForward").initForm([(port_enable == "1")?1:0, 0, "", "", "", 0, ""]);
	updatePortForward();
}

function initSinglePortForward()
{
	$("#singlePortForward").initForm([(singleport_enable == "1")?1:0, 0, "", "", "", 0, ""]);
	updateSinglePortForward();
}

function initSNat()
{
	$("#staticNAT").initForm([(sNat_enable == "1")?1:0, 0, "", "", ""]);
	updateStaticNat() ;
}

function initRCNat()
{
	var RCNATDefault = "<% getCfgGeneral(1, "PortForwardRCNATDefault"); %>";
	var RCNATDefaultIdx = 1;
	if(RCNATDefault=="NONE") RCNATDefaultIdx = 0;
	else if(RCNATDefault=="WWAN2") RCNATDefaultIdx = 2;
	else RCNATDefaultIdx = 1;
	
	$("#restrictedCornNAT").initForm([(restrictedCornNATEnable == "1")?1:0, RCNATDefaultIdx, 0, "", "", ""]);	
	updateRrestrictedCornNat();
}
	
function onInit()
{
	initPortForward();
	initSinglePortForward();
	initSNat();
	initRCNat();
}

function updatePortForward() 
{
	if($("#portForwardEnabled").val()=="0")
	{
		$("#trForwardVirtualSrvIPAddr").hide();
		$("#trportForwardingInterface").hide();
		$("#trForwardVirtualSrvPortRange").hide();
		$("#trForwardVirtualSrvProtocol").hide();
		$("#trForwardVirtualSrvComment").hide();
		$("#divMaxRuleCnt").hide();
		$("#portForwardRules").hide();
	}
	else
	{
		$("#trForwardVirtualSrvIPAddr").show();
		$("#trportForwardingInterface").show();
		$("#trForwardVirtualSrvPortRange").show();
		$("#trForwardVirtualSrvProtocol").show();
		$("#trForwardVirtualSrvComment").show();
		$("#divMaxRuleCnt").show();
		
		if( rules_num > 0 ) $("#portForwardRules").show();
		else $("#portForwardRules").hide();
	}
}

function updateSinglePortForward() 
{
	if($("#singlePortForwardEnabled").val()=="0")
	{
		$("#trsinglePortVirtualInterface").hide();
		$("#trSinglePortVirtualSrvIPAddr").hide();
		$("#trSinglePortVirtualSrvPublicPort").hide();
		$("#trSinglePortVirtualSrvPrivatePort").hide();
		$("#trSinglePortVirtualSrvProtocol").hide();
		$("#trSinglePortVirtualSrvComment").hide();
		$("#divMaxRuleCnt2").hide();
		$("#singlePortForwardRules").hide();
	}
	else
	{
		$("#trsinglePortVirtualInterface").show();
		$("#trSinglePortVirtualSrvIPAddr").show();
		$("#trSinglePortVirtualSrvPublicPort").show();
		$("#trSinglePortVirtualSrvPrivatePort").show();
		$("#trSinglePortVirtualSrvProtocol").show();
		$("#trSinglePortVirtualSrvComment").show();
		$("#divMaxRuleCnt2").show();

		if( rules_num_singleport > 0 ) $("#singlePortForwardRules").show();
		else $("#singlePortForwardRules").hide();
	}
}

function updateStaticNat() 
{
	if($("#PortForwardSNatEnable").val()=="0")
	{
		$("#trPortForwardSNatInterface").hide();
		$("#trPortForwardSNatPbulicIPAddr").hide();
		$("#trPortForwardSNatPrivateIPAddr").hide();
		$("#trPortForwardSNatComment").hide();
		$("#divMaxRuleCnt3").hide();
		$("#divPortForwardSNatDelete").hide();
	}
	else
	{
		$("#trPortForwardSNatInterface").show();
		$("#trPortForwardSNatPbulicIPAddr").show();
		$("#trPortForwardSNatPrivateIPAddr").show();
		$("#trPortForwardSNatComment").show();
		$("#divMaxRuleCnt3").show();

		if( rules_num_snat > 0 ) $("#divPortForwardSNatDelete").show();
		else $("#divPortForwardSNatDelete").hide();
	}
}

function updateRrestrictedCornNat() 
{
	if($("#PortForwardRCNATEnable").val() == "0")
	{
		$("#trPortForwardRCNATPublicIP").hide();
		$("#trPortForwardRCNATInterface").hide();
		$("#trPortForwardRCNATRange").hide();
		$("#trPortForwardRCNATComment").hide();		
		$("#divMaxRuleCnt4").hide();
		$("#divPortForwardRCNATDelete").hide();		
	}
	else
	{
		$("#trPortForwardRCNATPublicIP").show();
		$("#trPortForwardRCNATInterface").show();
		$("#trPortForwardRCNATRange").show();
		$("#trPortForwardRCNATComment").show();
		$("#divMaxRuleCnt4").show();
		
		if( rules_num_restricted_corn_nat > 0 ) $("#divPortForwardRCNATDelete").show();
		else $("#divPortForwardRCNATDelete").hide();
	}
}

</script>
</head>


<body>
<script language = "JavaScript" type = "text/javascript"> printContentHead("port_forward.asp"); </script>

	<h1 id="forwardTitle">Virtual Server  Settings </h1>
	<% checkIfUnderBridgeModeASP(); %>
	<div align="left">
	&nbsp;&nbsp; <font id = "forwardIntroduction"> </font> 
	</div>
	<div id = "blank"> </div>	
	
	<form method=post name="portForward" id="portForward" action=/goform/portForward>
	<table>
	<caption id = "forwardVirtualSrv"> Port Forwarding</caption>
	<tr>
		<th id="forwardVirtualSrvSet"> Port Forwarding </th>
		<td>
			<select name="portForwardEnabled" id="portForwardEnabled" size="1"> 
			<option value=0 <% getPortForwardEnableASP(0); %> id="forwardVirtualSrvDisable">Disable</option>
			<option value=1 <% getPortForwardEnableASP(1); %> id="forwardVirtualSrvEnable">Enable</option>
			</select>
		</td>
	</tr>

	<tr id ="trportForwardingInterface" >
		<th id = "portForwardingInterface"> Interface </th>
		<td>
			<select name="portForwardInterface" id="portForwardInterface">
			<option select="" value="WWAN1" id="filterWWAN1">WWAN1</option>
			<option select="" value="WWAN2" id="filterWWAN2">WWAN2</option>
            		</select>
		</td>
	</tr>

	<tr id="trForwardVirtualSrvIPAddr">
		<th id="forwardVirtualSrvIPAddr"> IP Address </th>
		<td>
	  		<input type="text" size="16" name="ip_address" id="pf_ip_address">
		</td>
	</tr>

	<tr id="trForwardVirtualSrvPortRange">
		<th id="forwardVirtualSrvPortRange"> Port Range </th>
		<td>
	  		<input type="text" size="5" maxlength="5" name="fromPort" id="fromPort">
	  		-<input type="text" size="5" maxlength="5" name="toPort" id="toPort"> &nbsp;&nbsp;
		</td>
	</tr>

	<tr  id="trForwardVirtualSrvProtocol">
		<th id="forwardVirtualSrvProtocol"> Protocol </th>
		<td>
			<select name="protocol">
	   		<option select value="TCP&UDP">TCP&UDP</option>
			<option value="TCP">TCP</option>
	   		<option value="UDP">UDP</option>
	   		</select>&nbsp;&nbsp;
		</td>
	</tr>

	<tr id="trForwardVirtualSrvComment">
		<th id="forwardVirtualSrvComment"> Comment </th>
		<td>
			<input type="text" name="comment"  id="pf_comment" size="16" maxlength="15">
		</td>
	</tr>
	</table>
	<div id=divMaxRuleCnt>
	<font id="maxRuleCnt">The maximum rule:</font>
		<script> document.write(MAX_RULES);</script>
	</div>
	
	<div id = "blank" class="error" name="addPf" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "forwardVirtualSrvApply" name="addFilterPort">
	<input class = "btn" type = "button" value = "Reset" id = "forwardVirtualSrvReset"  name="reset" >
	</form>

	<div id="portForwardRules" >
	<div id = "blank"> </div>
	<!--  delete rules -->
	<form action=/goform/portForwardDelete method=POST name="portForwardDelete">

	<table name="tablePortForRules">	
	<caption id = "forwardCurrentVirtualSrv"> Current Port Forwarding in system:</caption>
	<thead>
	<tr>
		<td bgcolor=#E8F8FF id="forwardCurrentVirtualSrvNo"> No.</td>
		<td bgcolor=#E8F8FF id="forwardCurrentVirtualSrvInterface"> Interface </td>
		<td bgcolor=#E8F8FF id="forwardCurrentVirtualSrvIP"> IP Address</td>
		<td bgcolor=#E8F8FF id="forwardCurrentVirtualSrvPort"> Port Range</td>
		<td bgcolor=#E8F8FF id="forwardCurrentVirtualSrvProtocol"> Protocol</td>
		<td bgcolor=#E8F8FF id="forwardCurrentVirtualSrvComment"> Comment</td>
	</tr>
	</thead>
	<tbody>
	<% showPortForwardRulesASP(); %>
	</tbody>
	</table>

	<div id = "blank" class="error" name="delPf" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Del Selected" id = "forwardCurrentVirtualSrvDel" name="forwardCurrentVirtualSrvDel">
	<input class = "btn" type = "reset" value = "Reset" id = "forwardCurrentVirtualSrvReset"  name="reset" >
	</form>
	</div>

	<div id = "blank"> </div>
	<form method=post name="singlePortForward"  id="singlePortForward"  action=/goform/singlePortForward>
	<table>
	<caption id = "singlePortVirtualSrv"> Virtual Server</caption>
	<tr>
		<th id="singlePortVirtualSrvSet"> Virtual Server </th>
		<td>
			<select name="singlePortForwardEnabled" id="singlePortForwardEnabled" size="1">
			<option value=0 <% getSinglePortForwardEnableASP(0); %> id="singlePortVirtualSrvDisable">Disable</option>
			<option value=1 <% getSinglePortForwardEnableASP(1); %> id="singlePortVirtualSrvEnable">Enable</option>
			</select>
		</td>
	</tr>

	<tr id ="trsinglePortVirtualInterface" >
		<th id = "singlePortInterface"> Interface </th>
		<td>
			<select name="singlePortForwardInterface" id="singlePortForwardInterface">
			<option select="" value="WWAN1" id="singlePortWWAN1">WWAN1</option>
			<option select="" value="WWAN2" id="singlePortWWAN2">WWAN2</option>
            		</select>
		</td>
	</tr>

	<tr id="trSinglePortVirtualSrvIPAddr">
		<th id="singlePortVirtualSrvIPAddr"> IP Address </th>
		<td>
	  		<input type="text" size="16" name="ip_address" id="vs_ip_address">
		</td>
	</tr>

	<tr id="trSinglePortVirtualSrvPublicPort">
		<th id="singlePortVirtualSrvPublicPort"> Public Port </th>
		<td>
	  		<input type="text" size="5"  maxlength="5" name="publicPort" id="publicPort">
		</td>
	</tr>

	<tr id="trSinglePortVirtualSrvPrivatePort">
	        <th id="singlePortVirtualSrvPrivatePort"> Private Port </th>
	        <td>
	                <input type="text" size="5" maxlength="5" name="privatePort" id="privatePort">
	        </td>
	</tr>

	<tr id="trSinglePortVirtualSrvProtocol">
		<th id="singlePortVirtualSrvProtocol"> Protocol </th>
		<td>
			<select name="protocol">
	   		<option select value="TCP&UDP">TCP&UDP</option>
			<option value="TCP">TCP</option>
	   		<option value="UDP">UDP</option>
	   		</select>&nbsp;&nbsp;
		</td>
	</tr>

	<tr  id="trSinglePortVirtualSrvComment">
		<th class="head" id="singlePortVirtualSrvComment"> Comment </th>
		<td>
			<input type="text" name="comment" id="vs_comment"  size="16" maxlength="15">
		</td>
	</tr>
	</table>
	<div id="divMaxRuleCnt2">
	<font id="maxRuleCnt2">The maximum rule:</font>
		<script> document.write(MAX_RULES);</script>
	</div>
	
	<div id = "blank" class="error" name="addVs" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "singlePortVirtualSrvApply" name="addSinglePort">
	<input class = "btn" type = "button" value = "Reset" id = "singlePortVirtualSrvReset"  name="reset" >
	</form>

	<div id="singlePortForwardRules" >
	<div id = "blank"> </div>
	<!--  delete rules -->
	<form action=/goform/singlePortForwardDelete method=POST name="singlePortForwardDelete">

	<table  name="tableSinglePortForwardDelete">	
	<caption id = "singlePortCurrentVirtualSrv"> Current Virtual Servers in system:</caption>
	<thead>
	<tr>
		<td bgcolor=#E8F8FF id="singlePortCurrentVirtualSrvNo"> No.</td>
		<td bgcolor=#E8F8FF id="singlePortCurrentVirtualSrvInterface"> Interface</td>
		<td bgcolor=#E8F8FF id="singlePortCurrentVirtualSrvIP"> IP Address</td>
		<td bgcolor=#E8F8FF id="singlePortCurrentVirtualSrvPublicPort"> Public Port</td>
		<td bgcolor=#E8F8FF id="singlePortCurrentVirtualSrvPrivatePort"> Private Port</td>
		<td bgcolor=#E8F8FF id="singlePortCurrentVirtualSrvProtocol"> Protocol</td>
		<td bgcolor=#E8F8FF id="singlePortCurrentVirtualSrvComment"> Comment</td>
	</tr>
	</thead>
	<tbody>
	<% showSinglePortForwardRulesASP(); %>
	</tbody>
	</table>

	<div id = "blank" class="error" name="delVPf" align="center">	<span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Del Selected" id = "singlePortCurrentVirtualSrvDel" name="singlePortCurrentVirtualSrvDel">
	<input class = "btn" type = "reset" value = "Reset" id = "singlePortCurrentVirtualSrvReset"  name="reset">
	</form>
	</div>
 
	<div id = "blank"> </div>
	<form method=post name="staticNAT" id="staticNAT" action=/goform/portForwardSNat>
	<table>
	<caption id = "portForwardSNat"> Static Nat</caption>
	<tr>
		<th id="thPortForwardSNatEnable"> Static Nat Enable</th>
		<td>
			<select name="PortForwardSNatEnable" id="PortForwardSNatEnable" size="1">
			<option value=0 <% getPortForwardStaticNatPolicyASP(0); %> id="forwardStaticNatDisable">Disable</option>
			<option value=1 <% getPortForwardStaticNatPolicyASP(1); %> id="forwardStaticNatEnable">Enable</option>
			</select>
		</td>
	</tr>

	<tr id ="trPortForwardSNatInterface" >
		<th id = "thPortForwardSNatInterface"> Interface </th>
		<td>
			<select name="PortForwardSNatInterface" id="PortForwardSNatInterface">
			<option select="" value="WWAN1" id="sNatWWAN1">WWAN1</option>
			<option select="" value="WWAN2" id="sNatWWAN2">WWAN2</option>
            		</select>
		</td>
	</tr>

	<tr id="trPortForwardSNatPbulicIPAddr">
		<th id="thPortForwardSNatPbulicIPAddr"> IP Address </th>
		<td>
	  		<input type="text" size="16" name="PortForwardSNatPbulicIPAddr", id = "PortForwardSNatPbulicIPAddr">
		</td>
	</tr>

	<tr id="trPortForwardSNatPrivateIPAddr">
		<th id="thPortForwardSNatPrivateIPAddr"> IP Address </th>
		<td>
	  		<input type="text" size="16" name="PortForwardSNatPrivateIPAddr" id="PortForwardSNatPrivateIPAddr">
		</td>
	</tr>

	<tr  id="trPortForwardSNatComment">
		<th class="head" id="thPortForwardSNatComment"> Comment </th>
		<td>
			<input type="text" name="PortForwardSNatComment" id="PortForwardSNatComment" size="42" maxlength="42">
		</td>
	</tr>	
	</table>
	<div id="divMaxRuleCnt3">
	<font id="maxRuleCnt3">The maximum rule:</font>
		<script> document.write(MAX_RULES);</script>
	</div>
	
	<div id = "blank" class="error" name="addSNat" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "applySNat" name="applySNat">
	<input class = "btn" type = "button" value = "Reset" id = "resetSNat"  name="reset" >
	</form>

 
	<div id="divPortForwardSNatDelete" >
	<div id = "blank"> </div>
	<!--  snat delete rules -->
	<form action=/goform/portForwardSNatDelete method=POST name="portForwardSNatDelete">

	<table name="tablePortForwardSNatDelete">	
	<caption id = "capPortForwardSNatDelete"> Static Nat  in system </caption>
	<thead>
	<tr>
		<td bgcolor=#E8F8FF id="portForwardSNatDeleteNo"> No.</td>
		<td bgcolor=#E8F8FF id="portForwardSNatDeleteInterface"> IP Address</td>
		<td bgcolor=#E8F8FF id="portForwardSNatDeletePublicAddress"> Public Address</td>
		<td bgcolor=#E8F8FF id="portForwardSNatDeletePrivateAddress"> Private Address</td>
		<td bgcolor=#E8F8FF id="portForwardSNatDeleteComment"> Comment</td>
	</tr>
	</thead>
	<tbody>
	<% showPortForwardSNatRulesASP(); %>
	</tbody>
	</table>	

	<div id = "blank" class="error" name="delSNat" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Del Selected" id = "singlePortSnatDel" name="singlePortSnatDel">
	<input class = "btn" type = "reset" value = "Reset" id = "singlePortSnatReset"  name="reset">
	</form>
	</div>

	<div id = "blank"> </div>
	<form method=post name="restrictedCornNAT" id="restrictedCornNAT" action=/goform/portForwardRestrictedCornNAT>
	<table>
	<caption id = "portForwardRCNAT"> Port restricted corn NAT</caption>
	<tr id ="trPortForwardRCNAT" >
		<th id = "thPortForwardRCNAT"> Port restricted corn NAT </th>
		<td>
			<select name="PortForwardRCNATEnable" id="PortForwardRCNATEnable" size="1">
			<option select="" value="0" id="RCNATDisabled"> Disabled</option>
			<option select="" value="1" id="RCNATEnabled"> Enabled</option>			
            		</select>
		</td>
	</tr>
	<tr id ="trPortForwardRCNATPublicIP" >
		<th id = "thPortForwardRCNATPublicIP"> Public IP address that is not in the list </th>
		<td>
			<select name="PortForwardRCNATPublicIP" id="PortForwardRCNATPublicIP">
			<option select="" value="NONE" id="RCNATPIPNotTrans"> Not Trans.</option>
			<option select="" value="WWAN1" id="RCNATPIPWWAN1">WWAN1/WAN</option>
			<option select="" value="WWAN2" id="RCNATPIPWWAN2">WWAN2</option>
            		</select>
		</td>
	</tr>
	<tr id ="trPortForwardRCNATInterface" >
		<th id = "thPortForwardRCNATInterface"> Interface </th>
		<td>
			<select name="PortForwardRCNATInterface" id="PortForwardRCNATInterface">
			<option select="" value="WWAN1" id="RCNATIPWWAN1">WWAN1/WAN</option>
			<option select="" value="WWAN2" id="RCNATIPWWAN2">WWAN2</option>
            		</select>
		</td>
	</tr>
	<tr id="trPortForwardRCNATRange">
		<th id="thPortForwardRCNATRange"> Range of public IP addr. </th>
		<td>
	  		<input type="text" size="15" maxlength="15" name="fromRCNATPublicIP" id="fromRCNATPublicIP">&nbsp;
	  		-&nbsp;<input type="text" size="15" maxlength="15" name="toRCNATPublicIP" id="toRCNATPublicIP">
		</td>
	</tr>
	<tr id="trPortForwardRCNATComment">
		<th id="thPortForwardRCNATComment"> Comment </th>
		<td>
			<input type="text" name="RCNATcomment" id="RCNATcomment" size="42" maxlength="42">
		</td>
	</tr>
	
	</table>
	<div id="divMaxRuleCnt4">
	<font id="maxRuleCnt4">The maximum rule:</font>
		<script> document.write(MAX_RULES);</script>
	</div>

	<div id = "blank" class="error" name="addRCNAT" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Apply" id = "applyRCNAT" name="applyRCNAT">
	<input class = "btn" type = "button" value = "Reset" id = "resetRCNAT"  name="reset" >
	</form>

	<div id="divPortForwardRCNATDelete" >
	<div id = "blank"> </div>
	<form action=/goform/portForwardRCNATDelete method=POST name="portForwardRCNATDelete">

	<table name="tablePortForwardRCNATDelete">	
	<caption id = "capPortForwardRCNATDelete"> Port restricted corn NAT Target List </caption>
	<thead>
	<tr>
		<td bgcolor=#E8F8FF id="portForwardRCNATDeleteNo"> No.</td>
		<td bgcolor=#E8F8FF id="tPortForwardRCNATInterface"> Interface </td>
		<td bgcolor=#E8F8FF id="tportForwardRCNATFromPublicAddress"> Public  IP Address</td>
		<td bgcolor=#E8F8FF id="tportForwardRCNATComment"> Comment</td>
	</tr>
	</thead>
	<tbody>
	<% showPortForwardRestrictCornRulesASP(); %>
	</tbody>
	</table>	

	<div id = "blank" class="error" name="delRCNAT" align="center"> <span></span> <br clear="all"></div>
	<input class = "btn" type = "submit" value = "Del Selected" id = "RCNATDel" name="RCNATDel">
	<input class = "btn" type = "reset" value = "Reset" id = "RCNATReset"  name="reset">
	</form>
	</div>

<script language = "JavaScript" type = "text/javascript"> printContentBottom(); </script>
</body>
</html>

