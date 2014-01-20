#!/bin/bash
# delete default fuseki graph
# usage:  fuclear

# Doesn't work. Error 500: Quad: object cannot be null. (beja-arteiga)
. bin/constants.sh

echo "fuclear.log" > logs/fuclear.log;

graph="<http://oi.uchicago.edu/aama/$1>"

echo "clearing graph $graph"
# set -x
${FUSEKIDIR}/s-update -v --service http://localhost:3030/aama/update "DROP ALL" 2>&1 | >> logs/fuclear.log
# set +x
