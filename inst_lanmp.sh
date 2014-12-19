#!/bin/bash 
#set -x 
#date: 2013-01-06 
#Description: 一键安装LNMP环境 or LAMP 环境 
#Version: 0.1 
#Author: Wolf 
#定义命令搜索路径 
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin 
export PATH 
src_dir=/usr/src 
nginx_dir=/usr/local/nginx 
mysql_dir=/usr/local/mysql 
php_dir=/usr/local/php 
libmcrypt_dir=/usr/local/libmcypt 
apache_dir=/usr/local/apache 
#关闭SELiunx 
echo "Disabled SELinux" 
if [ -s /etc/selinux/config ] 
then 
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config 
fi 

/usr/sbin/setenforce 0 
# Check if user is root 
if [ "$UID" -ne 0 ] 
then 
printf "Error: You must be root to run this script!\n" 
exit 1 
fi 

#检查需要的软件包是否存在，如果没有就下载。 
download_src(){ 
cd $src_dir 

if [ -s libiconv-1.13.1.tar.gz ] 
then 
echo "libiconv-1.13.1.tar.gz found" 
else 
echo "libiconv-1.13.1.tar.gz not found. download new...." 
wget http://mozbuildtools.googlecode.com/files/libiconv-1.13.1.tar.gz 
fi 

if [ -s mhash-0.9.9.9.tar.gz ] 
then 
echo "mhash-0.9.9.9.tar.gz found" 
else 
echo "mhash-0.9.9.9.tar.gz not found. download new....." 
wget http://acelnmp.googlecode.com/files/mhash-0.9.9.9.tar.gz 
fi 

if [ -s mysql-5.5.25a.tar.gz ] 
then 
echo "mysql-5.5.25a.tar.gz found" 
else 
echo "mysql-5.5.25a.tar.gz not found. download new....." 
wget http://mysql.ntu.edu.tw/Downloads/MySQL-5.5/mysql-5.5.25a.tar.gz 
fi 

if [ -s php-5.3.13.tar.gz ] 
then 
echo "php-5.3.13.tar.gz found" 
else 
echo "php-5.3.13.tar.gz not found. download new....." 
wget http://us1.php.net/distributions/php-5.3.13.tar.gz 
fi 

if [ -s google-perftools-1.6.tar.gz ] 
then 
echo "google-perftools-1.6.tar.gz found" 
else 
echo "google-perftools-1.6.tar.gz not found. download new....." 
wget http://gperftools.googlecode.com/files/google-perftools-1.6.tar.gz 
fi 

if [ -s cmake-2.8.4.tar.gz ] 
then 
echo "cmake-2.8.4.tar.gz found......" 
else 
echo "cmake-2.8.4.tar.gz not found. download new....." 
wget http://www.cmake.org/files/v2.8/cmake-2.8.4.tar.gz 
fi 

if [ -s libmcrypt-2.5.7.tar.gz ] 
then 
echo "libmcrypt-2.5.7.tar.gz found" 
else 
echo "libmcrypt-2.5.7.tar.gz not found. download new..." 
wget http://nchc.dl.sourceforge.net/project/mcrypt/Libmcrypt/Production/libmcrypt-2.5.7.tar.gz 
fi 

if [ -s memcache-2.2.5.tgz ] 
then 
echo "memcache-2.2.5.tgz found" 
else 
echo "memcache-2.2.5.tgz not found. download new......" 
wget http://vps.googlecode.com/files/memcache-2.2.5.tgz 
fi 

if [ -s eaccelerator-0.9.5.3.tar.bz2 ] 
then 
echo "eaccelerator-0.9.5.3.tar.bz2 found" 
else 
echo "eaccelerator-0.9.5.3.tar.bz2 not found. download new.." 
wget http://autosetup1.googlecode.com/files/eaccelerator-0.9.5.3.tar.bz2 
fi 

if [ -s ImageMagick.tar.gz ] 
then 
echo "ImageMagick.tar.gz found" 
else 
echo "ImageMagick.tar.gz not found. download nrw." 
wget http://www.imagemagick.org/download/ImageMagick.tar.gz 
fi 

if [ -s imagick-2.3.0.tgz ] 
then 
echo "imagick-2.3.0.tgz found" 
else 
echo "imagick-2.3.0.tgz not found. download new" 
wget http://lnmpp.googlecode.com/files/imagick-2.3.0.tgz 
fi 
} 

