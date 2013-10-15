#!/bin/bash
# usage:  fuquery-prop-val.sh <dir> 
# The template <aama>/sparql/templates is hard-coded into the script.

# Cf. sparql/templates/README.txt

# example:
#    <aama> $ bin/fuquery.sh data/alaaba 

. bin/constants.sh

echo "fuquery.log" > logs/fuquery.log;
for f in `find $1 -name *.html`
do
    lang=`basename ${f%-pdgms.html}`
    Lang="${lang[@]^}"
	labbrev=`grep $lang bin/lname-pref.txt`
	abbrev=${labbrev#$lang=}
    #echo querying $Lang $lang -- $abbrev
    #of=`basename ${2#sparql/templates/}`
	of=pdgm-finite-props.template
	#echo of = $of
    localqry="tmp/prop-val/${of%.template}.$lang.rq"
	response="tmp/prop-val/${of%.template}.$lang-resp.tsv"
    #echo $localqry
    #sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" $2 > $localqry
    sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/pdgm-finite-props.template > $localqry
    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry > $response
	perl pl/propvaltsv2table.pl $response
done

#./s-query \
#	--output=tsv  \
#	--service http://localhost:3030/aamaTestData/query  \
#	--file=query-temp.rq  \
#	> ../cygwin/home/Gene/aamadata/tools/rq-ru/query-trial/$response
