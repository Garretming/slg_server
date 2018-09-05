#!/bin/bash
# echo "please input port:" 
# read PORT

pids=`ps aux | grep skynet | awk -F " " '{if($11 != "grep")print $2;}'`
for pid in $pids;do
	kill -9 $pid
done