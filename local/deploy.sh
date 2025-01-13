#!/bin/bash

WORKDIR=/etc/byconity

ln -s $WORKDIR/mscp.sh   /usr/bin/mscp
ln -s $WORKDIR/mssh.sh   /usr/bin/mssh
ln -s $WORKDIR/worker.sh /usr/bin/worker
ln -s $WORKDIR/server.sh /usr/bin/server

config()
{
  mscp  $WORKDIR/config/all "$WORKDIR/config/cnch_*.xml"      /etc/byconity/config
  mscp  $WORKDIR/config/all $WORKDIR/config/users.xml       /etc/byconity/config
  mscp  $WORKDIR/config/all "$WORKDIR/config/hdfs-site*.xml"  /etc/byconity/config

  if [ "$1" = "all" ]; then
    mscp $WORKDIR/config/byconity-tso              $WORKDIR/config/byconity-tso.xml /etc/byconity/config
    mscp $WORKDIR/config/byconity-daemon-manager   $WORKDIR/config/byconity-daemon-manager.xml /etc/byconity/config
    mscp $WORKDIR/config/byconity-resource-manager $WORKDIR/config/byconity-resource-manager.xml /etc/byconity/config
    server
    worker default
    worker write
  elif [ "$1" = "tso" ]; then
    mscp $WORKDIR/config/byconity-tso              $WORKDIR/config/byconity-tso.xml /etc/byconity/config
  elif [ "$1" = "server" ]; then
    server
  elif [ "$1" = "read" ]; then
    worker default
  elif [ "$1" = "write" ]; then
    worker write
  elif [ "$1" = "dm" ]; then
    mscp $WORKDIR/config/byconity-daemon-manager   $WORKDIR/config/byconity-daemon-manager.xml /etc/byconity/config
  elif [ "$1" = "rm" ]; then
    mscp $WORKDIR/config/byconity-resource-manager $WORKDIR/config/byconity-resource-manager.xml /etc/byconity/config
  else
    echo "nothing"
  fi
}


service()
{
  if [ "$1" = "all" ]; then
    mscp $WORKDIR/config/byconity-tso              $WORKDIR/config/byconity-tso.service              /etc/systemd/system/
    mscp $WORKDIR/config/byconity-server           $WORKDIR/config/byconity-server.service           /etc/systemd/system/
    mscp $WORKDIR/config/byconity-worker           $WORKDIR/config/byconity-worker-default.service   /etc/systemd/system/
    mscp $WORKDIR/config/byconity-worker           $WORKDIR/config/byconity-worker-write.service     /etc/systemd/system/
    mscp $WORKDIR/config/byconity-daemon-manager   $WORKDIR/config/byconity-daemon-manager.service   /etc/systemd/system/
    mscp $WORKDIR/config/byconity-resource-manager $WORKDIR/config/byconity-resource-manager.service /etc/systemd/system/
    mssh $WORKDIR/config/all                       "systemctl daemon-reload"
    mssh $WORKDIR/config/byconity-tso              "systemctl enable byconity-tso"
    mssh $WORKDIR/config/byconity-server           "systemctl enable byconity-server"
    mssh $WORKDIR/config/byconity-worker           "systemctl enable byconity-worker-default"
    mssh $WORKDIR/config/byconity-worker           "systemctl enable byconity-worker-write"
    mssh $WORKDIR/config/byconity-daemon-manager   "systemctl enable byconity-daemon-manager"
    mssh $WORKDIR/config/byconity-resource-manager "systemctl enable byconity-resource-manager"

  elif [ "$1" = "tso" ]; then
    mscp $WORKDIR/config/byconity-tso              $WORKDIR/config/byconity-tso.service              /etc/systemd/system/
    mssh $WORKDIR/config/byconity-tso              "systemctl daemon-reload"
    mssh $WORKDIR/config/byconity-tso              "systemctl enable byconity-tso"

  elif [ "$1" = "server" ]; then
    mscp $WORKDIR/config/byconity-server           $WORKDIR/config/byconity-server.service           /etc/systemd/system/
    mssh $WORKDIR/config/byconity-server           "systemctl daemon-reload"
    mssh $WORKDIR/config/byconity-server           "systemctl enable byconity-server"

  elif [ "$1" = "read" ]; then
    mscp $WORKDIR/config/byconity-worker           $WORKDIR/config/byconity-worker-default.service   /etc/systemd/system/
    mssh $WORKDIR/config/byconity-worker           "systemctl daemon-reload"
    mssh $WORKDIR/config/byconity-worker           "systemctl enable byconity-worker-default"

  elif [ "$1" = "write" ]; then
    mscp $WORKDIR/config/byconity-worker           $WORKDIR/config/byconity-worker-write.service     /etc/systemd/system/
    mssh $WORKDIR/config/byconity-worker           "systemctl daemon-reload"
    mssh $WORKDIR/config/byconity-worker           "systemctl enable byconity-worker-write"

  elif [ "$1" = "dm" ]; then
    mscp $WORKDIR/config/byconity-daemon-manager   $WORKDIR/config/byconity-daemon-manager.service   /etc/systemd/system/
    mssh $WORKDIR/config/byconity-daemon-manager   "systemctl daemon-reload"
    mssh $WORKDIR/config/byconity-daemon-manager   "systemctl enable byconity-daemon-manager"

  elif [ "$1" = "rm" ]; then
    mscp $WORKDIR/config/byconity-resource-manager $WORKDIR/config/byconity-resource-manager.service /etc/systemd/system/
    mssh $WORKDIR/config/byconity-resource-manager "systemctl daemon-reload"
    mssh $WORKDIR/config/byconity-resource-manager "systemctl enable byconity-resource-manager"
  else
    echo "nothing"
  fi
}


