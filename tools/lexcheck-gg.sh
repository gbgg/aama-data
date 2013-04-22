#!/bin/bash
# usage:  lexcheck.sh "dir"


. tools/constants-gg.sh

ofsum=tmp/lexcheck.txt
#for d in `ls -d data`
#do
#fs=`find $d -name *xml`
fs=`find $1 -name '*.xml'`
for f in $fs
do
	echo f is $f
	bf=`basename $f`
	echo $bf
    of=tmp/lexcheck.`basename $f`.txt
	echo of is $of
	echo $f to $of
	java  -jar ${JARDIR}/${SAXON} \
	-xi \
	-s:$f \
	-o:$of \
	-xsl:tools/lexcheck.xsl \
	f=$f;
	#cat $of >> $ofsum
done
#done