#!/bin/bash
. ../conf
. ../fun.conf

:>host.conf
while read line
do
let i=$i+1
(
echo "host Test$i {"
echo -n "hardware ethernet  "
mac=`echo "$line" |awk '{print $2}'`
echo "$mac;"
echo -n "fixed-address  "
ip=`echo  "$line" |awk '{print $1}'`
echo "$ip;"
echo "}"
)>>.new.txt
done<./addr.conf
