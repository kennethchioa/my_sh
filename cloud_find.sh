#!/bin/bash
SERVERS="1 2 3 4 7 8 9 10 11 12"
READ=20971520
WRITE=10485760
for s in $SERVERS; do
server="kdsho$s.powere2e.com"
echo $server
ssh -l root $server "updatedb"
ssh -l root $server "locate $1"

done;
