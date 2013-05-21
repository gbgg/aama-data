#!/bin/bash
# usage:  fuput "dir"
# examples:
#    aama/$ bin/fuput "data/*" --  puts everything
#    aama/$ bin/fuput "data/alaaba" -- puts only alaabe
#    aama/$ bin/fuput "data/alaaba data/burji data/coptic" -- puts all 3 datasets
#    aama/$ bin/fuput "schema" -- puts all 3 datasets
# cumulative logfile written to logs/fuput.log
# each lang/var gets its own logfile
 # 05/10/13: gg created from fuput.sh to be parallel with fuput-schema.sh
 # 05/20/13: gbgg datagen-aa created from datagen to generalize data.ttl to aama: namespace
 
. bin/constants.sh

echo "fuput.log" > logs/fuput.log;
for f in `find $1 -name *.xml`
do
    lang=`dirname ${f#data/}`
    echo $lang
    fn=data/$lang/`basename ${f%-pdgms.xml}`.data-aa.rdf
    graph="http://oi.uchicago.edu/aama/$lang"
    #echo putting $fn to $graph;
    echo putting $fn to default graph;
    #${FUSEKIDIR}/s-put  http://localhost:3030/aama/data $graph $fn 2>&1 >>logs/fuput.log
    ${FUSEKIDIR}/s-put  http://localhost:3030/aama/data 'default' $fn 2>&1 >>logs/fuput.log
 	#version=`${FUSEKIDIR}/s-put --version`
	#echo $version
done

#		./s-put http://localhost:3030/aamatrial/data default ../../../home/Gene/coma-2-aama/elmolo/elmolo-pdgms.ttl