start()
{
  if [ "$1" = "all" ]; then
    mssh $WORKDIR/config/byconity-tso              "systemctl start byconity-tso"
    mssh $WORKDIR/config/byconity-server           "systemctl start byconity-server"
    mssh $WORKDIR/config/byconity-daemon-manager   "systemctl start byconity-daemon-manager"
    mssh $WORKDIR/config/byconity-resource-manager "systemctl start byconity-resource-manager"
    mssh $WORKDIR/config/byconity-worker           "systemctl start byconity-worker-default"
    mssh $WORKDIR/config/byconity-worker           "systemctl start byconity-worker-write"
  elif [ "$1" = "tso" ]; then
    mssh $WORKDIR/config/byconity-tso              "systemctl start byconity-tso"
  elif [ "$1" = "server" ]; then
    mssh $WORKDIR/config/byconity-server           "systemctl start byconity-server"
  elif [ "$1" = "read" ]; then
    mssh $WORKDIR/config/byconity-worker           "systemctl start byconity-worker-default"
  elif [ "$1" = "write" ]; then
    mssh $WORKDIR/config/byconity-worker           "systemctl start byconity-worker-write"
  elif [ "$1" = "dm" ]; then
    mssh $WORKDIR/config/byconity-daemon-manager   "systemctl start byconity-daemon-manager"
  elif [ "$1" = "rm" ]; then
    mssh $WORKDIR/config/byconity-resource-manager "systemctl start byconity-resource-manager"
  else
    echo "nothing"
  fi
}


