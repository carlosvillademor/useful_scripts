#!/usr/bin/env bash
host=${1}
index=${2}
type=${3}
documentId=${4}
field=${5}
value=${6}

if [ $# -lt 6 ]; then
  echo "USAGE: $0 host index type documentId field value"
  exit 1;
fi

echo "HOST: $host"

curl -H "Content-Type: application/json" -X POST http://$host:9200/$index/$type/$documentId/_update -d "
	{ \"doc\" : 
		{ \"${field}\": \"${value}\" }
	}"


