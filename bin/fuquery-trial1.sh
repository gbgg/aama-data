#!/bin/bash
# usage:  fuquery <dir> <qry>
# where <qry> is a skeleton in <aama>/sparql.  See
# exponents.local.skel.rq for an example.

# example:
#    <aama> $ tools/fuquery data/alaaba sparql/exponents.local.skel.rq


echo "fuquery.log" > logs/fuquery.log;
for f in `find $1 -name *.xml`
do
	echo f is $f
    lang=`basename ${f%-pdgms.xml}`
	echo lang is $lang
    fn=${lang/-/\/}
	echo fn is $fn
	# find out function of parentheses
    fn1=( ${lang/-/ } )
	echo fn1 is $fn1
	fn1a=${lang/-/ }
	echo fn1a is $fn1a
    fn2="${fn1[@]^}"
	echo fn2 is $fn2
    FN=${fn2/ /\/}
	echo FN is $FN
    echo querying ${FN/ /\/} $fn
    of=`basename ${2#sparql/templates/}`
	echo of is $of
    localqry="sparql/${of%.template}.$lang.rq"
    echo localqry is $localqry
	echo
    sed -e "s/%Lang%/${FN/\//\/}/g" -e "s/%lang%/${fn/\//\/}/g" $2 > $localqry
    #s-query --service http://localhost:3030/aama/query --query=$localqry
done
