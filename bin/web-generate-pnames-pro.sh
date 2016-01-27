
#!/bin/sh

# rev 12/03/13, adapted from generate-pnames-nfv.sh
# usage: bin/generate-pnames-pro.sh <dir>

# The script is designed to produce displays of pro paradigm names in one or more languages. 

. bin/constants.sh
ldomain=${1//,/ }
ldomain=${ldomain//\"/}

for f in `find $ldomain -name *.edn`
do
    lang=`basename ${f%-pdgms.edn}`
    Lang="${lang[@]^}"
	labbrev=`grep $lang bin/lname-pref.txt`
	abbrev=${labbrev#$lang=}
	echo "  "
	echo "querying $lang ($abbrev)"
	localqry=tmp/pdgm/pnames-pro-$lang-query.rq
	response=tmp/pdgm/pnames-pro-$lang-resp.tsv
	#echo " "
	#echo "Localqry = $localqry"
	#echo "Response = $response"
	sed -e "s/%abbrev%/${abbrev}/g" -e "s/%lang%/${lang}/g" sparql/templates/pdgm-pro-pnames.template > $localqry

    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry > $response

	perl pl/web-pname-np-list2txt.pl $response $lang 
done
echo "   "
echo "   "