#初始化服务器 
init_server(){ 
for src in dialog ntp vim-enhanced vixie-cron gcc gcc-c++ gcc-g77 flex bison autoconf automake glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel libtool* zlib-devel libxml2-devel libjpeg-devel libpng-devel libtiff-devel fontconfig-devel freetype-devel libXpm-devel gettext-devel curl curl-devel pam-devel e2fsprogs-devel krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel net-snmp net-snmp-devel nss_ldap openldap-clients openldap-servers libtidy libtidy-devel wget libc-client libc-client-devel pcre pcre-devel 
do 
yum -y install $src 
done 

ln -s /usr/lib64/libc-client.so* /usr/lib/ 
ln -s /usr/lib64/libldap* /usr/lib 
} 


#先检测apache是否已经安装，如果已经安装就不在安装，如果没有安装就安装apache 
cd $src_dir 
inst_apache () { 
if [ -d $apache_dir ] 
then 
echo "Apache is installed" 
exit 1 
else 
cd $src_dir 
echo "Apache not install. install run..." 
if [ -s httpd-2.2.24.tar.gz ] 
then 
echo "httpd-2.2.24.tar.gz found." 
else 
echo "httpd-2.2.24.tar.gz not found. download new...." 
wget http://mirror.apache-kr.org/httpd/httpd-2.2.24.tar.gz 
fi 

if [ "$apache_mo" = "" ] 
then 
echo "你没有输入编译参数，使用默认的参数进行编译......." 
tar zxvf httpd-2.2.24.tar.gz 
cd $src_dir/httpd-2.2.24 
./configure --prefix=/usr/local/apache3 --enable-so --enable-rewrite --enable-mods-shared=most --with-mpm=worker 
make && make install 
cd ../ 
else 
tar zxvf httpd-2.2.24.tar.gz 
cd $src_dir/httpd-2.2.24 
$apache_mo 
make && make install 
fi 
fi 
} 

#先检测mysql是否已经安装，如果已经安装了就不再安装，如果没安装就安装mysql 
inst_mysql(){ 
useradd -s /sbin/nologin -M mysql 
tar zxvf cmake-2.8.4.tar.gz 
cd $src_dir/cmake-2.8.4 
./configure && make && make install 

if [ -d $mysql_dir ] 
then 
echo "MySQL is installed" 
else 
if [ "$mysql_mo" = "" ] 
then 
echo "你没有输入mysql编译参数，使用本脚本默认参数进行编译......" 
echo "MySQL not install. install run..." 
cd $src_dir 
tar zxvf mysql-5.5.25a.tar.gz 
cd mysql-5.5.25a 
cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/usr/local/mysql/data -DSYSCONFDIR=/etc -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DMYSQL_TCP_PORT=3306 -DENABLED_LOCAL_INFILE=1 -DWITH_SSL=yes -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_READLINE=on 
gmake && make install 
else 
echo "MySQL not install. install run..." 
cd $src_dir 
tar zxvf mysql-5.5.25a.tar.gz 
cd mysql-5.5.25a 
$mysql 
fi 
fi 

if [ -f /ect/my.cnf ] 
then 
cd $src_dir/mysql-5.5.25a 
echo "MySQL config file my.cnf found. backup my.cnf to my.cnf.bak" 
mv /etc/my.cnf /etc/my.cnf.bak 
/bin/cp support-files/my-small.cnf /etc/my.cnf 
/bin/cp support-files/mysql.server /etc/rc.d/init.d/mysqld 
chmod 755 /etc/rc.d/init.d/mysqld 
chown mysql:mysql /usr/local/mysql -R 
fi 
/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data/ --user=mysql --defaults-file=/etc/my.cnf 
chown mysql:mysql /usr/local/mysql -R 
} 

