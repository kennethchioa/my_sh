#!/bin/bash

#./migrate.sh kdsho2.powere2e.com TEST
#Migrate to host kdsho2.powere2e.com guests with TEST in their name

for i in `ssh -l root $1 "virsh list" | awk '{print $2}' | grep $3`; do

	echo "Transfering $i from $1 to $2"
	sleep 10
	SIZE=`ssh -l root $1 "qemu-img info /var/lib/libvirt/images/$i.qcow2" | grep virtual | awk '{ print $4 }' | sed 's/(//'`
	#echo $SIZE

	echo "Create new disk image of size $SIZE"
	ssh -l root $2 "qemu-img create -f qcow2 /var/lib/libvirt/images/$i.qcow2 $SIZE"
	sleep 10

	echo "Migrate"
	time virsh -c qemu+tcp://$1/system migrate --verbose --live --copy-storage-all --persistent --undefinesource --domain $i --desturi qemu+ssh://$2/system
	rsync -aP $1:/var/lib/libvirt/images/$i* /root/archive/
	sleep 10

	echo "Set Disk IO"
	ssh -l root $2 "echo '252:1 10485760' > /sys/fs/cgroup/blkio/libvirt/qemu/$i/blkio.throttle.write_bps_device"
	ssh -l root $2 "echo '252:1 20971520' > /sys/fs/cgroup/blkio/libvirt/qemu/$i/blkio.throttle.read_bps_device"
	ssh -l root $2 "cat /sys/fs/cgroup/blkio/libvirt/qemu/$i/blkio.throttle.read_bps_device"
	ssh -l root $2 "cat /sys/fs/cgroup/blkio/libvirt/qemu/$i/blkio.throttle.write_bps_device"
	sleep 10

#ssh -l root $1 "mv -v /var/lib/libvirt/images/$i.qcow2"

done;

for i in `ssh -l root $1 "virsh list" | awk '{print $2}' | grep $3`; do
	bzip2 -vf /var/lib/libvirt/images/$i*
	ssh -l root $1 "nice ionice -c3 bzip2 -vf /var/lib/libvirt/images/$i*"
done;
