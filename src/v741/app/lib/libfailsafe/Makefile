LIBLED=libfailsafe.a

CFLAGS += -I$(ROOTDIR)/$(LINUXDIR)/include

LDFLAGS =  --warn-common --warn-once -z combreloc -z defs

OBJS	:= fslog.o
HEADERS := fslog.h
DEPS = $(OBJS:.o=.dep)
DEPEND_FILE=dependency

all:	$(LIBLED) 

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@
	@$(STRIPTOOL) -x -R .note -R .comment $*.o
	
.cpp.o:
	$(CXX) $(CFLAGS) -c $< -o $@
	@$(STRIPTOOL) -x -R .note -R .comment $*.o	


$(LIBLED) ar-target: $(OBJS)
	$(AR) $(ARFLAGS) $(LIBLED) $(OBJS)

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
	
