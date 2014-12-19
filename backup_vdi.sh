#!/bin/bash
for i in `collie vdi list | awk '{print $1}'| grep SERVER`; do
	echo $i
	sleep 10
	time nice ionice -c3 qemu-img convert -O raw sheepdog:$i /root/backup/$i
done
