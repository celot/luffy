EXEC = upgrader

OBJS =  upgrader.o crc32.o flash_api.o boot_env.o

DEPS = $(OBJS:.o=.dep)
DEPEND_FILE=dependency
PWD  = $(shell pwd)
INSTALL    = install

CFLAGS += -I$(ROOTDIR) -I$(ROOTDIR)/lib/libnvram -I$(ROOTDIR)/$(LINUXDIR)/drivers/char
CFLAGS += -I$(PWD)
CFLAGS += -I$(ROOTDIR)/user/openssl-0.9.8e/include
CFLAGS += -I../lib/libctutil

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
	$(CXX) -MM -o  $@ $(CFLAGS) $<
	
-include $(DEPEND_FILE)

