#!/bin/bash
. conf
. fun.conf
check_server ()
{
serve="$1"
version=`rpm -q $serve`
if [ "x$version" != "x" ];then
    fun_log "Check $serve"
else
    echo "$serve installed failed. Please check." |tee -a message
    yum install -y $serve >/dev/null
    sh yum_check.sh
    fun_log "Install $serve"
    return 12
fi

}
echo "=========================================" |tee -a result.log
echo "Starting to check the service you need..." |tee -a result.log
echo "`date`" |tee -a result.log
echo "=========================================" |tee -a result.log
echo "=========================================" >> message
echo "Starting to check the service you need..." >> message
echo "`date`" >> message
echo "=========================================" >> message

Flag_server=""

for i in dhcp tftp syslinux autofs nfs-utils httpd samba
do
    check_server $i || Flag_server=$Flag_server"$i "
done

if [ x"$Flag_server" != x"" ];then
    echo "Check the service $Flag_server." |tee -a message
    exit 0
else
    echo "All service exist." |tee -a result.log
    echo "Starting to create the dir..."
    sleep 2
fi
