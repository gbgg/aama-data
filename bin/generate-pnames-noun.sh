#!/bin/sh

# rev 12/03/13, adapted from generate-pnames-nfv.sh
# usage: bin/generate-pnames-pro.sh <dir>

# The script is designed to produce displays of pro paradigm names in one or more languages. 

. bin/constants.sh

for f in `find $1 -name *.edn`
do
    lang=`basename ${f%-pdgms.edn}`
    Lang="${lang[@]^}"
	labbrev=`grep $lang bin/lname-pref.txt`
	abbrev=${labbrev#$lang=}
	#echo "querying $lang $Lang $abbrev"
	localqry=sparql/pdgms/output/pnames-noun-$lang-query.rq
	response=sparql/pdgms/output/pnames-noun-$lang-resp.tsv
	echo "Localqry = $localqry"
	echo "Response = $response"
	sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/pdgm-noun-pnames.template > $localqry

    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry > $response

	perl pl/pname-np-list2txt.pl $response $lang 
done




#perl pl/pnamestsv2txt.pl	$response $qstring

