EXEC = diagnosis

OBJS =  main.o \
	dutil.o \
	ram_info.o \
	rom_info.o \
	network_info.o \
	firmware_info.o \
	module_info.o \
	diagnosis_serial.o \
	info_manager.o \
	diag_led.o

EXEC += diagnosis_daemon
OBJS_MON = dutil.o \
	diagnosis_daemon.o


DEPS = $(OBJS:.o=.dep) 
DEPEND_FILE=dependency
PWD  = $(shell pwd)
INSTALL    = install

CFLAGS += -I$(ROOTDIR) -I$(ROOTDIR)/lib/libnvram -I$(ROOTDIR)/$(LINUXDIR)/drivers/char -I$(ROOTDIR)/lib/include
CFLAGS += -I$(PWD)
CFLAGS += -I$(ROOTDIR)/$(LINUXDIR)/include
CFLAGS += -I$(ROOTDIR)/lib/libusb-0.1.12
CFLAGS += -I$(ROOTDIR)/$(LINUXDIR)/drivers/net/rt_rdm
CFLAGS += -I../lib/libqmi
CFLAGS += -I../lib/libmodule
CFLAGS += -I../lib/libctutil

LDFLAGS += -L../lib/libqmi -lqmi
LDFLAGS += -L../lib/libmodule -lmodule
LDFLAGS += -L../lib/libctutil -lctutil
LDFLAGS += -L$(ROOTDIR)/llib/ibpthread -lpthread
LDFLAGS += -L$(ROOTDIR)/lib/libnvram -lnvram
LDFLAGS += -L$(ROOTDIR)/lib/librt -lrt
LDFLAGS += -L$(ROOTDIR)/lib/libusb-0.1.12 -lusb

all: $(EXEC)


install: $(EXEC)
	@$(INSTALL) -d $(ROOTDIR)/romfs/usr/sbin
	@sudo chmod +x $(EXEC)
	@sudo cp -f $(EXEC) $(ROOTDIR)/romfs/usr/sbin

clean:
	@rm -f *.o $(EXEC) $(DEPS) $(DEPEND_FILE)

dep:$(DEPS)
	@rm -f $(DEPEND_FILE)
	@for d in $(DEPS); do (cat $$d >> $(DEPEND_FILE)) done 

%.dep:%.cpp
	$(CXX) -MM -o  $@ $(CFLAGS) $<

%.dep:%.c
	$(CC) -MM -o  $@ $(CFLAGS) $<

-include $(DEPEND_FILE)
$(EXEC) : ../lib/libqmi/libqmi.a ../lib/libctutil/libctutil.a ../lib/libmodule/libmodule.a
$(EXEC) : $(ROOTDIR)/uClibc++/src/libstdc++.a
