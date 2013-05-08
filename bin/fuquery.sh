#!/usr/local/bin/bash
# usage:  fuquery <dir> <qry>
# where <qry> is a skeleton in <aama>/sparql.  See
# exponents.local.skel.rq for an example.

# example:
#    <aama> $ bin/fuquery.sh data/alaaba sparql/exponents.local.skel.rq

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
    ${FUSEKIDIR}/s-query --service http://localhost:3030/aama/query --query=$localqry
done
