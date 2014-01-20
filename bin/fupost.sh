#!/bin/bash
# usage:  fupost "dir"
# examples:
#    aama/$ tools/fupost "data/*" --  loads everything
#    aama/$ tools/fupost "data/alaaba" -- loads only alaaba
#    aama/$ tools/fupost "data/alaaba data/burji data/coptic" -- loads all 3 datasets
#    aama/$ tools/fupost "schema" -- loads all 3 datasets
# cumulative logfile written to logs/fupost.log
# each lang/var gets its own logfile

# 07/13/13: cf. fupost-default.sh for loading data into single default graph

. bin/constants.sh

echo "fuload.log" > logs/fuload.log;
for f in `find $1 -name *.rdf`
do
    l=${f%.rdf}
    lang=${l#data/}
    graph="http://oi.uchicago.edu/aama/2013/graph/`dirname ${lang/\/\///}`"
    echo posting $f to $graph;
    ${FUSEKIDIR}/s-post -v http://localhost:3030/aama/data $graph  $f 2>&1 >>logs/fuload.log
	#${FUSEKIDIR}/s-post -v http://localhost:3030/aamaData/data 'default'   $f 2>&1 >>logs/fuload.log
done
