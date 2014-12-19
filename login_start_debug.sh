#!/bin/sh
######StartingLogin#####
if test -f "ProcessID.txt"  ;then
	rm -Rf ProcessID.txt
fi
ncount=`ps -x | grep -v "grep" | grep "$PWD/LoginD ../conf/Login.conf" | wc -l`
if test $ncount -lt 1 ; then
	$PWD/LoginD ../conf/Login.conf&
	echo LoginD $! >> ProcessID.txt
else
	echo $PWD"/LoginD  already been started!"
fi;
sleep 1

######StartingAgent#####
AllSDKOrder="DL ND QH UC MG SN WDJ CW NM UM XL FC BD PPS YYH SG SG1 SQ OP AZ PPZ TBT"
for  SDK in $AllSDKOrder;
do
AgentProc=SDK"Agent"
AgentDProc=SDK"AgentD"
ncount=`ps -x | grep -v "grep" | grep "$PWD/$AgentDProc ../conf/$AgentProc.conf" | wc -l`

if test $ncount -lt 1 ; then
	$PWD/$AgentDProc ../conf/$AgentProc.conf&
	echo $AgentDProc $! >> ProcessID.txt
else
	echo $PWD"/$AgentDProc  already been started!"
fi;
sleep 1
done

######CheckingProcesses######
ProcessID=`cat ProcessID.txt`
ProcessSum=`cat ProcessID.txt | wc -l`
if test $ProcessSum -eq 23 ; then
	echo "All Agent Processes started successful!"
else  
        echo "Warning! Some Agent Processes missed!"
fi;
echo "Agent Processes :"
echo $ProcessID
