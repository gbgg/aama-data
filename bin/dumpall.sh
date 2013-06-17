#!/bin/bash
# usage:  fudumpall

echo "fudump.log" > logs/fudump.log;
s-query --service http://localhost:3030/aama/query --query=sparql/fuseki.query.rq

