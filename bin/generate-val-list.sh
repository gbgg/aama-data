#!/bin/bash
# usage:  bin/generate-lang-prop-val-lists.sh <dir>
# 01/03/14: Generates tsv of all lang-prop-val cooccurrences in <dir>
# and makes 4 files: 
#		lang	prop: v, v, v, ...
#		prop val: l, l, l, ...
#		val	prop: l, l, l, ...
#		prop	lang: v, v, v, ...

. bin/constants.sh
ldomain=${1//,/ }
ldomain=${ldomain//\"/}
response=tmp/prop-val/lang-prop-val-list.tsv
rm $response
filetag=$2
#echo "filetag = $filetag"
#echo "ldomain = $ldomain"
echo "fuquery.log" > logs/fuquery.log;
for f in `find $ldomain -name *-pdgms.edn`
do
    lang=`basename ${f%-pdgms.edn}`
    Lang="${lang[@]^}"
    labbrev=`grep $lang bin/lname-pref.txt`
    abbrev=${labbrev#$lang=}
    #echo querying $lang -- $abbrev
    #of=`basename ${2#sparql/templates/}`
    of=val-list.template
    localqry="tmp/prop-val/${of%.template}.all.rq"
    #mv $localqry "${localqry}.bck"
    #echo localqry = $localqry
    #sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" $2 > $localqry
    sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/lang-prop-val-list.template > $localqry
    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry >> $response
done


perl pl/lang-prop-val-list-tsv2table.pl $response $filetag

#perl pl/lang-prop-val-list-tsv2table.pl tmp/prop-val/lang-prop-val-list.tsv

echo "    "

if [ "$3" = "menu" ] ; then
    read -e -p "[ENTER] to continue" input
    bin/aama-query-display-demo.sh
else
    read -e -p "[ENTER] to continue" input
    bin/aama-query-display-test.sh $1
fi
