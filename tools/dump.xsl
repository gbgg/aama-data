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

    <xsl:variable name="f">
      <xsl:value-of select="concat('tmp/', fn:translate($lang, '/', '-'),
    			    '.props')"/>
    </xsl:variable>
    <xsl:result-document method="text"
    			 href="{$f}">
      <xsl:apply-templates select="//prop" mode="prop"/>
    </xsl:result-document>

    <!-- <xsl:variable name="g"> -->
    <!--   <xsl:value-of select="concat('tmp/',  fn:translate($lang, '/', '-'), -->
    <!-- 			    '-vals')"/> -->
    <!-- </xsl:variable> -->
    <!-- <xsl:result-document method="text" -->
    <!-- 			 href="{$g}"> -->
    <!--   <xsl:apply-templates select="//prop" mode="val"/> -->
    <!-- </xsl:result-document> -->

    <!-- <xsl:variable name="h"> -->
    <!--   <xsl:value-of select="concat('tmp/',  fn:translate($lang, '/', '-'), -->
    <!-- 			    '-propvals')"/> -->
    <!-- </xsl:variable> -->
    <!-- <xsl:result-document method="text" -->
    <!-- 			 href="{$g}"> -->
    <!--   <xsl:apply-templates select="//prop" mode="propval"/> -->
    <!-- </xsl:result-document> -->

  </xsl:template>


  <xsl:template match="prop" mode="prop">
<xsl:message>
  PROP <xsl:value-of select="@type"/>
</xsl:message>
    <xsl:value-of select="@type"/>
    <xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="prop" mode="val">
    <xsl:value-of select="@val"/>
    <xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="prop" mode="val">
    <xsl:value-of select="@type"/>
    <xsl:text>		|	</xsl:text>
    <xsl:value-of select="@val"/>
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
