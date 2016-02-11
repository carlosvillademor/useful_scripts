#!/usr/bin/env bash
host=${1}
index=${2}

if [ $# -lt 2 ]; then
  echo "USAGE: $0 host index"
  exit 1;
fi

echo "HOST: $host"

curl -XPUT $host:9200/$index