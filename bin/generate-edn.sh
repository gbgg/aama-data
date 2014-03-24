#!/bin/bash
# usage: generate-edn.sh "dir"

. bin/constants.sh

echo "xml2edn" >> logs/xml2edn.log;

for d in `ls -d data`
do
   echo "$d ********************************************"
	fs=`find $d -name *xml`
#	fs=`find $1 -name *xml`
	for f in $fs
	do
		lang=`basename ${f%-pdgms\.xml}`
		abb=`grep $lang bin/lname-pref.txt`
		abb=${abb#$lang=}
		echo "generating ${f%-pdgms\.xml}-pdgms.edn from $f ($lang / $abb) "
		# set -x;
		java -jar ${JARDIR}/${SAXON} \
			-xi \
			-s:$f \
			-o:${f%-pdgms\.xml}-pdgms.edn \
			-xsl:bin/xml2edn.xsl \
			lang=`dirname ${f#data/}` \
			abbr=$abb;
		# set +x;
	done
done

#		lang=`basename ${f%-pdgms\.xml}`;
#		abb=`grep $lang bin/lname-pref.txt`
#		abb=${abb#$lang=}
