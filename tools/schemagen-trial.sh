#!/bin/sh
# usage:  fuquery "dir"

#echo > logs/schemagen.log

for d in `ls  -d data`
do
	fs=`find $d -name *xml`

	for f in $fs
	do
		of=tmp/lexcheck.`basename $f`.txt
		echo $f to $of
		echo trial $d
	done
done
# note that 'ls -d data/*' on command line works