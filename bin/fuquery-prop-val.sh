#!/bin/bash
# usage:  fuquery <dir> <qry>
# where <qry> is a skeleton in <aama>/sparql.  See
# exponents.local.skel.rq for an example.

# Cf. sparql/templates/README.txt

# example:
#    <aama> $ bin/fuquery.sh data/alaaba sparql/exponents.local.skel.rq
# example:
#    <aama> $ bin/fuquery.sh data/oromo sparql/templates/properties.template

. bin/constants.sh

echo "fuquery.log" > logs/fuquery.log;
for f in `find $1 -name *.xml`
do
    lang=`basename ${f%-pdgms.xml}`
    Lang="${lang[@]^}"
    echo querying $Lang $lang
    #of=`basename ${2#sparql/templates/}`
	of=propval.template
	echo of = $of
    localqry="sparql/prop-val/${of%.template}.$lang.rq"
	response="tmp/prop-val/${of%.template}.$lang-resp.tsv"
    echo $localqry
    #sed -e "s/%Lang%/${Lang}/g" -e "s/%lang%/${lang}/g" $2 > $localqry
    sed -e "s/%Lang%/${Lang}/g" -e "s/%lang%/${lang}/g" sparql/templates/propval.template > $localqry
    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry > $response
	perl pl/propvaltsv2table.pl $response
done

#./s-query \
#	--output=tsv  \
#	--service http://localhost:3030/aamaTestData/query  \
#	--file=query-temp.rq  \
#	> ../cygwin/home/Gene/aamadata/tools/rq-ru/query-trial/$response
