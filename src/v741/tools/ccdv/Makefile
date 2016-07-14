TARGET = ccdv
OBJS = ccdv.o

CFLAG = -c
LFLAG = -o

all:$(OBJS)
	$(CC) $(OBJS) $(LFLAG) $(TARGET)

%.o:%.c
	$(CC) $(CFLAG) $<
