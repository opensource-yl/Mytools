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
#======Colect the infos    = =========#
(
    Eth=`route -n|grep UG |awk '{print $8}'`
    ip=`ifconfig $Eth |grep addr: |awk '{print $2}' |awk -F : '{print $2}'`
    way=`route -n|grep UG |awk '{print $2}'`
    grep -q "pxe_ip" conf || echo "pxe_ip=$ip" >>conf
    grep -q "gateway" conf || echo "gateway=$way" >>conf
    grep -q "netmask" conf || echo "netmask=255.255.255.0" >>conf
    break
)2>/dev/null
#=====================================#
