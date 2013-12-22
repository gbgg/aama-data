#!/bin/sh
# usage:  bin/generate-ttl-rdf.sh "dir" 

# 03/12/13
# script to regenerate lang ttl/rdf after xml repair. unites datagen-gg.sh, schemagen-gg.sh, fudelete.sh, fupost.sh

echo > logs/datagen.log

for d in `ls -d $1`
do
    bin/xml2data-gg.sh $d  || echo FAILURE xml2data-gg $d >> logs/datagen.log

    bin/data2rdf.sh $d 

    bin/xml2schema-gg.sh $d  || echo FAILURE xml2schema-gg $d >> logs/schemagen.log

    bin/uniqschema.sh $d

    bin/schema2rdf.sh $d 

	# delete old data from datastore
	bin/fudelete.sh $d
    # Use fupost.sh (or fuput.sh) to load data
	bin/fupost.sh $d
done
# test count-triples.rq and list-graphs.rq
bin/fuqueries.sh

