#!/bin/sh
#clean logfile
#author heero.zhao
#date 2013-08-28
#set env
APP_HOME=/mj
CLEANDAY=`date +%Y%m%d`
CLEANOLDDAY=`date -v-2d +%Y-%m-%d`
CLEAN_APP_LOG=/usr/local/clean_app_log/clean_app_$CLEANDAY.log
ZONE_ID="1"
for zone in $ZONE_ID;
do
  ZONE_HOME=$APP_HOME/"mj"$zone
# test direction
if test -d $ZONE_HOME
then
 APP_LOG_HOME=$ZONE_HOME/bin
 echo "------------------------------------------------------------" >> $CLEAN_APP_LOG
 echo "$APP_LOG_HOME exists!"  >>  $CLEAN_APP_LOG
 echo "------------------------------------------------------------" >> $CLEAN_APP_LOG
 echo $(date +"%Y-%m-%d %H:%M:%S") >> $CLEAN_APP_LOG
 echo "------------------------------------------------------------" >>  $CLEAN_APP_LOG
#change direction
cd $APP_LOG_HOME 
echo "Change Direction to $APP_LOG_HOME" >>  $CLEAN_APP_LOG
# test logfile
 if (ls $APP_LOG_HOME/*_$CLEANOLDDAY.log ) >/dev/null 2>&1;
 then
  echo "------------------------------------------------------------" >> $CLEAN_APP_LOG
  echo "Logfile exists!"  >>  $CLEAN_APP_LOG
  echo "------------------------------------------------------------" >> $CLEAN_APP_LOG
#remove 1 day log
   for logfile in `find $APP_LOG_HOME/*$CLEANOLDDAY.log | grep -v Arena` ;
   do /bin/rm -rf $logfile;
    if [ $? = 0 ]; then
      echo "$logfile Cleaned!" >> $CLEAN_APP_LOG
    else
     echo "Clean $logfile failed!" >> $CLEAN_APP_LOG
    fi
   done
 else
  echo "------------------------------------------------------------" >> $CLEAN_APP_LOG
  echo "No Logfile!"    >>  $CLEAN_APP_LOG
  echo "------------------------------------------------------------" >> $CLEAN_APP_LOG
 fi
else
 echo "------------------------------------------------------------" >> $CLEAN_APP_LOG
 echo "No Direction $ZONE_HOME "    >>  $CLEAN_APP_LOG
 echo "------------------------------------------------------------" >> $CLEAN_APP_LOG
fi
done
