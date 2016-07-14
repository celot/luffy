#
#	Makefile -- Build instructions for celot
#

.EXPORT_ALL_VARIABLES:

#include  $(ROOTDIR)/lib/Rules.mak

SUB_DIR = libctutil \
           libled \
           libqmi \
           libmodule 

SUB_DIR += libfailsafe

all: 
	for d in $(SUB_DIR); do ($(MAKE) -C $$d) done	

dep:
	for d in $(SUB_DIR); do ($(MAKE) -C $$d dep) done

install:
	for d in $(SUB_DIR); do ($(MAKE) -C $$d install) done	

clean:
	for d in $(SUB_DIR); do ($(MAKE) -C $$d clean) done	
