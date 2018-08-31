#!/usr/bin/env bash
hostName=${1}
index=${2}

if [ $# -lt 2 ]; then
  echo "USAGE: $0 hostName index"
  exit 1;
fi

echo "hostName: $hostName"

curl -XDELETE http://$hostName:9200/$index
