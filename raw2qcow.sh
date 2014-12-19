#!/bin/bash
for i in `ls /root/kdsho11/root/backup/ | grep $1`; do
	echo $i
	sleep 10
	time qemu-img convert -O qcow2 /root/kdsho11/root/backup/$i /var/lib/libvirt/images/$i.qcow2
done
