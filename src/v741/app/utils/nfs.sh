#!/bin/sh

rmmod nfs
rmmod nfs_acl
rmmod rpcsec_gss_spkm3
rmmod rpcsec_gss_krb5
rmmod auth_rpcgss
rmmod lockd
rmmod sunrpc

insmod sunrpc.ko
insmod lockd.ko
insmod auth_rpcgss.ko
insmod rpcsec_gss_krb5.ko
insmod rpcsec_gss_spkm3.ko
insmod nfs_acl.ko
insmod nfs.ko

