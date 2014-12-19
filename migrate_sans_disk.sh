#!/bin/bash

#./migrate.sh kdsho2.powere2e.com TEST
#Migrate to host kdsho2.powere2e.com guests with TEST in their name

for i in `virsh list | awk '{print $2}' | grep $2`; do
	sleep 10
	time virsh migrate --verbose --live --persistent --undefinesource --domain $i --desturi qemu+ssh://root@$1/system
done

