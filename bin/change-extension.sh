#!/bin/bash


for f in `find bin/ -name display-*.shx`
do
    f2=${f/%.sh/.bck}
    f3=${f/%.shx/.sh}
    mv $f $f3
done
