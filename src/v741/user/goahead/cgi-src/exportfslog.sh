#!/bin/sh
echo "Pragma: no-cache\n"
echo "Cache-control: no-cache\n"
echo "Content-type: application/octet-stream"
echo "Content-Transfer-Encoding: binary"			#  "\n" make Un*x happy
echo "Content-Disposition: attachment; filename=\"fslog.log\""
echo ""

echo "Fail Safe Log"
if [ -f /system/fslog.log.bak ]; then  cat /system/fslog.log.bak 2>/dev/null; fi
if [ -f /system/fslog.log ]; then  cat /system/fslog.log 2>/dev/null; fi

