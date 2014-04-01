#!/bin/bash
# usage:  ~/aama-data/bin/copy2langrepo.sh

# 03/21/14: 
# 03/26/14: restricted to edn (xml now out of date)

. bin/constants.sh

for d in `ls -d data`
do
echo "$d ********************************************"
fs=`find $d -name *edn`
#fs=`find $1 -name *edn`
	for f in $fs
	do
		lang=`basename ${f%-pdgms\.edn}`
		echo copying files for $lang to aama/$lang
		#cp data/$lang/$lang-pdgms\.xml ../aama/$lang/
		cp data/$lang/$lang-pdgms\.edn ../aama/$lang/
	done
done

