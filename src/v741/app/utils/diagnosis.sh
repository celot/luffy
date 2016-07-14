#!/bin/sh

echo "Run diagnosis"

killall -9 diagnosis
diagnosis_daemon&
