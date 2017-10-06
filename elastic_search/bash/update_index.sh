#!/usr/bin/env bash
host=${1}
index=${2}
replicas=${3}

if [ $# -lt 3 ]; then
  echo "USAGE: $0 host index replicas"
  exit 1;
fi

echo "HOST: $host"

curl -XPUT $host:9200/$index/_settings -d "
{
    \"index\" : {
	"number_of_replicas": 0
    }
}"
