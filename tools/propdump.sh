#!/bin/bash
# usage:  propdump.sh "dir"
# IMPORTANT:  use quotes if dir includes a wildcard
# e.g.  propdump.sh "data/*"

. tools/constants.sh

for d in `ls -d $1`
do
    echo "$d ****************************************************************"
    for f in `find $d -name "*xml"`
    do
	echo "dumping properties of " $f in tmp/${d#data/}.props
	# set -x;
	# java  -jar ${JARDIR}/${SAXON} \
	#     -xi \
	#     -s:$f \
	#     -o:${f#/Users/gar/work/aamadata/} \
	#     -xsl:tools/propdump.xsl;
	# set +x;
    done
done
