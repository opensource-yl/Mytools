#!/bin/bash

echo "Check the yum..."
echo;echo
#======Check the nameserver===========#
ping www.baidu.com -c 2
if [ $? -ne 0 ];then
	echo "No nameserver..."
	echo "Resolving..."
	echo "nameserver $nameserver" >>/etc/resolv.conf
else
	echo "Nameserver is Ok."
fi
#=====================================#
:>.yum.txt
#======Check if it works =============#
#yum clean all
#yum install -y atop >.yum.txt
#if [ $? = 0 ];then
#	echo "Yum works."
#else
#	echo "Yum failed."
#fi
#======Check the key =================#
verson=`cat /etc/redhat-release |awk '{print $3}'`
key=`cat .yum.txt |grep Key`
if [ x"$key" != x"" ];then
	if [ x"$verson" = x"5.4" ];then
	rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-5
	wait
	else
	echo "Try..."
	rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-5
	fi
else
	echo "Key is OK."
fi
#===================================== #
[ $? = 0 ]&& sh server_install.sh 
