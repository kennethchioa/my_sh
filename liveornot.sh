#!/bin/bash
#2013-01-08
for n in {50..200}; 
do
  host=10.204.2.$n
  ping -c1 $host &> /dev/null
 if [ $? = 0 ]; then
              echo "$host is UP"
              echo "$host" >> /root/alive.txt
else
              echo "$host is DOWN"
              echo "$host" >> /root/dead.txt  
 fi
done
