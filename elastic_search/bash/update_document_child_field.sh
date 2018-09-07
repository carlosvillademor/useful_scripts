#!/usr/bin/env bash
hostName=${1}
index=${2}
type=${3}
documentId=${4}
field=${5}
childField=${6}
value=${7}

if [ $# -lt 7 ]; then
  echo "USAGE: $0 hostName index type documentId field childField value"
  exit 1;
fi

echo "hostName: $hostName"

curl -H "Content-Type: application/json" -X POST http://$hostName:9200/$index/$type/$documentId/_update -d "
	{ \"doc\" :
		{ \"${field}\": { \"${childField}\": \"${value}\" }}
	}"


