#!/bin/bash
# dependency:  rapper, from raptor, part of redland rdf lib
# usage:  ttl2rdff "dir"
# examples:
#    aama/$ tools/ttl2rdff "data/*" --  converts everything
#    aama/$ tools/ttl2rdffttl2rdff "data/alaaba" -- converts only alaabe
#    aama/$ tools/ttl2rdffttl2rdff "data/alaaba data/burji data/coptic" -- converts three files
#    aama/$ tools/ttl2rdffttl2rdff "schema" -- converts only schema
# cumulative logfile written to logs/ttl2rdff.log
# each lang/var gets its own logfile

. tools/constants.sh

echo "ttl2rdff" > logs/ttl2rdff.log;

# for f in `find $1 -name *.xml`
# do
    # l1=`dirname $f`
    # lang=${l1#data/}
    # from=data/$lang/`basename ${f%-pdgms.xml}`.schema.ttl
    # to=data/$lang/`basename ${f%-pdgms.xml}`.schema.rdf
    # echo "$lang: rdfizing "$from to $to

    java -jar ${RDF2RDF} $1 ${1%.ttl}.rdf

    # rapper -q -i guess -o rdfxml schema/$fn 2>&1 \
    # 	1>schema/${fn%.ttl}.rdf | tee -a logs/ttl2rdff.log | tee schema/${fn%.ttl}.log
# done
