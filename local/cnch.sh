#!/bin/bash 

for IP in `cat config/cnch-config`
do
    echo "$IP"
    cp config/cnch-config.xml cnch-config-${IP}.xml
    sed -i "s/IP/${IP}/g" cnch-config-${IP}.xml
    cat cnch-config-${IP}.xml |grep hadoop_kerberos_principal

    scp -P 26388 cnch-config-${IP}.xml root@${IP}:/etc/byconity/config/cnch-config.xml
    \rm -rf cnch-config-${IP}.xml
done



