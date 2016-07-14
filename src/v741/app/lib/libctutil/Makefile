LIBNAME = ctutil
LIB=lib$(LIBNAME).a

CFLAGS += -I$(shell pwd)
CFLAGS += -I$(ROOTDIR)/lib/include -I$(ROOTDIR)/$(LINUXDIR)/include -I$(ROOTDIR)/lib/libnvram

OBJS	:= basethread.o \
			sysutil.o \
			queue_imp.o \
			queue.o \
			timer.o \
			event.o \
			control.o \
			nvram_wrap.o \
			ping.o
			
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

$(OBJS):$(ROOTDIR)/.config

