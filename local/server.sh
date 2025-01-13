#!/bin/bash 

for IP in `cat config/byconity-server`
do
    echo "$IP"
    cp config/byconity-server.xml byconity-server-${IP}.xml
    sed -i "s/IP/${IP}/g" byconity-server-${IP}.xml
    cat byconity-server-${IP}.xml |grep hadoop_kerberos_principal

    scp -P 26388 byconity-server-${IP}.xml root@${IP}:/etc/byconity/config/byconity-server.xml
    \rm -rf byconity-server-${IP}.xml
done



