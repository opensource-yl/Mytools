#!/bin/bash
. conf
. fun.conf
#======Check the network   ===========#
ping 202.108.22.5 -c 2 >/dev/null
if [ $? -ne 0 ];then
    echo "Network is unable. Please check the network and make sure it works."
    exit;
else
    echo "Network works."
fi
#=====================================#
#======Collect the network infos    = =========#
(
    Eth=`route -n|grep UG |awk '{print $8}'`
    ip=`ifconfig $Eth |grep addr: |awk '{print $2}' |awk -F : '{print $2}'`
    way=`route -n|grep UG |awk '{print $2}'`
    SUBNET=${ip%\.*}.0
    RANGE_FROM=${ip%\.*}.1
    RANGE_TO=${ip%\.*}.253
    grep -q "pxe_ip" conf || echo "pxe_ip=$ip" >>conf
    grep -q "gateway" conf || echo "gateway=$way" >>conf
    grep -q "netmask" conf || echo "netmask=255.255.255.0" >>conf
    grep -q "RANGE_FROM" conf || echo "RANGE_FROM=$RANGE_FROM" >>conf
    grep -q "RANGE_TO" conf || echo "RANGE_TO=$RANGE_TO" >>conf
    grep -q "SUBNET" conf || echo "SUBNET=$SUBNET" >>conf
)2>/dev/null
#=====================================#
