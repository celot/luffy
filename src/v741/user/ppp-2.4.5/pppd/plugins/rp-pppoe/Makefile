# Generated automatically from Makefile.in by configure.
#***********************************************************************
#
# Makefile
#
# Makefile for Roaring Penguin's Linux PPPoE plugin.
# Modified for integration with pppd sources by Paul Mackerras.
#
# Copyright (C) 2001 Roaring Penguin Software Inc.
#
# This program may be distributed according to the terms of the GNU
# General Public License, version 2 or (at your option) any later version.
#
# $Id: Makefile.linux,v 1.8 2008/06/09 08:34:23 paulus Exp $
#***********************************************************************

DESTDIR = $(INSTROOT)/usr/local
BINDIR = $(DESTDIR)/sbin
INSTALL	= install

# Version is set ONLY IN THE MAKEFILE!  Don't delete this!
RP_VERSION=3.8p

COPTS=-O2
CFLAGS=$(COPTS) -I../../../include '-DRP_VERSION="$(RP_VERSION)"'
all: rp-pppoe.so pppoe-discovery

pppoe-discovery: pppoe-discovery.o debug.o
	$(CC) -o pppoe-discovery pppoe-discovery.o debug.o

pppoe-discovery.o: pppoe-discovery.c
	$(CC) $(CFLAGS) -c -o pppoe-discovery.o pppoe-discovery.c

debug.o: debug.c
	$(CC) $(CFLAGS) -c -o debug.o debug.c

rp-pppoe.so: plugin.o discovery.o if.o common.o
	$(CC) -o rp-pppoe.so -shared plugin.o discovery.o if.o common.o

romfs: all
	$(ROMFSINST) /etc_ro/ppp/plugins/rp-pppoe.so
	$(ROMFSINST) /sbin/pppoe.sh

clean:
	rm -f *.o *.so pppoe-discovery

plugin.o: plugin.c
	$(CC) $(CFLAGS) -I../../.. -c -o plugin.o -fPIC plugin.c

discovery.o: discovery.c
	$(CC) $(CFLAGS) -I../../.. -c -o discovery.o -fPIC discovery.c

if.o: if.c
	$(CC) $(CFLAGS) -I../../.. -c -o if.o -fPIC if.c

common.o: common.c
	$(CC) $(CFLAGS) -I../../.. -c -o common.o -fPIC common.c

