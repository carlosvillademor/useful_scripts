#!/usr/bin/env bash
hostName=${1}
index=${2}
type=${3}
documentId=${4}

if [ $# -lt 4 ]; then
  echo "USAGE: $0 hostName index type documentId"
  exit 1;
fi

echo "hostName: $hostName"

curl -XDELETE http://$hostName:9200/$index/$type/$documentId

