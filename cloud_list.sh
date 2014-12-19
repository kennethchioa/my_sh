#!/bin/bash
SERVERS="1 2 3 4 7 8 9 10 11 12"
READ=20971520
WRITE=10485760
for s in $SERVERS; do
sleep 1
echo $s
virsh -c qemu+tcp://kdsho$s.powere2e.com/system list --all | grep "$1"
sleep 1
done;
