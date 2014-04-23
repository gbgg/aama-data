#!/bin/bash



for f in `find bin/ -name generate-p*`
do
#    f2=${f/%.sh/.bck}
#   echo "copying $f to ${f2} . . . "
#  cp $f $f2
    f3=${f/%.sh/.new}
    echo "renaming $f to ${f3} . . . "
    mv $f $f3
    sed -f bin/append.sed $f3 > $f
done
