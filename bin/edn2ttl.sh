#!/bin/bash
# usage:  ~/aama-data/bin/edn2ttl.sh "dir"

# 03/21/14: 

. bin/constants.sh

 
#for d in `ls data`
#do
 #    echo "$d ********************************************"
	#fs=`find data/$d -name *edn`
	fs=`find $1 -name *edn`
    for f in $fs
	do
		echo "generating ${f%\.edn}.ttl  from  $f "
		java -jar ../.jar/aama-edn2ttl.jar $f > ${f%\.edn}.ttl
	done
#done
