#!/bin/sh
# usage:  bin/schemagen.sh "dir" 
# e.g.: bin/schemagen.sh data/oromo 

# 04/22/2013: gbgg modified script names to accommodate changed constants.sh and xsl
# 05/07/13: gbgg added abbr arg (for xml2schema.sh)
# 05/10/13: gbgg restricted fuput.sh to fuput-schema.sh
# 08/09/13: gbgg added fupost.sh (for cumulative upload), and two sample 
# 10/02/13:	abbr arg supplied by grep in xml2schema-gg.sh
# verification queries (num. of triples and list of graphs -- more substantive queries
# to be added.

echo > logs/schemagen.log

for d in `ls -d $1`
do
    bin/xml2schema-gg.sh $d  || echo FAILURE xml2schema-gg $d >> logs/schemagen.log

    bin/uniqschema.sh $d

    bin/schema2rdf.sh $d 

    # Use fupost.sh (or fuput.sh) to load data
    #bin/fuput-schema.sh $d || echo FAILURE fuput $d >> logs/schemagen.log
	
	#bin/fupost.sh $d

    # bin/fuquery.sh $d sparql/predicates-local-skel.rq || echo FAILURE fuquery $d >> logs/reload.log
	
	#bin/fuquery-gen.sh sparql/rq-ru/count-triples.rq
	#bin/fuquery-gen.sh sparql/rq-ru/list-graphs.rq

done
