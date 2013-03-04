#!/bin/bash
# usage:  fuput "dir"
# examples:
#    aama/$ tools/fuput "data/*" --  puts everything
#    aama/$ tools/fuput "data/alaaba" -- puts only alaabe
#    aama/$ tools/fuput "data/alaaba data/burji data/coptic" -- puts all 3 datasets
#    aama/$ tools/fuput "schema" -- puts all 3 datasets
# cumulative logfile written to logs/fuput.log
# each lang/var gets its own logfile

echo "fuput.log" > logs/fuput.log;
for f in `find $1 -name *.xml`
do
    lang=`dirname ${f#data/}`
    echo $lang
    fn=data/$lang/`basename ${f%-pdgms.xml}`.schema.rdf
    graph="http://oi.uchicago.edu/aama/$lang"
    echo putting $fn to $graph;
    s-put -v http://localhost:3030/aama/data $graph  $fn 2>&1 >>logs/fuput.log
done
