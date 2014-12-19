#!/bin/bash  
#created by Heero 
#date:20130508  
MYUSER=root  
MYPASS="root" 
MYSOCK=/data/3306/mysql.sock  
MySQL_STARTUP="/data/3306/mysql" 
LOG_PATH=/tmp  
LOG_FILE=${LOG_PATH}/mysqllogs_`date +%F`.log  
MYSQL_PATH=/usr/local/mysql/bin  
MYSQL_CMD="$MYSQL_PATH/mysql -u$MYUSER -p$MYPASS -S $MYSOCK" 
#→全变量定义方式，显得更专业。  
$MYSQL_CMD -e "select version();" >/dev/null 2>&1  
if [ $? -eq 0 ]   
then 
echo "MySQL is running! "   
exit 0  
else 
$MySQL_STARTUP start >$LOG_FILE#→日志也是变量。  
sleep 5;  
$MYSQL_CMD -e "select version();" >/dev/null 2>&1  
if [ $? -ne 0 ]  
then   
for num in `seq 10`#→通过for循环来杀死mysqld，真正杀死则退出循环或每隔个两秒杀一次，一共杀10次。  
do  
killall mysqld>/dev/null 2>&1   
[ $? -ne 0 ] && break;  
sleep 2  
done  
$MySQL_STARTUP start >>$LOG_FILE   
fi  
$MYSQL_CMD -e "select version();" >/dev/null 2>&1 && Status="restarted" || Status="unknown"#→这个逻辑更准确。  
echo "MySQL status is $Status" >>$LOG_FILE  
mail -s "MySQL status is $Status" 31333741@qq.com < $LOG_FILE  
#→把上面的Status作为结果标题传给邮件，当然你可以做短信，语音通话报警。  
fi  
exit 