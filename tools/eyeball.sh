#!/bin/sh

. tools/constants.sh

java -cp ${EYEBALL} jena.eyeball -check $1
