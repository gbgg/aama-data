<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:coma="urn:coma:2010" xmlns:java="java:java.util.UUID" exclude-result-prefixes="xsl fn java"
  version="2.0">

  <xsl:output method="text" indent="yes" encoding="utf-8"/>

  <xsl:strip-space elements="*"/>

  <xsl:param name="f" required="yes"/>
  <!-- ################################################################ -->
  <xsl:template match="/">
    <xsl:value-of select="$f"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="//common-properties"/>
  </xsl:template>

  <xsl:template match="common-properties">
    <xsl:if test="not(prop[fn:matches(@type,'.*lexlabel.*')])">
<xsl:message>
FAIL: pid=<xsl:value-of select="../@pid"/>
</xsl:message>
      <xsl:value-of select="../@pid"/>
      <xsl:text>&#10;      </xsl:text>
	  <xsl:value-of select="../pdgmlabel"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
