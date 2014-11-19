#!/bin/bash
#==============================##
#This is a shell for PXE setup  #
#               Write by Liuyu  #
#===============================#

sh ipcheck.sh

. conf 
service iptables stop
(
mkdir -p /tftpboot/
echo "==========`date`================="
echo "==Begin to install the servers==="

sh server_install.sh
wait
echo "==========`date`================="
echo "==Begin to check the servers==="
echo
sh server_check.sh
wait
echo "==========`date`================="
echo "==Begin to mkdir the directors==="
sh server_chk.sh
echo
sh mkdir.sh
wait
echo "==========`date`================="
echo "==Begin to config the confs  ===="
echo
sh make_config.sh 
wait
echo "==========`date`================="
echo "==Begin to make the mount file===="
echo
sh update_mount.sh
wait
echo "==========`date`================="
echo "==Begin to restart the servers===="
echo
sh server_restart.sh 
wait
) |tee  -a result.log
echo "All the service are running..."
echo "Now, let's do something."
