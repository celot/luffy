# 
SYSCONFDIR=	/etc
SBINDIR=	/sbin
LIBEXECDIR=	/libexec
DBDIR=		/var/db
RUNDIR=		/var/run
LIBDIR=		/lib
MANDIR=		/usr/share/man
CC=		/opt/buildroot-gcc342/bin/mipsel-linux-uclibc-gcc
SRCS+=		bpf.c if-bsd.c platform-bsd.c
