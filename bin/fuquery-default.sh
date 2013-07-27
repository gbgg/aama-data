#!/bin/bash
# usage:  fuquery <qry> <output>

# example:
#    <aama> $ bin/fuquery-gen.sh sparql/rq-ru/count-triples.rq

. bin/constants.sh

echo "Query:" $1
${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aamaDefault/query --query=$1


#./s-query \
#	--output=tsv  \
#	--service http://localhost:3030/aamaTestData/query  \
#	--file=query-temp.rq  \
#	> ../cygwin/home/Gene/aamadata/tools/rq-ru/query-trial/$response
