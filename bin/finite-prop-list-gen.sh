#!/bin/bash
# usage:  fuquery-prop-val.sh <dir> 
# The template <aama>/sparql/templates/pdgm-finite-prop-list.template is hard-coded into the script.

# Cf. sparql/templates/README.txt

# example:
#    <aama> $ bin/fuquery.sh data/alaaba 

. bin/constants.sh
response=sparql/pdgms/pdgm-prop-list.out
echo "fuquery.log" > logs/fuquery.log;
for f in `find $1 -name *.html`
do
	echo f = $f
    lang=`basename ${f%-pdgms.html}`
    Lang="${lang[@]^}"
	labbrev=`grep $lang bin/lname-pref.txt`
	abbrev=${labbrev#$lang=}
    echo querying $Lang $lang -- $abbrev
	echo "##$lang : '$abbrev," >> $response
    #of=`basename ${2#sparql/templates/}`
	of=pdgm-finite-prop-list.template
	#echo of = $of
    localqry="tmp/prop-val/${of%.template}.$lang.rq"
    echo localqry = $localqry
    #sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" $2 > $localqry
    sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/pdgm-finite-prop-list.template > $localqry
    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry >> $response
done
#	perl pl/finite-proplist2text.pl $response

