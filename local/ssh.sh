#!/bin/bash 
for IP in `cat $1`
do
    echo "$IP"
    /bin/ssh -p 26388 root@${IP} "$2" 
done

wait

