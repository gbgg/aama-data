#!/bin/bash
# usage:  lexcheck.sh "dir"

# 04/22/2013: gbgg modified constants.sh and   
# 05/27/13: outputs file with names of pdgms with no lexlabel/mulabel/multiLex property
# templates to be added to xml file can be found in bin/xml-file-lexeme-template.txt

. bin/constants.sh

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
    of=tmp/lexcheck/lexcheck.`basename $f`.txt
	echo of is $of
	echo $f to $of
	java  -jar ${JARDIR}/${SAXON} \
	-xi \
	-s:$f \
	-o:$of \
	-xsl:bin/lexcheck.xsl \
	f=$f;
	#cat $of >> $ofsum
done
#done