<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:coma="urn:coma:2010" xmlns:java="java:java.util.UUID" exclude-result-prefixes="xsl fn java"
  version="2.0">

  <xsl:output method="text" indent="yes" encoding="utf-8"/>

  <xsl:param name="lang" required="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- ################################################################ -->
  <xsl:template match="/">
    <xsl:apply-templates select="//prop" mode="val"/>
  </xsl:template>


  <xsl:template match="prop" mode="val">
    <xsl:choose>
      <xsl:when test="fn:contains(@type,'attributes')"/>
      <xsl:when test="fn:contains(@type,'auxAdjunct')"/>
      <xsl:when test="fn:contains(@type,'example')"/>
      <xsl:when test="fn:matches(@type,'[gG]loss')"/>
      <xsl:when test="fn:contains(@type,'label')"/>
      <xsl:when test="fn:contains(@type,'Label')"/>
      <xsl:when test="fn:contains(@type,'lemma')"/>
      <xsl:when test="fn:matches(@type,'token')"/>
      <xsl:when test="fn:matches(@type,'^ *$')">
	<xsl:message>
EMPTY PROPVAL in <xsl:value-of select="$lang"/>
	</xsl:message>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@val"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="*"> UNCAUGHT ELEMENT: <xsl:value-of select="namespace-uri()"/> |
      <xsl:value-of select="name()"/>
    <xsl:message> UNCAUGHT ELEMENT: <xsl:value-of select="namespace-uri()"/> | <xsl:value-of
        select="name()"/>
    </xsl:message>
  </xsl:template>

</xsl:stylesheet>
