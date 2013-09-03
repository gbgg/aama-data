#!/bin/bash
# usage:  fuquery <dir> <qry>
# where <qry> is a skeleton in <aama>/sparql.  See
# exponents.local.skel.rq for an example.

# example:
#    <aama> $ bin/fuquery.sh data/oromo sparql/templates/exponents.template


echo "fuquery.log" > logs/fuquery.log;
for f in `find $1 -name *.xml`
do
	echo f is $f
    lang=`basename ${f%-pdgms.xml}`
	echo lang is $lang
    Lang="${lang[@]^}"
	echo Lang is $Lang
    echo querying $Lang $lang
    of=`basename ${2#sparql/templates/}`
	echo of is $of
    localqry="sparql/${of%.template}.$lang.rq"
    echo localqry is $localqry
	echo
    sed -e "s/%Lang%/${Lang}/g" -e "s/%lang%/${lang}/g" $2 > $localqry
    #s-query --service http://localhost:3030/aama/query --query=$localqry
done
