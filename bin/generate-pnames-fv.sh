 #!/bin/sh

# rev 11/22/13, adapted from display-paradigms.sh
# usage: bin/display-pnames.sh <dir>

# The script is designed to produce displays of finite verb paradigm names
# in one or more languages. 

. bin/constants.sh

# After starting the server with fuseki.sh, first copy the query files;

for f in `find $1 -name *.edn`
do
    lang=`basename ${f%-pdgms.edn}`
    Lang="${lang[@]^}"
	labbrev=`grep $lang bin/lname-pref.txt`
	abbrev=${labbrev#$lang=}
	echo "querying $lang $Lang $abbrev"
	localqry=sparql/pdgms/output/pnames-fv-$lang-query.rq
	response=sparql/pdgms/output/pnames-fv-$lang-resp.tsv
	echo "Localqry = $localqry"
	echo "Response = $response"
	sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/pdgm-finite-prop-list.template > $localqry

    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry > $response

	localqry2=sparql/pdgms/output/pnames-fv-$lang-query2.rq
	perl pl/pname2query.pl  $response $lang $abbrev $localqry2
	response2=sparql/pdgms/output/pnames-fv-$lang-resp2.tsv

    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry2 > $response2
	echo "Response2 = $response2"
	perl pl/pname-fv-list2txt.pl $response2 $lang 
done




#perl pl/pnamestsv2txt.pl	$response $qstring

