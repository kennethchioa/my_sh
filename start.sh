rm *Port
if test -f "ProcessID.txt"  ;then
	rm -Rf ProcessID.txt
fi

ncount=`ps | grep "$PWD/LogD ../conf/Log.conf 7150" | wc -l`

if test $ncount -lt 2 ; then
	$PWD/LogD ../conf/Log.conf 7150&
	echo $! >> ProcessID.txt
else
	echo "$PWD/LogD already been started!"
fi;
sleep 1

ncount=`ps | grep "$PWD/ManagerD ../conf/Manager.conf 7150" | wc -l`

if test $ncount -lt 2 ; then
	$PWD/ManagerD ../conf/Manager.conf 7150&
	echo $! >> ProcessID.txt
else
	echo "$PWD/ManagerD already been started!"
fi;
sleep 1

ncount=`ps | grep "$PWD/ArenaD ../conf/Arena.conf 7150" | wc -l`

if test $ncount -lt 2 ; then
	$PWD/ArenaD ../conf/Arena.conf 7150&
	echo $! >> ProcessID.txt
else
	echo "$PWD/ArenaD already been started!"
fi;
sleep 1

ncount=`ps | grep "$PWD/AssistantD ../conf/Assistant.conf 7150" | wc -l`

if test $ncount -lt 2 ; then
	$PWD/AssistantD ../conf/Assistant.conf 7150&
	echo $! >> ProcessID.txt
else
	echo "$PWD/AssistantD already been started!"
fi;
sleep 1

ncount=`ps | grep "$PWD/ChatD ../conf/Chat.conf 7150" | wc -l`

if test $ncount -lt 2 ; then
	$PWD/ChatD ../conf/Chat.conf 7150&
	echo $! >> ProcessID.txt
else
	echo "$PWD/ChatD already been started!"
fi;
sleep 1

ncount=`ps | grep "$PWD/BattleD ../conf/Battle.conf 7150" | wc -l`

if test $ncount -lt 2 ; then
	$PWD/BattleD ../conf/Battle.conf 7150&
	echo $! >> ProcessID.txt
else
	echo "$PWD/BattleD already been started!"
fi;
sleep 1

ncount=`ps | grep "$PWD/ZoneD ../conf/Zone1.conf 7150" | wc -l`

if test $ncount -lt 2 ; then
	$PWD/ZoneD ../conf/Zone1.conf 7150&
	echo $! >> ProcessID.txt
else
	echo "$PWD/ZoneD already been started!"
fi;
sleep 1

ncount=`ps | grep "$PWD/GateD ../conf/Gate1.conf 7150" | wc -l`

if test $ncount -lt 2 ; then
	$PWD/GateD ../conf/Gate1.conf 7150&
	echo $! >> ProcessID.txt
else
	echo "$PWD/GateD already been started!"
fi;
sleep 1

ncount=`ps | grep "$PWD/SNSD ../conf/SNS.conf 7150" | wc -l`

if test $ncount -lt 2 ; then
	$PWD/SNSD ../conf/SNS.conf 7150&
	echo $! >> ProcessID.txt
else
	echo "$PWD/SNSD already been started!"
fi;
sleep 1

