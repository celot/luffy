function aDown(num)
{

	flag = 0;
	switch(num) 
	{	
		case 'mobile':
			if ( mobile_menu.style.display == "block") 
			{
				mobile_menu.style.display = "none";
				flag = 1;
			}
			break;
			
		case 'internet':
			if ( internet_menu.style.display == "block") 
			{
				internet_menu.style.display = "none";
				flag = 1;
			}
			break;
			
		case 'wireless': 
			if(use_wifi == "1")
			{
				if ( wireless_menu.style.display == "block") 
				{
					wireless_menu.style.display = "none";
					flag = 1;
				}
			}
			break;		
			
		case 'firewall': 
			if ( firewall_menu.style.display == "block") 
			{
				firewall_menu.style.display = "none";
				flag = 1;
			}
			break;
			
		case 'admin': 
			if ( admin_menu.style.display == "block") 
			{
				admin_menu.style.display = "none";
				flag = 1;
			}
			break;
		case 'service':
			if ( service_menu.style.display == "block") 
			{
				service_menu.style.display = "none";
				flag = 1;
			}
			break;
	}
	
	if (!flag) 
	{	
		mobile_menu.style.display = 'none';  
		internet_menu.style.display = 'none';  
		if(use_wifi == "1") wireless_menu.style.display = 'none'; 
		firewall_menu.style.display = 'none';
		admin_menu.style.display = 'none'; 
		service_menu.style.display = 'none'; 

		switch(num) 
		{
			case 'mobile':
				if ( mobile_menu.style.display == "none")
					mobile_menu.style.display = "block";
				break;
			case 'internet':
				if ( internet_menu.style.display == "none")
					internet_menu.style.display = "block";
				break;

			case 'wireless': 
				if(use_wifi == "1")
				{
					if ( wireless_menu.style.display == "none")
						wireless_menu.style.display = "block";
				}
				break;

				
			case 'firewall': 
				if ( firewall_menu.style.display == "none")
					firewall_menu.style.display = "block";
				break;
			case 'admin': 
				if ( admin_menu.style.display == "none")
					admin_menu.style.display = "block";
				break;
			case 'service':
				if ( service_menu.style.display == "none")
					service_menu.style.display = "block";
				break;
		}
	}	
}

/* for low browser version (before IE 5.5)*/
function getElement( id ) {
 if( document.all ) return document.all( id );
 if( document.getElementById ) return document.getElementById( id );
}

function selectMenu(now_file_name)
{
	mobile_menu.style.display = 'none';  
	internet_menu.style.display = 'none';  
	if(use_wifi == "1") wireless_menu.style.display = 'none'; 
	firewall_menu.style.display = 'none';
	admin_menu.style.display = 'none'; 
	service_menu.style.display = 'none'; 

	switch(now_file_name) 
	{
		case 'home.asp':
			break;

		case 'config.asp':
		case 'mstatus.asp':
		case 'center_push.asp':
			mobile_menu.style.display = 'block'; 
			break;

		case 'wan.asp':
		case 'lan.asp':
		case 'vpn.asp':
		case 'dhcpcliinfo.asp':
		case 'routing.asp':
			internet_menu.style.display = 'block'; 
			break;

		case 'basic.asp':
		case 'security.asp':
		case 'apcli.asp':
		case 'stainfo.asp':
		case 'apstatistics.asp':
			if(use_wifi == "1") wireless_menu.style.display = 'block'; 
			break;

		case 'port_filtering.asp':
		case 'port_forward.asp':
		case 'DMZ.asp':
		case 'system_firewall.asp':
		case 'content_filtering.asp':
		case 'secu_vpn.asp':	
			firewall_menu.style.display = 'block'; 
			break;

		case 'management.asp':
		case 'upload_firmware.asp':
		case 'settings.asp':
		case 'reboot.asp':	
		case 'status.asp':
		case 'statistic.asp':
		case 'statistic_KDDI.asp':
		case 'syslog.asp':
		case 'kddi_ota.asp':
		case 'failsafe.asp':
			admin_menu.style.display = 'block'; 
			break;

		case 'directserial.asp':
		case 'serialmodem.asp':
		case 'ups_set.asp':
		case 'nms.asp':
		case 'power_controller.asp':
		case 'modbus.asp':
			service_menu.style.display = 'block'; 
			break;
	}
}

function Node(id, pid, name, url, title)
{
	this.id = id;
	this.pid = pid;
	this.name = name;
	this.name_menu = name+"_menu";
	this.url = url;
	this.title = title;
}

function dTree(objName) 
{
	this.obj = objName;
	this.aNodes = [];
}

dTree.prototype.add = function(id, pid, name, url, title) 
{
	this.aNodes[this.aNodes.length] = new Node(id, pid, name, url, title);
};

