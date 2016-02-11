#!/usr/bin/env bash
host=${1}
index=${2}
type=${3}

if [ $# -lt 3 ]; then
  echo "USAGE: $0 host index type"
  exit 1;
fi

echo "HOST: $host"

curl -XDELETE http://$host:9200/$index/$type/_query -d '
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
