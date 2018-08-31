#!/usr/bin/env bash
hostName=${1}
alias=${2}
index=${3}

if [ $# -lt 3 ]; then
  echo "USAGE: $0 hostName alias index"
  exit 1;
fi

echo "hostName: $hostName"

curl -XPUT https://$hostName:9200/$index/_alias/$alias