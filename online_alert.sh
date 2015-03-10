#!/bin/bash
#author kenneth.chioa
#for check online connections
#date 2015-02-21

alert_threshold='100'
host_tag=`/bin/hostname -f`
mail_to_list=("13816656813@139.com" "kikoyywd@139.com")
online_total=`netstat -n | grep 8080 |awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'`
online_EST=`netstat -n | grep 8080 |awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}' | grep "ESTABLISHED"`
online_EST_count=`netstat -n | grep 8080 |awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}' | grep "ESTABLISHED" | awk '{print $2}'`
if [ ${online_EST_count} -lt ${alert_threshold} ]
    then 
for mail in ${mail_to_list}
do
    /usr/bin/mail -s "Monsu Online Alert" ${mail} << EOF
VM Host is ${host_tag}
Total Count is ${online_total}
Warring!!ESTABLISHED Count is ${online_EST_count} < ${alert_threshold}
EOF
done
fi
