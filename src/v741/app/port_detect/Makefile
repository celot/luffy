#PORT_DETECT MINITOR use y
USE_PORT_DETECT_MON=y

EXEC = port_detect

OBJS =  port_detect.o \
	portconfig.o \
	portchecker.o \
	portsender.o \
	portmail.o \
	port_check_item.o \
	port_sender_thread.o
ifeq ($(USE_PORT_DETECT_MON),y)
EXEC += port_dmon
OBJS_MON = port_dmon.o

CFLAGS += -DUSE_PORT_DETECT_MON
endif

DEPS = $(OBJS:.o=.dep) 
DEPEND_FILE=dependency
PWD  = $(shell pwd)
INSTALL    = install

CFLAGS += -I$(ROOTDIR) -I$(ROOTDIR)/lib/libnvram -I$(ROOTDIR)/$(LINUXDIR)/drivers/char
CFLAGS += -I$(PWD)
CFLAGS += -I../lib/libctutil

LDFLAGS += -L../lib/libctutil -lctutil
LDFLAGS += -L$(ROOTDIR)/llib/ibpthread -lpthread
LDFLAGS += -L$(ROOTDIR)/lib/libnvram -lnvram
LDFLAGS += -L$(ROOTDIR)/lib/librt -lrt

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

$(EXEC) : $(ROOTDIR)/uClibc++/src/libstdc++.a

