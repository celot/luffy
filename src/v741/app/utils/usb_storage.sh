#!/bin/sh
rmmod nls_cp437.ko
rmmod nls_cp949.ko
rmmod nls_iso8859-1.ko
rmmod nls_utf8.ko
rmmod usb-storage.ko
rmmod sd_mod.ko
rmmod scsi_wait_scan.ko
rmmod vfat.ko
rmmod ntfs.ko
rmmod msdos.ko
rmmod scsi_mod.ko
rmmod fat.ko
rmmod nls_base.ko

insmod nls_base.ko
insmod nls_cp437.ko
insmod nls_cp949.ko
insmod nls_iso8859-1.ko
insmod nls_utf8.ko
insmod fat.ko
insmod vfat.ko
insmod ntfs.ko
insmod msdos.ko
insmod scsi_mod.ko
insmod scsi_wait_scan.ko
insmod sd_mod.ko
insmod usb-storage.ko

if [ ! -f /dev/sda ]; then
	mknod /dev/sda b 8 0
fi
if [ ! -f /dev/sda1 ]; then
	mknod /dev/sda1 b 8 1
fi

if [ ! -f /dev/sda ]; then
	mknod /dev/sdb b 8 16
fi
if [ ! -f /dev/sda1 ]; then
	mknod /dev/sdb1 b 8 17
fi

#mkdir /usb
#mount /dev/sda1 /usb

