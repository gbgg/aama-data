#!/bin/bash


for f in `find bin/ -name display-*.shx`
do
    f2=${f/%.sh/.bck}
    cp $f $f2
    f3=${f/%.shx/.sh}
    mv $f $f3
done
