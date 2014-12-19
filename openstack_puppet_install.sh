#!/bin/bash
#Puppet agent deploy script  by kenneth 

#echo color
echored ()
{
echo "\033[31m"$1"\033[0m\n"
}
echogreen ()
{
echo "\033[32m"$1"\033[0m\n"
}
echoyellow ()
{
echo "\033[33m"$1"\033[0m\n"
}

TIME_STAMP=`date '+%F %H:%M:%S'`
NTP_SERVER1="0.0.0.0"
DNS_SERVER="0.0.0.0"
SOURCE_SERVER="0.0.0.0"
echo "nameserver $DNS_SERVER" > /etc/resolv.conf
IPADDR=`ifconfig eth0 | grep "inet addr:" |awk '/inet addr/{print substr($2,6)}'`
HOSTNAME_FROM_DNS=`/usr/bin/host $IPADDR | awk '{print $NF}' | sed 's/\.$//g'`
HOSTNAME_FROM_LOCAL=`cat /etc/hostname`
NTPD_PID=`ps aux| grep /usr/sbin/ntpd | grep -v grep |awk '{print $2}'`
DHCP_PID=`ps aux | grep dhclient | grep -v grep  | awk '{print $2}'`
PUPPST_STAT=`/usr/bin/dpkg -l puppet | tail -1 | awk '{print $1,$2}'`
[ "X${PUPPST_STAT}X" = "Xii puppetX" ] && PUPPET_INSTALL=YES || PUPPET_INSTALL=NO

#check vt
if [ `kvm-ok | grep -c 'Virtualization Technology'` -eq 1 ];then
echored "[WARNING]: Enter your BIOS setup and enable Virtualization Technology (VT), and then hard poweroff/poweron your system"
exit
fi

#check disk IO
Check_Disk_IO() {
	dd if=/dev/zero of=/tmp/test_io.img bs=100M count=30 conv=fdatasync 2> /tmp/test_date
	DISK_SPEED=`cat /tmp/test_date  | grep copied | awk '{print $(NF-1)}'`
	if [ $DISK_SPEED -lt 300 ];then
		echored "Disk_IO is wrong" | tee -a /var/log/puppet_init.log && exit
	else
		echogreen "Disk IO is OK ... "
	fi
}

Sys_Init() {
	[ "$NTPD_PID" > 0 ] && kill -9 ${NTPD_PID}
	[ "$DHCP_PID" > 0 ] && kill -9 ${DHCP_PID}
	sleep 1
	/usr/sbin/ntpdate $NTP_SERVER1 || /usr/sbin/ntpdate $NTP_SERVER2
}

Hostname_Init() {
	if [ "X${HOSTNAME_FROM_LOCAL}X" != "X${HOSTNAME_FROM_DNS}X" ];then
		rm -rf /var/lib/puppet/ssl*
		echo $HOSTNAME_FROM_DNS > /etc/hostname
		/bin/hostname $HOSTNAME_FROM_DNS
		[ -f /etc/init.d/puppet ] && /etc/init.d/puppet stop
	fi
}

Puppet_Ins() {
	echo '
deb http://0.0.0.0/ubuntu/ precise main restricted
deb http://0.0.0.0/ubuntu/ precise-updates main restricted
deb http://0.0.0.0/ubuntu/ precise universe
deb http://0.0.0.0/ubuntu/ precise-updates universe
deb http://0.0.0.0/ubuntu/ precise multiverse
deb http://0.0.0.0/ubuntu/ precise-updates multiverse
deb http://0.0.0.0/ubuntu/ precise-backports main restricted universe multiverse
deb http://0.0.0.0/ubuntu precise-security main restricted
deb http://0.0.0.0/ubuntu precise-security universe
deb http://0.0.0.0/ubuntu precise-security multiverse
' > /etc/apt/sources.list
        /usr/bin/apt-get -y --force-yes update
        /usr/bin/apt-get -y --force-yes install puppet
}

Puppet_Conf() {
	echo '
START=yes
DAEMON_OPTS=""
' > /etc/default/puppet
        echo '
[main]
    vardir = /var/lib/puppet
    logdir = /var/log/puppet
    rundir = /var/run/puppet
    ssldir = $vardir/ssl
    factpath=$vardir/lib/facter
[agent]
    classfile = $vardir/classes.txt
    localconfig = $vardir/localconfig
    server = puppet.uuzu.idc
    report = true
    runinterval = 900
' > /etc/puppet/puppet.conf

}

Puppet_Stat() {
	/etc/init.d/puppet status && PUPPET_RUN=YES || PUPPET_RUN=NO
}

#check server
echogreen "Checking env ... "
ping -c 1 $DNS_SERVER > /dev/null 2>&1 && echogreen "Dns server is OK ... " ||  { echored "$TIME_STAMP dns server is wrong" | tee -a /var/log/puppet_init.log && exit 8 ;}
ping -c 1 $NTP_SERVER1 > /dev/null 2>&1 && echogreen "Ntp server is OK ... " || { echored "ntp server is wrong" | tee -a /var/log/puppet_init.log && exit 8 ;}
ping -c 1 $SOURCE_SERVER > /dev/null 2>&1 && echogreen "Sources server is OK ... " || { echored "ubuntu sources server is wrong" | tee -a /var/log/puppet_init.log && exit 8 ;}
ping -c1 puppet.uuzu.idc > /dev/null 2>&1 && echogreen "Puppet master is OK ... " || { echored "puppet master dns is wrong" | tee -a /var/log/puppet_init.log && exit 8 ;}
Check_Disk_IO


Sys_Init

Hostname_Init

if [ "$PUPPET_INSTALL" = "NO" ];then
	Puppet_Ins
	Puppet_Conf
	/usr/bin/puppet agent --test
	/etc/init.d/puppet restart
fi

Puppet_Stat

if [ "$PUPPET_RUN" = "NO" ];then
	/usr/bin/puppet agent --test
	/etc/init.d/puppet restart
fi
