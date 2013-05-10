#!/bin/bash
# usage:  fuquery <dir> <qry>
# where <qry> is a skeleton in <aama>/sparql.  See
# exponents.local.skel.rq for an example.

# example:
#    <aama> $ bin/fuquery.sh data/alaaba sparql/exponents.local.skel.rq
# example:
#    <aama> $ bin/fuquery.sh data/oromo sparql/templates/properties.template

. bin/constants.sh

echo "fuquery.log" > logs/fuquery.log;
for f in `find $1 -name *.xml`
do
    lang=`basename ${f%-pdgms.xml}`
    fn=${lang/-/\/}
    fn1=( ${lang/-/ } )
    fn2="${fn1[@]^}"
    FN=${fn2/ /\/}
    echo querying ${FN/ /\/} $fn
    of=`basename ${2#sparql/templates/}`
    localqry="sparql/${of%.template}.$lang.rq"
    echo $localqry
    sed -e "s/%Lang%/${FN/\//\/}/g" -e "s/%lang%/${fn/\//\/}/g" $2 > $localqry
    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry
done

#./s-query \
#	--output=tsv  \
#	--service http://localhost:3030/aamaTestData/query  \
#	--file=query-temp.rq  \
#	> ../cygwin/home/Gene/aamadata/tools/rq-ru/query-trial/$response
