#!/bin/sh

# rev 11/22/13, adapted from display-paradigms.sh
# usage: bin/display-pnames.sh <dir>

# The script is designed to produce displays of finite verb paradigm names
# in one or more languages. 


. bin/constants.sh
ldomain=${1//,/ }
ldomain2=${ldomain//\"/}

# After starting the server with fuseki.sh, first copy the query files;

for f in `find $ldomain2 -name *.edn`
do
    lang=`basename ${f%-pdgms.edn}`
    Lang="${lang[@]^}"
    labbrev=`grep $lang bin/lname-pref.txt`
    abbrev=${labbrev#$lang=}
    echo "querying $lang $Lang $abbrev"
    localqry=tmp/pdgm/pnames-fv-$lang-query.rq
    response=tmp/pdgm/pnames-fv-$lang-resp.tsv
#    echo " "
#    echo "Localqry = $localqry"
    sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/pdgm-finite-prop-list.template > $localqry
#    disp=yes
#    echo "Display Localquery?"
#    read -e -p "yes/no (default $disp): " input
#    display=${input:-$disp}
#    if [ "$display" == "yes" ] ; then
#	while read line
#	do
#	    echo $line
#	done < $localqry
#    fi

    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry > $response
#    echo "Response = $response"
#    echo "Display Response?"
#    read -e -p "yes/no (default $disp): " input
#    display=${input:-$disp}
#    echo "   "
#    if [ "$display" == "yes" ] ; then
#	while read line
#	do
#	    echo $line
#	done < $response
#    fi
#    echo "  "
    localqry2=tmp/pdgm/pnames-fv-$lang-query2.rq
#    echo "Localqry2 = $localqry2"
    perl pl/web-pname2query.pl  $response $lang $abbrev $localqry2
#    echo "Display Localquery2?"
#    read -e -p "yes/no (default $disp): " input
#    display=${input:-$disp}
#    if [ "$display" == "yes" ] ; then
#	while read line
#	do
#	    echo $line
#	done < $localqry2
#    fi
    response2=tmp/pdgm/pnames-fv-$lang-resp2.tsv

    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry2 > $response2
#    echo "Response2 = $response2"
#    echo "Display Response2?"
#    read -e -p "yes/no (default $disp): " input
#    display=${input:-$disp}
#    echo "  "
#    if [ "$display" == "yes" ] ; then
#	while read line
#	do
#	    echo $line
#	done < $response2
#    fi
#    echo "  "
#    read -e -p "[ENTER] to see formatted output" input
#    echo "  "
    perl pl/web-pname-fv-list2txt.pl $response2 $lang 
done
echo "    "
echo "    "


#perl pl/pnamestsv2txt.pl	$response $qstring

#if [ "$2" = "menu" ] ; then
#    read -e -p "[ENTER] to continue" input
#    bin/aama-query-display-demo.sh
#fi
#if [ "$2" = $1 ] ; then
#    read -e -p "[ENTER] to continue" input
#    bin/aama-query-display-test.sh $1
#fi

