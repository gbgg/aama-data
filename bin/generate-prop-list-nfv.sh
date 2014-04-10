#!/bin/bash
# usage:  bin/generate-prop-list-nfv.sh 
# 12/06/13: Makes file of all props that can or must occur in
# non-finite pdgms of each language

. bin/constants.sh
response=sparql/pdgms/pdgm-non-finite-prop-list.tsv
mv $response "${response}.bck"
#echo "fuquery.log" > logs/fuquery.log;
for f in `find data/ -name *.edn`
do
	#echo f = $f
    lang=`basename ${f%-pdgms.edn}`
    Lang="${lang[@]^}"
	labbrev=`grep $lang bin/lname-pref.txt`
	abbrev=${labbrev#$lang=}
    echo querying $Lang $lang -- $abbrev
	echo "##$lang : '$abbrev," >> $response
    #of=`basename ${2#sparql/templates/}`
	of=pdgm-non-finite-prop-list.template
	#echo of = $of
    localqry="sparql/pdgms/output/${of%.template}.$lang.rq"
	#mv $localqry "${localqry}.bck"
    #echo localqry = $localqry
    #sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" $2 > $localqry
    sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/pdgm-non-finite-prop-list.template > $localqry
    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry >> $response
done
	perl pl/pdgm-proplist2txt.pl $response

