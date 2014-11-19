#!/bin/bash
. fun.conf

servers=(dhcpd nfs xinetd httpd smb autofs)
len=${#servers[@]}
#echo $len
for ((i=0;i<$len;i++))
do
service ${servers[i]} restart >>message 
wait
fun_log "Service ${servers[i]} restart"
done
