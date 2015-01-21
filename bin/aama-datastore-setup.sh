#!/bin/sh

# rev 04/29/14 

# Script to re-initiate aama datastore with all (ARG: "data/*") or a selection
# of (ARG: "data/LANG,data/LANG,...") the languages.  Assumes that the relevant'# edn files are in place, that ttl and rdf have been generated, and that 
# fuseki has been launched. To regenerates pname files, uncomment relevant
# lines.

. bin/constants.sh
ldomain=${1//,/ }
ldomain=${ldomain//\"/}
echo "ldomain is ${ldomain}"

for f in `find $ldomain -name *.edn`
do
    f2=${f%/*-pdgms.edn}
    echo "2fuseki f = ${f2}"
    bin/aama-rdf2fuseki.sh $f2
    #echo "pnames f = ${f}"
    #bin/generate-pnames-all.sh $f
done

echo "Datastore now consists of:"
bin/fuqueries.sh

