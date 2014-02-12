#!/bin/bash
# usage:  htmlgen.sh "dir"

. bin/constants.sh


#for d in `ls -d data`
#do
    # echo "$d ********************************************"
	#fs=`find $d -name *xml`
	fs=`find $1 -name *xml`
    for f in $fs
	do
		lang=`dirname ${f#data/}`
		cd ../aama
		echo "git clone https://github.com/aama/$lang"
		# set -x;
		git clone https://github.com/aama/$lang
		cd ../aama-data
		# set +x;
	done
#done
