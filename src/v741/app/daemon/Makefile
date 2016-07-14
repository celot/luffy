EXEC = ct_daemon

OBJS =  daemon.o

DEPS = $(OBJS:.o=.dep)
DEPEND_FILE=dependency
PWD  = $(shell pwd)
INSTALL    = install


CFLAGS += -I$(ROOTDIR)/lib/include -I$(ROOTDIR) -I$(ROOTDIR)/lib/libnvram -I$(ROOTDIR)/$(LINUXDIR)/drivers/char
CFLAGS += -I$(PWD)
CFLAGS += -I../lib/libfailsafe

LDFLAGS	+= -L$(ROOTDIR)/lib/libnvram -lnvram
LDFLAGS += -L../lib/libfailsafe -lfailsafe

all: $(EXEC)


install: $(EXEC)
	@$(INSTALL) -d $(ROOTDIR)/romfs/usr/sbin
	@sudo cp -f $(EXEC) $(ROOTDIR)/romfs/usr/sbin

clean:
	@rm -f *.o $(EXEC) $(DEPS) $(DEPEND_FILE)

dep:$(DEPS)
	@rm -f $(DEPEND_FILE)
	@for d in $(DEPS); do (cat $$d >> $(DEPEND_FILE)) done 

%.dep:%.c
	$(CC) -MM -o  $@ $(CFLAGS) $<
	
-include $(DEPEND_FILE)
