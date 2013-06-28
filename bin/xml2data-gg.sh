#!/bin/bash
# usage:  datagen.sh "dir" abbr
# usage:  datagen-aa.sh "dir" 

# 04/22/2013: gbgg modified constants.sh and xsl
# abbr added for prefix, usage:  "datagen.sh dir abbr"
# 05/10/13: gbgg datagen.sh remodeled on schemagen.sh, xml2data.sh factored out
# 05/20/13: gbgg datagen-aa created from datagen to generalize data.ttl to aama: namespace

. bin/constants.sh

#for d in `ls -d data`
#do
    # echo "$d ********************************************"
	#fs=`find $d -name *xml`
	fs=`find $1 -name *xml`
    for f in $fs
	do
		echo "f is $f"
		lang=`basename ${f%-pdgms\.xml}`;
		abb=$2
		echo "lang is $lang"
		#echo "abb is $abb"
		echo "generating ${f%-pdgms\.xml}.data.ttl  from  $f "
		# set -x;
		java  -jar ${JARDIR}/${SAXON} \
			-xi \
			-s:$f \
			-o:${f%-pdgms\.xml}.data.ttl \
			-xsl:bin/xml2data-gg.xsl \
			lang=$lang \
			abbr=$abb;
			#lang=`dirname ${f#data/}`;
		# set +x;
	done
#done

