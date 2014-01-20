#!/bin/sh

# rev 02/12/13

#This script takes as argument a query string string of format
# ARG1^ARG2 where each ARG has structure:
#	langName+prop=val:prop=val: . . .  and passes it
# to pdgmtemplate2query.pl to make query,
# runs query on fuseki, returns output to tools/rq-ru/rq-pdgm-def/, 
# and transforms it to various display formats using pdgmtsv2table.pl .
# The script is based on query-output-display.sh.
# Default qstring "beja-arteiga+tam=aorist:polarity=affirmative:conjClass=prefix:rootClass=CCC^oromo+tam=past:polarity=affirmative:derivedStem=base"



# After starting the server with fuseki.sh, first copy the query files;
qstring=$1
# FIND OUT HOW TO DO NON-GREEDY SPLIT
# AND LANG1 LANG2
#lang=${1%+*}
#response=$lang-comp-response.tsv
response=lang-comp-response.tsv
# find way to parse qstring to give value string $vstring
# then give "title=$lang-$vstring" as argument to pdgmtsv2table.pl 
# for output title

echo "Query String = $qstring"
echo "Language = $lang"
echo "Response = $response"
#echo "Title = $title"

cd ../tools/rq-ru/rq-pdgm-def
#cp *-response.tsv back/
mv *-query.rq back/
#mv *.tsv back/
perl ../../pl/pdgmtemplate2query-comp.pl $qstring

cd /cygdrive/c/Fuseki-0.2.4/

cp ../cygwin/home/Gene/aamadata/tools/rq-ru/rq-pdgm-def/query-temp.rq ./query-temp.rq

./s-query \
	--output=tsv  \
	--service http://localhost:3030/aamaData/query  \
	--file=query-temp.rq  \
	> ../cygwin/home/Gene/aamadata/tools/rq-ru/rq-pdgm-def/$response

rm *-temp.rq

cd ../cygwin/home/Gene/aamadata/tools/rq-ru/rq-pdgm-def/

perl ../../pl/pdgmtsv2table.pl	$response