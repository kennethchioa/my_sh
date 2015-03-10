#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/mysql/bin:/root/bin:/usr/local/mysql/bin
DATE=`date "+%Y%m%d %H:%M:%S"`
MYSQL_DIR=/usr/local/mysql
#DATA_DIR=/home/mysql/data
CHECKINSTALL="is not installed"
RPMLIST="make gcc gcc-c++  autoconf automake  bison  ncurses-devel libtool-ltdl-devel* cmake"
TAR=/usr/local/src
cat >>/etc/profile <<EOF
export PATH=$PATH:/usr/local/mysql/bin
EOF
source /etc/profile
cp -a /etc/profile  /etc/profile.bak
read -p "please enter you mysql version (eg:/mysql-5.5.34):" BANBEN
read -p "please enter you mysql datadir (eg:/data/mysql/data):" DATA_DIR
echo 执行完该脚本启动你的MYSQL并在/etc/profile文件里写入并source执行这样才能直接使用mysql命令 export PATH=$PATH:/usr/local/mysql/bin
sleep 1
echo  '装包部分开始'
sleep 1
rpm -qa |grep mysql  > /tmp/mysqlremove.txt
if [ $? -eq 0 ];then
	for i in $(cat /tmp/mysqlremove.txt); do yum -y remove $i ; done
	echo ""
	echo -e "$DATE \033[32m MYSQL already removed \033[0m" >> /tmp/tarmysql.log
	echo ""
else
	echo -e "$DATE \033[32m MYSQL does not exist \033[0m"  >> /tmp/tarmysql.log
fi
rpm -q --qf '%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n' gcc gcc-c++  autoconf automake  bison  ncurses-devel libtool-ltdl-devel cmake > /tmp/rpmtoolinstall.log


	grep 'is not install' /tmp/rpmtoolinstall.log

	if [ $? -eq  0 ];then
	 yum -y install $RPMLIST
else
	echo -e "$DATE \033[32m MYSQL tool already install \033[0m"  >> /tmp/mysqltool.log
	fi



echo '创建mysql相关目录开始'
sleep 1
if [ ! -d /usr/local/mysql ];then
	mkdir /usr/local/mysql -p
else
	echo '/usr/local/mysql already having'    >> /tmp/tarmysql.log
fi
if [ ! -d $DATA_DIR ];then
	mkdir $DATA_DIR -p 
else
	echo $DATA_DIR already having    >> /tmp/tarmysql.log
fi


echo '创建mysql相关用户和组开始'
sleep 1
grep mysql /etc/group &>/dev/null
if [ $? -eq 0 ];then
	echo "group:mysql is already exist"    >> /tmp/tarmysql.log
else
	groupadd mysql 
fi

grep mysql /etc/passwd &>/dev/null
if [ $? -eq 0 ];then
	echo 'user:mysql is already exist'    >> /tmp/tarmysql.log
else
	useradd -g mysql mysql
fi
useradd mysql
chown mysql.mysql -R /usr/local/mysql/
echo '解压部分开始'
sleep 1
if [ ! -d $TAR/$BANBEN ];then
	tar -xf  $TAR/$BANBEN.tar.gz
else
	echo  'tar -xf already ----> ok'
	echo 'tar -xf already ----> ok'     >> /tmp/tarmysql.log
fi  

if [ -d $TAR/$BANBEN ];then
	cd $TAR/$BANBEN
else
	echo  "没有包装数据库,not having mysql-tar,,请把你下载的mysql的tar包放在/usr/local/src目录下再执行"
	sleep 2
	exit 20
fi

echo '重头戏装包开始'
sleep 1
if [ -f $TAR/$BANBEN/CMakeCache.txt ];
then 
echo 你已经装好了一个数据库顶多是没有执行 请先启动正常使用如有问题执行 ./mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=$DATA_DIR  --skip-grant-tables --skip-networking /usr/local/mysql/scripts/执行上一条命令如果还是不行请删除你现有的数据库再执行该脚本
exit 21
else
cd $TAR/$BANBEN
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS:STRING=all \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_EXAMPLE_STORAGE_ENGINE=1 \
-DMYSQL_DATADIR=$DATA_DIR \
-DMYSQL_USER=mysql \
-DMYSQL_TCP_PORT=3306
sleep 1
echo 'start make'
sleep 1
make
sleep 2
echo 'start make install'
sleep 1
make install
fi
/usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=$DATA_DIR --skip-grant-tables --skip-networking 

cp /usr/local/mysql/support-files/my-small.cnf /etc/my.cnf
cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
export PATH=$PATH:/usr/local/mysql/bin
chmod +x /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig mysqld on
chown mysql.mysql /usr/local/mysql -R
sleep 1
echo "请你手动启动数据库 service mysqld start 给你的数据库设置密码谢谢使用"
