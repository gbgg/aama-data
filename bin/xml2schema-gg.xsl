<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:aama="urn:aama:2010" xmlns:java="java:java.util.UUID" exclude-result-prefixes="xsl fn java"
  version="2.0">

  <xsl:output method="text" indent="yes" encoding="utf-8"/>

  <xsl:strip-space elements="*"/>

  <xsl:param name="language" required="yes"/>
  <xsl:param name="abbr" required="yes"/>
  <!--  <xsl:param name="langVar" required="no"/>-->

  <xsl:variable name="aamaURI">
    <xsl:text>&lt;http://id.oi.uchicago.edu/aama/2013/</xsl:text>
  </xsl:variable>
  <xsl:variable name="l-pref" select="concat($abbr, ':')"/>
  <xsl:variable name="lang" select="aama:dncase-first($language)"/>
  <xsl:variable name="Lang" select="aama:upcase-first($language)"/>

  <!-- ######################################################## -->
  <!-- 04/23/13: gbgg calqued two entries for "Mu-term" based on two etries for "Lexeme"-->
  <!-- 05/08/13: gbgg modified program to accommodate lang prefixes-->
  <!-- 06/13/13: gbgg [Mm]uterm substituted for [Mm]u-term -->
  <!-- 08/08/13: gbgg uniform lang @prefix (e.g. no orm/Orm, only orm), extension of aamas: -->
  <!-- 10/02/13: gbgg xml2data/schema updated for aama "token" and "text" nodes; rdf/rdfs normalized -->

  <xsl:template match="/">
    <!-- n3 header -->
    <!-- @prefix xsd:	 &lt;http://www.w3.org/2001/XMLSchema#> . -->
    <!-- @prefix dc:	 &lt;http://purl.org/dc/elements/1.1/> . -->
    <!-- @prefix dcterms: &lt;http://purl.org/dc/terms> . -->
    <!-- @prefix gold:	 &lt;http://purl.org/linguistics/gold/> . -->

    <xsl:text>
<!--@prefix rdf:	 &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:	 &lt;http://www.w3.org/2000/01/rdf-schema#> .
@prefix aama:	 &lt;http://id.oi.uchicago.edu/aama/2013/> .
@prefix aamas:	 &lt;http://id.oi.uchicago.edu/aama/2013/schema/> .-->
@prefix </xsl:text>
    <xsl:value-of select="$l-pref"/>
    <xsl:text>   </xsl:text>
    <xsl:value-of select="$aamaURI"/>
    <xsl:value-of select="$lang"/>
    <xsl:text>/> .
    
