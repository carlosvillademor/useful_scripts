#!/usr/bin/env bash
hostName=${1}
index=${2}
replicas=${3}

if [ $# -lt 3 ]; then
  echo "USAGE: $0 hostName index replicas"
  exit 1;
fi

echo "hostName: $hostName"

curl -XPUT http://$hostName:9200/$index/_settings -d "
{
    \"index\" : {
	"number_of_replicas": 0
    }
}"
