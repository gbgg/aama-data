#!/bin/sh
# usage:  bin/datagen.sh "dir" abbr

# 05/10/13: gbgg remodeled datagen on basis of schemagen.sh
# old datagen.sh is now xml2data.sh fuput.sh 

echo > logs/datagen.log

for d in `ls -d $1`
do
    bin/xml2data.sh $d  $2|| echo FAILURE xml2data $d >> logs/datagen.log

    bin/data2rdf.sh $d 

    bin/fuput-data.sh $d || echo FAILURE fuput $d >> logs/datagen.log

    # bin/fuquery.sh $d sparql/predicates-local-skel.rq || echo FAILURE fuquery $d >> logs/reload.log

done
