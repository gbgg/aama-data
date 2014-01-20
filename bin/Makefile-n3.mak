AAMADATA_HOME=..
XSLHOME=${AAMADATA_HOME}/tools
JARDIR=/usr/local/jar
SAXON=saxon9.jar

default:
	echo "Usage: make n3 F=<filename> LANG=<lang>"

n3:
	java  -jar ${JARDIR}/${SAXON} \
	-xi \
	-s:${F}.xml \
	-xsl:${XSLHOME}/xml2n3.xsl \
	lang=${LANG} > ${F}.n3 ;

dump:
	java  -jar ${JARDIR}/${SAXON} \
	-xi \
	-s:${F}.xml \
	-xsl:${XSLHOME}/propdump.xsl;


