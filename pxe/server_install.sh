#!/bin/bash
#=====================================================
. conf
. fun.conf
#-----Check the nameserver --------------------
echo "Checking nameserver..."
nameserver=`cat /etc/resolv.conf |grep nameserver`
[ x"$nameserver" == x"" ] && echo "No nameserver. Adding..." && echo "nameserver 8.8.8.8" >>/etc/resolv.conf
ping www.baidu.com -c 2 >message
fun_log "Check nameserver..."
#------Check the firewall --------------------
echo "Checking firewall..."
firewall=`service iptables status`
if echo $firewall |grep stopped
then
    echo "Firewall is stopped."
else  service iptables stop >message
    fun_log "Stop iptables"
fi

#===============================================
yum install -y dhcp tftp xinetd tftp-server tftpd syslinux autofs nfs  http samba |tee -a message
fun_log "Install all the services"
[ $? == 0 ] || sh yum_check.sh
#dhcp_install ()
#{    yum install -y dhcp }
#tftp_install ()
###{yum install -y tftpd xinetd tftp-server tftp}
#syslinux_install ()
#{yum install -y syslinux}
#autofs_install ()
###{yum install -y autofs}
#nfs_install ()
#{yum install -y nfs}
#smb_install ()
#{yum install -y samba}
#http_install ()
#{yum install -y http}
##========================================================
#dhcp_install
#tftp_install
#syslinux_install
#autofs_install
#nfs_install
#smb_install
#http_install
