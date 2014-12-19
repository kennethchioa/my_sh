#!/bin/bash
ip link set tun0 up
ip addr add 10.204.7.170/32 peer 10.204.7.171 dev tun0
arp -sD 10.204.7.171 eth0 pub
