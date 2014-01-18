#!/bin/bash
# usage:  htmlgen.sh "dir"

. bin/constants.sh

echo "xml2html" >> logs/xml2html.log;

#for d in `ls -d data`
#do
    # echo "$d ********************************************"
	#fs=`find $d -name *xml`
	#fs=`find $1 -name *xml`
    #for f in $fs
	for f in `find $1 -name *-pdgms.xml`
		do
		lang=`basename ${f%-pdgms.xml}`
		echo "generating $lang-lexlist.html  from  $f "
		# set -x;
		java  -jar ${JARDIR}/${SAXON} \
			-xi \
			-s:$f \
			-o:tmp/lexlists/$lang-lexlist.html \
			-xsl:bin/xml2html-lexlist.xsl \
			lang=`dirname ${f#data/}`;
		# set +x;
	done
#done

