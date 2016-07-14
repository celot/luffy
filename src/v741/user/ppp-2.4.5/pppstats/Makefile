#
# pppstats makefile
# $Id: Makefile.linux,v 1.9 2006/06/04 05:07:46 paulus Exp $
#

PPPSTATSRCS = pppstats.c
PPPSTATOBJS = pppstats.o

COPTS = -O
COMPILE_FLAGS = -I../include
LIBS =


CFLAGS = $(COPTS) $(COMPILE_FLAGS)

all: pppstats

romfs: pppstats
	$(ROMFSINST) /bin/pppstats

pppstats: $(PPPSTATSRCS)
	$(CC) $(CFLAGS) -o pppstats pppstats.c $(LIBS)

clean:
	rm -f pppstats *~ #* core

depend:
	cpp -M $(CFLAGS) $(PPPSTATSRCS) >.depend
#	makedepend $(CFLAGS) $(PPPSTATSRCS)
