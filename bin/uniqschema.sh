#!/bin/bash
# usage:  uniqttl.sh

# 05/07/13: gbgg transferring @prefix section to xml2schema.xsl

AAMADATA_HOME=..
XSLHOME=${AAMADATA_HOME}/tools
JARDIR=/cygdrive/c/saxon9pe-3-0-5j
SAXON=saxon9pe.jar

for f in `find $1 -name *.xml`
do
    l1=`dirname $f`
    lang=${l1#data/}
    t=`basename ${f%-pdgms.xml}`.schema.ttl
    l=tmp/$t
    echo "$lang: uniqifying " $l to data/$lang/$t
	echo "@prefix rdf:	 <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:	 <http://www.w3.org/2000/01/rdf-schema#> .
@prefix aama:	 <http://id.oi.uchicago.edu/aama/2013/> .
@prefix aamas:	 <http://id.oi.uchicago.edu/aama/2013/schema/> ." > "data/$lang/$t"
	sort --ignore-case $l | uniq >> data/$lang/$t
done

# echo producing unified ttl
# cat tmp/*.ttl | sort --ignore-case | uniq > schema/aamaschema.ttl
