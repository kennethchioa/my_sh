#!/bin/bash

#./migrate.sh kdsho2.powere2e.com TEST
#Migrate to host kdsho2.powere2e.com guests with TEST in their name

for i in `virsh list | awk '{print $2}' | grep $2`; do
sleep 30
if [ -e /var/lib/libvirt/images/$i.qcow2 ]; then
	sleep 10
	SIZE=`qemu-img info /var/lib/libvirt/images/$i.qcow2 | grep virtual | awk '{ print $4 }' | sed 's/(//'`
	ssh $1 "qemu-img create -f qcow2 /var/lib/libvirt/images/$i.qcow2 $SIZE"
	sleep 10
	time virsh migrate --verbose --live --copy-storage-all --persistent --undefinesource --domain $i --desturi qemu+tcp://$1/system
	RUNNING=`virsh list --all | grep $i | wc -l`
	if [ $RUNNING -eq 0 ]; then
		if [ -e /var/lib/libvirt/images/$i.qcow2.bz2 ]; then
			rm /var/lib/libvirt/images/$i.qcow2.bz2
		fi
		time nice ionice -c3 bzip2 -v /var/lib/libvirt/images/$i.qcow2
	fi
fi
done

