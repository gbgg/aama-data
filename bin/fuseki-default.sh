#!/bin/sh

# rev 12/22/12
# Start the server before queries

 cd /cygdrive/c/Fuseki-0.2.4/
#./fuseki-server  --config=aamaconfig.ttl 
./fuseki-server -v  --update --loc=aamaDefault /aamaDefault
