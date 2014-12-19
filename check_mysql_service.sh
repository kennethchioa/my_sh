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
#��ȫ�������巽ʽ���Եø�רҵ��  
$MYSQL_CMD -e "select version();" >/dev/null 2>&1  
if [ $? -eq 0 ]   
then 
echo "MySQL is running! "   
exit 0  
else 
$MySQL_STARTUP start >$LOG_FILE#����־Ҳ�Ǳ�����  
sleep 5;  
$MYSQL_CMD -e "select version();" >/dev/null 2>&1  
if [ $? -ne 0 ]  
then   
for num in `seq 10`#��ͨ��forѭ����ɱ��mysqld������ɱ�����˳�ѭ����ÿ��������ɱһ�Σ�һ��ɱ10�Ρ�  
do  
killall mysqld>/dev/null 2>&1   
[ $? -ne 0 ] && break;  
sleep 2  
done  
$MySQL_STARTUP start >>$LOG_FILE   
fi  
$MYSQL_CMD -e "select version();" >/dev/null 2>&1 && Status="restarted" || Status="unknown"#������߼���׼ȷ��  
echo "MySQL status is $Status" >>$LOG_FILE  
mail -s "MySQL status is $Status" 31333741@qq.com < $LOG_FILE  
#���������Status��Ϊ������⴫���ʼ�����Ȼ����������ţ�����ͨ��������  
fi  
exit 