dTree.prototype.toString = function() 
{
	var str = '<div id="header">\n';
	if(none_Logo=="1")
	{
		str += '<div id="header_logo"><a href="/home.asp" onfocus="blur()"></a></div>\n';
	}
	else
	{
		str += '<div id="header_logo"><a href="/home.asp" onfocus="blur()"><img id="title_img" src="/graphics/img_title3.png" alt="title_img" border="0" /></a></div>\n';	
	}
	str += '<div id="header_content" />\n';
	str += '</div>\n';

	str += '<div class="menu">\n';
	str += '<div class="menu_start"><img id="menu_title_img" src="/graphics/img_menu_title.gif" alt="config_img" border="0" /></div>\n';
	str += '<div class="menu_content" id="content_menu" style="display:block">\n';
	str += '<ul>\n';

	var n=0;
	for (n; n<this.aNodes.length; n++) 
	{
		if (this.aNodes[n].pid == 0) 
		{
			str += '<li class="depth1"> <img src="/graphics/li_icon01.gif" alt="*"/> <a onmousedown="aDown(\'' + this.aNodes[n].name + '\')" href="' + this.aNodes[n].url + '">' + this.aNodes[n].title + '</a>\n';

			var m = 0;
			var sub_cnt=0;
			for (m; m<this.aNodes.length; m++) 
			{
				if ((n!=m) && (this.aNodes[n].id == this.aNodes[m].pid)) 
				{
					if(sub_cnt==0)
					{
						str += '<div id='+ this.aNodes[n].name_menu+ ' style="display:none">\n';
						str += '<ul class="depth2">\n';							
					}
					str +='<li><img src="/graphics/li_icon02.gif" alt="*"> <a href="'+ this.aNodes[m].url+'">'+this.aNodes[m].title+'</a></li>\n';
					sub_cnt++;
				}
			}
			if(sub_cnt>0)
			{
				str += '</ul>\n';		
				str += '</div>\n';	
			}
			str += '</li>\n';	
		}
	}

	str += '</ul>\n';
	str += '</div>\n';
	str += '<div class="menu_end"></div>\n';
	str += '</div>\n';
	return str;
};

function printContentHead(now_file_name)
{
	var str = '<div id = "celot">\n';
	document.write(str);

	menu = new dTree('menu');
	var old_domain = Butterlate.getTextDomain();
	Butterlate.setTextDomain("main");

	menu.add(100, 0, 'OverView',"/home.asp", _("treeapp overview"));	
		
	menu.add(200, 0, 'mobile',"#", _("treeapp mobile"));	
		menu.add(201, 200, '',"/mobile/config.asp", _("treeapp mobile config"));	
		menu.add(202, 200, '',"/mobile/mstatus.asp", _("treeapp mobile status"));
		menu.add(203, 200, '',"/mobile/center_push.asp", _("treeapp center push"));

	menu.add(300, 0, 'internet',"#", _("treeapp internet"));	
		menu.add(301, 300, '',"/internet/wan.asp", _("treeapp wan"));	
		menu.add(302, 300, '',"/internet/lan.asp", _("treeapp lan"));	
		menu.add(303, 300, '',"/internet/dhcpcliinfo.asp", _("treeapp dhcp clients"));	
		menu.add(304, 300, '',"/internet/routing.asp", _("treeapp routing"));	
		if((cfgMenu & 0x01)==0x01) menu.add(305, 300, '',"/internet/vpn.asp", _("treeapp vpn"));	

	if(use_wifi == "1")
	{
		menu.add(400, 0, 'wireless',"#", _("treeapp wireless"));	
			menu.add(401, 400, '',"/wireless/basic.asp", _("treeapp basic"));
			menu.add(402, 400, '',"/wireless/security.asp", _("treeapp security"));
			menu.add(403, 400, '',"/wireless/apcli.asp", _("treeapp ap client"));
			menu.add(405, 400, '',"/wireless/stainfo.asp", _("treeapp station list"));
			menu.add(406, 400, '',"/wireless/apstatistics.asp", _("treeapp wifi statistics"));
	}
	
	menu.add(500, 0, 'firewall',"#", _("treeapp firewall"));	
		menu.add(501, 500, '',"/firewall/port_filtering.asp", _("treeapp ip/port filtering"));
		menu.add(502, 500, '',"/firewall/port_forward.asp", _("treeapp port forwarding"));
		menu.add(503, 500, '',"/firewall/DMZ.asp", _("treeapp dmz"));
		menu.add(504, 500, '',"/firewall/system_firewall.asp", _("treeapp system firewall"));
		menu.add(505, 500, '',"/firewall/content_filtering.asp", _("treeapp content filtering"));
		
	menu.add(600, 0, 'admin', "#", _("treeapp admin"));	
		menu.add(601, 600, '',"/adm/management.asp", _("treeapp management"));
		menu.add(602, 600, '',"/adm/upload_firmware.asp", _("treeapp upload firmware"));
		menu.add(603, 600, '',"/adm/settings.asp", _("treeapp settings management"));
		menu.add(604, 600, '',"/adm/reboot.asp", _("treeapp reboot"));
		menu.add(605, 600, '',"/adm/status.asp", _("treeapp status"));
		menu.add(606, 600, '',"/adm/statistic.asp", _("treeapp statistics"));
		menu.add(607, 600, '',"/adm/syslog.asp", _("treeapp system log"));
		if(cfgMenu&0x00010000) menu.add(610, 600, '',"/adm/failsafe.asp", _("treeapp mobile failsafe"));
		
	menu.add(700, 0, 'service', "#", _("treeapp service"));	
		menu.add(701, 700, '',"/service/directserial.asp", _("treeapp directserial"));
		if((cfgMenu & 0x400)==0x400) menu.add(702, 700, '',"/service/serialmodem.asp", _("treeapp serialmodem"));
		menu.add(703, 700, '',"/service/ups_set.asp", _("treeapp ups"));
		if("1" == menuMODBUS)
		{
			menu.add(704, 700, '',"/service/modbus.asp", _("treeapp modbus"));
		}

	Butterlate.setTextDomain(old_domain);
	document.write(menu);

	selectMenu(now_file_name);

	str = '<div id = "content">\n';
	str +='<div id = "content_start"> </div>\n';
	str +='<div id = "content_background">\n';
	str +='<div id = "content_padding">\n';
	document.write(str);
}

function printContentBottom()
{
	var str = '</div> \n'; //<!-- content_padding -->
	str += '</div>\n'; //<!-- content_background -->
	str += '<div id = "content_close"></div>\n';
	str += '</div>\n'; //<!-- content -->
	str += '</div> \n';//<!-- celot -->
	document.write(str);
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

function trim(s)
{
	s += ''; 
	return s.replace(/^\s*|\s*$/g, '');
}

