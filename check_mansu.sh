#!/bin/bash
#author kenneth.chioa
#for restart java
#date 2015-02-17

mkdir -p /tmp/restart_logs
log_file="/tmp/restart_logs/auto_run_server.log"
monsu_home="/home/monsuuser"
java_path="/usr/java/jdk1.8.0_31/bin"
monsu_version="1.4.1"

process_arry=("java")
area_tag=`/bin/hostname -f |awk -F "-" '{print $1}'`

down_logs(){
        dates=`date`
        echo -e "${dates}---$1 process down off ! Now restart..." >> ${log_file}
}

for process in ${process_arry[@]}
do
        pid=$(/bin/pidof java)
        if [ -z $pid ]
        then
                #restart java
                case ${area_tag} in
                "Monsu")
                    if [ -f ${monsu_home}/MonsterServer-${monsu_version}-prod.jar ]
                        then
                        (${java_path}/java -jar ${monsu_home}/MonsterServer-${monsu_version}-prod.jar &)  &&  down_logs ${process}
                    fi
                               ;;
                "MonsuT")
                    if [ -f ${monsu_home}/MonsterServer-${monsu_version}-prod.tw.jar ]
                       then
                      (${java_path}/java -jar ${monsu_home}/MonsterServer-${monsu_version}-prod.tw.jar & )  &&  down_logs ${process}
                    fi
                               ;;
                "MonsuK")
                    if [ -f ${monsu_home}/MonsterServer-${monsu_version}-prod.k.jar ]
                       then
                      (${java_path}/java -jar ${monsu_home}/MonsterServer-${monsu_version}-prod.k.jar & )  &&  down_logs ${process}
                    fi
                               ;;
                "MonsuX")
                    if [ -f ${monsu_home}/MonsterServer-${monsu_version}-prod.x.jar ]
                       then
                      (${java_path}/java -jar ${monsu_home}/MonsterServer-${monsu_version}-prod.x.jar & )  &&  down_logs ${process}
                    fi
                               ;;
                 *)
                    echo "No such area...."
                               ;;


                esac
        fi
done
