#!/bin/bash
# usage:  convert "dir"

. tools/constants.sh

for d in `ls -d ~/work/aamadata/$1`
do
    echo "$d ****************************************************************"
    for f in `find $d -path ~/work/aamadata/documentation -prune -o  -name "*xml"`
    do
	echo "converting " $f to data/${f#/Users/gar/work/aamadata/}
	# mkdir -p data/`dirname  ${f#/Users/gar/work/aamadata/}`
	set -x;
	java  -jar ${JARDIR}/${SAXON} \
	    -xi \
	    -s:$f \
	    -o:data/${f#/Users/gar/work/aamadata/} \
	    -xsl:tools/convert.xsl;
	set +x;
    done
done
