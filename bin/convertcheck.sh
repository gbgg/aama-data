#!/bin/bash
# usage:  convert "dir"

. tools/constants.sh

for d in `ls -d ~/work/aamadata/$1`
do
    # echo "$d ****************************************************************"
    for f in `find $d -path ~/work/aamadata/documentation -prune -o  -name "*xml"`
    do
	# echo "diffing " $f and ${f#/Users/gar/work/aamadata/}
	# set -x;
	diff -ws $2 $f ${f#/Users/gar/work/aamadata/}
	# set +x;
    done
done
