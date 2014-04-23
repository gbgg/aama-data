#!/bin/bash
# usage: display-langsforval.sh <dir> val

# 11/04/13: calqued on display-valsforprop.sh. Probably can be
# eventually combined with it (certainly in UI).
# The template <aama>/sparql/templates is hard-coded into the script.

# Cf. sparql/templates/README.txt

# example:
#    <aama> $ bin/display-langsforval.sh "data/*" Aorist [What languages have a tam=Aorist?]

. bin/constants.sh
ldomain=${1//,/ }
ldomain=${ldomain//"/}
val=$2
of=langsforval.template
response="tmp/prop-val/${of%.template}.$val-resp.tsv"

echo "fuquery.log" > logs/fuquery.log;
for f in `find $1 -name *.edn`
do
    lang=`basename ${f%-pdgms.edn}`
    #Lang="${lang[@]^}"
    #echo querying $lang for $type values
    #of=`basename ${2#sparql/templates/}`
	out=langsforval-$type
	#echo out = $out
	#echo of = $of
    localqry="tmp/prop-val/${of%.template}.$lang.rq"
    #echo $localqry
    #sed -e "s/%Lang%/${Lang}/g" -e "s/%lang%/${lang}/g" $2 > $localqry
    sed -e "s/%val%/${val}/g" -e "s/%lang%/${lang}/g" sparql/templates/langsforval.template > $localqry
    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry >> $response
done
perl pl/langsforvaltsv2table.pl $response $val

#./s-query \
#	--output=tsv  \
#	--service http://localhost:3030/aamaTestData/query  \
#	--file=query-temp.rq  \
#	> ../cygwin/home/Gene/aamadata/tools/rq-ru/query-trial/$response
bin/aama-query-display-demo.sh
