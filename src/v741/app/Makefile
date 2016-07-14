#
#	Makefile -- Build instructions for celot
#
include $(ROOTDIR)/.config
include $(LINUX_CONFIG)

.EXPORT_ALL_VARIABLES:

MAKE+= --no-print-directory

SUB_DIR = lib \
          utils \
          directserial \
          serial_modem \
          daemon \
          sms2serial \
          mod_man \
          module	\
          dmz_search \
          report_status \
          netcheck \
          printver

SUB_DIR += smtp
SUB_DIR += upsd
SUB_DIR += port_detect
SUB_DIR += ctsh
SUB_DIR += app_observer

SUB_DIR += wifi_state_checker

ifeq ($(CONFIG_SERVICE_WIFI_HOTSPOT),y)
SUB_DIR += chilli
endif

SUB_DIR += upgrader
SUB_DIR += diagnosis
SUB_DIR += emg_notifier
SUB_DIR += mloader_nv_setter

ifeq ($(CONFIG_SERVICE_GPS),y)
	SUB_DIR += gps
endif
ifeq ($(CONFIG_SERVICE_MODBUS),y)
	SUB_DIR += modbus
endif

ifeq ($(CONFIG_SERVICE_FAILSAFE),y)
	SUB_DIR += failsafe
	CFLAGS	+= -DCONFIG_SERVICE_FAILSAFE
endif

all: 
	for d in $(SUB_DIR); do ($(MAKE) -C $$d) done

%_only:
	$(MAKE) -j1 -C $(@:_only=)

%_clean:
	$(MAKE) -j1 -C $(@:_clean=) clean

%_dep:
	$(MAKE) -j1 -C $(@:_dep=) dep

dep:
	for d in $(SUB_DIR); do ($(MAKE) -C $$d dep) done

install:
	for d in $(SUB_DIR); do ($(MAKE) -C $$d install) done

clean:
	for d in $(SUB_DIR); do ($(MAKE) -C $$d clean) done
