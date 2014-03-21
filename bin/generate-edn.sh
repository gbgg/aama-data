#!/bin/bash
# usage: htmlgen.sh "dir"

. bin/constants.sh

echo "xml2edn" >> logs/xml2edn.log;

for d in `ls -d data`
do
    echo "$d ********************************************"
	fs=`find $d -name *xml`
	#fs=`find $1 -name *xml`
	for f in $fs
	do
		lang=${f%\.xml}
		echo "generating ${f%-pdgms\.xml}-pdgms.edn from $f "
		# set -x;
		java -jar ${JARDIR}/${SAXON} \
			-xi \
			-s:$f \
			-o:${f%-pdgms\.xml}-pdgms.edn \
			-xsl:bin/xml2edn.xsl \
			lang=`dirname ${f#data/}`;
		# set +x;
	done
#done

