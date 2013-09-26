#!/bin/bash
# usage:  lexcheck.sh "dir"

# 04/22/2013: gbgg modified constants.sh and   
# 09/23/13: outputs file with names of pdgms and terms with no unitary "token" property. (created from lexcheck-gg.sh)

. bin/constants.sh

ofsum=tmp/tokencheck.txt
#for d in `ls -d data`
#do
#fs=`find $d -name *xml`
fs=`find $1 -name '*.xml'`
for f in $fs
do
	echo f is $f
	bf=`basename $f`
	echo $bf
    of=tmp/tokencheck/tokencheck.`basename $f`.txt
	echo of is $of
	echo $f to $of
	java  -jar ${JARDIR}/${SAXON} \
	-xi \
	-s:$f \
	-o:$of \
	-xsl:bin/tokencheck.xsl \
	f=$f ;
	cat ${of} | uniq  >> $ofsum
done
#done