KERNELZ = $(IMAGEDIR)/zImage
RAMDISK  = $(IMAGEDIR)/ramdisk
IMAGE = $(IMAGEDIR)/uImage
ROMFS_DIR = $(ROOTDIR)/romfs

RAMDISK_SIZE  := $(shell echo $(CONFIG_BLK_DEV_RAM_SIZE))
MKIMAGE_DIR = $(ROOTDIR)/user/mkimage
CUR_DIR = $(shell pwd)
COMP = lzma

ifeq ($(CONFIG_CARRIER_NZ),y)
	APPPEND_NZ=_nz
endif

RCS_FILE=rcS$(APPPEND_NZ)

ROMFS_DIRS = \
	tmp \
	bin \
	dev dev/pts \
	home \
	etc \
	etc_ro etc_ro/web etc_ro/ppp etc_ro/ppp/peers etc_ro/ppp/plugins etc_ro/ppp/3g \
	etc_ro/wlan etc_ro/Wireless etc_ro/xml etc_ro/usb \
	etc_ro/linuxigd etc_ro/Wireless/RT2860AP etc_ro/Wireless/RT61AP etc_ro/Wireless/iNIC \
	lib lib/modules lib/ipsec \
	mnt \
	proc \
	sbin \
	sys \
	system \
	media \
	usr usr/bin usr/sbin usr/codepages \
	var 

all: romfs image


clean:
	rm -f mkimage

romfs: 
	[ -d $(ROMFSDIR)/$$i ] || mkdir -p $(ROMFSDIR)
	for i in $(ROMFS_DIRS); do \
		[ -d $(ROMFSDIR)/$$i ] || mkdir -p $(ROMFSDIR)/$$i; \
	done
	#generate device node
ifneq	($(LINUXDIR),linux-2.4.x)
	@if [ \! -d $(ROMFSDIR)/dev ];then mkdir -p $(ROMFSDIR)/dev;fi;
	./makedevlinks $(ROMFSDIR)
endif
	$(ROMFSINST) $(RCS_FILE) /etc_ro/rcS
	chmod +x $(ROMFSDIR)/etc_ro/rcS

ifeq ($(CONFIG_CPRN_KLW),y)	
	$(ROMFSINST) default/jp_hitachi_kddi/RT2860_default_novlan /etc_ro/Wireless/RT2860AP/RT2860_default_novlan
	$(ROMFSINST) default/jp_hitachi_kddi/RT2860_default_vlan /etc_ro/Wireless/RT2860AP/RT2860_default_vlan
else ifeq ($(CONFIG_CPRW_KLW),y)
	$(ROMFSINST) default/jp_hitachi_kddi/RT2860_default_novlan /etc_ro/Wireless/RT2860AP/RT2860_default_novlan
	$(ROMFSINST) default/jp_hitachi_kddi/RT2860_default_vlan /etc_ro/Wireless/RT2860AP/RT2860_default_vlan
else ifeq ($(CONFIG_CPRN_NLW),y)
	$(ROMFSINST) default/jp_hitachi_ntt/RT2860_default_novlan /etc_ro/Wireless/RT2860AP/RT2860_default_novlan
	$(ROMFSINST) default/jp_hitachi_ntt/RT2860_default_vlan /etc_ro/Wireless/RT2860AP/RT2860_default_vlan
else ifeq ($(CONFIG_CPRW_NLW),y)
	$(ROMFSINST) default/jp_hitachi_ntt/RT2860_default_novlan /etc_ro/Wireless/RT2860AP/RT2860_default_novlan
	$(ROMFSINST) default/jp_hitachi_ntt/RT2860_default_vlan /etc_ro/Wireless/RT2860AP/RT2860_default_vlan
else ifeq ($(CONFIG_CPRN_NLW2),y)
	$(ROMFSINST) default/jp_hitachi_ntt/RT2860_default_novlan /etc_ro/Wireless/RT2860AP/RT2860_default_novlan
	$(ROMFSINST) default/jp_hitachi_ntt/RT2860_default_vlan /etc_ro/Wireless/RT2860AP/RT2860_default_vlan
