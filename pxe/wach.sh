#!/bin/bash
####################################
#####WRITE BY Liuyu#################
####################################
i=$1
mkdir -p /mnt/nfsly/$i
dir=`date +%m-%d`
last >/mnt/la.log 2>/dev/null
ps -ax >/mnt/px.log 2>/dev/null
mount >/mnt/mount.log 2>/dev/null
#df >df.log
stil=`grep  still /mnt/la.log`
copy=`grep  copy /mnt/px.log`
dif=`grep  diff /mnt/px.log`
ltp=`grep  ltp /mnt/px.log`
mou=`grep  enfs /mnt/mount.log`
#dfh=`df |grep fsmnt |awk '{print $2}'`
echo
if [ -n "$stil" ];then
	rm -rf /mnt/nfsly/$i/*
	rm -rf /mnt/*.log
	exit 
else
        if [ -n "$copy" -a -n "$dif" ];then
		rm -rf /mnt/nfsly/$i/*
		rm -rf /mnt/*.log
		exit 
	else
      		 if [ -n "$ltp" ];then
			rm -rf /mnt/nfsly/$i/*
			rm -rf /mnt/*.log 
			exit 
		else
			if [ -n "$mou" ];then
		#	size=`df |grep fsmnt |awk '{print $2}'`
		#		if [ "$dfh" != "$size" ];then
					rm -rf /mnt/nfsly/$i/*
					rm -rf /mnt/*.log
					exit
		#		else
		#			cd /mnt/nfsly/$i	
                #       			if [ -e hist ];then
                #              			rm -rf /mnt/nfsly/$i/*
		#					poweroff
		#					exit
                #       			else	
		#					echo "$date" >hist
                #       				exit
		#				fi
                #		fi
        		else
				df1=`df`
				sleep 1
				df2=`df`
				if [ x"$df1"=x"$df2" ];then
					cd /mnt/nfsly/$i
	#				[ "$?" != 0 ] && { cd /mnt/nfsly/$i }
                                        if [ -e "hist" ];then
                                             	rm -rf /mnt/nfsly/$i/*
						date >>/mnt/wach.log
						echo "10.10.99.$i" >>/mnt/nfsly/$dir/list.txt
						poweroff
                                             exit
                                        else    
                                             echo "$date" >hist
					     rm -rf /mnt/*.log
                                             exit
                                         fi
				else
					rm -rf /mnt/nfsly/$i/*
					exit
				fi
			fi
		fi
	fi
fi
