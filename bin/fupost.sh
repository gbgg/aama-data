#!/bin/bash
# usage:  fuload "dir"
# examples:
#    aama/$ tools/fuload "data/*" --  loads everything
#    aama/$ tools/fuload "data/alaaba" -- loads only alaabe
#    aama/$ tools/fuload "data/alaaba data/burji data/coptic" -- loads all 3 datasets
#    aama/$ tools/fuload "schema" -- loads all 3 datasets
# cumulative logfile written to logs/fuload.log
# each lang/var gets its own logfile


. tools/constants.sh

echo "fuload.log" > logs/fuload.log;
for f in `find $1 -name *.rdf`
do
    l=${f%.rdf}
    lang=${l#data/}
    graph="http://oi.uchicago.edu/aama/`dirname ${lang/\/\///}`"
    echo posting $f to $graph;
    ${FUSEKIDIR}/s-post -v http://localhost:3030/aama/data $graph  $f 2>&1 >>logs/fuload.log
done
