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
		lang=${f%-pdgms\.xml}
		echo "mv ${f%-pdgms\.xml}-pdgms.html  ${f%-pdgms\.xml}-pdgmdisp.html "
		# set -x;
		mv ${f%-pdgms\.xml}-pdgms.html  ${f%-pdgms\.xml}-pdgmdisp.html
		# set +x;
	done
#done

