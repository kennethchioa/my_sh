#!/bin/bash

for i in `ssh -l root $1 "virsh list --inactive" | awk '{print $2}' | grep SERVER`; do

	virsh -c qemu+tcp://$1/system start $i
	sleep 60

done;
