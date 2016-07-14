TOPDIR=../
include $(TOPDIR)Rules.mak

MAJOR_VERSION = 0
MINOR_VERSION = 1
SUBLEVEL      = 12
VERSION       = $(MAJOR_VERSION).$(MINOR_VERSION).$(SUBLEVEL)

CFLAGS+=-DHAVE_CONFIG_H -Ilibusb

LIBUSB=libusb.a
LIBUSB_SHARED=libusb.so
LIBUSB_SHARED_FULLNAME=libusb-$(MAJOR_VERSION).$(MINOR_VERSION).$(SUBLEVEL).so

OBJS    := descriptors.o  error.o  linux.o  usb.o

all: $(LIBUSB)

$(OBJS): %.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@
	$(STRIPTOOL) -x -R .note -R .comment $*.o

shared: all
	$(LD) $(LDFLAGS) -soname=$(LIBUSB_SHARED).$(MAJOR_VERSION) \
		-o $(LIBUSB_SHARED_FULLNAME) --whole-archive $(LIBUSB) \
		--no-whole-archive $(TOPDIR)libc/misc/internals/interp.o \
		-L$(TOPDIR)lib -lc $(LDADD_LIBFLOAT) $(LIBGCC);
	$(LN) -sf $(LIBUSB_SHARED_FULLNAME) $(LIBUSB_SHARED)
	$(INSTALL) -d $(TOPDIR)lib
	$(RM) $(TOPDIR)lib/$(LIBUSB_SHARED_FULLNAME) $(TOPDIR)lib/$(LIBUSB_SHARED).$(MAJOR_VERSION)
	$(INSTALL) -m 644 $(LIBUSB_SHARED_FULLNAME) $(TOPDIR)lib
	$(LN) -sf $(LIBUSB_SHARED_FULLNAME) $(TOPDIR)lib/$(LIBUSB_SHARED)
	$(LN) -sf $(LIBUSB_SHARED_FULLNAME) $(TOPDIR)lib/$(LIBUSB_SHARED).$(MAJOR_VERSION)


$(LIBUSB) ar-target: $(OBJS)
	$(AR) $(ARFLAGS) $(LIBUSB) $(OBJS)
	$(INSTALL) -d $(TOPDIR)lib
	$(RM) $(TOPDIR)lib/$(LIBUSB)
	$(INSTALL) -m 644 $(LIBUSB) $(TOPDIR)lib

romfs:
	$(INSTALL) -m 644 $(LIBUSB_SHARED) $(TOPDIR)lib

$(OBJS): Makefile

clean:
	$(RM) *.[oa] $(LIBUSB_SHARED)* 

