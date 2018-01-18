#!/usr/bin/env bash
host=${1}
index=${2}
type=${3}
documentId=${4}

if [ $# -lt 4 ]; then
  echo "USAGE: $0 host index type documentId"
  exit 1;
fi

curl -XDELETE $host:9200/$index/$type/$documentId

