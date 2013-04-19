#!/bin/bash

echo "fuload.log" > logs/fuload.log;
for f in `ls $1.rdf`
do
    l=${f%.rdf}
    lang=${l#schema/}
    graph="http://oi.uchicago.edu/aama/Arabic"
    echo posting $f to $graph;
    s-post -v http://localhost:3030/aama/data $graph  $f 2>&1 >>logs/fuload.log
done
