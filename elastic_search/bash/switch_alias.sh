#!/usr/bin/env bash
hostName=${1}
currentIndex=${2}
newIndex=${3}
alias=${4}

if [ $# -lt 4 ]; then
  echo "USAGE: $0 hostName originalIndex newIndex alias"
  exit 1;
fi

echo "hostName: $hostName"

curl -XPOST http://$hostName:9200/_aliases -d "
{
    \"actions\" : [
        { \"remove\" : { \"index\" : \"${currentIndex}\", \"alias\" : \"${alias}\" } },
        { \"add\" : { \"index\" : \"${newIndex}\", \"alias\" : \"${alias}\" } }
    ]
}"