<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:coma="urn:coma:2010" xmlns:java="java:java.util.UUID" exclude-result-prefixes="xsl fn java"
  version="2.0">
  <xsl:output method="text" indent="yes" encoding="utf-8"/>

  <xsl:strip-space elements="*"/>

  <xsl:param name="f" required="yes"/>
  <xsl:param name="lang" required="yes"/>
  <!-- ################################################################ -->
  <!--04/19/13: gbgg added pdgmlabel to output-->
  <!--04/22/13: gbgg added "or mulabel" to common-properties test-->
  <!-- 04/23/13: gbgg added multiLex option to common-properties -->
  <!--04/25/13: gbgg 
		  This program was "forked" from lexcheck.xsl, which is limited to a
  		first-pass, to pick out termclusters which do not
       have a lex label (many of which will need to be assigned a mulabel
  		 or a multiLex property). Run by the script lexadd.sh, 
  		 lexcheckadd.xsl has been created as a second
  		 pass to make sure that every termcluster has either a lexlabel, a mulabel, 
  		 or a multiLex property, and in the last case, to add to the log file (lexadd) 
  		 a dummy lexeme with the appropriate lexlabel, in case a full lexeme does not exist. -->
	<!-- 06/11/13: Cf. docs/notes/lexemes-w-id-mlex.txt -->

  <xsl:template match="/">
    <xsl:value-of select="$f"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="//common-properties"/>
  </xsl:template>

  <xsl:template match="common-properties">
    <xsl:choose>
      <xsl:when test="prop[fn:matches(@type, '.*multiLex.*')]">
        <xsl:variable name="multiLex" select="prop[@type='multiLex']/@val"/>
        <xsl:for-each select="../termcluster/term">
          <xsl:variable name="lexref" select="replace(prop[@type='lexlabel']/@val, '\?', '_')"/>
          <xsl:if test="not(//lexeme/prop[@type='lexlabel' and @val=$lexref])">
            <!--write to output file tmp/lexcheck/lexadd.[lang]-pdgms.xml.txt -->
            <xsl:text>&#10;</xsl:text>
            <!--<xsl:value-of select="ancestor::pdgm/common-properties/prop[@type='multiLex']/@val"/>-->
            <xsl:text>&lt;lexeme id="mlex_</xsl:text>
            <xsl:value-of select="$multiLex"/><xsl:text>-</xsl:text><xsl:value-of select="$lexref"/>
            <xsl:text>"&gt;
              &lt;prop type="gloss" val="[x]"/&gt;
              &lt;prop type="lang" val="</xsl:text>
              <xsl:value-of select="$lang"/>
            <xsl:text>"/&gt;
              &lt;prop type="lemma" val="[y]"/&gt;
              &lt;prop type="lexlabel" val="</xsl:text>
            <xsl:value-of select="$lexref"/>
            <xsl:text>"/&gt;
            &lt;/lexeme&gt;</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="prop[fn:matches(@type, '.*lexlabel.*')]">
          <xsl:variable name="lexref" select="prop[@type='lexlabel']/@val"/>
          <xsl:if test="not(//lexeme/prop[@type='lexlabel' and @val=$lexref])">
            <!--write to output file tmp/lexcheck/lexadd.[lang]-pdgms.xml.txt -->
            <xsl:text>&#10;</xsl:text>
            <!--<xsl:value-of select="ancestor::pdgm/common-properties/prop[@type='multiLex']/@val"/>-->
            <xsl:text>&lt;lexeme id="newlex_</xsl:text>
            <xsl:value-of select="$lexref"/>
            <xsl:text>"&gt;
              &lt;prop type="gloss" val="[x]"/&gt;
              &lt;prop type="lang" val="</xsl:text>
              <xsl:value-of select="$lang"/>
            <xsl:text>"/&gt;
              &lt;prop type="lemma" val="[y]"/&gt;
              &lt;prop type="lexlabel" val="</xsl:text>
            <xsl:value-of select="$lexref"/>
            <xsl:text>"/&gt;
            &lt;/lexeme&gt;</xsl:text>
          </xsl:if>
      </xsl:when>
      <xsl:when
        test="not(prop[fn:matches(@type,'.*lexlabel.*')] or prop[fn:matches(@type,'.*mulabel.*')] or prop[fn:matches(@type, '.*multiLex.*')])">
        <xsl:message> FAIL: pid=<xsl:value-of select="../@pid"/>
        </xsl:message>
        <xsl:value-of select="../@pid"/>
        <xsl:text>&#10;      </xsl:text>
        <xsl:value-of select="../pdgmlabel"/>
        <xsl:text>&#10;</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
