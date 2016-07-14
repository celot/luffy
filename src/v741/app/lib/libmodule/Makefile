LIBNAME = module
LIB=lib$(LIBNAME).a

CFLAGS += -I$(ROOTDIR)/lib/include -I$(ROOTDIR)/$(LINUXDIR)/drivers/char 
CFLAGS += -I$(shell pwd)
CFLAGS += -I$(ROOTDIR)/$(LINUXDIR)/include
CFLAGS += -I$(ROOTDIR)/lib/libusb-0.1.12
CFLAGS += -I$(ROOTDIR)/$(LINUXDIR)/drivers/net/rt_rdm
CFLAGS += -I../libctutil

OBJS	:= utils.o devfile_at.o socket_mm.o sms.o crcchecker.o
HEADERS := utils.h
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

install:
	@echo "noop"

clean:
	@$(RM) *.[oa] lib$(LIBNAME)*
	@rm -f $(DEPS) $(DEPEND_FILE)
	@rm -f $(ROOTDIR)/romfs/lib/lib$(LIBNAME)*
	
dep:$(DEPS)
	@rm -f $(DEPEND_FILE)
	@for d in $(DEPS); do (cat $$d >> $(DEPEND_FILE)) done 

%.dep:%.c
	$(CC) -MM -o  $@ $(CFLAGS) $<

%.dep:%.cpp
	$(CC) -MM -o  $@ $(CFLAGS) $<

-include $(DEPEND_FILE)

