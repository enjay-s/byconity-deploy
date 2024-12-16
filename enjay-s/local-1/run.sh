#!/bin/bash
# 
#  Copyright (2022) Bytedance Ltd. and/or its affiliates
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#  
#      http://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# 


function run_tso() {
    docker run -d --restart=on-failure \
    --cpus 2 \
    --memory 500m \
    --mount type=bind,source="$(pwd)"/config,target=/root/app/config \
    --mount type=bind,source="$(pwd)"/logs,target=/root/app/logs \
    --expose 18689 \
    --network host \
    --name byconity-tso byconity/byconity-server:stable tso-server --config-file /root/app/config/tso.xml
}

function run_server() {
    docker run -d --restart=on-failure \
    --cpus 16 \
    --memory 30g \
    --mount type=bind,source="$(pwd)"/config,target=/root/app/config \
    --mount type=bind,source="$(pwd)"/logs,target=/root/app/logs \
    --mount type=bind,source="$(pwd)"/data,target=/root/app/data \
    --expose 18684 \
    --expose 18685 \
    --expose 18686 \
    --expose 18687 \
    --expose 18688 \
    --network host \
    --name byconity-server byconity/byconity-server:stable server -C --config-file /root/app/config/server.xml 
}

function run_read_worker() {
    local worker_id=$1
    if [ -z "$worker_id" ]; then
		worker_id=`hostname`-read
	fi
    docker run -d --restart=on-failure \
    --cpus 16 \
    --memory 30g \
    --mount type=bind,source="$(pwd)"/config,target=/root/app/config \
    --mount type=bind,source="$(pwd)"/logs,target=/root/app/logs \
    --mount type=bind,source="$(pwd)"/data,target=/root/app/data \
    -e VIRTUAL_WAREHOUSE_ID=vw_default \
    -e WORKER_GROUP_ID=wg_default \
    -e WORKER_ID=$worker_id\
    --expose 18690 \
    --expose 18691 \
    --expose 18692 \
    --expose 18693 \
    --expose 18694 \
    --network host \
    --name byconity-read-worker byconity/byconity-server:stable server -C --config-file /root/app/config/worker.xml 
}

function run_write_worker() {
    local worker_id=$1
    if [ -z "$worker_id" ]; then
		worker_id=`hostname`-write
	fi
    docker run -d --restart=on-failure \
    --cpus 16 \
    --memory 30g \
    --mount type=bind,source="$(pwd)"/config,target=/root/app/config \
    --mount type=bind,source="$(pwd)"/logs,target=/root/app/logs \
    --mount type=bind,source="$(pwd)"/data,target=/root/app/data \
    -e VIRTUAL_WAREHOUSE_ID=vw_write \
    -e WORKER_GROUP_ID=wg_write \
    -e WORKER_ID=$worker_id\
    --expose 28696 \
    --expose 28697 \
    --expose 28698 \
    --expose 28699 \
    --expose 28700 \
    --network host \
    --name byconity-write-worker byconity/byconity-server:stable server -C --config-file /root/app/config/worker-write.xml 
}

function run_dm() {
    docker run -d --restart=on-failure \
    --cpus 4 \
    --memory 10g \
    --mount type=bind,source="$(pwd)"/config,target=/root/app/config \
    --mount type=bind,source="$(pwd)"/logs,target=/root/app/logs \
    --mount type=bind,source="$(pwd)"/data,target=/root/app/data \
    --expose 18965 \
    --network host \
    --name byconity-dm byconity/byconity-server:stable daemon-manager --config-file /root/app/config/dm.xml 
}

function run_rm() {
    docker run -d --restart=on-failure \
    --cpus 8 \
    --memory 16g \
    --mount type=bind,source="$(pwd)"/config,target=/root/app/config \
    --mount type=bind,source="$(pwd)"/logs,target=/root/app/logs \
    --mount type=bind,source="$(pwd)"/data,target=/root/app/data \
    --expose 18989 \
    --network host \
    --name byconity-rm byconity/byconity-server:stable resource-manager --config-file /root/app/config/rm.xml 
}

function run_cli() {
    docker run -it\
    --network host \
    --name byconity-cli byconity/byconity-server:stable client --host 127.0.0.1 --port 18684
}

function run_cli2() {
    docker run -it\
    --network host \
    --rm byconity/byconity-server:stable client --host $1 --port 18684
}

function stop_byconity() {
    if [ "$1" = "tso" ]; then
        docker stop -t 30 byconity-tso
    elif [ "$1" = "server" ]; then
        docker stop -t 30 byconity-server
    elif [ "$1" = "read_worker" ]; then
        docker stop -t 30 byconity-read-worker
    elif [ "$1" = "write_worker" ]; then
        docker stop -t 30 byconity-write-worker
    elif [ "$1" = "dm" ]; then
        docker stop -t 30 byconity-dm
    elif [ "$1" = "rm" ]; then
        docker stop -t 30 byconity-rm
    else
        echo "valid argument stop tso, stop server, stop read_worker, stop write_worker, stop dm"
    fi
}

function start_byconity() {
    if [ "$1" = "tso" ]; then
        docker start byconity-tso
    elif [ "$1" = "server" ]; then
        docker start byconity-server
    elif [ "$1" = "read_worker" ]; then
        docker start byconity-read-worker
    elif [ "$1" = "write_worker" ]; then
        docker start byconity-write-worker
    elif [ "$1" = "dm" ]; then
        docker start byconity-dm
    elif [ "$1" = "rm" ]; then
        docker start byconity-rm
    elif [ "$1" = "cli" ]; then
        docker start -i byconity-cli
    else
        echo "valid argument start tso, start server, start read_worker, start write_worker, start dm, start cli"
    fi
}


if [ ! -f "config/fdb.cluster" ]; then
    echo "file config/fdb.cluster does not exist."
    exit 0
fi

if grep -q example.host.com "config/fdb.cluster"; then
    echo "file config/fdb.cluster haven't been configured properly."
    exit 0
fi

mkdir -p data/byconity_server/server_local_disk/data/0/
mkdir -p logs/

if [ "$1" = "tso" ]; then
    run_tso
elif [ "$1" = "server" ]; then
    run_server
elif [ "$1" = "read_worker" ]; then
    run_read_worker $2
elif [ "$1" = "write_worker" ]; then
    run_write_worker $2
elif [ "$1" = "dm" ]; then
    run_dm
elif [ "$1" = "rm" ]; then
    run_rm
elif [ "$1" = "cli" ]; then
    run_cli
elif [ "$1" = "cli2" ]; then
    run_cli2 $2
elif [ "$1" = "stop" ]; then
    stop_byconity $2
elif [ "$1" = "start" ]; then
    start_byconity $2
else
    echo "valid argument are tso, server, read_worker, write_worker, dm, cli, cli2, stop tso, stop server, stop read_worker, stop write_worker, stop dm, start tso, start server, start read_worker ..."
fi
