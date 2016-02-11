#!/usr/bin/env bash
host=${1}
currentIndex=${2}
newIndex=${3}
alias=${4}

if [ $# -lt 4 ]; then
  echo "USAGE: $0 host originalIndex newIndex alias"
  exit 1;
fi

echo "HOST: $host"

curl -XPOST http://$host:9200/_aliases -d "
{
    \"actions\" : [
        { \"remove\" : { \"index\" : \"${currentIndex}\", \"alias\" : \"${alias}\" } },
        { \"add\" : { \"index\" : \"${newIndex}\", \"alias\" : \"${alias}\" } }
    ]
}"