#!/bin/bash
###################################
. ../conf
. ../fun.conf
. ./auto
. passwd.conf
#---------------------------------
cp ./get.sh $dir_nfs
logdir=`date +%m-%d`
mkdir -p $logdir
mkdir -p /etc/mytools/res/$logdir
gate=`route -n |grep UG |awk '{print $2}'`
way=${gate%.*}

echo "These IP are Poweroff:" >>/etc/mytools/res/$logdir/list.txt
echo "#####################################" >>/etc/mytools/res/$logdir/list.txt
#####Check this file to find out which IP was shutdown.##########
#############Watching Begin...####################################
for i in {1..254}
do
	passwd=`cat passwd.conf |grep "$way.$i" |awk '{print $2}'` 
	autossh "root@$way.$i" "$passwd" "mkdir -p /media/nfsly/"
	autossh root@$way.$i $passwd "mount -t nfs $gate:$dir_nfs /media/nfsly"
	sleep 1
	autossh root@$way.$i $passwd "sh /media/nfsly/get.sh"
	sleep 1
	wait
	autossh root@$way.$i $passwd "umount -f /media/nfsly/"
wait
done
