#!/bin/bash
# usage:  qrylangs

echo "qrylangs.log" > logs/qrylangs.log;
set -x
fuquery.sh --service http://localhost:3030/aama/query --query=sparql/langs.rq
set +x
