#!/bin/sh
######StartingGame#####
if test -f "ProcessID.txt"  ;then
	rm -Rf ProcessID.txt
fi
AllGameProcOrder="LoginD DLAgentD NDAgentD QHAgentD UCAgentD MGAgentD SNAgentD WDJAgentD CWAgentD NMAgentD UMAgentD XLAgentD FCAgentD BDAgentD PPSAgentD YYHAgentD SGAgentD SQAgentD OPAgentD AZAgentD"
for  GameProc in $AllGameProcOrder;
do
ncount=`ps -x | grep -v "grep" | grep "$PWD/$GameProc ../conf/$GameProc.conf" | wc -l`

if test $ncount -lt 1 ; then
	$PWD/$GameProc ../conf/$GameProc.conf&
	echo $GameProc $! >> ProcessID.txt
else
	echo $PWD"/$GameProc  already been started!"
fi;
sleep 1
done

######CheckingProcesses######
ProcessID=`cat ProcessID.txt`
ProcessSum=`cat ProcessID.txt | wc -l`
if test $ProcessSum -eq 8 ; then
	echo "All Game Processes started successful!"
else  
        echo "Warning! Some Game Processes missed!"
fi;
echo "Game Processes :"
echo $ProcessID