else ifeq ($(CONFIG_CPRW_NLW2),y)
	$(ROMFSINST) default/jp_hitachi_ntt/RT2860_default_novlan /etc_ro/Wireless/RT2860AP/RT2860_default_novlan
	$(ROMFSINST) default/jp_hitachi_ntt/RT2860_default_vlan /etc_ro/Wireless/RT2860AP/RT2860_default_vlan
else
	$(ROMFSINST) default/jp_hitachi/RT2860_default_novlan /etc_ro/Wireless/RT2860AP/RT2860_default_novlan
	$(ROMFSINST) default/jp_hitachi/RT2860_default_vlan /etc_ro/Wireless/RT2860AP/RT2860_default_vlan
endif

	$(ROMFSINST) /etc_ro/inittab
	$(ROMFSINST) /etc_ro/motd
	$(ROMFSINST) -e CONFIG_CELOT_MTD_16M fstab_16M /etc/fstab
	$(ROMFSINST) -e CONFIG_CELOT_MTD_8M fstab_8M /etc/fstab
	$(ROMFSINST) /etc_ro/Wireless/RT3352_AP_2T2R-4L_V12.BIN

romfs.post:: 
	[ -d $(IMAGEDIR) ] || mkdir -p $(IMAGEDIR)
	
	#Squash File System
	 rm -f $(RAMDISK)  
	 sudo chown root:root -R $(ROMFSDIR) 
ifeq	($(LINUXDIR),linux-2.4.x)
	$(CONFIG_CROSS_COMPILER_PATH)/mksquashfs_lzma-3.0 $(ROMFSDIR) $(RAMDISK)
else
	#linux2.6.x support squashfs with lzma
ifeq	($(CONFIG_BLK_DEV_INITRD),)

ifeq	($(LINUXDIR),linux-2.6.21.x)
	$(CONFIG_CROSS_COMPILER_PATH)/mksquashfs_lzma-3.2 $(ROMFSDIR) $(RAMDISK)
endif
ifeq	($(LINUXDIR),linux-2.6.36.x)
	$(CONFIG_CROSS_COMPILER_PATH)/mksquashfs_lzma-4.2 $(ROMFSDIR) $(RAMDISK)
endif
endif
endif
	sudo chown `id -u`:`id -g` -R $(ROMFSDIR)

ifeq	($(CONFIG_BLK_DEV_INITRD),y)
ifeq	($(LINUXDIR),linux-2.4.x)
	gzip -9 -f $(RAMDISK)
	cp $(RAMDISK).gz $(ROOTDIR)/$(LINUXDIR)/arch/mips/ramdisk/ramdisk.gz 2>/dev/null
endif
endif


mkimage: $(MKIMAGE_DIR)/crc32.c $(MKIMAGE_DIR)/mkimage.c 
	$(HOSTCC) $(HOST_CFLAGS) -DUSE_HOSTCC -o $@ -I$(MKIMAGE_DIR)/include $^ 

image: mkimage
	$(CROSS_COMPILE)objcopy -O binary -R .note -R .comment -S $(ROOTDIR)/$(LINUXDIR)/vmlinux  $(KERNELZ)
	cd $(IMAGEDIR) ; rm -f $(KERNELZ).*; $(COMP) -9 -f -S .$(COMP) $(KERNELZ)

