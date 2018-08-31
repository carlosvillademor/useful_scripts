#!/usr/bin/env bash
hostName=${1}
index=${2}
type=${3}

if [ $# -lt 3 ]; then
  echo "USAGE: $0 hostName index type"
  exit 1;
fi

echo "hostName: $hostName"

curl -XDELETE http://$hostName:9200/$index/$type/_query -d '
{
  "query": {
    "bool": {
      "must": [
        {
          "match_all": {}
        }
      ]
    }
  }
}'
