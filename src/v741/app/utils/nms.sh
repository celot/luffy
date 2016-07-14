#!/bin/sh

nmsReport=`nvram_get 2860 nmsReport`
nmsRemote=`nvram_get 2860 nmsRemote`

if [ "$nmsReport" != "Enable" -a "$nmsRemote" != "Enable" ]; then
    killall -9 nmsd
    exit 0
fi

echo "Run nmsd"
killall -9 nmsd
nmsd &

