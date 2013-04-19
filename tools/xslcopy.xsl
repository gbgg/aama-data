<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:err="http://www.w3.org/2005/xqt-errors"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:sbwh="http://rdf.insidearabic.org/sibawaihi/terms/"
    xmlns:sib="http://sibawayhi.org/schema/2010/05/ns#"
    exclude-result-prefixes="sbwh"
    version="2.0">

  <xsl:output method="xml"
	      indent="yes"
	      encoding="utf-8"
	      />

  <!-- use-character-maps="arabic" -->
  <xsl:character-map name="arabic">
    <!-- use Eastern Arabic (u06F?) for digits in this spreadsheet, so
         they make it into the output correctly -->
    <xsl:output-character character="0" string="٠"/>
    <xsl:output-character character="1" string="١"/>
    <xsl:output-character character="2" string="٢"/>
    <xsl:output-character character="3" string="٣"/>
    <xsl:output-character character="4" string="٤"/>
    <xsl:output-character character="5" string="٥"/>
    <xsl:output-character character="6" string="٦"/>
    <xsl:output-character character="7" string="٧"/>
    <xsl:output-character character="8" string="٨"/>
    <xsl:output-character character="9" string="٩"/>
  </xsl:character-map>

  <xsl:strip-space elements="*"/>	      

  <xsl:variable name="sib">http://sibawayhi.org/kitab/</xsl:variable>

  <xsl:template match="/">
  <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="rdf:RDF">
    <xsl:element name="rdf:RDF">
      <xsl:namespace name="rdf"
		     select="'http://www.w3.org/1999/02/22-rdf-syntax-ns#'"/>
      <xsl:namespace name="dc"
		     select="'http://purl.org/dc/elements/1.1/'"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sbwh:Article">
    <xsl:variable name="nbr" select="sbwh:article"/>
    <xsl:element name="sib:Article"
		 inherit-namespaces="no">
      <xsl:attribute name="rdf:about">
	<xsl:value-of select="concat($sib, $nbr)"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sbwh:*">
    <xsl:variable name="n" select="concat('sib:', fn:local-name())"/>
    <xsl:element name="{$n}"
		 inherit-namespaces="no">
      <xsl:apply-templates select="@* | node()"/>
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
