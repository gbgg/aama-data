#!/bin/sh

#in master branch, EYEBALL="../src/eyeball-2.3/lib/*"

. bin/constants.sh

java -cp ${EYEBALL} jena.eyeball -check $1
