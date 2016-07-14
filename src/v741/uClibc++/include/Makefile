TOPDIR=../
include $(TOPDIR)Rules.mak

all:

clean:

distclean:

HEADERS = $(filter-out .svn CVS Makefile,$(wildcard *))
install:

#tyranno remove heaer insalll
install_old:
	$(INSTALL) -d $(PREFIX)$(UCLIBCXX_RUNTIME_INCLUDEDIR)
	$(INSTALL) -m 644 $(HEADERS) $(PREFIX)$(UCLIBCXX_RUNTIME_INCLUDEDIR)
