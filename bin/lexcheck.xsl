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
  <!--04/25/13: gbgg 
		This program is only for first-pass, to pick out termclusters which do not
         have a lex label (many of which will need to be assigned a mulabel
		 or a multiLex property). lexcheckadd.xsl has been created as a second
		 pass to make sure that every termcluster has either a lexlabel, a mulabel, 
		 or a multiLex property, and in the last case, to create in the log a dummy
		 lexeme with the appropriate lexlabel, in case a full lexeme does not exist. -->
		 
    <xsl:template match="/">
    <xsl:value-of select="$f"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="//common-properties"/>
  </xsl:template>

  <xsl:template match="common-properties">
    <xsl:if
      test="not(prop[fn:matches(@type,'.*lexlabel.*')] or prop[fn:matches(@type,'.*mulabel.*')] or prop[fn:matches(@type, '.*multiLex.*')])">
      <xsl:message> FAIL: pid=<xsl:value-of select="../@pid"/>
      </xsl:message>
      <xsl:value-of select="../@pid"/>
      <xsl:text>&#10;      </xsl:text>
      <xsl:value-of select="../pdgmlabel"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
