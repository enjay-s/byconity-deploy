#!/bin/bash 

cat >> /root/.bashrc << EOF

export UID_BIGDATA=`id -u hdfs_user`
export GID_BIGDATA=`id -g hdfs_user`

EOF

source /root/.bashrc
