# ByConity Deploy

### 一 Role



#### MetaStore

FDB



#### Storage

hdfs



#### Scheduler

k8s



### 二 ByConity 

#### On Local

```shell
mv local  /etc/byconity 
ln -s /etc/byconity/mssh.sh /usr/bin/mssh 
ln -s /etc/byconity/mscp.sh /usr/bin/mscp
ln -s /etc/byconity/worker.sh /usr/bin/worker
ln -s /etc/byconity/server.sh /usr/bin/server
ln -s /etc/byconity/cnch.sh /usr/bin/cnch


参数介绍：
S1 部署操作(config service start restart stop status)
S2 操作角色(all tso server read write dm rm)
//all tso server worker-read worker-write daemon-manager resource-manager

## 配置下发
deploy config all


## service下发
deploy service all


## start 
deploy start all
```



#### On K8s mode1

```shell
## 搭建
helm upgrade --install --create-namespace --namespace namespace1  -f ./k8s-mode1/byconity.yaml byconity ./k8s-mode1

## uninstall
helm uninstall --namespace namespace1  byconity
```



#### On K8s mode2

```shell
## 搭建
helm upgrade --install --create-namespace --namespace namespace1  -f ./k8s-mode2/byconity.yaml byconity ./k8s-mode2

## uninstall
helm uninstall --namespace namespace1  byconity
```

