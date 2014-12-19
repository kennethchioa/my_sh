#!/bin/bash

SERVERS="1 2 3 4 7 8 9 10 11 12"
for s in $SERVERS; do
server="kdsho$s.powere2e.com"
echo $server
LIST=`ssh -l root $server "ls /sys/fs/cgroup/blkio/libvirt/qemu" | grep SERVER`
	for i in $LIST;  do
		echo $i
		ssh -l root $server " echo '252:1 10485760' > /sys/fs/cgroup/blkio/libvirt/qemu/$i/blkio.throttle.write_bps_device"
		ssh -l root $server " echo '252:1 20971520' > /sys/fs/cgroup/blkio/libvirt/qemu/$i/blkio.throttle.read_bps_device"
		ssh -l root $server "cat /sys/fs/cgroup/blkio/libvirt/qemu/$i/blkio.throttle.read_bps_device"
		ssh -l root $server "cat /sys/fs/cgroup/blkio/libvirt/qemu/$i/blkio.throttle.write_bps_device"
done;

done;
