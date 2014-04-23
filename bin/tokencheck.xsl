<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:coma="urn:coma:2010" xmlns:java="java:java.util.UUID" exclude-result-prefixes="xsl fn java"
  version="2.0">
  <xsl:output method="text" indent="yes" encoding="utf-8"/>

  <xsl:strip-space elements="*"/>

  <xsl:param name="f" required="yes"/>
  <!-- ################################################################ -->
  <!--04/19/13: gbgg added pdgmlabel to output-->
  <!--09/23/13: gbgg 
		This program is adapted from lexcheck-gg.xsl  to pick out terms which do not have a unitary "token" property (many of them will have a "token-. . ." property). A group of adhoc Find/Replace patterns have been created (bin/token-insert.txt, in lieu of a tokencheckadd.xs)l  to insert a "token" property from succession of "token-..."s) -->
		 
    <xsl:template match="/">
    <xsl:value-of select="$f"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="//term"/>
  </xsl:template>

  <xsl:template match="term">
    <xsl:if
      test="not(prop[@type='token']) and not(../../common-properties/prop[@type='token'])">
      <xsl:message> FAIL: pid=<xsl:value-of select="../../pdgmlabel"/>
      </xsl:message>
      <xsl:value-of select="../../pdgmlabel"/>
	  <xsl:text>&#10;</xsl:text>
	<!--<xsl:text> (</xsl:text>
      <xsl:value-of select="../../@pid"/>
	<xsl:text>)&#10;</xsl:text>-->
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
