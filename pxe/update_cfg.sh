#!/bin/bash
add_top()
{
(
echo "LABEL RETURN"
echo "MENU LABEL return"
echo "kernel menu.c32"
echo "append initrd=pxelinux.cfg/default"
)>/tftpboot/pxelinux.cfg/manual
}
add_top_auto()
{
(
echo "LABEL RETURN"
echo "MENU LABEL return"
echo "kernel menu.c32"
echo "append initrd=pxelinux.cfg/default"
)>/tftpboot/pxelinux.cfg/manual
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
add_auto()
{
(
echo;echo
echo "LABEL $1"
echo "MENU LABEL $2"
echo "kernel /kernel/$2/vmlinuz"
echo "append initrd=/kernel/$2/initrd.img noipv6 ks=http://$pxe_ip/ks/$3"
)>>/tftpboot/pxelinux.cfg/autocentos
}
#----------------------------------------------
add_top
release_os=(`ls /tftpboot/kernel/`)
len=${#release_os[@]}
for ((i=0;i<$len;i++))
do
add_manul $i ${release_os[$i]}
done
