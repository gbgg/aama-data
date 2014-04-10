#!/bin/sh

./bin/constants.sh

echo "ttl2rdf" > logs/ttl2rdf.log;

for f in `find $1 -name *.ttl`
do
    l1=`dirname $f`
    lang=${l1#-pdgms}
    echo "$lang: rdfizing from ${f} to ${f%.ttl}.rdf by ${RDF2RDF}"
    java -jar ../.jar/rdf2rdf-1.0.1-2.3.1.jar $f ${f%.ttl}.rdf
done
