#!/bin/bash
#
#This scripts is to auto mount all your ISO, and automatically create the kernel files for your PXE.
#Notice: Please make sure that your ISO is named as "$Product_$Version_$Byte.iso"
#For example: "RHEL_6.6_20141013_x86.iso"
#
#Wrote by yuliu 
#Modefied by 11/19/2014
#Any problem please feel free to contact me: yuliu@redhat.com / liuyu3210@gmail.com
#####
. conf
. fun.conf

##############3
ISO_ARRAY=(`ls $dir_iso`)
for i in ${ISO_ARRAY[@]}
do
    mount_point=${i%\.*}
    echo "$mount_point -fstype=iso9660,ro,loop :$dir_iso/$i" >>$file_iso_conf
    mkdir -p $dir_iso_mount/$mount_point
    mount -o loop $dir_iso/$i $dir_iso_mount/$mount_point
    mkdir -p $dir_kernel/$mount_point
    dir_vmlinuz=`find $dir_iso_mount/$mount_point -name vmlinuz |awk NR==1`
    dir_initrd=`find $dir_iso_mount/$mount_point -name initrd.img |awk NR==1`
    cp $dir_vmlinuz $dir_initrd $dir_kernel/$mount_point
    wait
done

###Create the default###
add_top()
{
cat <<EOF > $dir_pxelinux/default
default menu.c32
prompt 0
timeout 300000000
MENU TITLE system install

LABEL Busybox
MENU LABEL BusyBox
kernel busybox/vmlinuz 
append initrd=busybox/busybox.img
#MENU PASSWD 111111

EOF
}
add_top

To_count=0
TO_install=(`ls $dir_kernel`)
for i in ${TO_install[@]}
do
let To_count=$To_count+1
cat <<EOF >>$dir_pxelinux/default
LABEL $To_count
MENU LABEL $i
kernel kernel/$i/vmlinuz
append initrd=kernel/$i/initrd.img

EOF
done
