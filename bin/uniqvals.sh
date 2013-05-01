#!/bin/bash
# usage:  dumpvals.sh "dir"
# IMPORTANT:  use quotes if dir includes a wildcard
# e.g.  dumpvals.sh "data/*"

AAMADATA_HOME=..
XSLHOME=${AAMADATA_HOME}/tools
JARDIR=/usr/local/jar
SAXON=saxon9.jar

for f in `ls tmp/*vals`
do
    echo "uniqifying vals of " $f
    # set -x;
    sort $f | uniq > $f.uniq
    # set +x;
done

echo producing tmp/allvals.uniq
cat tmp/*.vals | sort | uniq > tmp/allvals.uniq
