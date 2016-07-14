INSTALL    = install

EXEC = lsusb nfs.sh \
	usb_storage.sh  \
	autoreboot.sh \
	reboot.sh \
	autodirectserial.sh \
	restart_ppp.sh \
	lte_interface.sh \
	serialmodem.sh \
	sms2serial.sh \
	dmd \
	upsd.sh \
	ctsh.sh \
	wwan_delay_connect.sh \
	port_detect.sh \
	report_status.sh \
	nms.sh \
	check_secuwizvpn.sh \
	diagnosis.sh \
	set_lan_speed.sh \
	gps_excute.sh \
	nvram_init_common.sh
ifeq ($(CONFIG_SERVICE_MODBUS),y)
	EXEC += modbus_bridge.sh
	EXEC += nvram_init_modbus.sh
endif

ifeq ($(CONFIG_SERVICE_GPS),y)
	EXEC += nvram_init_gps.sh
endif

ifeq ($(CONFIG_SERVICE_FAILSAFE),y)
	EXEC += nvram_init_failsafe.sh
endif

all: $(EXEC)
	@for f in $(EXEC); do ( cp $$f $(HOME)/nfs/) done	
	
install: $(EXEC)
	@$(INSTALL) -d $(ROOTDIR)/romfs/usr/sbin
	@sudo cp -f $(EXEC) $(ROOTDIR)/romfs/usr/sbin
	for f in $(EXEC); do ( sudo chmod +x $(ROOTDIR)/romfs/usr/sbin/$$f ) done

clean:
	@for f in $(EXEC); do ( if [ -f $(ROOTDIR)/romfs/usr/sbin/$$f ]; then sudo rm -rf $(ROOTDIR)/romfs/usr/sbin/$$f; fi ) done
	
dep:
	@echo updated

.PHONY:	$(EXEC)