inst_libmcypt(){ 
if [ -d $libmcrypt_dir ] 
then 
echo "libmcrypt is installed." 
else 
cd $src_dir 
tar zxvf libmcrypt-2.5.7.tar.gz 
cd libmcrypt-2.5.7 
./configure --prefix=/usr/local/libmcypt && make && make install 
/sbin/ldconfig 
cd libltdl/ 
./configure --enable-ltdl-install 
make 
make install 
fi 

cd $src_dir 
tar zxf mhash-0.9.9.9.tar.gz 
cd mhash-0.9.9.9/ 
./configure 
make 
make install 
ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a 
ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la 
ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so 
ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2 
ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1 
} 
#先检测PHP是否已经编译安装，如果安装了就不再进行安装，如果没安装就安装PHP 
inst_php_apache(){ 
cd $src_dir 
tar zxf libiconv-1.13.1.tar.gz 
cd libiconv-1.13.1/ 
./configure --prefix=/usr/local 
make 
make install 
cd $src_dir 
if [ -d $php_dir ] 
then 
echo "PHP is installed" 
else 
if [ "$php_mo" = "" ] 
then 
echo "你没有输入编译安装参数，使用本脚本默认的参数进行编译安装.........." 
echo "PHP not install. install run...." 
cd $src_dir 
tar zxvf php-5.3.13.tar.gz 
cd php-5.3.13 
./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/lib --with-mysql=/usr/local/mysql/bin/mysql_config --with-enable-sysvsem --with-apxs2=/usr/local/apache/bin/apxs --with-openssl --with-zlib --with-bz2 --with-curl --with-libxml-dir=/usr --with-gd --with-jpeg-dir --with-png-dir --with-zlib-dir --enable-gd-native-ttf --enable-gd-jis-conv --without-iconv --with-ldap --with-mcrypt=/usr/local/libmcypt --with-zlib-dir --with-snmp --enable-zip --with-curlwrappers --with-imap --with-kerberos --with-imap-ssl --with-freetype-dir --with-mysql=/usr/local/mysql 
make && make install 
cp php.ini-development /usr/local/php/lib/php.ini 
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf 
else 
echo "使用你输入的参数进行编译安装......." 
echo "PHP not install. install run...." 
cd $src_dir 
tar zxvf php-5.3.13.tar.gz 
cd php-5.3.13 
$php_mo 
make && make install 
cp php.ini-development /usr/local/php/lib/php.ini 
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf 
fi 
fi 
} 
inst_php(){ 
cd $src_dir 
tar zxf libiconv-1.13.1.tar.gz 
cd libiconv-1.13.1/ 
./configure --prefix=/usr/local/libiconv 
make 
make install 
cd $src_dir 
if [ -d $php_dir) 
then 
echo "PHP is installed" 
else 
if [ "$php_mo" = "" ] 
then 
echo "你没有输入PHP安装编译参数，将使用本脚本默认参数进行编译......" 
sleep 5 
echo "请选择安装方式，1,安装和Nginx结合使用的PHP，2,安装和apache结合使用的PHP....." 
read -p "请输入一个数字[1 | 2]: " php_num 
case $php_num in 
1) 
echo "正在安装和nginx结合使用的PHP.........." 
sleep 5 
echo "PHP not install. install run...." 
cd $src_dir 
tar zxvf php-5.3.13.tar.gz 
cd php-5.3.13 
./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/lib --with-mysql=/usr/local/mysql/bin/mysql_config --with-enable-sysvsem --enable-fpm --with-openssl --with-zlib --with-bz2 --with-curl --with-libxml-dir=/usr --with-gd --with-jpeg-dir --with-png-dir --with-zlib-dir --enable-gd-native-ttf --enable-gd-jis-conv --with-iconv=/use/local/libiconv --with-ldap --with-mcrypt=/usr/local/libmcypt --with-zlib-dir --with-snmp --enable-zip --with-curlwrappers --with-imap --with-kerberos --with-imap-ssl --with-freetype-dir --with-mysql=/usr/local/mysql 
make && make install 
cp php.ini-development /usr/local/php/lib/php.ini 
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf 
;; 
2) 
echo "正在安装和apache结合使用的PHP......." 
sleep 5 
./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/lib --with-mysql=/usr/local/mysql/bin/mysql_config --with-enable-sysvsem --with-apxs2=/usr/local/apache/bin/apxs --with-openssl --with-zlib --with-bz2 --with-curl --with-libxml-dir=/usr --with-gd --with-jpeg-dir --with-png-dir --with-zlib-dir --enable-gd-native-ttf --enable-gd-jis-conv --without-iconv --with-ldap --with-mcrypt=/usr/local/libmcypt --with-zlib-dir --with-snmp --enable-zip --with-curlwrappers --with-imap --with-kerberos --with-imap-ssl --with-freetype-dir --with-mysql=/usr/local/mysql 
make && make install 
cp php.ini-development /usr/local/php/lib/php.ini 
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf 
;; 
*) 
echo "请输入一个数字[1 | 2]: " 
esac 
else 
echo "你输入了PHP编译安装参数，使用你输入的参数进行编译......." 
sleep 5 
echo "PHP not install. install run...." 
cd $src_dir 
tar zxvf php-5.3.13.tar.gz 
cd php-5.3.13 
$php_mo 
make && make install 
cp php.ini-development /usr/local/php/lib/php.ini 
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf 
fi 
fi 
} 

