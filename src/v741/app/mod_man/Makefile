EXEC = mod_man 

OBJS =  main.o \
	mainmanager.o \
	ctl_socket.o \
	ctl_checker.o \
	ctl_checker_qmi.o \
	ctl_checker_ppp2.o \
	ctl_ping.o \
	ctl_sms.o \
	ctl_emg.o


DEPS = $(OBJS:.o=.dep)  $(MM_OBJS:.o=.dep)
DEPEND_FILE=dependency
PWD  = $(shell pwd)
INSTALL    = install

CFLAGS += -I$(ROOTDIR)/lib/include -I$(ROOTDIR) -I$(ROOTDIR)/lib/libnvram
CFLAGS += -I$(PWD) 
CFLAGS += -I../lib/libled 
CFLAGS += -I../lib/libqmi
CFLAGS += -I../lib/libmodule
CFLAGS += -I../lib/libctutil
CFLAGS += -I$(ROOTDIR)/lib/libusb-0.1.12
CFLAGS += -I$(ROOTDIR)/$(LINUXDIR)/drivers/net/rt_rdm
CFLAGS += -I../lib/libfailsafe

LDFLAGS	+= -L../lib/libled  -lled
LDFLAGS += -L../lib/libqmi -lqmi
LDFLAGS += -L../lib/libmodule -lmodule
LDFLAGS += -L../lib/libctutil -lctutil
LDFLAGS += -L$(ROOTDIR)/uClibc++/src -lstdc++
LDFLAGS += -L$(ROOTDIR)/llib/ibpthread -lpthread
LDFLAGS += -L$(ROOTDIR)/lib/libnvram -lnvram
LDFLAGS += -L$(ROOTDIR)/lib/libusb-0.1.12 -lusb
LDFLAGS += -L$(ROOTDIR)/lib/librt -lrt
LDFLAGS += -L../lib/libfailsafe -lfailsafe

# Syslog message
ifeq ("$(CONFIG_USE_REMOTE_SYSLOG)", "y")
CFLAGS	+= -DUSE_SYSLOG_MSG
endif

CONFIG_TEST_PPP_MOD=n
ifeq ("$(CONFIG_TEST_PPP_MOD)", "y")
CFLAGS	+= -DTEST_PPP_MODE
OBJS +=  ctl_checker_ppp.o 
endif


all: $(EXEC) 

	
install: $(EXEC)
	@$(INSTALL) -d $(ROOTDIR)/romfs/usr/sbin
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

$(EXEC) : ../lib/libqmi/libqmi.a ../lib/libctutil/libctutil.a ../lib/libled/libled.a ../lib/libmodule/libmodule.a
$(EXEC) : $(ROOTDIR)/lib/lib/libpthread.a
$(EXEC) : $(ROOTDIR)/lib/libusb-0.1.12/libusb.a
$(EXEC) : $(ROOTDIR)/lib/lib/libnvram.a
$(EXEC) : $(ROOTDIR)/uClibc++/src/libstdc++.a
$(EXEC) : $(ROOTDIR)/lib/lib/librt.a


