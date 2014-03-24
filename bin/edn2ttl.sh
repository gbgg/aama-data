#!/bin/bash
# usage:  ~/aama-data/bin/copy2langrepo.sh

# 03/21/14: 

. bin/constants.sh

for d in `ls -d data`
do
echo "$d ********************************************"
fs=`find $d -name *xml`
#fs=`find $1 -name *xml`
	for f in $fs
	do
		lang=`basename ${f%-pdgms\.xml}`
		echo copying files for $lang to aama/$lang
		cp data/$lang/$lang-pdgms\.xml ../aama/$lang/
		cp data/$lang/$lang-pdgms\.edn ../aama/$lang/
	done
done

