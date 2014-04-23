#!/bin/bash
# usage:  display-paradigms.sh data/<lang> qlabel, display-paradigms.sh "data/<lang> data/<lang> . . ." qlabel, display-paradigms.sh "data/*" qlabel


. bin/constants.sh
ldomain=${1//,/ }
ldomain=${ldomain//"/}

echo "fuquery.log" > logs/fuquery.log;
#echo " 'Non-finite verb' is operationally defined as any form of  a verb that" 
#echo " is marked for a value of tam, and is marked also at least for" 
#echo " person  (optionally also for gender and number). "
#echo
#echo Please provide a label for query --
#read -e -p Query_Label: querylabel
for f in `find $1 -name *.edn`
do
    lang=`basename ${f%-pdgms.edn}`
    Lang="${lang[@]^}"
	pnamefile="sparql/pdgms/pname-noun-list-$lang.txt";
	labbrev=`grep $lang bin/lname-pref.txt`
	abbrev=${labbrev#$lang=}
	echo "pnamefile = $pnamefile"
	echo 
	echo " The following is a list of properties and values"
	echo " for noun paradigms in ${lang}:"
	echo
	perl pl/pnames-print.pl $pnamefile
	echo
	echo "Choose pdgm number or Ctrl-C to exit"
	echo
	read -e -p Number: pnumber
	echo
	localqry=sparql/pdgms/output/pname-$lang-noun-$pnumber-query.rq
	response=sparql/pdgms/output/pname-$lang-noun-$pnumber-resp.tsv
	echo "Localqry = $localqry"
	echo "Response = $response"
	echo 

	perl pl/qstring-noun-pname2query.pl $pnamefile $pnumber $localqry $abbrev

	${FUSEKIDIR}/s-query \
		--output=tsv  \
		--service http://localhost:3030/aama/query  \
		--query=$localqry  \
		> $response

	perl pl/pdgmtsv2table.pl	$response $qstring
done 
bin/aama-query-display-demo.sh
