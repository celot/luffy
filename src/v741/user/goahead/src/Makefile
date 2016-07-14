#
# Makefile for the GoAhead web server reference source base
#  for the uClinux OS
#
# Copyright (c) GoAhead Software, Inc. 1995-2000
#
# $Id: Makefile,v 1.69.2.5 2012-03-30 12:31:45 chhung Exp $
#

NAME	= goahead


all:	$(NAME)


romfs:
	@sudo chmod +x $(NAME)
	$(ROMFSINST) /bin/$(NAME)
ifeq ("$(CONFIG_USER_GOAHEAD_SSL)", "y")
	$(ROMFSINST) /etc_ro/serverkey.pem
	$(ROMFSINST) /etc_ro/servercert.pem
endif

clean:
	rm -f $(NAME) *.o

clean_inet:
	rm -f internet.o

$(DEPEND_FILES):$(ROOT_CONFIG)

