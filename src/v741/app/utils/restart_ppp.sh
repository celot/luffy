#!/bin/sh

echo "Restart DirectSerial"
killall -9 directserial
directserial&

exit 0

