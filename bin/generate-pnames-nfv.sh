#!/bin/sh

# rev 11/26/13, adapted from display-pnames.sh
# usage: bin/display-pnames.sh <dir>

# The script is designed to produce displays of non-finite verb paradigm names in one or more languages. 

. bin/constants.sh
ldomain=${1//,/ }
ldomain=${ldomain//\"/}

for f in `find $1 -name *.edn`
do
    lang=`basename ${f%-pdgms.edn}`
    Lang="${lang[@]^}"
	labbrev=`grep $lang bin/lname-pref.txt`
	abbrev=${labbrev#$lang=}
	#echo "querying $lang $Lang $abbrev"
	localqry=sparql/pdgms/output/pnames-nfv-$lang-query.rq
	response=sparql/pdgms/output/pnames-nfv-$lang-resp.tsv
	echo " "
	echo "Localqry = $localqry"
	echo "Response = $response"
	sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/pdgm-non-finite-pnames.template > $localqry

    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry > $response

	perl pl/pname-nfv-list2txt.pl $response $lang 
done




#perl pl/pnamestsv2txt.pl	$response $qstring


if [ "$2" = "menu" ] ; then
    bin/aama-query-display-demo.sh
fi
