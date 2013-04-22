#!/bin/bash
# dependency:  rdf2rdf
# usage:  data2rdf "dir"
# examples:
#    aama/$ tools/data2rdf "data/*" --  converts everything
#    aama/$ tools/data2rdfdata2rdf "data/alaaba" -- converts only alaabe
#    aama/$ tools/data2rdfdata2rdf "data/alaaba data/burji data/coptic" -- converts three files
#    aama/$ tools/data2rdfdata2rdf "schema" -- converts only schema
# cumulative logfile written to logs/data2rdf.log
# each lang/var gets its own logfile

. tools/constants-gg.sh

echo "data2rdf" > logs/data2rdf.log;

for f in `find $1 -name *.xml`
do
    l1=`dirname $f`
    lang=${l1#data/}
    from=data/$lang/`basename ${f%-pdgms.xml}`.data.ttl
    to=data/$lang/`basename ${f%-pdgms.xml}`.data.rdf
    echo "$lang: rdfizing "$from to $to

    java -jar ${RDF2RDF} $from $to

    # rapper -q -i guess -o rdfxml $from 2>&1 \
    # 	1>$to | tee -a logs/data2rdf.log | tee schema/${fn%.ttl}.log
done
