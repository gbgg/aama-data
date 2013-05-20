#!/bin/sh
# usage:  bin/datagen.sh "dir" abbr

# 05/10/13: gbgg remodeled datagen on basis of schemagen.sh
# old datagen.sh is now xml2data.sh fuput.sh 
# 05/20/13: gbgg datagen-aa created from datagen to generalize data.ttl to aama: namespace

echo > logs/datagen-aa.log

for d in `ls -d $1`
do
    bin/xml2data-aa.sh $d  $2|| echo FAILURE xml2data $d >> logs/datagen-aa.log

    bin/data2rdf-aa.sh $d 

    bin/fuput-data-aa.sh $d || echo FAILURE fuput $d >> logs/datagen-aa.log

    # bin/fuquery.sh $d sparql/predicates-local-skel.rq || echo FAILURE fuquery $d >> logs/reload.log

done
