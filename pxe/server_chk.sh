#!/bin/bash
#--------------------------------------
. conf
. fun.conf
#--------------------------------------
array_ser=(httpd dhcpd xinetd autofs nfs)
len=${#array_ser[@]}
echo "Chkconfig off the Firewall:"
chkconfig iptables off >/dev/null
fun_log "iptables off"
sleep 0.1
for ((i=0;i<$len;i++))
do
chkconfig --level 3 ${array_ser[i]} on
fun_log "Add ${array_ser[i]} to chkconfig list"
done
chkconfig --level 3 nfs on
