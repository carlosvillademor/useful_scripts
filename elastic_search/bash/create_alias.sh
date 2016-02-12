#!/usr/bin/env bash
host=${1}
alias=${2}
index=${3}

if [ $# -lt 3 ]; then
  echo "USAGE: $0 host alias index"
  exit 1;
fi

echo "HOST: $host"

curl -XPUT $host:9200/$index/_alias/$alias