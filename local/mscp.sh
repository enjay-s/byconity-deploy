#!/bin/bash 
set -x
for IP in `cat $1`
do
    echo "$IP"
    scp -P 26388 $2 root@${IP}:$3  &
done

wait
