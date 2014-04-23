#!/bin/bash
# usage:  htmlgen.sh "dir"

. bin/constants.sh
ldomain=${1//,/ }
ldomain=${ldomain//"/}

echo "xml2html" >> logs/xml2html.log;

#for d in `ls -d data`
#do
    # echo "$d ********************************************"
	#fs=`find $d -name *xml`
	fs=`find $1 -name *xml`
    for f in $fs
	do
		lang=${f%\.xml}
		echo "generating ${f%-pdgms\.xml}-pdgms.html  from  $f "
		# set -x;
		java  -jar ${JARDIR}/${SAXON} \
			-xi \
			-s:$f \
			-o:${f%-pdgms\.xml}-pdgms.html \
			-xsl:bin/xml2html-pdgms.xsl \
			lang=`dirname ${f#data/}`;
		# set +x;
	done
#done

bin/aama-query-display-demo.sh