inst_php_nginx () { 
cd $src_dir 
tar zxf libiconv-1.13.1.tar.gz 
cd libiconv-1.13.1/ 
./configure --prefix=/usr/local 
make 
make install 
cd $src_dir 
if [ -d $php_dir) 
then 
echo "PHP is installed" 
else 
if [ "$php_mo" = "" ] 
then 
echo "你没有输入编译安装参数，使用本脚本默认的参数进行安装" 
echo "PHP not install. install run...." 
cd $src_dir 
tar zxvf php-5.3.13.tar.gz 
cd php-5.3.13 
./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/lib --with-mysql=/usr/local/mysql/bin/mysql_config --with-enable-sysvsem --enable-fpm --with-openssl --with-zlib --with-bz2 --with-curl --with-libxml-dir=/usr --with-gd --with-jpeg-dir --with-png-dir --with-zlib-dir --enable-gd-native-ttf --enable-gd-jis-conv --without-iconv --with-ldap --with-mcrypt=/usr/local/libmcypt --with-zlib-dir --with-snmp --enable-zip --with-curlwrappers --with-imap --with-kerberos --with-imap-ssl --with-freetype-dir --with-mysql=/usr/local/mysql 
make && make install 
cp php.ini-development /usr/local/php/lib/php.ini 
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf 
else 
echo "你输入了mysql编译参数，使用你输入的参数进行编译........" 
echo "PHP not install. install run...." 
sleep 5 
cd php-5.3.13 
$php_mo 
make && make install 
cp php.ini-development /usr/local/php/lib/php.ini 
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf 
fi 

fi 
} 
#安装PHP扩展 
inst_php_ex(){ 
cd $src_dir 
tar zxf memcache-2.2.5.tgz 
cd memcache-2.2.5/ 
${php_dir}/bin/phpize 
./configure --with-php-config=${php_dir}/bin/php-config 
make 
make install 
cd ../ 

tar jxf eaccelerator-0.9.5.3.tar.bz2 
cd eaccelerator-0.9.5.3 
${php_dir}/bin/phpize 
./configure --enable-eaccelerator=shared --with-eaccelerator-shared-memory --with-php-config=${php_dir}/bin/php-config 
make 
make install 
cd $src_dir 

tar zxf ImageMagick.tar.gz 
cd ImageMagick-6.8.1-9/ 
./configure 
make 
make install 
cd ../ 

tar zxf imagick-2.3.0.tgz 
cd imagick-2.3.0/ 
${php_dir}/bin/phpize 
./configure --with-php-config=${php_dir}/bin/php-config 
make 
make install 
cd .. 
echo "php extension installed successfully!" 
} 
#安装nginx 
inst_nginx(){ 
if [ -s nginx-1.3.10.tar.gz ] 
then 
echo "nginx-1.3.10.tar.gz found." 
else 
echo "nginx-1.3.10.tar.gz not found. download new...." 
wget http://www.nginx.org/download/nginx-1.3.10.tar.gz 
fi 

cd $src_dir 
tar zxf google-perftools-1.6.tar.gz 
cd google-perftools* 
./configure 
make 
make install 
cd $src_dir 

if [ -d $nginx_dir ] 
then 
echo "Nginx is installed" 
else 
if [ "$nginx_mo" = "" ] 
then 
echo "你没有输入安装参数，使用本脚本默认的参数进行编译安装" 
cd $src_dir 
tar zxvf nginx-1.3.10.tar.gz 
cd nginx-1.3.10 
./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module --with-http_stub_status_module 
make && make install 
else 
echo "你输入了安装参数，使用你输入的参数进行安装......" 
cd $src_dir 
tar zxvf nginx-1.3.10.tar.gz 
cd nginx-1.3.10 
$nginx_mo 
make && make install 
fi 
fi 
} 

