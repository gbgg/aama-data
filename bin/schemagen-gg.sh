#!/bin/sh
# usage:  bin/schemagen.sh "dir" abbr

# 04/22/2013: gbgg modified script names to accommodate changed constants.sh and xsl
# 05/07/13: gbgg added abbr arg (for xml2schema.sh)
# 05/10/13: gbgg restricted fuput.sh to fuput-schema.sh

echo > logs/schemagen.log

for d in `ls -d $1`
do
    bin/xml2schema-gg.sh $d  $2|| echo FAILURE xml2schema-gg $d >> logs/schemagen.log

    bin/uniqschema.sh $d

    bin/schema2rdf.sh $d 

    # Use fupost.sh (or fuput.sh) to load data
    #bin/fuput-schema.sh $d || echo FAILURE fuput $d >> logs/schemagen.log

    # bin/fuquery.sh $d sparql/predicates-local-skel.rq || echo FAILURE fuquery $d >> logs/reload.log

done
