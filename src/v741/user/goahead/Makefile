.EXPORT_ALL_VARIABLES:

DIRS = src cgi-src
ROOT_DIRECTORY = /etc_ro/web
WEB_DIRECTORY = $(ROMFSDIR)/etc_ro/web

CFLAGS+=-DCONFIG_JP_DEALER_HITACHI

ifeq ("$(CONFIG_RT_FIRST_CARD)", "2860")
FIRST_CARD=$(CONFIG_RT_FIRST_CARD)V2
else
FIRST_CARD=$(CONFIG_RT_FIRST_CARD)
endif
FIRST_WDS=CONFIG_RT$(FIRST_CARD)_AP_WDS
SECOND_WDS=CONFIG_RT$(CONFIG_RT_SECOND_CARD)_AP_WDS
FIRST_APCLI=CONFIG_RT$(FIRST_CARD)_AP_APCLI

ifeq ("$(CONFIG_MODEM_KDDI)", "y")
CFLAGS+=-DCONFIG_KDDI
endif

ifeq ("$(CONFIG_MODEM_PANTECH)", "y")
CFLAGS+=-DCONFIG_PANTECH
endif

all:
	for i in $(DIRS) ; do make -C $$i $@ || exit $?; done

romfs: 
	$(ROMFSINST) $(ROOT_DIRECTORY)
	cp -rf web/* $(WEB_DIRECTORY)
	for i in $(DIRS) ; do make -C $$i $@ ; done
	rm -rf $(ROMFSDIR)$(ROOT_DIRECTORY)/lang/*.xlsx
ifeq ("$(CONFIG_MODEM_PANTECH)", "y")
	mv $(ROMFSDIR)$(ROOT_DIRECTORY)/menu/menu_pt.js $(ROMFSDIR)$(ROOT_DIRECTORY)/menu/menu.js
	mv $(ROMFSDIR)$(ROOT_DIRECTORY)/mobile/config_pt.asp $(ROMFSDIR)$(ROOT_DIRECTORY)/mobile/config.asp
	-rm -rf $(ROMFSDIR)$(ROOT_DIRECTORY)/adm/statistic_KDDI.asp
else
	mv $(ROMFSDIR)$(ROOT_DIRECTORY)/adm/statistic_KDDI.asp $(ROMFSDIR)$(ROOT_DIRECTORY)/adm/statistic.asp
	-rm -rf $(ROMFSDIR)$(ROOT_DIRECTORY)/menu/menu_pt.js
	-rm -rf $(ROMFSDIR)$(ROOT_DIRECTORY)/mobile/center_push.asp
	-rm -rf $(ROMFSDIR)$(ROOT_DIRECTORY)/adm/nttconfig.asp
	-rm -rf $(ROMFSDIR)$(ROOT_DIRECTORY)/mobile/config_pt.asp
endif
ifneq ("$(CONFIG_SERVICE_APN_DWL)", "y")
	-rm -rf $(ROMFSDIR)$(ROOT_DIRECTORY)/adm/domain_wl.asp
endif
clean:
	for i in $(DIRS) ; do make -C $$i clean ; done

