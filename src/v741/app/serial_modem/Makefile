EXEC = ct_chat sm_launcher
#EXEC += serial_modem

OBJS = main_control.o \
	modem_control.o \
	main.o 

CT_CHAT_OBJ = ct_chat.o

SM_LAUNCHER_OBJ = sm_launcher.o

DEPS = $(OBJS:.o=.dep) $(CT_CHAT_OBJ:.o=.dep) $(SM_LAUNCHER_OBJ:.o=.dep)
DEPEND_FILE=dependency
PWD  = $(shell pwd)
INSTALL    = install


CFLAGS += -I$(ROOTDIR)/lib/include -I$(ROOTDIR) -I$(ROOTDIR)/lib/libnvram -I$(ROOTDIR)/$(LINUXDIR)/drivers/char
CFLAGS += -I$(PWD)
CFLAGS += -I../lib/libmodule
CFLAGS += -I../lib/libctutil
CFLAGS += -I$(ROOTDIR)/lib/libusb-0.1.12

LDFLAGS += -L../lib/libmodule  -lmodule
LDFLAGS += -L../lib/libctutil -lctutil
LDFLAGS += -L$(ROOTDIR)/uClibc++/src -lstdc++
LDFLAGS += -L$(ROOTDIR)/llib/ibpthread -lpthread
LDFLAGS += -L$(ROOTDIR)/lib/libnvram -lnvram
LDFLAGS += -L$(ROOTDIR)/lib/libusb-0.1.12 -lusb
	

all: $(EXEC)

	
install: $(EXEC) 
	@$(INSTALL) -d $(ROOTDIR)/romfs/usr/sbin
	@sudo cp -f $(EXEC) $(ROOTDIR)/romfs/usr/sbin
	@sudo ln -sf /usr/sbin/ct_chat $(ROOTDIR)/romfs/usr/sbin/disct_chat

clean:
	@rm -f *.o $(EXEC) $(DEPS) $(DEPEND_FILE)

dep:$(DEPS)
	@rm -f $(DEPEND_FILE)
	@for d in $(DEPS); do (cat $$d >> $(DEPEND_FILE)) done 

%.dep:%.cpp
	$(CXX) -MM -o  $@ $(CFLAGS) $<
	
-include $(DEPEND_FILE)
serial_modem :../lib/libctutil/libctutil.a ../lib/libmodule/libmodule.a