ifeq	($(CONFIG_BLK_DEV_INITRD),)
ifeq	($(CONFIG_ROOTFS_IN_FLASH_NO_PADDING),)
	@#============================================================
	@# uboot hdr(64B) + mtdblock0(192KB) + mtdblock1(64KB) + 
	@# mtdblock2(64KB) + mtdblock3 + mtdblock4 + mtdblock5
	@# 
	@# Padding size of mtdblock3 is equal to "MTD_KRN_PART_SIZE 
	@# - 64B - the size of compressed kernel image"
	@#
	@# In Other Words:
	@# MTD Kernel Partition Size is MUST bigger than 
	@# "Original Kernel Image Size + 64B"
	@#============================================================
	#========<< This is README not Warning Message>>==============
	# Please make sure that original kernel image size can't 
	# bigger or equal to Kernel Partition Size. 
	#
	# For Example:
	# 
	# Original kernel image size is 563421 Bytes(0x898DD Bytes).
	# Flash sector size is 0x10000, so MTD kernel 
	# partition size MUST bigger than 0x90000.
	#
	# #make menuconfig
	#
	# Kernel/Library/Defaults Selection  --->
	#   [*] Customize Kernel Settings (NEW)
	#      Machine selection  --->
	#        (90000) MTD Kernel Partition Size (Unit:Bytes)
	#=============================================================
	# Original Kernel Image Size
	  @wc -c $(KERNELZ).$(COMP)
	# Padded Kernel Image Size 
ifeq    ($(findstring 0x, $(CONFIG_MTD_KERNEL_PART_SIZ)),0x)
	  @SIZE=`wc -c $(KERNELZ).$(COMP) | awk '{ print $$1 }'` ; \
	   MTD_KRN_PART_SIZE=`printf "%d" $(CONFIG_MTD_KERNEL_PART_SIZ)` ; \
	   PAD=`expr $$MTD_KRN_PART_SIZE - 64 - $$SIZE` ; \
	   dd if=/dev/zero count=1 bs=$$PAD 2> /dev/null | tr \\000 \\377 >> $(KERNELZ).$(COMP)
else
	  @SIZE=`wc -c $(KERNELZ).$(COMP) | awk '{ print $$1 }'` ; \
	   MTD_KRN_PART_SIZE=`printf "%d" 0x$(CONFIG_MTD_KERNEL_PART_SIZ)` ; \
	   PAD=`expr $$MTD_KRN_PART_SIZE - 64 - $$SIZE` ; \
	   dd if=/dev/zero count=1 bs=$$PAD 2> /dev/null | tr \\000 \\377 >> $(KERNELZ).$(COMP)
endif
endif
	@wc -c $(KERNELZ).$(COMP)
	# Original RootFs Size 
	  @du -sb $(ROMFSDIR)
	# Compressed RootFs Size 
	  @wc -c $(RAMDISK)
	# Padded Kernel Image + Compressed Rootfs Size
	  @cat $(RAMDISK) >> $(KERNELZ).$(COMP) 
	  @wc -c $(KERNELZ).$(COMP)
	#===========================================
endif

ifeq	($(CONFIG_ROOTFS_IN_FLASH_NO_PADDING),y)
	@cd $(IMAGEDIR) ; \
	ISIZE=`wc -c $(KERNELZ).$(COMP) | awk '{print $$1}'` ; \
	RSIZE=`wc -c $(RAMDISK) | awk '{print $$1}'` ; \
	KRN_SIZE=`expr $$ISIZE - $$RSIZE + 64` ; \
	ENTRY=`readelf -h $(ROOTDIR)/$(LINUXDIR)/vmlinux | grep "Entry" | awk '{print $$4}'` ; \
	$(CUR_DIR)/mkimage -A mips -O linux -T kernel -C $(COMP) -a 80000000 -e $$ENTRY -k $$KRN_SIZE -n "Linux Kernel Image" -d $(KERNELZ).$(COMP) $(IMAGE)
else
	@cd $(IMAGEDIR) ; $(CUR_DIR)/mkimage -A mips -O linux -T kernel -C $(COMP) -a 80000000 -e $(shell readelf -h $(ROOTDIR)/$(LINUXDIR)/vmlinux | grep "Entry" | awk '{print $$4}') -n "$(CTR_VER)" -d $(KERNELZ).$(COMP) $(IMAGE)
endif

# 2015.01.08 by unyou for HITACHI : change for print Model and version	 :: "Linux Kernel Image" -> $(CTR_VER) 
CTR_VER=$(shell ./ctr_get_version.sh)
	


