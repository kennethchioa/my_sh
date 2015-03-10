#!/bin/sh 

# This will flush the existing rules - sudo ipfw -f flush
# You can execute this script without dropping existing connections/states 

fwcmd="/sbin/ipfw -q"
#extif="fxp0" 
#em0_ip=`ifconfig em0 | grep inet | awk '{print $2}'`
#em1_ip=`ifconfig em1 | grep inet | awk '{print $2}'`
network192="192.168.0.0/24"
network172="172.16.0.0/24"
companyip02="222.66.44.10,222.66.44.12"
companyip07="211.161.199.179,60.55.9.61,61.174.53.137,222.73.189.1"
dns_server="202.96.209.5"
portsrange91web="80"
portsrangeclient="1800-1999"
portsrangeweb="2000-2199"

# Reset all rules in case script run multiple times 
${fwcmd} -f flush

${fwcmd} add 200 check-state

# Block RFC 1918 networks - the , syntax only works in ipfw2 
#${fwcmd} add 210 deny all from 0.0.0.0/7,1.0.0.0/8,2.0.0.0/8,5.0.0.0/8,10.0.0.0/8,23.0.0.0/8,\ 
#27.0.0.0/8,31.0.0.0/8,67.0.0.0/8,68.0.0.0/6,72.0.0.0/5,80.0.0.0/4,96.0.0.0/3,127.0.0.0/8,\ 
#128.0.0.0/16,128.66.0.0/16,169.254.0.0/16,172.16.0.0/12,191.255.0.0/16,192.0.0.0/16,\ 
#192.168.0.0/16,197.0.0.0/8,201.0.0.0/8,204.152.64.0/23,224.0.0.0/3,240.0.0.0/8 to any 

# Allow all via loopback to loopback 
${fwcmd} add 220 allow all from any to any via lo0

# Allow from me to anywhere 
${fwcmd} add 240 allow tcp from me to any keep-state
${fwcmd} add 260 allow udp from me to any keep-state
${fwcmd} add 280 allow icmp from me to any

# Allow local LAN to connect to us 
${fwcmd} add 300 allow ip from ${network192} to ${network192}
${fwcmd} add 320 allow ip from ${network172} to ${network172}

# Allow company IP to connect to server 
# 2102
${fwcmd} add 340 allow tcp from ${companyip02} to me keep-state
${fwcmd} add 360 allow udp from ${companyip02}  to me keep-state
${fwcmd} add 380 allow icmp from ${companyip02} to me

# 2107
${fwcmd} add 400 allow tcp from ${companyip07} to me keep-state
${fwcmd} add 420 allow udp from ${companyip07}  to me keep-state
${fwcmd} add 440 allow icmp from ${companyip07} to me

# Gate
${fwcmd} add 333 allow tcp from any to any dst-port 8101 in



# Allow INCOMING SSH,SMTP,HTTP from anywhere on the internet 
#${fwcmd} add 460 allow tcp from any to me 80 in keep-state

# Disable icmp 
${fwcmd} add 480 allow icmp from any to any icmptype 0,3,11

# Block all other traffic and log in 
#${fwcmd} add 500 deny log all from any to any 


# Allow all game ports in
for range in ${portsrangeclient};do
${fwcmd} add 1800 allow tcp from any to any ${range} in
done
for range in ${portsrange91web};do
${fwcmd} add 1900 allow tcp from any to any ${range} in
done
for range in ${portsrangeweb};do
${fwcmd} add 2000 allow tcp from any to any ${range} in
done

ipfw add 02002 allow tcp from any to any dst-port 8080 in
ipfw add 02005 allow tcp from any to any dst-port 8200 in
ipfw add 02006 allow tcp from any to any dst-port 9200 in
ipfw add 02009 allow tcp from any to any dst-port 18000 in
# End of /etc/ipfwrules.sh
