#!/bin/sh

#in master branch, EYEBALL="../src/eyeball-2.3/lib/*"
# in dev branch EYEBALL="/usr/local/eyeball-2.3/lib/*"

. bin/constants.sh

java -cp ${EYEBALL} jena.eyeball -check $1
#java -cp ${JARDIR}/${EYEBALL} jena.eyeball -check $1

# Even though I have /usr/local/eyeball-2.3/lib/arq.jar, get:
# "java.lang.NoClassDefFoundError: /usr/local/eyeball-2/3/lib/arq/jar"