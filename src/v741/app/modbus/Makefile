EXEC=modbus_tool

OBJS= config.o modbus.o serialMng.o socketMng.o toolMng.o bridgeMng.o modbus_util.o




DEPS = $(OBJS:.o=.dep)
DEPEND_FILE=dependency

PWD  = $(shell pwd)
INSTALL    = install

CFLAGS += -I$(ROOTDIR)/lib/include -I$(ROOTDIR) -I$(ROOTDIR)/lib/libnvram -I$(ROOTDIR)/$(LINUXDIR)/drivers/char
CFLAGS += -I$(PWD) -I$(PWD)/serialib 


CFLAGS += -I../lib/libmodule
CFLAGS += -I../lib/libctutil
CFLAGS += -I$(ROOTDIR)/lib/libusb-0.1.12
CFLAGS += -I$(ROOTDIR)/$(LINUXDIR)/include



LDFLAGS += -L../lib/libmodule -lmodule
LDFLAGS += -L../lib/libctutil -lctutil
LDFLAGS += -L$(ROOTDIR)/llib/ibpthread -lpthread
LDFLAGS += -L$(ROOTDIR)/lib/libnvram -lnvram
LDFLAGS += -L$(ROOTDIR)/lib/libusb-0.1.12 -lusb
LDFLAGS += -L$(ROOTDIR)/lib/librt -lrt




all: $(EXEC)


install: $(EXEC) 
	@$(INSTALL) -d $(ROOTDIR)/romfs/usr/sbin
	@sudo chmod +x $(EXEC)
	@sudo cp -f $(EXEC) $(ROOTDIR)/romfs/usr/sbin
	@sudo ln -sf /usr/sbin/modbus_tool $(ROOTDIR)/romfs/usr/sbin/modbus_bridge


clean:
	@rm -f *.o $(EXEC) $(DEPS) $(DEPEND_FILE)


dep:$(DEPS)
	@rm -f $(DEPEND_FILE)
	@for d in $(DEPS); do (cat $$d >> $(DEPEND_FILE)) done 

%.dep:%.cpp
	$(CXX) -MM -o  $@ $(CFLAGS) $<
%.dep:%.c
	$(CXX) -MM -o  $@ $(CFLAGS) $<

vpath %.cpp serialib
-include $(DEPEND_FILE)


$(EXEC) : ../lib/libqmi/libqmi.a ../lib/libctutil/libctutil.a ../lib/libled/libled.a ../lib/libmodule/libmodule.a
$(EXEC) : $(ROOTDIR)/lib/lib/libnvram.a
$(EXEC) : $(ROOTDIR)/uClibc++/src/libstdc++.a
