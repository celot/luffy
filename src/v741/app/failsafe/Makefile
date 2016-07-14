EXEC = failsafe 

OBJS =  main.o \
	failsafe.o \
	ctl_chcker.o \
	ctl_data.o \
	ctl_conn.o \
	ctl_reboot.o

DEPS = $(OBJS:.o=.dep)  $(MM_OBJS:.o=.dep)
DEPEND_FILE=dependency
PWD  = $(shell pwd)
INSTALL    = install

CFLAGS += -I$(ROOTDIR)/lib/include -I$(ROOTDIR) -I$(ROOTDIR)/lib/libnvram
CFLAGS += -I$(PWD)
CFLAGS += -I../lib/libctutil
CFLAGS += -I../lib/libfailsafe

LDFLAGS += -L../lib/libctutil -lctutil
LDFLAGS += -L$(ROOTDIR)/lib/libnvram -lnvram
LDFLAGS += -L$(ROOTDIR)/llib/ibpthread -lpthread
LDFLAGS += -L$(ROOTDIR)/lib/librt -lrt
LDFLAGS += -L../lib/libfailsafe -lfailsafe

ifeq ("$(CONFIG_CPRN_KLW)", "y")
CFLAGS	+= -DCONFIG_CPRN_KLW
else ifeq ("$(CONFIG_CPRW_KLW)", "y")
CFLAGS	+= -DCONFIG_CPRN_KLW
else ifeq ("$(CONFIG_CPRN_NLW)", "y")
CFLAGS	+= -DCONFIG_CPRN_NLW
else ifeq ("$(CONFIG_CPRW_NLW)", "y")
CFLAGS	+= -DCONFIG_CPRW_NLW
else ifeq ("$(CONFIG_CPRN_NLW2)", "y")
CFLAGS	+= -DCONFIG_CPRN_NLW2
else ifeq ("$(CONFIG_CPRW_NLW2)", "y")
CFLAGS	+= -DCONFIG_CPRW_NLW2
endif

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


