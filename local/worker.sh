#!/bin/bash 

#$1 role
for IP in `cat config/byconity-worker`
do
    echo "$IP"
    cp config/byconity-worker-${1}.xml byconity-worker-${1}-${IP}.xml
    sed -i "s/>VIRTUAL_WAREHOUSE_ID</>vw_${1}</g" byconity-worker-${1}-${IP}.xml
    cat byconity-worker-${1}-${IP}.xml |grep VIRTUAL_WAREHOUSE_ID

    sed -i "s/>WORKER_GROUP_ID</>wg_${1}_a</g" byconity-worker-${1}-${IP}.xml
    cat byconity-worker-${1}-${IP}.xml |grep WORKER_GROUP_ID

    sed -i "s/>WORKER_ID</>vw_${1}_wg_${1}_a_${IP}</g" byconity-worker-${1}-${IP}.xml
    cat byconity-worker-${1}-${IP}.xml |grep WORKER_ID

    sed -i "s/IP/${IP}/g" byconity-worker-${1}-${IP}.xml
    cat byconity-worker-${1}-${IP}.xml |grep hadoop_kerberos_principal

    scp -P 26388 byconity-worker-${1}-${IP}.xml root@${IP}:/etc/byconity/config/byconity-worker-${1}.xml
    \rm -rf byconity-worker-${1}-${IP}.xml
done