#生成一个PHP启动脚本，可以用service phpd start | restart | stop | show 进行启动、重启、关闭、查看运行状态 
phpd(){ 
cat <<EOF >>phpd 
#!/bin/bash 
#Author: wolf 
#Date: 2013-01-03 
# 
#chkconfig: - 85 15 
#processname: php 
php=/usr/local/php/sbin/php-fpm 
conf=/usr/local/php/etc/php-fpm.conf 
case $1 in 
start) 
echo -n "Starting php" 
$php 
echo " done" 
;; 
stop) 
echo -n "Stopping php" 
killall -9 php-fpm 
echo " done" 
;; 
restart) 
$0 stop 
$0 start 
;; 
show) 
ps -aux|grep php 
;; 
*) 
echo -n "Usage: $0 {start|restart|reload|stop|test|show}" 
;; 
esac 
EOF 
if [ -f /usr/src/phpd ] 
then 
/bin/cp /usr/src/phpd /etc/rc.d/init.d/phpd 
chmod +x /etc/rc.d/init.d/phpd 
fi 
} 
#生成nginx启动脚本，可以用service nginxd start | restart | stop | reload | test | show 进行重启、关闭、启动>、测试配置文件、查看状态和重新加载。 
nginxd(){ 
cat <<EOF >>/usr/src/nginxd 
#!/bin/bash 
#Author: wolf 
#Date: 2013-01-03 
# 
#chkconfig: - 85 15 
#description: Nginx is a World Wide Web server. 
#processname: nginx 
nginx=/usr/local/nginx/sbin/nginx 
conf=/usr/local/nginx/conf/nginx.conf 
case $1 in 
start) 
echo -n "Starting Nginx" 
$nginx -c $conf 
echo " done" 
;; 
stop) 
echo -n "Stopping Nginx" 
killall -9 nginx 
echo " done" 
;; 
test) 
$nginx -t -c $conf 
;; 
reload) 
echo -n "Reloading Nginx" 
ps auxww | grep nginx | grep master | awk '{print $2}' | xargs kill -HUP 
echo " done" 
;; 
restart) 
$0 stop 
$0 start 
;; 
show) 
ps -aux|grep nginx 
;; 
*) 
echo -n "Usage: $0 {start|restart|reload|stop|test|show}" 
;; 
esac 
EOF 
if [ -s /usr/src/nginxd ] 
then 
/bin/cp /usr/src/nginxd /etc/rc.d/init.d/nginxd 
chmod +x /etc/rc.d/init.d/nginxd 
fi 
} 
cat <<EOF 
############################################ 
1 install Nginx 
2 install PHP 
3 install MySQL 
4 install LNMP 
5 install Apache 
6 install LAMP 
############################################ 
############################################ 
Select your web server(1 | 2 | 3 | 4 | 5 | 6) 
EOF 

