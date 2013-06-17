#!/bin/bash
# usage:  qrygraphs
# list uris of all named graphs

echo "qrygraphs.log" > logs/qrygraphs.log;
set -x
s-query --service http://localhost:3030/aama/query --query=sparql/graphs.rq
set +x
