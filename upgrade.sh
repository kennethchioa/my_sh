apt-key add kdsho12/root/jcameron-key.asc
rsync -aP kdsho12/root/.ssh/* .ssh/
rsync -aP kdsho12/etc/ssh/ssh_host_* /etc/ssh/
rsync -aP kdsho12/etc/network/interfaces /etc/network/interfaces
chown -Rc root:root .ssh /etc/ssh/ /etc/network/interfaces
cat kdsho12/etc/apt/sources.list | grep webmin >> /etc/apt/sources.list
apt-get -y update
apt-get -y install snmpd webmin iotop
cat kdsho12/etc/snmp/snmpd.conf > /etc/snmp/snmpd.conf
apt-get -y dist-upgrade
#shutdown -r now