echo "Input a number: " 
read num 
case $num in 
1) 
read -p "请输入nginx的编译参数：" nginx_mo 
echo "Nginx installing........... have a rest" 
init_server 
download_src 
inst_nginx 
;; 
2) 
read -p "请输入PHP的安装参数" php_mo 
echo "PHP installing....... have a rest" 
download_src 
init_server 
inst_mysql 
inst_libmcypt 
inst_php 
inst_php_ex 
;; 
3) 
read -p "请输入mysql编译安装参数: " mysql_mo 
echo "MySQL installing...... have a rest" 
init_server 
download_src 
inst_mysql 
;; 
4) 
read -p "请输入nginx的编译参数：" nginx_mo 
read -p "请输入PHP的安装参数" php_mo 
read -p "请输入mysql编译安装参数: " mysql_mo 
echo "LNMP installing...... have a rest" 
download_src 
init_server 
inst_mysql 
inst_libmcypt 
inst_php 
inst_php_ex 
inst_nginx 
;; 
5) 
read -p "请输入apache编译安装参数: " apache_mo 
echo "apache installing....... nave a rest." 
download_src 
init_server 
inst_apache 
;; 
6) 
read -p "请输入apache的安装参数: " apache_mo 
read -p "请输入mysql的安装参数: " mysql_mo 
read -p "请输入php的安装参数: " php_mo 
echo "LAMP installing......... nave a rest." 
download_src 
init_server 
inst_apache 
inst_mysql 
inst_libmcypt 
inst_php_apache 
inst_php_ex 
;; 
*) 
echo "Input error" 
echo "Select your service(1 | 2 | 3 | 4| 5| 6)" 
;; 
esac 

#检查安装是否成功 
case $num in 
4) 
if [ -s /usr/local/nginx ] && [ -s /usr/local/php ] && [ -s /usr/local/mysql ] 
then 
echo "LNMP is install completed" 
echo "Nginx basedir: /usr/local/nginx" 
echo "PHP basedir: /usr/local/php" 
echo "MySQL basedir: /usr/local/mysql" 
echo "MySQL datadir: /usr/local/mysql/data" 
else 
echo "LNMP is install fail" 
fi 
;; 
3) 
if [ -s /usr/local/mysql ] 
then 
echo "Nginx is install completed" 
echo "MySQL basedir: /usr/local/mysql" 
echo "MySQL datadir: /usr/local/mysql/data" 
phpd 
nginxd 
else 
echo "Nginx is install fail" 
fi 
;; 
2) 
if [ -s /usr/local/php ] 
then 
echo "PHP is install completed" 
echo "PHP basedir: /usr/local/php" 
phpd 
else 
echo "PHP is install fail" 
fi 
;; 
1) 
if [ -s /usr/local/nginx ] 
then 
echo "Nginx is install completed" 
echo "Nginx basedir: /usr/local/nginx " 
nginxd 
else 
echo "Nginx is install fail" 
fi 
;; 
5) 
if [ -s /usr/local/apache ] 
then 
echo "Apache is installed completed." 
echo "Apache basedir: /usr/local/nginx." 
else 
echo "Apache is install fail." 
fi 
;; 
6) 
if [ -s /usr/local/apache ] && [ -s /usr/local/php ] && [ -s /usr/local/mysql ] 
then 
echo "LNMP is install completed" 
echo "Apache basedir: /usr/local/apache" 
echo "PHP basedir: /usr/local/php" 
echo "MySQL basedir: /usr/local/mysql" 
echo "MySQL datadir: /usr/local/mysql/data" 
else 
echo "LNMP is install fail" 
fi 
;; 
esac 
