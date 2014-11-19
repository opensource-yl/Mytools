#!/bin/bash
alias cp="cp -f"
. conf
. fun.conf
#============DHCP=============
config_dhcp ()
{
cp /etc/dhcpd.conf /etc/dhcpd.conf.bak
cp ./pxe.conf/dhcpd.conf /etc/dhcpd.conf
sed -i "s/PXESERVER/$pxe_ip/g" /etc/dhcpd.conf
sed -i "s/GATEWAY/$gateway/g" /etc/dhcpd.conf
sed -i "s/SUBNET/$SUBNET/g" /etc/dhcpd.conf
sed -i "s/RANGE_FROM/$RANGE_FROM/g" /etc/dhcpd.conf
sed -i "s/RANGE_TO/$RANGE_TO/g" /etc/dhcpd.conf
#
fun_log "Configure DHCP server"
}

#============AUTOFS===========
config_autofs()
{
echo "$dir_iso_mount $file_iso_conf --ghost ">>/etc/auto.master
sh update_mount.sh
fun_log "Collect autofs infomation"
}

#============HTTP=============
config_http()
{
cp -rf ./pxe.conf/welcome.conf /etc/httpd/conf.d/welcome.conf >message
fun_log "Configure /etc/httpd/"
}
#===========pxelinux.0========
config_syslinux()
{
cp ./pxe.conf/pxelinux.0 $dir_tftpboot
cp ./pxe.conf/menu.c32 $dir_tftpboot
fun_log "Configure syslinux"
}

#===========default===========
#============tftp=============
config_tftp()
{
cp ./pxe.conf/tftp /etc/xinetd.d/tftp
fun_log "Configure /etc/xinetd.d/tftp"
}
#===========exports===========
config_nfs()
{
#while read line
#do
#each_item=`echo $line |grep $dir_nfs`
#[ x"$each_item" = x"" ]&& 
echo "$dir_nfs *(rw,async,no_root_squash)">/etc/exports
#done </etc/exports
fun_log "Configure nfs"
}
#===========busybox===========
config_busybox()
{
mkdir -p $dir_tftpboot/busybox/
cp -rf ./pxe.conf/busybox/* $dir_tftpboot/busybox/
#$cp ./pxe.conf/busybox.img $dir_tftpboot/busybox/
fun_log "Configure busybox"
}
config_ks ()
{
cp -rf ./pxe.conf/ks /var/www/html/
fun_log "Configure ks"
}
#
config_busybox
config_nfs
config_tftp
config_syslinux
config_http
config_dhcp
config_autofs
config_mv
config_ks
