#!/bin/sh

if [ -f "/var/run/udhcpc_lte.pid" ]; then
     kill -9 `cat /var/run/udhcpc_lte.pid`
fi

ifconfig $1 down
ifconfig $1 up
ifconfig $1 0.0.0.0
udhcpc -i $1 -s /sbin/udhcpc_lte.sh -p /var/run/udhcpc_lte.pid &
