#!/bin/bash



for f in `find $1 -name *.edn`
do
    f2=${f/%.edn/.new}     
    echo "renaming $f to ${f2} . . . "
    mv $f $f2
    #sed -e "s/ldomain\/\/\"\//ldomain\/\/\\\\\"\//" $f2 > $f
    sed -e "s/:Pro,/:Pronoun,/g" $f2 > $f
    #sed -f bin/append.sed $f2 > $f
done
