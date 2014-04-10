#!/bin/bash
# usage:  display-pdgms-fv-pv.sh data/<lang> , display-paradigms.sh "data/<lang> data/<lang> . . ." , display-paradigms.sh "data/*" 

# 10/30/13
#11/04/13 generalized to more than one language

# Script to generate finite verb paradigms in one or more languages.
# Script first generates table of the properties and their values which can occur in pdgm of finite verb. The user is then asked to specify a line of properties and values of the form: prop=val:prop=val: . . . The corresponding pradigm is then generated.
# This script is a combination of finite-prop-val-lang.sh and pdgm-display.sh
# The template <aama>/sparql/templates is hard-coded into the script.

# Cf. sparql/templates/README.txt

# example:
# bin/display-paradigms.sh "data/beja-arteiga data/oromo" 
# At prompt "beja-arteiga:" enter  " conjClass=Suffix,polarity=Affirmative,tam=Present". 
# At prompt "oromo:" enter  "clauseType=Main,derivedStem=Base,polarity=Affirmative,tam=Present"

. bin/constants.sh

echo "fuquery.log" > logs/fuquery.log;
#echo " 'Finite verb' is operationally defined as any form of  a verb that" 
#echo " is marked for a value of tam, and is marked also at least for" 
#echo " person  (optionally also for gender and number). "
#echo
querylabel=fv
#echo Please provide a label for query --
#read -e -p Query_Label: querylabel
echo 
echo " In addition to png, each language has its own set of additional "
echo " properties which can or must be represented in any finite verb "
echo " paradigm. The following table(s) list those properties and values"
echo " for \"${1}\":"
echo
for f in `find $1 -name *.edn`
do
    lang=`basename ${f%-pdgms.edn}`
   # Lang="${lang[@]^}"
	labbrev=`grep $lang bin/lname-pref.txt`
	abbrev=${labbrev#$lang=}
    echo querying $lang -- $abbrev
    #of=`basename ${2#sparql/templates/}`
	of=pdgm-fv-props.template
	#echo of = $of
    localqry="tmp/prop-val/${of%.template}.$lang.rq"
	response="tmp/prop-val/${of%.template}.$lang-resp.tsv"
    echo "props query = $localqry"

    #sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" $2 > $localqry
    sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/pdgm-fv-props.template > $localqry
    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry > $response
	perl pl/verb-propvaltsv2table.pl $response
	echo " Command line format:"
	echo " [lang]:[property]=[value],[property]=[value],[property]=[value], . .  [or Ctrl-C to exit]."
	echo "Example -- "
	echo " oromo:clauseType=Main,derivedStem=Base,polarity=Affirmative,tam=Present"
	echo " beja-arteiga:conjClass=Suffix,polarity=Affirmative,tam=Present". 
	echo " [CR at prompt will return all finite-verb pdgms.]"
	read -e -p $lang: propvalset
	#echo "propvalset = $propvalset"
	commandline="${commandline}+${lang}:${propvalset}"
	#echo "commandline = $commandline"
	echo
done
commandline=${commandline#*+}
#echo "commandline = $commandline"

bin/pdgm-display.sh $commandline $querylabel
