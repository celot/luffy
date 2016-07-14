
LIB=libqmi.a
LDFLAGS =  --warn-common --warn-once -z combreloc -z defs

INSTALL    = install
LN		   = ln

CFLAGS += -I$(ROOTDIR)/lib/include -I$(ROOTDIR)/$(LINUXDIR)/drivers/char 
CFLAGS += -I$(ROOTDIR)/$(LINUXDIR)/include

OBJS	:= qmi.o qmi_common.o qmi_ctl.o qmi_wds.o qmi_dms.o qmi_nas.o qmi_wms.o
HEADERS := qmi.h
DEPS = $(OBJS:.o=.dep)
DEPEND_FILE=dependency

all:	$(LIB)  

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@
	@$(STRIPTOOL) -x -R .note -R .comment $*.o
	
.cpp.o:
	$(CXX) $(CFLAGS) -c $< -o $@
	@$(STRIPTOOL) -x -R .note -R .comment $*.o	


$(LIB) ar-target: $(OBJS)
	$(AR) $(ARFLAGS) $(LIB) $(OBJS)

$(OBJS): $(HEADERS) Makefile

install : 
	@echo noop
	
clean:
	@$(RM) *.[oa] 
	@rm -f $(DEPS) $(DEPEND_FILE)
	
dep:$(DEPS)
	@rm -f $(DEPEND_FILE)
	@for d in $(DEPS); do (cat $$d >> $(DEPEND_FILE)) done 

%.dep:%.c
	$(CC) -MM -o  $@ $(CFLAGS) $<

-include $(DEPEND_FILE)

