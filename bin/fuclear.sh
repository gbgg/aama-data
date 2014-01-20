#!/bin/bash
# delete fuseki graphs
# usage:  fuclear <arg>
# <arg> ==  DEFAULT | NAMED | ALL | IRIref

# Has no effect. Returns: "204: no content". Also in Fuseki interface.

. bin/constants.sh

echo "fuclear.log" > logs/fuclear.log;

graph="<http://oi.uchicago.edu/aama/$1>"

echo "clearing graph $graph"
# set -x
${FUSEKIDIR}/s-update -v --service http://localhost:3030/aama/update "CLEAR DEFAULT" 2>&1 | >> logs/fuclear.log
# set +x
