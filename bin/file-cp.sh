#!/bin/bash
# usage:  htmlgen.sh "dir"

. bin/constants.sh

echo "xml2edn" >> logs/xml2edn.log;

#for d in `ls -d data`
#do
    # echo "$d ********************************************"
	#fs=`find $d -name *xml`
	fs=`find $1 -name *xml`
    for f in $fs
	do
		lang=`dirname ${f#data/}`
		echo "cp ${f%-pdgms\.xml}-pdgms.*  ../aama/${lang}/"
		# set -x;
		cp ${f%-pdgms\.xml}-pdgms.*  ../aama/${lang}/
		# set +x;
	done
#done

