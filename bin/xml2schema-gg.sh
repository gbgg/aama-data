#!/bin/bash
# usage:  xml2schema.sh "dir" abbr

# 04/22/2013: gbgg modified constants.sh
# 05/07/2013: gbgg added params for xml2schema
. bin/constants.sh

for d in `ls -d $1`
do
    # echo "$d ****************************************************************"
    for f in `find $d -name "*xml"`
    do
	l=`dirname ${f#data/}`;
	lang=`basename ${f%-pdgms\.xml}`;
	abb=$2
	echo "lang is $lang"
	echo "abb is $abb"
	echo generating schema for $l in tmp/`basename ${f%-pdgms\.xml}`.schema.ttl
	# set -x;
	java  -jar ${JARDIR}/${SAXON} \
	    -xi \
	    -s:$f \
	    -o:tmp/`basename ${f%-pdgms\.xml}`.schema.ttl \
	    -xsl:bin/xml2schema-gg.xsl \
		language=$lang \
		abbr=$abb;
	# set +x;
    done
done
