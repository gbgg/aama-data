#!/bin/bash
# dependency:  rapper, from raptor, part of redland rdf lib
# usage:  schema2rdf "dir"
# examples:
#    aama/$ tools/schema2rdf "data/*" --  converts everything
#    aama/$ tools/schema2rdfschema2rdf "data/alaaba" -- converts only alaabe
#    aama/$ tools/schema2rdfschema2rdf "data/alaaba data/burji data/coptic" -- converts three files
#    aama/$ tools/schema2rdfschema2rdf "schema" -- converts only schema
# cumulative logfile written to logs/schema2rdf.log
# each lang/var gets its own logfile

. tools/constants.sh

echo "schema2rdf" > logs/schema2rdf.log;

for f in `find $1 -name *.xml`
do
    l1=`dirname $f`
    lang=${l1#data/}
    from=data/$lang/`basename ${f%-pdgms.xml}`.schema.ttl
    to=data/$lang/`basename ${f%-pdgms.xml}`.schema.rdf
    echo "$lang: rdfizing "$from to $to

    java -jar ${RDF2RDF} $from $to

    # rapper -q -i guess -o rdfxml schema/$fn 2>&1 \
    # 	1>schema/${fn%.ttl}.rdf | tee -a logs/schema2rdf.log | tee schema/${fn%.ttl}.log
done