</xsl:text>

    <!--   <xsl:message> -->
    <!-- GENERATING SCHEMA for  -->
    <!-- lang: <xsl:value-of select="$lang"/> -->
    <!--       <xsl:text> -->
    <!-- lang var: </xsl:text> -->
    <!--       <xsl:value-of select="$lvar"/> -->
    <!--       <xsl:text> -->
    <!-- properties: </xsl:text> -->
    <!--       <xsl:value-of select="$pref-p"/> -->
    <!--       <xsl:text> -->
    <!-- exponents: </xsl:text> -->
    <!--       <xsl:value-of select="$pref-v"/> -->
    <!--     </xsl:message> -->

    <xsl:text>aamas:MuExponent rdfs:subClassOf rdfs:Class .&#10;</xsl:text>
    <xsl:text>aamas:muProperty rdfs:subPropertyOf rdf:Property .&#10;</xsl:text>
    <xsl:text>aamas:Cluster rdfs:subClassOf rdfs:Class .&#10;</xsl:text>
    <xsl:text>aamas:Lexeme rdfs:subClassOf aamas:Cluster .&#10;</xsl:text>
    <xsl:text>aamas:Muterm rdfs:subClassOf aamas:Cluster .&#10;</xsl:text>
    <xsl:text>aamas:MuScheme rdfs:subClassOf aamas:Cluster .&#10;</xsl:text>
    <xsl:text>aamas:Term rdf:type aamas:Lexeme .&#10;</xsl:text>
    <xsl:text>aamas:Term rdf:type aamas:Muterm .&#10;</xsl:text>
    <xsl:text>aamas:Term rdf:type aamas:MuScheme .&#10;</xsl:text>
    <xsl:text>aamas:Token rdfs:subClassOf rdfs:Class .&#10;</xsl:text>
    <xsl:text>aamas:Text rdfs:subClassOf rdfs:Class .&#10;</xsl:text>

    <xsl:text>&#10;</xsl:text>

    <xsl:value-of select="$l-pref"/>
    <xsl:text>MuExponent rdfs:subClassOf aamas:MuExponent .&#10;</xsl:text>

    <xsl:text>&#10;</xsl:text>

    <xsl:value-of select="$l-pref"/>
    <xsl:text>muProperty rdfs:subPropertyOf aamas:muProperty .&#10;</xsl:text>

    <xsl:text>&#10;</xsl:text>


    <xsl:text>aama:</xsl:text>
    <xsl:value-of select="$Lang"/>
    <xsl:text> a aamas:Language .&#10;</xsl:text>


    <xsl:text>aama:</xsl:text>
    <xsl:value-of select="$Lang"/>
    <xsl:text> rdfs:label "</xsl:text>
    <xsl:value-of select="$Lang"/>
    <xsl:text>" .&#10;</xsl:text>

    <xsl:apply-templates select="//prop"/>
  </xsl:template>

  <!-- ################################################ -->
  <xsl:template match="prop">
    <xsl:variable name="lang">
      <xsl:value-of select="aama:dncase-first((//prop[@type='lang'])[1]/@val)"/>
    </xsl:variable>
    <xsl:variable name="lvar">
      <xsl:if test="(//prop[@type='langVar'])[1]">
        <xsl:value-of select="aama:dncase-first((//prop[@type='langVar'])[1]/@val)"/>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="langURI">
      <xsl:value-of select="$aamaURI"/>
      <!-- <xsl:text>lang/</xsl:text> -->
      <xsl:value-of select="aama:dncase-first($lang)"/>
      <xsl:text>/</xsl:text>
    </xsl:variable>
    <xsl:variable name="LangURI">
      <xsl:value-of select="$aamaURI"/>
      <!-- <xsl:text>Lang/</xsl:text> -->
      <xsl:value-of select="aama:upcase-first($lang)"/>
      <xsl:text>/</xsl:text>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="@type = 'lang'"/>
      <xsl:when test="@type = 'lexlabel'"/>
      <xsl:otherwise>
        <xsl:variable name="prop">
          <xsl:choose>
            <xsl:when test="fn:matches(@type, '[eE]xample')"/>
            <xsl:when test="fn:matches(@type, '[gG]loss')"/>
            <xsl:when test="fn:matches(@type, '[lL]emma')"/>
            <xsl:when test="fn:matches(@type, '[lL]abel')"/>
            <xsl:when test="fn:matches(@type, 'note')"/>
            <xsl:when test="fn:matches(@type, '[tT]oken.*')"/>
            <xsl:when test="fn:matches(@val, '_NULL')"/>
            <xsl:otherwise>
              <xsl:value-of select="$lang"/>
              <xsl:text>/</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <!-- <xsl:value-of select="@type"/> -->
        </xsl:variable>

        <!-- property -->
        <xsl:value-of select="$l-pref"/>
        <xsl:value-of select="@type"/>

        <xsl:choose>
          <xsl:when test="fn:matches(@type, '[eE]xample')">
            <xsl:text> rdf:type aamas:Text</xsl:text>
          </xsl:when>
          <xsl:when test="fn:matches(@type, '[gG]loss')">
            <xsl:text> rdf:type aamas:Text</xsl:text>
          </xsl:when>
          <xsl:when test="fn:matches(@type, '[lL]emma')">
            <xsl:text> rdf:type aamas:Text</xsl:text>
          </xsl:when>
          <xsl:when test="fn:matches(@type, '[lL]abel')">
            <xsl:text> rdf:type aama:Label</xsl:text>
          </xsl:when>
          <xsl:when test="fn:matches(@type, 'note')">
            <xsl:text> rdf:type aamas:Text</xsl:text>
          </xsl:when>
          <xsl:when test="fn:matches(@type, '[tT]oken.*')">
            <xsl:text> rdf:type aamas:Token</xsl:text>
          </xsl:when>
          <xsl:when test="fn:matches(@val, '_NULL')">
            <xsl:text> rdf:type aama:NULL</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text> rdfs:subPropertyOf </xsl:text>
            <xsl:value-of select="$l-pref"/>
            <xsl:text>muProperty</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> .&#10;</xsl:text>

        <xsl:value-of select="$l-pref"/>
        <xsl:value-of select="@type"/>
        <xsl:value-of select="concat(' rdfs:label &quot;',
			      @type, '&quot; .&#10;')"/>

        <xsl:value-of select="$l-pref"/>
        <xsl:value-of select="@type"/>
        <xsl:text> aamas:lang aama:</xsl:text>
        <xsl:value-of select="$Lang"/>
        <xsl:text> .&#10;</xsl:text>

        <xsl:text>&#10;</xsl:text>

        <!-- schema stuff -->
        <xsl:value-of select="$l-pref"/>
        <xsl:value-of select="@type"/>
        <xsl:text> rdfs:domain aamas:Term .&#10;</xsl:text>
        <xsl:value-of select="$l-pref"/>
        <xsl:value-of select="@type"/>
        <xsl:text> rdfs:range </xsl:text>
        <xsl:value-of select="$l-pref"/>
        <xsl:value-of select="aama:upcase-first(@type)"/>
        <xsl:text> .&#10;</xsl:text>

        <xsl:text>&#10;</xsl:text>

        <xsl:value-of select="$l-pref"/>
        <xsl:value-of select="aama:upcase-first(@type)"/>
        <xsl:text> rdfs:subClassOf </xsl:text>
        <xsl:value-of select="$l-pref"/>
        <xsl:text>MuExponent .&#10;</xsl:text>

        <xsl:value-of select="$l-pref"/>
        <xsl:value-of select="aama:upcase-first(@type)"/>
        <xsl:text> rdfs:label "</xsl:text>
        <xsl:value-of select="concat(@type, ' exponents&quot; .&#10;')"/>

        <xsl:value-of select="$l-pref"/>
        <xsl:value-of select="aama:upcase-first(@type)"/>
        <xsl:text> aamas:lang aama:</xsl:text>
        <xsl:value-of select="$Lang"/>
        <xsl:text> .&#10;</xsl:text>

        <xsl:choose>
          <xsl:when test="fn:matches(@type, '[eE]xample')"/>
          <xsl:when test="fn:matches(@type, '[gG]loss')"/>
          <xsl:when test="fn:matches(@type, '[lL]emma')"/>
          <xsl:when test="fn:matches(@type, '[lL]abel')"/>
          <xsl:when test="fn:matches(@type, 'note')"/>
          <xsl:when test="fn:matches(@type, '[tT]oken')"/>
          <xsl:when test="fn:matches(@val, '_NULL')"/>
          <xsl:otherwise>
            <xsl:text>

