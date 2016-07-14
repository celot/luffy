#!/bin/sh

systemReport=`nvram_get 2860 systemReport`
if [ "$systemReport" != "Enable" ]; then
    killall -9 report_status
    exit 0
fi

echo "Run ReportStatus"
killall -9 report_status
report_status &

