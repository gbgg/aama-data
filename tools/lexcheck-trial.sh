#!/bin/bash

. tools/constants.sh

ofsum=tmp/lexcheck.txt

for d in `ls -d data`
do
fs=`find $d -name *xml`

for f in $fs
do
    of=tmp/lexcheck.`basename $f`.txt
	echo $f to $of
done
done