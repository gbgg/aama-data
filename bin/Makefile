AAMATOOLS_HOME=./bin
XSLHOME=${AAMATOOLS_HOME}
#JARDIR=/usr/local/jar
#SAXON=saxon9.jar

JARDIR=../../../usr/local/jar
SAXON=saxon9pe.jar

default:
	echo "Usage: make edn F=<filename>"
	echo "    <filename> includes path"

# convert xml data to edn, put results in same dir as source
# put this makefile wherever convenient (e.g. ./bin/)
# run e.g. $ make edn -f bin/Makefile F=data/beja-bishari/beja-bishari-pdgms.xml

edn:
	LANG=${F%-pdgms}
	java  -jar ${JARDIR}/${SAXON} \
	-xi \
	-s:${F} \
	-xsl:${XSLHOME}/xml2edn.xsl \
	lang=${LANG} > `dirname ${F}`/`basename ${F} .xml`.edn ;
