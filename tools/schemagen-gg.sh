#!/bin/sh
# usage:  fuquery "dir"

echo > logs/schemagen.log

for d in `ls -d $1`
do
    tools/xml2schema-gg.sh $d || echo FAILURE xml2schema $d >> logs/schemagen.log

    tools/uniqschema.sh $d

    tools/schema2rdf-gg.sh $d

    #tools/fuput.sh $d || echo FAILURE fuput $d >> logs/schemagen.log

    # tools/fuquery.sh $d sparql/predicates-local-skel.rq || echo FAILURE fuquery $d >> logs/reload.log

done
