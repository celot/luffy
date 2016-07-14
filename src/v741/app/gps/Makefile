EXEC = gps_func

OBJS =  main.o \
	gps_util.o \
	gps_data.o \
	gps_queue.o \
	gps_config.o \
	gps_module.o \
	gps_sender_thread.o \
	gps_udp.o \
	gps_tcp_client.o \
	gps_tcp_server.o \
	gps_connect.o \
	gps_manager.o

DEPS = $(OBJS:.o=.dep) 
DEPEND_FILE=dependency
PWD  = $(shell pwd)
INSTALL    = install

CFLAGS += -I$(ROOTDIR) -I$(ROOTDIR)/lib/libnvram -I$(ROOTDIR)/$(LINUXDIR)/drivers/char -I$(ROOTDIR)/lib/include
CFLAGS += -I$(PWD)
CFLAGS += -I$(ROOTDIR)/$(LINUXDIR)/include
CFLAGS += -I$(ROOTDIR)/$(LINUXDIR)/drivers/net/rt_rdm
CFLAGS += -I../lib/libmodule
CFLAGS += -I../lib/libctutil

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
$(EXEC) : ../lib/libctutil/libctutil.a ../lib/libmodule/libmodule.a
$(EXEC) : $(ROOTDIR)/uClibc++/src/libstdc++.a