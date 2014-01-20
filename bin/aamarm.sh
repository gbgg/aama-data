#!/bin/sh

#rev 10/02/13

#brute-force removal of all files in aama datastore
#necessary because fudrop.sh (with named graphs)
#returns error message: "Quad: object cannot be null"
#also multiple: "Error TDB: Impossibly large object"

rm -r /cygdrive/c/Fuseki-0.2.4/aama/*
