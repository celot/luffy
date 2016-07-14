include $(ROOTDIR)/.config

ifeq ($(CONFIG_CPRN_KLW),y) 
CFLAGS += -DCONFIG_CPRN_KLW
else ifeq ($(CONFIG_CPRW_KLW),y) 
CFLAGS += -DCONFIG_CPRW_KLW
else ifeq ($(CONFIG_CPRN_NLW),y) 
CFLAGS += -DCONFIG_CPRN_NLW
else ifeq ($(CONFIG_CPRW_NLW),y) 
CFLAGS += -DCONFIG_CPRW_NLW
else ifeq ($(CONFIG_CPRN_NLW2),y) 
CFLAGS += -DCONFIG_CPRN_NLW
else ifeq ($(CONFIG_CPRW_NLW2),y) 
CFLAGS += -DCONFIG_CPRW_NLW
endif

obj-m := netcheck.o

all : 

	
clean:
	@echo "clean..."
	@$(RM) -rf *.ko *.mod.* .*.cmd *.o .tmp_versions Module.symvers *.order

install:
	@sudo cp -f netcheck.ko $(ROOTDIR)/romfs/lib


	
dep:
	@echo "dep"

.c.o:
	$(CC) -c $(CFLAGS) $<

.cpp.o:
	$(CXX) -c $(CFLAGS) $<

