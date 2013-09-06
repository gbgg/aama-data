#!/bin/bash
# usage:  fuquery-vals-for-prop.sh <dir> prop
# The template <aama>/sparql/templates is hard-coded into the script.

# Cf. sparql/templates/README.txt

# example:
#    <aama> $ bin/fuquery.sh data/alaaba 

. bin/constants.sh

echo "fuquery.log" > logs/fuquery.log;
for f in `find $1 -name *.html`
do
    lang=`basename ${f%-pdgms.html}`
	type=$2
    #Lang="${lang[@]^}"
    echo querying $lang for $type values
    #of=`basename ${2#sparql/templates/}`
	of=valsforprop.template
	#out=valsforprop-$type
	echo out = $out
	#echo of = $of
    localqry="tmp/prop-val/${of%.template}.$lang.rq"
	response="tmp/prop-val/${of%.template}.$lang-resp.tsv"
    #echo $localqry
    #sed -e "s/%Lang%/${Lang}/g" -e "s/%lang%/${lang}/g" $2 > $localqry
    sed -e "s/%type%/${type}/g" -e "s/%lang%/${lang}/g" sparql/templates/valsforprop.template > $localqry
    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry > $response
	perl pl/valforproptsv2table.pl $response $type
done

#./s-query \
#	--output=tsv  \
#	--service http://localhost:3030/aamaTestData/query  \
#	--file=query-temp.rq  \
#	> ../cygwin/home/Gene/aamadata/tools/rq-ru/query-trial/$response
