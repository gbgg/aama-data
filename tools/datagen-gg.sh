#!/bin/bash
# usage:  datagen.sh "dir"

# 04/22/2013: gbgg modified constants.sh and xsl

. tools/constants-gg.sh

#for d in `ls -d data`
#do
    # echo "$d ********************************************"
	#fs=`find $d -name *xml`
	fs=`find $1 -name *xml`
    for f in $fs
	do
		lang=${f%\.xml}
		echo "generating ${f%-pdgms\.xml}.data.ttl  from  $f "
		# set -x;
		java  -jar ${JARDIR}/${SAXON} \
			-xi \
			-s:$f \
			-o:${f%-pdgms\.xml}.data.ttl \
			-xsl:tools/xml2data-gg.xsl \
			lang=`dirname ${f#data/}`;
		# set +x;
	done
#done
