<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:err="http://www.w3.org/2005/xqt-errors"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    version="2.0">

  <xsl:output method="xml"
	      indent="yes"
	      encoding="utf-8"
	      />

  <xsl:strip-space elements="*"/>	      

  <xsl:template match="/">
  <xsl:apply-templates/>
  </xsl:template>
 
 <xsl:template match="lexeme">
   <xsl:element name="lexeme">
     <xsl:attribute name="id" select="concat(prop[@type='lang']/@val, '-', prop[@type='lexlabel']/@val)"/>
     <xsl:apply-templates/>
   </xsl:element>
 </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy copy-namespaces="no"
	      inherit-namespaces="no">
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

<xsl:template match="text()" priority="10">
	<xsl:value-of select="normalize-space(.)"/>
</xsl:template>

</xsl:stylesheet>
