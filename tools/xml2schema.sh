#!/bin/bash
# usage:  xml2schema.sh "dir"

. tools/constants.sh

for d in `ls -d $1`
do
    # echo "$d ****************************************************************"
    for f in `find $d -name "*xml"`
    do
	l=`dirname ${f#data/}`;
	echo generating schema for $l in tmp/`basename ${f%-pdgms\.xml}`.schema.ttl
	# set -x;
	java  -jar ${JARDIR}/${SAXON} \
	    -xi \
	    -s:$f \
	    -o:tmp/`basename ${f%-pdgms\.xml}`.schema.ttl \
	    -xsl:tools/xml2schema.xsl;
	# set +x;
    done
done
