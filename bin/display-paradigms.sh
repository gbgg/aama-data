#!/bin/bash

# 10/30/13
# usage:  displayparadigms.sh <dir> 
# Script which first generates table of the properties and their values which can occur in pdgm of finite verb. The user is then asked to specify a line of properties and values of the form: prop=val:prop=val: . . . The corresponding pradigm is then generated.
# This script is a combination of finite-prop-val-lang.sh and pdgm-display.sh
# The template <aama>/sparql/templates is hard-coded into the script.

# Cf. sparql/templates/README.txt

# example:
#    <aama> $ bin/finite-prop-val-lang.sh data/beja-arteiga 

. bin/constants.sh

echo "fuquery.log" > logs/fuquery.log;
for f in `find $1 -name *.html`
do
    lang=`basename ${f%-pdgms.html}`
    Lang="${lang[@]^}"
	labbrev=`grep $lang bin/lname-pref.txt`
	abbrev=${labbrev#$lang=}
    #echo querying $Lang $lang -- $abbrev
    #of=`basename ${2#sparql/templates/}`
	of=pdgm-finite-props.template
	#echo of = $of
    localqry="tmp/prop-val/${of%.template}.$lang.rq"
	response="tmp/prop-val/${of%.template}.$lang-resp.tsv"
    #echo $localqry
	echo
	echo " 'Finite verb' is operationally defined as any form of  a verb that" 
	echo " is marked for a value of tam, and is marked also at least for" 
	echo " person  (optionally also for gender and number). "
	echo 
	echo " In addition to png, each language has its own set of additional "
	echo " properties which are necessarily represented in a finite verb "
	echo " paradigm. The following table lists those properties and values"
	echo " for ${lang}:"
	echo
    #sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" $2 > $localqry
    sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/pdgm-finite-props.template > $localqry
    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry > $response
	perl pl/finite-propvaltsv2table.pl $response
done

echo " Command line format:"
echo " [lang]:[property]=[value],[property]=[value],[property]=[value], . . ."
echo "Example -- "
echo " oromo:tam=Present,polarity=Affirmative,clauseType=Main"
echo " [CR at prompt will return all finite-verb pdgms.]"
echo
read -e -p $lang: propvalset
#echo "propvalset = $propvalset"
commandline="${lang}:${propvalset}"
#echo "commandline = $commandline"
bin/pdgm-display.sh $commandline