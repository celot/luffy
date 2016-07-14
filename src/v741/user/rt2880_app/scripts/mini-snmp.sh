#!/bin/sh

. /sbin/global.sh

/bin/snmpd -h localhost -c public &
