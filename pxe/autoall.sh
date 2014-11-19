#!/bin/sh
#autoscp 10.10.99.190:/root/hello  111111 /root/
autossh()
{
if [ $# -ne 3 ];then
	echo "Usage: ./autossh.ssh 10.10.10.1 111111 'ls /home'"
	exit 1
fi        


	IP=$1
        PASSWD=$2
        COMM=$3
        rm -f /root/.ssh/known_hosts
 
        expect -c "
                set timeout 9
                spawn ssh $IP $COMM
                expect \"(yes/no)?\" {
                        send_user \"sending yes...\"
                        send \"yes\r\"
                } \"password:\" {
                        send_user \"sending passwd directly...\"
                        send \"$PASSWD\r\"
                        set timeout -1
                        expect eof {
                                exit 0
                        } timeout {
                                send_user \"timeout in execute phase\"
                                exit 2
                        } \"*password:\" {
                                send_user \"wrong passwd\"
                                exit 4
                        }
                } eof {
                        exit 0
                } timeout {
                        send_user \"timeout in yes_phase\"
                        exit 2
                } \"No route\" {
                        send_user \"No route to host...\"
                        exit 1
                }
                expect \"password:\" {
                        send_user \"sending passwd after yes phase...\"
                        send \"$PASSWD\r\"
                } eof {
                        exit 0
                } timeout { 
                        send_user \"timeout in passwd phase\"
                        exit 2
                }
                set timeout -1
                expect eof {
                        exit 0
                } timeout { 
                        send_user \"timeout in execute phase\"
                        exit 2
                } \"password:\" {
                        send_user \"wrong passwd\"
                        exit 4
                }
                expect \"No route\" {
                        send_user \"No route to host...\"
                        exit 2
                }
        "
}
#autossh admin@10.10.99.5 password "portdisable 6"
###################################################################
logdir=`date +%m-%d`
mkdir -p $logdir
mkdir -p /etc/mytools/res/$logdir
echo "These IP are Poweroff:" >>/etc/mytools/res/$logdir/list.txt
echo "#####################################" >>/etc/mytools/res/$logdir/list.txt
#####Check this file to find out which IP was shutdown.##########
#############Watching Begin...####################################
for i in {1..255}
do
(	autossh root@10.10.99.$i 111111 "mkdir -p /media/nfsly/"
	autossh root@10.10.99.$i 111111 "mount -t nfs 10.10.37.103:/etc/mytools/res /media/nfsly"
	sleep 1
	autossh root@10.10.99.$i 111111 "/media/nfsly/wach.sh $i"
	sleep 1
	wait
	autossh root@10.10.99.$i 111111 "umount -f /media/nfsly/"
)>>./$logdir/all.log
wait
done
(sh /etc/mytools/wach/sleep3h.sh &) && exit
#autoscp 10.10.99.190:/root/hello  111111 /root/

