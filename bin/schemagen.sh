#!/bin/sh
# usage:  bin/schemagen.sh "dir" abbr

# 04/22/2013: gbgg modified script names to accommodate changed constants.sh and xsl
# 05/07/2013 gbgg added abbr arg (for xml2schema.sh

echo > logs/schemagen.log

for d in `ls -d $1`
do
    bin/xml2schema.sh $d  $2|| echo FAILURE xml2schema $d >> logs/schemagen.log

    bin/uniqschema.sh $d

    bin/schema2rdf.sh $d 

    #bin/fuput.sh $d || echo FAILURE fuput $d >> logs/schemagen.log

    # bin/fuquery.sh $d sparql/predicates-local-skel.rq || echo FAILURE fuquery $d >> logs/reload.log

done
