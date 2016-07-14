EXEC = ctsh

OBJS =  ctsh.o \
	ctsh_ota.o \
	ctsh_shell.o \
	ctsh_protocol.o \
	ctsh_socket.o \
	crc32.o \
	zmodem.o


CONF	= $(ROOTDIR)/$(LINUXDIR)
ZLIB_H  = $(ROOTDIR)/lib/zlib
CONF_H  = $(ROOTDIR)/$(LINUXDIR)/include/linux/autoconf.h


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

LDFLAGS	+= -L../lib/libled  -lled
LDFLAGS += -L../lib/libqmi -lqmi
LDFLAGS += -L../lib/libmodule -lmodule
LDFLAGS += -L../lib/libctutil -lctutil
LDFLAGS += -L$(ROOTDIR)/uClibc++/src -lstdc++
LDFLAGS += -L$(ROOTDIR)/llib/ibpthread -lpthread
LDFLAGS += -L$(ROOTDIR)/lib/libnvram -lnvram
LDFLAGS += -L$(ROOTDIR)/lib/libusb-0.1.12 -lusb
LDFLAGS += -L$(ROOTDIR)/lib/librt -lrt


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

$(EXEC) : ../lib/libqmi/libqmi.a ../lib/libctutil/libctutil.a ../lib/libled/libled.a ../lib/libmodule/libmodule.a
$(EXEC) : $(ROOTDIR)/lib/lib/libpthread.a
$(EXEC) : $(ROOTDIR)/lib/libusb-0.1.12/libusb.a
$(EXEC) : $(ROOTDIR)/lib/lib/libnvram.a
$(EXEC) : $(ROOTDIR)/uClibc++/src/libstdc++.a
$(EXEC) : $(ROOTDIR)/lib/lib/librt.a


crc32.o: crc32.cpp $(CONF_H)
	$(CXX) $(CFLAGS) -DUSE_HOSTCC -I$(CONF) -I$(ZLIB_H) -c crc32.cpp -o $@

crc32.dep: crc32.cpp $(CONF_H)
	$(CXX) $(CFLAGS) -DUSE_HOSTCC -I$(CONF) -I$(ZLIB_H) -MM crc32.cpp -o $@

