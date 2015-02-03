#!/bin/bash



for f in `find $1 -name *.edn`
#for f in `find $1 -name *.sh`
do
    f2=${f/%.edn/.new}     
    echo "renaming $f to ${f2} . . . "
    mv $f $f2
    sed -e "s/:Nominative,/:Subject,/g" $f2 > $f
    sed -e "s/:Accusative,/:Object,/g" $f2 > $f
    sed -e "s/:Genitive,/:Possessive,/g" $f2 > $f
    #sed -e "s/display-test\.sh/display-test.sh \$1/" $f2 > $f 
    #sed -f bin/sed-append2.sed $f2 > $f
done
