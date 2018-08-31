#!/usr/bin/env node
var ElasticSearch = require('elasticsearch');
var _ = require('lodash');

if(process.argv.length !== 12) {
    console.log('USAGE: ', process.argv[0], process.argv[1], 'originHostName originESIndex originESType targetHostName targetESIndex targetESType from size throttleInMs searchFilter');
    process.exit(1);
}

var originHostName = process.argv[2];
var originESIndex = process.argv[3];
var originESType = process.argv[4];
var targetHostName = process.argv[5];
var targetESIndex = process.argv[6];
var targetESType = process.argv[7];
var from = Number(process.argv[8]);
var size = Number(process.argv[9]);
var throttleInMs = Number(process.argv[10]);
var filter = process.argv[11] && JSON.parse(process.argv[11]) || {match_all: {}};

console.log("FROM: Elastic Search host:", originHostName);
console.log("TO:   Elastic Search host:", targetHostName);

console.log('Double check the hosts to copy the data from and to are correct. You have 5 seconds to stop this script by using Ctrl + C');

setTimeout(function() {
    var startTime = new Date();
    var esOriginOptions = {
        host: 'http:' + originHostName + ':9200',
        log: 'info',
        apiVersion: '1.3'
    };
    var esOrigin = new ElasticSearch.Client(esOriginOptions);

    var esTargetOptions = {
        host: 'http' + targetHostName + ':9200',
        log: 'info',
        apiVersion: '1.3'
    };
    var esTarget = new ElasticSearch.Client(esTargetOptions);

    function scanAndScroll(next) {
        var bulkBody = [];
        var matchAllFilter = {
            query: {
                filtered: {
                    filter: filter
                }
            },
            from: from,
            size: size
        };
        var startTime = new Date();
        esOrigin.search({index: originESIndex, type: originESType, body: matchAllFilter, searchType: 'scan', scroll: '10s'}, function getMoreUntilDone(err, scanSearch, status) {
            if (err) {
                console.log('Error while scanning data from Elastic Search host', originHostName, 'for index', originESIndex, 'and type', originESType, ', error:', err, ', status:', status);
                process.exit(1);
            }
            _.forEach(scanSearch.hits.hits, function(hit) {
                bulkBody.push({ index: { _index: targetESIndex, _type: targetESType, _id: hit._id } });
                bulkBody.push(hit._source);
            });
            if((bulkBody.length/2) >= scanSearch.hits.total - from) {
                console.log('Number of documents read and passed to bulk operation', bulkBody.length / 2, '. Scanning and scrolling took', new Date() - startTime, 'ms');
                return next(bulkBody);
            }
            esOrigin.scroll({ scrollId: scanSearch._scroll_id, scroll: '10s' }, getMoreUntilDone);
        });
    }

    var reindexFrom = 0;
    function reindex(bulkBody) {
      function bulk(bulkBodyPortion) {
          esTarget.bulk({body: bulkBodyPortion}, function(err, response, status) {
              if (err) {
                  console.log('Error while indexing data to Elastic Search host', targetHostName, 'for index', targetESIndex, 'and type', targetESType, ', error:', err, ', status:', status);
                  process.exit(1);
              }
              reindexFrom += size*2;
              reindex(bulkBody);
          });
      }
      if(bulkBody.length === 0 || reindexFrom>=(bulkBody.length)) {
          console.log('' + bulkBody.length/2, 'documents indexed to Elastic Search host', targetHostName, 'for index', targetESIndex, 'and type', targetESType, '. Total time,', new Date() - startTime, 'ms');
          process.exit(0);
      }
      setTimeout(function() {
          bulk(bulkBody.slice(reindexFrom, reindexFrom + size * 2));
      }, throttleInMs);
    }

    scanAndScroll(reindex);
}, 5000);