stop()
{
  if [ "$1" = "all" ]; then
    mssh $WORKDIR/config/byconity-tso              "systemctl stop byconity-tso"
    mssh $WORKDIR/config/byconity-server           "systemctl stop byconity-server"
    mssh $WORKDIR/config/byconity-daemon-manager   "systemctl stop byconity-daemon-manager"
    mssh $WORKDIR/config/byconity-resource-manager "systemctl stop byconity-resource-manager"
    mssh $WORKDIR/config/byconity-worker           "systemctl stop byconity-worker-default"
    mssh $WORKDIR/config/byconity-worker           "systemctl stop byconity-worker-write"
  elif [ "$1" = "tso" ]; then
    mssh $WORKDIR/config/byconity-tso              "systemctl stop byconity-tso"
  elif [ "$1" = "server" ]; then
    mssh $WORKDIR/config/byconity-server           "systemctl stop byconity-server"
  elif [ "$1" = "read" ]; then
    mssh $WORKDIR/config/byconity-worker           "systemctl stop byconity-worker-default"
  elif [ "$1" = "write" ]; then
    mssh $WORKDIR/config/byconity-worker           "systemctl stop byconity-worker-write"
  elif [ "$1" = "dm" ]; then
    mssh $WORKDIR/config/byconity-daemon-manager   "systemctl stop byconity-daemon-manager"
  elif [ "$1" = "rm" ]; then
    mssh $WORKDIR/config/byconity-resource-manager "systemctl stop byconity-resource-manager"
  else
    echo "nothing"
  fi
}

restart()
{
  if [ "$1" = "all" ]; then
    mssh $WORKDIR/config/byconity-tso              "systemctl restart byconity-tso"
    mssh $WORKDIR/config/byconity-server           "systemctl restart byconity-server"
    mssh $WORKDIR/config/byconity-daemon-manager   "systemctl restart byconity-daemon-manager"
    mssh $WORKDIR/config/byconity-resource-manager "systemctl restart byconity-resource-manager"
    mssh $WORKDIR/config/byconity-worker           "systemctl restart byconity-worker-default"
    mssh $WORKDIR/config/byconity-worker           "systemctl restart byconity-worker-write"
  elif [ "$1" = "tso" ]; then
    mssh $WORKDIR/config/byconity-tso              "systemctl restart byconity-tso"
  elif [ "$1" = "server" ]; then
    mssh $WORKDIR/config/byconity-server           "systemctl restart byconity-server"
  elif [ "$1" = "read" ]; then
    mssh $WORKDIR/config/byconity-worker           "systemctl restart byconity-worker-default"
  elif [ "$1" = "write" ]; then
    mssh $WORKDIR/config/byconity-worker           "systemctl restart byconity-worker-write"
  elif [ "$1" = "dm" ]; then
    mssh $WORKDIR/config/byconity-daemon-manager   "systemctl restart byconity-daemon-manager"
  elif [ "$1" = "rm" ]; then
    mssh $WORKDIR/config/byconity-resource-manager "systemctl restart byconity-resource-manager"
  else
    echo "nothing"
  fi
}

status()
{
  if [ "$1" = "all" ]; then
    mssh $WORKDIR/config/byconity-tso              "systemctl status byconity-tso"
    mssh $WORKDIR/config/byconity-server           "systemctl status byconity-server"
    mssh $WORKDIR/config/byconity-daemon-manager   "systemctl status byconity-daemon-manager"
    mssh $WORKDIR/config/byconity-resource-manager "systemctl status byconity-resource-manager"
    mssh $WORKDIR/config/byconity-worker           "systemctl status byconity-worker-default"
    mssh $WORKDIR/config/byconity-worker           "systemctl status byconity-worker-write"
  elif [ "$1" = "tso" ]; then
    mssh $WORKDIR/config/byconity-tso              "systemctl status byconity-tso"
  elif [ "$1" = "server" ]; then
    mssh $WORKDIR/config/byconity-server           "systemctl status byconity-server"
  elif [ "$1" = "read" ]; then
    mssh $WORKDIR/config/byconity-worker           "systemctl status byconity-worker-default"
  elif [ "$1" = "write" ]; then
    mssh $WORKDIR/config/byconity-worker           "systemctl status byconity-worker-write"
  elif [ "$1" = "dm" ]; then
    mssh $WORKDIR/config/byconity-daemon-manager   "systemctl status byconity-daemon-manager"
  elif [ "$1" = "rm" ]; then
    mssh $WORKDIR/config/byconity-resource-manager "systemctl status byconity-resource-manager"
  else
    echo "nothing"
  fi
}


echo "$1 $2"
$1 $2

