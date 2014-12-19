#!/bin/bash
SERVERS="1 2 3 4"
READ=20971520
WRITE=10485760
for s in $SERVERS; do
sleep 1
echo $s
virsh -c qemu+ssh://kvm$s.powere2e.com/system list --all | grep "$1"
sleep 1
done;
