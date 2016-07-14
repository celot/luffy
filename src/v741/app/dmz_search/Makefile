EXEC = dmz_search

OBJS =  dmz_search.o

DEPS = $(OBJS:.o=.dep)
DEPEND_FILE=dependency
PWD  = $(shell pwd)
INSTALL    = install


CFLAGS += -I$(ROOTDIR)/lib/include -I$(ROOTDIR) -I$(ROOTDIR)/lib/libnvram -I$(ROOTDIR)/$(LINUXDIR)/drivers/char
CFLAGS += -I$(PWD)

LDFLAGS	+= -L$(ROOTDIR)/lib/libnvram -lnvram

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

%.dep:%.c
	$(CC) -MM -o  $@ $(CFLAGS) $<
	
-include $(DEPEND_FILE)