</xsl:text>

            <xsl:call-template name="uri">
              <xsl:with-param name="path">
                <xsl:value-of select="aama:upcase-first(@val)"/>
              </xsl:with-param>
            </xsl:call-template>

            <xsl:text> rdf:type </xsl:text>

            <xsl:value-of select="$l-pref"/>
            <xsl:value-of select="aama:upcase-first(@type)"/>
            <xsl:text> .&#10;</xsl:text>

            <xsl:call-template name="uri">
              <xsl:with-param name="path">
                <xsl:value-of select="aama:upcase-first(@val)"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:text> aamas:lang aama:</xsl:text>
            <xsl:value-of select="$Lang"/>

            <xsl:text> .
</xsl:text>

            <xsl:call-template name="uri">
              <xsl:with-param name="path">
                <xsl:value-of select="aama:upcase-first(@val)"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:text> rdfs:label "</xsl:text>
            <xsl:value-of select="@val"/>
            <xsl:text>" .

</xsl:text>

            <!-- <xsl:text>aama:</xsl:text> -->
            <!--   <xsl:value-of select="$lang"/> -->
            <!--   <xsl:text>:</xsl:text> -->
            <!--   <xsl:text>PropertyValue .</xsl:text> -->
            <!--   </xsl:otherwise> -->
            <!-- </xsl:choose> -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*"> UNCAUGHT ELEMENT: <xsl:value-of select="namespace-uri()"/> |
      <xsl:value-of select="name()"/>
    <xsl:message> UNCAUGHT ELEMENT: <xsl:value-of select="namespace-uri()"/> | <xsl:value-of
        select="name()"/>
    </xsl:message>
  </xsl:template>

  <xsl:function name="aama:upcase-first">
    <xsl:param name="str" as="xs:string"/>
    <xsl:sequence
      select="fn:concat(
			  fn:upper-case(fn:substring($str, 1, 1)),
			  fn:substring($str, 2))"
    />
  </xsl:function>

  <xsl:function name="aama:dncase-first">
    <xsl:param name="str" as="xs:string"/>
    <xsl:sequence
      select="fn:concat(
			  fn:lower-case(fn:substring($str, 1, 1)),
			  fn:substring($str, 2))"
    />
  </xsl:function>

  <xsl:template name="uri">
    <xsl:param name="path"/>
    <xsl:value-of select="$l-pref"/>
    <xsl:value-of select="$path"/>
    <xsl:text/>
  </xsl:template>

  <xsl:template name="label">
    <xsl:param name="label"/>
    <xsl:value-of select="$aamaURI"/>
    <xsl:text> rdfs:label </xsl:text>
    <xsl:value-of select="$label"/>
  </xsl:template>

</xsl:stylesheet>
