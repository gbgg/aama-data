#!/bin/bash
# usage:  bin/generate-lang-prop-val-lists.sh <dir>
# 01/03/14: Generates tsv of all lang-prop-val cooccurrences in <dir>
# and makes 4 files: 
#		lang	prop: v, v, v, ...
#		prop val: l, l, l, ...
#		val	prop: l, l, l, ...
#		prop	lang: v, v, v, ...

. bin/constants.sh
response=tmp/prop-val/lang-prop-val-list.tsv
mv $response "${response}.bck"
echo "fuquery.log" > logs/fuquery.log;
for f in `find $1 -name *-pdgms.xml`
do
	#echo f = $f
    lang=`basename ${f%-pdgms.xml}`
    Lang="${lang[@]^}"
	labbrev=`grep $lang bin/lname-pref.txt`
	abbrev=${labbrev#$lang=}
    echo querying $Lang $lang -- $abbrev
    #of=`basename ${2#sparql/templates/}`
	of=lang-prop-val-list.template
	#echo of = $of
    localqry="tmp/prop-val/output/${of%.template}.$lang.rq"
	#mv $localqry "${localqry}.bck"
    #echo localqry = $localqry
    #sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" $2 > $localqry
    sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/lang-prop-val-list.template > $localqry
    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry >> $response
done
	perl pl/lang-prop-val-list-tsv2table.pl $response

#	perl pl/lang-prop-val-list-tsv2table.pl tmp/prop-val/lang-prop-val-list.tsv
