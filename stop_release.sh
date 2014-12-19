echo "Remove *Port..."
rm -rf *Port
echo "Remove ProcessID.txt..."
rm -rf ProcessID.txt
ps -x | grep "$PWD/Gate"
ps -x | grep "$PWD/Gate"| grep -v grep | awk '{cmd="kill -9 "$1;system(cmd)}'
echo "Gate killed"
echo "Waiting for 10 seconds"
sleep 10
echo "Begin to kill Log Process"
ps -x | grep "$PWD/Log"
ps -x | grep "$PWD/Log" | grep -v grep |awk '{cmd="kill -9 "$1;system(cmd)}'
echo "Log killed"
echo "Begin to kill Assistant Process"
ps -x | grep "$PWD/Assistant"
ps -x | grep "$PWD/Assistant" | grep -v grep |awk '{cmd="kill -9 "$1;system(cmd)}'
echo "Assistant killed"
echo "Done"
