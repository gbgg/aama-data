#!/bin/bash

arURI="http://id.oi.uchicago.edu/aama/2013/Arabic"

hdr='@prefix rdf:	 <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:	 <http://www.w3.org/2000/01/rdf-schema#> .
@prefix aama:	 <http://id.oi.uchicago.edu/aama/2013/> .
@prefix aamas:	 <http://id.oi.uchicago.edu/aama/2013/schema/> .
@prefix arab:	 <http://id.oi.uchicago.edu/aama/2013/Arabic/> .\n'

schema="
<aamas:Rad> rdfs:subClassOf rdfs:Class .
<$arURI/Monad> rdfs:subClassOf aamas:Rad .
<$arURI/Dyad> rdfs:subClassOf aamas:Rad .
<$arURI/Triad> rdfs:subClassOf aamas:Rad .
<$arURI/Tetrad> rdfs:subClassOf aamas:Rad .
<$arURI/Pentad> rdfs:subClassOf aamas:Rad .
<$arURI/Hexad> rdfs:subClassOf aamas:Rad .
<$arURI/Heptad> rdfs:subClassOf aamas:Rad .\n
"

set -e

for d in `find /Users/gar/work/lex/lisaan/xml/$1 -type d`
do
    echo "$d ***************************"
    of=tmp/`basename ${d}`.roots.ttl
    echo to $of
    env gprintf "$hdr" > $of
    env gprintf "$schema" >> $of
    for f in `find $d -type f -name *lisaan.xml`
    do
	# echo "f: " $f
	ar=`basename ${f%.lisaan.xml}`
	# echo $ar
	if [[ $ar =~ [[:alpha:]] ]]; then
	    echo "Skipping alpha root: " $ar
	    continue
	fi
	# continue
	len=`gexpr length $ar / 2`
	# echo "ar: " $ar " " $len
	# original
	# reversed: 'ywhnmlkqfgʕẓṭḍṣšszrðdxḥjθtba'`
	er=`echo $ar | tr 'ابتثجحخدذرزسشصضطظعغفقكلمنهوي' 'abtθjḥxdðrzsšṣḍṭẓʕgfqklmnhwy'`
	# echo "en: " $er
	# read x
	case $len in
	    1 ) alexad="<${arURI}/Root/${ar}> rdfs:type arab:Monad ."
		;;
	    2 ) alexad="<${arURI}/Root/${ar}> rdfs:type arab:Dyad ."
		;;
	    3 ) alexad="<${arURI}/Root/${ar}> rdfs:type arab:Triad ."
		;;
	    4 ) alexad="<${arURI}/Root/${ar}> rdfs:type arab:Tetrad ."
		;;
	    5 ) alexad="<${arURI}/Root/${ar}> rdfs:type arab:Pentad ."
		;;
	    6 ) alexad="<${arURI}/Root/${ar}> rdfs:type arab:Hexad ."
		;;
	    7 ) alexad="<${arURI}/Root/${ar}> rdfs:type arab:Heptad ."
		;;
	    8 ) alexad="<${arURI}/Root/${ar}> rdfs:type arab:Octad ."
		;;
	    * ) echo "ROOT ANOMALIE" $ar
		exit 1
		;;
	esac

	lang="<${arURI}/Root/${ar}> aama:lang <http://id.oi.uchicago.edu/aama/2013/Arabic> ."
	label="<${arURI}/Root/${ar}> rdfs:label \"${er}\" ."
	# echo $alexad
	echo ${alexad} >> $of
	echo ${label} >> $of
	echo ${lang} >> $of
    done
done
