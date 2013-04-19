#!/bin/bash
# usage:  fuget "dir"
# examples:
#    aama/$ tools/fuget "data/*" --  gets everything
#    aama/$ tools/fuget "data/alaaba" -- gets only alaabe
#    aama/$ tools/fuget "data/alaaba data/burji data/coptic" -- gets all 3 datasets
#    aama/$ tools/fuget "schema" -- gets all 3 datasets
# cumulative logfile written to logs/fuget.log
# each lang/var gets its own logfile

echo "fuget.log" > logs/fuget.log;
for f in `ls $1.rdf`
do
    l=${f%.rdf}
    lang=${l#schema/}
    graph="http://oi.uchicago.edu/aama/$lang"
    echo getting $f to $graph;
    # s-get -v http://localhost:3030/aama/data $graph  $f 2>&1 >>logs/fuget.log
done
