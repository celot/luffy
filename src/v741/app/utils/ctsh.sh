#!/bin/sh

echo "Run Ctsh"

killall -USR1 ctsh
killall -USR1 ctsh_observer

rm -rf /var/run/ctsh.chk
rm /usr/sbin/ctsh_observer

cp /usr/sbin/app_observer /usr/sbin/ctsh_observer

ctsh_observer ctsh.sh /var/run/ctsh.chk 60 10

ctsh

