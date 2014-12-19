#!/bin/sh
#author heero.zhao
#date 2013-10-16
patchhome=/home/dev/patch/autoPatch/sanguoPublish/serverPatch
tmpfiledir=/home/mj/mjz/test_server_patch/tmp_upfile
mjzdir=/home/mj/mjz
inputversion=`echo $1 | sed "s/_/ /g;s/-/ /g;s/.tar.gz/ /g" | awk '{print $3$4$5$6}'`
version=`cat /home/mj/mjz/test_server_patch/update_patch_list`
if [ "$inputversion" -gt "$version" ];
then
 if [ -f  "$patchhome/$1" ]; then
 rm -r $tmpfiledir/* >/dev/null 2>&1
 rm -r update_patch_list >/dev/null 2>&1
 rsync -av --progress $patchhome/$1 .
 tar zxvf $1 -C  $tmpfiledir/
 chown -R mj $tmpfiledir/*
 echo "Begin to stop >>>>>>>>>>>>>>>>>>"
 (cd ../bin/ && sh stop_release.sh) && echo "Stoped!"
 echo "Sleep 20 seconds"
 sleep 20
 for patchfile in $(ls -l $tmpfiledir| awk '/^d/{print $NF}') 
    do      echo "Begin to copy $patchfile >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"  
  	   rsync -av --progress  $tmpfiledir/$patchfile/* $mjzdir/$patchfile && echo "Copy $patchfile OK!"
    done
 echo $(date +"%Y-%m-%d %H:%M:%S")  >> patch_list
 echo $1 | sed "s/_/ /g;s/-/ /g;s/.tar.gz/ /g" | awk '{print $3$4$5$6}' > update_patch_list
 echo "$1 Updated!" >> patch_list
  if [ ! -d  "$tmpfiledir/database" ]; then
   echo "Begin to start >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    (cd ../bin/ && sh start_release.sh)
   else 
    echo "Warning!! Database should be updated before start game process!"
  fi	 
 else 
    echo "No patch file! or Put wrong patch file name!"
 fi
else
echo "Version is the new one!"
fi
