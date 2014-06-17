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
ldomain=${1//,/ }
ldomain=${ldomain//\"/}

echo "fuquery.log" > logs/fuquery.log;
#echo " 'Finite verb' is operationally defined as any form of  a verb that" 
#echo " is marked for a value of tam, and is marked also at least for" 
#echo " person  (optionally also for gender and number). "
#echo
#echo Please provide a label for query --
#read -e -p Query_Label: querylabel
#for f in `find $1 -name *.edn`
echo " arg1 = $1"
echo "ldomain = $ldomain"
#qlbl=${1//data\//}
#qlabel=${qlbl//\/,/-}
#echo "qlabel = $qlabel"
qlbl=bil-tsv-trial
echo "Enter query label"
read -e -p "Qlabel (default $qlbl) : " input
qlabel=${input:-$qlbl}
response=tmp/pdgm/pname-$qlabel-resp.tsv
rm $response

for f in `find $ldomain -name *.edn`
do
    lang=`basename ${f%-pdgms.edn}`
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
	localqry=tmp/pdgm/pname-$lang-fv-$pnumber-query.rq
	echo "Localqry = $localqry"
	echo "Response = $response"
	echo

        perl pl/qstring-bil-fv-pname2query.pl $pnamefile $localqry $pnumber $abbrev $pdgmlist

	${FUSEKIDIR}/s-query \
		--output=tsv  \
		--service http://localhost:3030/aama/query  \
		--query=$localqry  \
		>> $response

	pdgmlist="${pdgmlist}+${pnamefile}=${pnumber}"
	#echo "pdgmlist = $pdgmlist"
done
pdgmlist=${pdgmlist#*+}
echo "plist = $pdgmlist"

echo "  "

perl pl/pdgm-fv-bil-tsv2table.pl $response $pdgmlist
#perl pl/pdgm-fv-bil-tsv2table.pl  tmp/pdgm/pname-bil-tsv-trial-resp.tsv sparql/pdgms/pname-fv-list-beja-arteiga.txt=10+sparql/pdgms/pname-fv-list-oromo.txt=31

#bin/aama-query-display-demo.sh

if [ "$2" = "menu" ] ; then
    read -e -p "[ENTER] to continue" input
    bin/aama-query-display-demo.sh
else
    read -e -p "[ENTER] to continue" input
    bin/aama-query-display-test.sh $1
fi
