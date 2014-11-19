#!/bin/bash
. conf

#centos52-64 -fstype=iso9660,ro,loop :/home/pxe/isos/CentOS-5.2-x86_64-bin-DVD.iso
name_isos_64=`ls  $dir_iso |grep iso |grep x86`
name_isos_32=`ls  $dir_iso |grep iso |grep i386`
(
for i in $name_isos_64
do
system=`echo "$i" |tr [A-Z] [a-z] | grep iso |awk -F - '{print $1}'`
release=`echo "$i" |grep iso| awk -F - '{print $2}' |tr -d [.]`
if [  a"$system" ==  a"" ];then
echo
else
echo "$system-$release-64  -fstype=iso9660,ro,loop :$dir_iso/$i"
mkdir -p "$system$release-64"
fi
done
#kernels=`echo $system-$release-64` | tr [A-Z] [a-z]
#mkdir -p "kernels"
#cp $dir_iso_mount/$system-$release-64/isolinux/vmlinuz initrd.img $dir_kernel/$system-$release-64
for j in $name_isos_32
do
system3=`echo "$j" |tr [A-Z] [a-z] | grep iso |awk -F - '{print $1}'`
release3=`echo "$j" |grep iso| awk -F - '{print $2}' |tr -d [.]`

if [  a"$system3" ==  a"" ];then
echo
else
echo "$system3-$release3-32  -fstype=iso9660,ro,loop :$dir_iso/$j"
mkdir -p "$system$release-32"
fi
#mkdir -p $system-$release-32
done
)>/etc/autofs/centos.iso

###creat the file manul                 ######
add_top()
{
(
echo "LABEL RETURN"
echo "MENU LABEL return"
echo "kernel menu.c32"
echo "append initrd=pxelinux.cfg/default"
) > /tftpboot/pxelinux.cfg/manual
}
add_manul()
{
(
echo;echo
echo "LABEL $1"
echo "MENU LABEL $2"
echo "kernel /kernel/$2/vmlinuz"
echo "append initrd=/kernel/$2/initrd.img noipv6"
)>>/tftpboot/pxelinux.cfg/manual
}
add_top
release_os=(`ls /tftpboot/kernel/`)
len=${#release_os[@]}
for ((i=0;i<$len;i++))
do
add_manul $i ${release_os[$i]}
done
