#!/bin/sh

# rev 11/22/13, adapted from display-paradigms.sh
# usage: bin/display-pnames.sh <dir>

# The script is designed to produce displays of finite verb paradigm names
# in one or more languages. 


. bin/constants.sh
ldomain=${1//,/ }
ldomain2=${ldomain//\"/}

# After starting the server with fuseki.sh;

for f in `find $ldomain2 -name *.edn`
do
    lang=`basename ${f%-pdgms.edn}`
    Lang="${lang[@]^}"
    labbrev=`grep $lang bin/lname-pref.txt`
    abbrev=${labbrev#$lang=}
    echo "querying $lang $Lang $abbrev"
    # fv pdgm names
    localqry=tmp/pdgm/pnames-fv-$lang-query.rq
    response=tmp/pdgm/pnames-fv-$lang-resp.tsv
    echo " "
    echo "Localqry = $localqry"
    sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/pdgm-finite-prop-list.template > $localqry
    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry > $response
    localqry2=tmp/pdgm/pnames-fv-$lang-query2.rq
    echo "Localqry2 = $localqry2"
    perl pl/pname2query.pl  $response $lang $abbrev $localqry2
    response2=tmp/pdgm/pnames-fv-$lang-resp2.tsv
    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry2 > $response2
    echo "Response2 = $response2"
    perl pl/pname-fv-list2txt.pl $response2 $lang 

    # nfv pdgm names
    localqry=tmp/pdgm/pnames-nfv-$lang-query.rq
    response=tmp/pdgm/pnames-nfv-$lang-resp.tsv
    echo " "
    echo "Localqry = $localqry"
    echo "Response = $response"
    sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/pdgm-non-finite-pnames.template > $localqry
    ../aama/fuseki/jena-fuseki-1.1.1/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry > $response
    perl pl/pname-nfv-list2txt.pl $response $lang 

    # pro pdgm names
    localqry=tmp/pdgm/pnames-pro-$lang-query.rq
    response=tmp/pdgm/pnames-pro-$lang-resp.tsv
    echo " "
    echo "Localqry = $localqry"
    echo "Response = $response"
    sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/pdgm-pro-pnames.template > $localqry
    ../aama/fuseki/jena-fuseki-1.1.1/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry > $response
    perl pl/pname-np-list2txt.pl $response $lang 

    # noun pdgm names
    localqry=tmp/pdgm/pnames-noun-$lang-query.rq
    response=tmp/pdgm/pnames-noun-$lang-resp.tsv
    echo " "
    echo "Localqry = $localqry"
    echo "Response = $response"
    sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/pdgm-noun-pnames.template > $localqry
    ../aama/fuseki/jena-fuseki-1.1.1/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry > $response
    perl pl/pname-np-list2txt.pl $response $lang 

done

