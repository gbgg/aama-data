#!/bin/sh

# rev 02/12/13
# rev 06/04/13 on the basis of pdgm-display.sh

# The script is designed to produce displays of finite verb paradigms in one
# or more languages. (For the moment, cf. pdgm-display-comp.sh for multi-lingual 
# paradigms.)

#This script differs from pdgm-display.sh only in that it takes as argument a query 
# string string of format  ARG1^ARG2 where each ARG has structure:
#	langName+prop=val:prop=val: . . .  
# and passes it to pdgmtemplate2query-comp.pl. Otherwise it is the same,
# and should be able to be unified with it.
# Default qstring "beja-arteiga+tam=aorist:polarity=affirmative:conjClass=prefix:rootClass=CCC^oromo+tam=past:polarity=affirmative:derivedStem=base"


# "Finite verb" is operationally defined as any form of  a verb that is marked for a 
# value of tam, and is marked also at least for person  (optionally also for gender 
# and number). 
 
# Each language has its own set of additional properties which are necessarily 
# represented in a finite verb paradigm. A first list of these properties is output by 
# the query sparql/pdgms/pdgm-finite-props.rq; an edited version of the output, 
# pdgm-finite-props.txt, is used by qstring2query.pl to produce a sparql query 
# out of the command-line prop=val string. For the purposes of this script, the list of 
# properties in pdgm-finite-props.txt is conflated with the language name 
# abbreviation from bin/lname-pref.txt.

#This script then runs the query on fuseki, returns output to sparql/pdgms/output, 
# and transforms it to various display formats using pdgmtsv2table.pl .
# The script is based on an earlier query-output-display.sh.

# Default qstring "oromo+tam=Present:polarity=Affirmative:clauseType=Main"

. bin/constants.sh

# After starting the server with fuseki.sh, first copy the query files;
qstring=$1
lang=${1%+*}
localqry=sparql/pdgms/output/$lang-query.rq
response=sparql/pdgms/output/$lang-response.tsv
# find way to parse qstring to give value string $vstring
# then give "title=$lang-$vstring" as argument to pdgmtsv2table.pl 
# for output title

echo "Query String = $qstring"
echo "Language = $lang"
echo "Localqry = $localqry"
echo "Response = $response"
#echo "Title = $title"

mv sparql/pdgms/output/$lang* sparql/pdgms/output/back/
#mv *.tsv back/
perl pl/qstring2query.pl $qstring $localqry

${FUSEKIDIR}/s-query \
	--output=tsv  \
	--service http://localhost:3030/aama/query  \
	--query=$localqry  \
	> $response


perl pl/pdgmtsv2table.pl	$response

