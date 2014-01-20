#!/bin/bash
# usage:  display-paradigms.sh data/<lang> qlabel, display-paradigms.sh "data/<lang> data/<lang> . . ." qlabel, display-paradigms.sh "data/*" qlabel

# 10/30/13
#11/04/13 generalized to more than one language

# Script to generate finite verb paradigms in one or more languages.
# Script first generates table of the properties and their values which can occur in pdgm of finite verb. The user is then asked to specify a line of properties and values of the form: prop=val:prop=val: . . . The corresponding pradigm is then generated.
# This script is a combination of finite-prop-val-lang.sh and pdgm-display.sh
# The template <aama>/sparql/templates is hard-coded into the script.

# Cf. sparql/templates/README.txt

# example:
#    <aama> $ bin/finite-prop-val-lang.sh data/beja-arteiga 

. bin/constants.sh

echo "fuquery.log" > logs/fuquery.log;
#echo " 'Non-finite verb' is operationally defined as any form of  a verb that" 
#echo " is marked for a value of tam, and is marked also at least for" 
#echo " person  (optionally also for gender and number). "
#echo
#echo Please provide a label for query --
#read -e -p Query_Label: querylabel
for f in `find $1 -name *.html`
do
    lang=`basename ${f%-pdgms.html}`
    Lang="${lang[@]^}"
	##pnamefile="sparql/pdgms/pname-$pos-list-$lang.txt";
	##add fv/nfv
	pnamefile="sparql/pdgms/pname-fv-list-$lang.txt";
	labbrev=`grep $lang bin/lname-pref.txt`
	abbrev=${labbrev#$lang=}
	echo "pnamefile = $pnamefile"
	echo 
	echo " The following is a list of property values"
	echo " for finite verbs in ${Lang}:"
	echo
	perl pl/pnames-print.pl $pnamefile
	echo
	echo "Choose pdgm number  or Ctrl-C to exit"
	echo
	read -e -p Number: pnumber
	echo
	## Find way to cycle through more than one number
	localqry=sparql/pdgms/output/pname-$lang-fv-$pnumber-query.rq
	response=sparql/pdgms/output/pname-$lang-fv-$pnumber-resp.tsv
	rm $response
	echo "Localqry = $localqry"
	echo "Response = $response"
	echo 
	#title=" "
	perl pl/qstring-fv-pname2query.pl $pnamefile $localqry $pnumber $abbrev 

	${FUSEKIDIR}/s-query \
		--output=tsv  \
		--service http://localhost:3030/aama/query  \
		--query=$localqry  \
		> $response

	perl pl/pdgm-fv-tsv2table.pl	$response 
done 