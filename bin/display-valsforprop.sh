#!/bin/bash
# usage: display-valsforprop.sh <dir> prop [NB: PROP MUST BE CAPITALIZED!]

# 11/04/13: adapted from  fuquery-vals-for-prop.sh 
# The template <aama>/sparql/templates is hard-coded into the script.

# Cf. sparql/templates/README.txt

# example:
#   bin/display-valsforprop.sh "data/beja-arteiga data/beja-atmaan" tam  

. bin/constants.sh
ldomain=${1//,/ }
ldomain=${ldomain//\"/}
#echo "lang domain = ${ldomain}"
#echo "type = ${2}"

echo "fuquery.log" > logs/fuquery.log;
for f in `find $ldomain -name *.edn`
do
    lang=`basename ${f%-pdgms.edn}`
    type=$2
    #Type="${type[@]^}"
    #echo type = $type
    #echo Type = $Type
    #of=`basename ${2#sparql/templates/}`
    of=valsforprop.template
    localqry="tmp/prop-val/${of%.template}.$lang.rq"
     response="tmp/prop-val/${of%.template}.$lang-resp.tsv"
    #echo $localqry
    sed -e "s/%type%/${type}/g" -e "s/%lang%/${lang}/g" sparql/templates/valsforprop.template > $localqry
    ${FUSEKIDIR}/s-query \
	--output=tsv \
	--service http://localhost:3030/aama/query \
        --query=$localqry \
	> $response
    perl pl/valforproptsv2table.pl $response $type
done
echo " "
echo " "
echo " "

if [ "$3" = "menu" ] ; then
    read -e -p "[ENTER] to continue" input
    bin/aama-query-display-demo.sh
elif [ "$3" = $ldomain ] ; then
    read -e -p "[ENTER] to continue" input
    bin/aama-query-display-test.sh $3
fi

