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
echo 
echo " In addition to png, each language has its own set of additional "
echo " properties which can or must be represented in any finite verb "
echo " paradigm. The following table(s) list those properties and values"
echo " for verb forms in \"${1}\" which are not inflected for person:"
echo
for f in `find $1 -name *.edn`
do
    lang=`basename ${f%-pdgms.edn}`
    Lang="${lang[@]^}"
	labbrev=`grep $lang bin/lname-pref.txt`
	abbrev=${labbrev#$lang=}
    #echo querying $Lang $lang -- $abbrev
    #of=`basename ${2#sparql/templates/}`
	of=pdgm-nfv-props.template
	#echo of = $of
	querylabel="${of%.template}.$lang"
    localqry="sparql/pdgms/output/${of%.template}.$lang.rq"
	response="sparql/pdgms/output/${of%.template}.$lang-resp.tsv"
    echo "localqry=$localqry"
	nsv="nsv"
	echo "nsv=$nsv"

    #sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" $2 > $localqry
    sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/pdgm-nfv-props.template > $localqry
    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry > $response
    # following works for both fv and nfv
    perl pl/verb-propvaltsv2table.pl $response
    echo " Command line format:"
    echo " [lang]:[property]=[value],[property]=[value],[property]=[value], . . .[  or Ctrl-C to exit ]"
    echo "Example -- "
    echo "beja-arteiga:derivedStem=B"
    echo " [CR at prompt will return all finite-verb pdgms.]"
    echo
    pvset="derivedStem=B"
    # see if something better would work as default nfv pvset
   read -e -p "Prop-val Set (default $pvset) : " input
    propvalset=${input:-$pvset}
    #echo "propvalset = $propvalset"
    commandline="${commandline}+${lang}:${propvalset}"
    #echo "commandline = $commandline"
done
commandline=${commandline#*+}
#echo commandline = $commandline

bin/pdgm-nfv-pv-display.sh $commandline $querylabel
#bin/aama-query-display-demo.sh

if [ "$2" = "menu" ] ; then
    read -e -p "[ENTER] to continue" input
    bin/aama-query-display-demo.sh
fi
