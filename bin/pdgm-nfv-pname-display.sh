#!/bin/sh

# rev 02/12/13
# rev 06/04/13 on the basis of pdgm-display.sh
# rev 11/04/13 generalized to one or more languages

# The script is designed to produce displays of finite verb paradigms
# in one or more languages. 

# Obligatory argument qstring, format: ARG1+ARG2+ . . .
# Where each ARG has structure:
# [lang]:[property]=[value],[property]=[value],[property]=[value]: . . .
# Example qstring: 
# "beja-arteiga:tam=Aorist,polarity=Affirmative,conjClass=Prefix,rootClass=CCC+
# oromo:tam=Past,polarity=Affirmative,derivedStem=Base"

#This script differs from pdgm-display.sh only in that it takes as
# argument a query string with more than one  ARGn.

#This script then runs the query on fuseki, returns output to
# sparql/pdgms/output,  and transforms it to various display 
# formats using pdgmtsv2table.pl .
# The script is based on an earlier query-output-display.sh.


. bin/constants.sh

# After starting the server with fuseki.sh, first copy the query files;
pnamefile=$1
pnumber=$2
lang=$3
labbrev=`grep $lang bin/lname-pref.txt`
abbrev=${labbrev#$lang=}
localqry=sparql/pdgms/output/$pnamefile-$pnumber-query.rq
response=sparql/pdgms/output/$pnamefile-$pnumber-response.tsv
# find way to parse qstring to give value string $vstring
# then give "title=$lang-$vstring" as argument to pdgmtsv2table.pl 
# for output title

echo "Query String = $qstring"
echo "Localqry = $localqry"
echo "Response = $response"
echo " "
#echo "QLabel = $qlabel"

#mv sparql/pdgms/output/$qlabel* sparql/pdgms/output/back/
#mv *.tsv back/
perl pl/qstring-nfv-pname2query.pl $pnamefile $pnumber $localqry $abbrev

${FUSEKIDIR}/s-query \
	--output=tsv  \
	--service http://localhost:3030/aama/query  \
	--query=$localqry  \
	> $response


perl pl/pdgmtsv2table.pl	$response $qstring

