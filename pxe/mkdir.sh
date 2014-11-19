#!/bin/bash
#--------------------------------------------
. conf 
. fun.conf
#---------------------------------------------
dir_array=(`cat conf |grep dir |awk -F = '{print $2}'`)
len=${#dir_array[@]}
for((i=0;i<$len;i++))
do
mkdir -p  ${dir_array[i]}
fun_log "MKDIR directory: ${dir_array[i]}"
sleep 0.1
done

file_array=(`cat conf |grep file |awk -F = '{print $2}'`)
for i in ${file_array[@]}
do
touch $i
fun_log "Create file: $i"
sleep 0.1
done
