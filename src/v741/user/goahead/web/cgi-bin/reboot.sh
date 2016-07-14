#!/bin/sh
echo "Content-type: text/html"
echo ""
echo "<body>rebooting</body>"

echo "Execute Auto Reboot"

baseDate=`date +%s -d '010101010113'`
now=`date +%s`
diff=`expr $now - $baseDate`

if [ $diff -gt 0 ]; then
    reboot_time=`date +'%Y.%m.%d %H:%M'`
    nvram_set 2860 lastRebootSched "$reboot_time"
    module reset
    reboot &
fi