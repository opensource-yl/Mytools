#!/bin/bash
ifconfig eth0 |grep -w "inet addr" |awk '{print $2}' | awk -F : 'BEGIN{ORS=" "}''{print $2}' >>/mnt/nfsly/addr.conf && ifconfig eth0 |grep HWaddr |awk '{print $5}' >>/mnt/nfsly/addr.conf
