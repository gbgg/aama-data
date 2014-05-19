#!/bin/sh

# rev 04/29/14 

# Script to delete current arg graphs from datastore, regenerate ttl/rdf
# from corrected edn, upload to fuseki, generate pnames files necessary for
# pdgm "pname" display; assumes fuseki has been launched by bin/fuseki.sh.

. bin/constants.sh
ldomain=${1//,/ }
ldomain=${ldomain//\"/}
echo "ldomain is ${ldomain}"

for f in `find $ldomain -name *.edn`
do
    f2=${f%/*-pdgms.edn}
    echo "delete f = ${f2}"
    bin/fudelete.sh $f2
    #bin/fuqueries.sh
    #echo "[Enter] to continue or Ctl-C to exit"
    #read
    echo "2rdf f = ${f}"
    bin/aama-edn2rdf.sh $f
    echo "2fuseki f = ${f2}"
    bin/aama-rdf2fuseki.sh $f2
    #bin/fuqueries.sh
    #echo "[Enter] to continue or Ctl-C to exit"
    #read
    echo "pnames f = ${f}"
    bin/generate-pnames-pro.sh $f
    bin/generate-pnames-fv.sh $f
    bin/generate-pnames-nfv.sh $f
    bin/generate-pnames-noun.sh $f
done
