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
		cd ../aama/${lang}
		echo "git add ${lang}*"
		echo "git commit -a -m 'adding edn/xml'"
		echo "git push origin"
		# set -x;
		git add ${lang}*
		git commit -a -m "adding edn/xml"
		git push origin
		cd ../../aama-data
		# set +x;
	done
#done
