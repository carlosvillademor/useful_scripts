#!/usr/bin/env bash
hostName=${1}
index=${2}
shards=${3}
replicas=${4}

if [ $# -lt 4 ]; then
  echo "USAGE: $0 hostName index shards replicas"
  exit 1;
fi

echo "hostName: $hostName"

curl -XPUT http://$hostName:9200/$index -d "
{
  \"settings\" : {
      \"index\" : {
          "number_of_shards": $shards,
  	  "number_of_replicas": $replicas
      }
  }
}"
