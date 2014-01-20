#!/bin/bash
# dependency:  rapper, from raptor, part of redland rdf lib
# ttlcheck - check ttl syntax and count triples
# usage:  ttlcheck "dir"
# from aamadata do $ ttlcheck "*" to check everything
echo "ttlcheck.log" > logs/ttlcheck.log
for d in `ls -d data/$1`
do
    echo "$d ****************************************************************"
    for f in `find $d -type f -name *ttl`
    do
#	echo $f to `dirname $f`/`basename $f .ttl`.rdf
	rapper -c -i guess $f 2>&1 | tee -a logs/ttlcheck.log
    done
done
