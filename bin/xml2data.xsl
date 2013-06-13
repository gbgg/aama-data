<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:aama="urn:aama:2010" xmlns:java="java:java.util.UUID" exclude-result-prefixes="xsl fn java"
  version="2.0">

  <!-- 04/22/2013: gbgg, tests added to pick up mu-term vals-->
  <!-- 04/23/13: gbgg, $lexref for terms in termclusters marked "multiLex" -->
  <!-- 05/03/13: gbgg, changed for revised ttl format w/o langVar and with lang @prefix  -->
  <!-- 06/13/13: gbgg [Mm]uterm substituted for [Mm]u-term -->
  
  <xsl:output method="text" indent="yes" encoding="utf-8"/>

  <xsl:strip-space elements="*"/>

  <xsl:param name="lang" required="yes"/>
  <xsl:param name="abbr" required="yes"/>
<!--  <xsl:param name="langVar" required="no"/>-->

  <xsl:variable name="aamaURI">
    <xsl:text>&lt;http://id.oi.uchicago.edu/aama/2013/</xsl:text>
  </xsl:variable>
  <xsl:variable name="Lang" select="aama:upcase-first($lang)"/>
  <xsl:variable name="pref-p">
    <xsl:value-of select="aama:dncase-first($abbr)"/><xsl:text>:</xsl:text>
  </xsl:variable>
  <xsl:variable name="pref-v">
    <xsl:value-of select="aama:upcase-first($abbr)"/><xsl:text>:</xsl:text>
  </xsl:variable>
  <!-- ################################################ -->
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="analysis">
    <!-- n3 header -->
    <!-- @prefix xsd:	 &lt;http://www.w3.org/2001/XMLSchema#> . -->
    <!-- @prefix dc:	 &lt;http://purl.org/dc/elements/1.1/> . -->
    <!-- @prefix dcterms: &lt;http://purl.org/dc/terms> . -->
    <!-- @prefix gold:	 &lt;http://purl.org/linguistics/gold/> . -->

    <xsl:text>
@prefix rdf:	 &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:	 &lt;http://www.w3.org/2000/01/rdf-schema#> .
@prefix aama:	 &lt;http://id.oi.uchicago.edu/aama/2013/> .
@prefix aamas:	 &lt;http://id.oi.uchicago.edu/aama/2013/schema/> .
@prefix </xsl:text>
    <xsl:value-of select="$pref-p"/><xsl:text>   </xsl:text><xsl:value-of select="$aamaURI"/><xsl:value-of select="$lang"/><xsl:text>/> .
@prefix </xsl:text>
    <xsl:value-of select="$pref-v"/><xsl:text>   </xsl:text><xsl:value-of select="$aamaURI"/><xsl:value-of select="$Lang"/><xsl:text>/> .
    
</xsl:text>

    <xsl:apply-templates/>

  </xsl:template>

  <xsl:template match="lexemes">
    <!--    <xsl:message>....skipping lexemes</xsl:message>-->
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="muterms">
    <!--    <xsl:message>....skipping lexemes</xsl:message>-->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- LEXEMES -->
  <xsl:template match="lexeme">

    <xsl:variable name="lang">
      <xsl:value-of select="aama:dncase-first((//prop[@type='lang'])[1]/@val)"/>
    </xsl:variable>
    <xsl:variable name="Lang">
      <xsl:value-of select="aama:upcase-first($lang)"/>
    </xsl:variable>

<!--    <xsl:variable name="lvar">
      <xsl:if test="(//prop[@type='langVar'])[1]">
        <xsl:value-of select="aama:dncase-first((//prop[@type='langVar'])[1]/@val)"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="Lvar">
      <xsl:value-of select="aama:upcase-first($lvar)"/>
    </xsl:variable>
-->
    <xsl:variable name="langURI">
      <xsl:value-of select="$aamaURI"/>
      <!-- <xsl:text>lang/</xsl:text> -->
      <xsl:value-of select="aama:dncase-first($lang)"/>
<!--      <xsl:if test="fn:string-length($lvar) > 0">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="aama:dncase-first($lvar)"/>
      </xsl:if>
-->      <xsl:text>/</xsl:text>
    </xsl:variable>
    <xsl:variable name="LangURI">
      <xsl:value-of select="$aamaURI"/>
      <!-- <xsl:text>Lang/</xsl:text> -->
      <xsl:value-of select="aama:upcase-first($lang)"/>
<!--      <xsl:if test="fn:string-length($lvar) > 0">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="aama:upcase-first($lvar)"/>
      </xsl:if>
-->      <xsl:text>/</xsl:text>
    </xsl:variable>

    <xsl:text>aama:</xsl:text>
<!--    <xsl:value-of select="$pref-p"/>-->
    <xsl:value-of select="@id"/>
    <xsl:text> a aamas:Lexeme ;&#10;</xsl:text>

    <xsl:for-each select="prop">
    <!-- properties     -->
      <xsl:choose>
        <xsl:when test="@type = 'lexlabel'">
          <xsl:text>  rdfs:label </xsl:text>
        </xsl:when>
        <xsl:when test="@type = 'mulabel'">
          <xsl:text>  rdfs:label </xsl:text>
        </xsl:when>
        <xsl:when test="@type = 'lang'">
          <xsl:text>  aama:lang </xsl:text>
        </xsl:when>
        <xsl:when test="@type = 'lemma'">
          <xsl:text>  aama:lemma </xsl:text>
        </xsl:when>
        <xsl:when test="@type = 'gloss'">
          <xsl:text>  aama:gloss </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>  </xsl:text>
          <xsl:value-of select="$pref-p"/>
          <xsl:value-of select="@type"/>
          <xsl:text>  </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <!-- values     -->
      <xsl:choose>
        <xsl:when test="@type = 'lang'">
<!--          <xsl:value-of select="fn:replace($LangURI, '(.*)/$', '$1>')"/>-->
          <xsl:text>aama:</xsl:text>
          <xsl:value-of select="$Lang"/>
        </xsl:when>
        <xsl:when test="fn:matches(@type, 'auxAdjunct')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, 'attributes')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, '[eE]xample')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, '[gG]loss')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, '[lL]emma')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, '[lL]abel')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, 'note')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, 'stem')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, 'structAux')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, 'structMain')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, '[tT]oken')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@val, '_NULL')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$pref-v"/>
<!--          <xsl:value-of select="aama:upcase-first(@type)"/>
          <xsl:text>_</xsl:text>
-->          <xsl:value-of select="aama:upcase-first(@val)"/>
          <xsl:text> </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="position() != last()">
        <xsl:text> ;&#10;</xsl:text>
      </xsl:if>
    </xsl:for-each>

    <xsl:text>
      .&#10;</xsl:text>

  </xsl:template>

  <!-- MUTERMS -->
  <xsl:template match="muterm">

    <xsl:variable name="lang">
      <xsl:value-of select="aama:dncase-first((//prop[@type='lang'])[1]/@val)"/>
    </xsl:variable>
    <xsl:variable name="Lang">
      <xsl:value-of select="aama:upcase-first($lang)"/>
    </xsl:variable>

<!--    <xsl:variable name="lvar">
      <xsl:if test="(//prop[@type='langVar'])[1]">
        <xsl:value-of select="aama:dncase-first((//prop[@type='langVar'])[1]/@val)"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="Lvar">
      <xsl:value-of select="aama:upcase-first($lvar)"/>
    </xsl:variable>
-->
    <xsl:variable name="langURI">
      <xsl:value-of select="$pref-p"/>
      <!-- <xsl:text>lang/</xsl:text> -->
      <xsl:value-of select="aama:dncase-first($lang)"/>
<!--      <xsl:if test="fn:string-length($lvar) > 0">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="aama:dncase-first($lvar)"/>
      </xsl:if>
-->      <xsl:text>/</xsl:text>
    </xsl:variable>
    <xsl:variable name="LangURI">
      <xsl:value-of select="$pref-v"/>
      <!-- <xsl:text>Lang/</xsl:text> -->
      <xsl:value-of select="aama:upcase-first($lang)"/>
<!--      <xsl:if test="fn:string-length($lvar) > 0">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="aama:upcase-first($lvar)"/>
      </xsl:if>
-->      <xsl:text>/</xsl:text>
    </xsl:variable>

    <xsl:text>aama:</xsl:text>
<!--    <xsl:value-of select="$pref-p"/>-->
    <xsl:value-of select="@id"/>
    <xsl:text> a aamas:Muterm ;&#10;</xsl:text>

    <xsl:for-each select="prop">
      <xsl:choose>
        <xsl:when test="@type = 'mulabel'">
          <xsl:text>  rdfs:label </xsl:text>
        </xsl:when>
        <xsl:when test="@type = 'gloss'">
          <xsl:text>  rdfs:comment </xsl:text>
        </xsl:when>
        <xsl:when test="@type = 'lang'">
          <xsl:text>  aama:lang </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>  </xsl:text>
          <xsl:value-of select="$pref-p"/>
          <xsl:value-of select="@type"/>
          <xsl:text>  </xsl:text>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="@type = 'lang'">
          <!--          <xsl:value-of select="fn:replace($LangURI, '(.*)/$', '$1>')"/>-->
          <xsl:text>aama:</xsl:text>
          <xsl:value-of select="$Lang"/>
        </xsl:when>
        <xsl:when test="fn:matches(@type, 'auxAdjunct')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, 'attributes')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, '[eE]xample')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, '[gG]loss')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, '[lL]emma')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, '[lL]abel')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, 'note')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, 'stem')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, 'structAux')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, 'structMain')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@type, '[tT]oken')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="fn:matches(@val, '_NULL')">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@val"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$pref-v"/>
<!--          <xsl:value-of select="aama:upcase-first(@type)"/>
          <xsl:text>_</xsl:text>
-->          <xsl:value-of select="aama:upcase-first(@val)"/>
          <xsl:text> </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="position() != last()">
        <xsl:text> ;&#10;</xsl:text>
      </xsl:if>
    </xsl:for-each>

    <xsl:text>
      .&#10;</xsl:text>

  </xsl:template>

  <xsl:template match="pdgms">

    <xsl:text>

########################################################
########  TERMS
########################################################

</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="pdgm/termcluster">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
  <xsl:template match="pdgm">

    <xsl:for-each select="termcluster/term">

      <xsl:text>aama:</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text> a aamas:Term ;
	</xsl:text>

      <xsl:variable name="lexref">
        <xsl:choose>
          <xsl:when test="ancestor::pdgm/common-properties/prop[@type='multiLex']">
            <xsl:value-of select="prop[@type='lexlabel']/@val"/>
          </xsl:when>
          <xsl:when test="ancestor::pdgm/common-properties/prop[@type='mulabel']">
            <xsl:value-of select="prop[@type='mulabel']/@val"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="ancestor::pdgm/common-properties/prop[@type='lexlabel']/@val"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="muref">
        <xsl:value-of select="ancestor::pdgm/common-properties/prop[@type='mulabel']/@val"/>
      </xsl:variable>
      
      <xsl:if test="$lexref = '' and $muref = ''">
        <xsl:message> LEXREF: <xsl:value-of select="$lexref"/>
          <xsl:text> PDGM: </xsl:text>
          <xsl:value-of select="ancestor::pdgm/pdgmlabel"/>
          <xsl:text> POS: </xsl:text>
          <xsl:value-of select="ancestor::pdgm/common-properties/prop[@type='pos']/@val"/> TERM
            <xsl:value-of select="@id"/>
        </xsl:message>
      </xsl:if>

      <xsl:variable name="lexid">
        <xsl:value-of select="(//lexeme/prop[@type='lexlabel' and @val=$lexref])/../@id"/>
      </xsl:variable>
      <xsl:variable name="muid">
        <xsl:value-of select="(//muterm/prop[@type='mulabel' and @val=$muref])/../@id"/>
      </xsl:variable>
      <xsl:if test="not($lexid) and not($muid)">
        <!-- <xsl:message> TID: <xsl:value-of select="@id"/> LEXREF: <xsl:value-of select="$lexref"/>
          LEXID: <xsl:value-of select="$lexid"/>
        </xsl:message> -->
        <xsl:message> TID: <xsl:value-of select="@id"/> LEX/MUID: MISSING </xsl:message>
      </xsl:if>

      <xsl:if test="fn:string-length($lexid) > 0">
        <xsl:text>aamas:lexeme aama:</xsl:text>
        <xsl:value-of select="$lexid"/>
        <xsl:text>;
	</xsl:text>
      </xsl:if>

      <xsl:if test="fn:string-length($muid) > 0">
        <xsl:text>aamas:muterm aama:</xsl:text>
        <xsl:value-of select="$muid"/>
        <xsl:text>;
	</xsl:text>
      </xsl:if>

      <!-- common-props -->
      <xsl:apply-templates select="../../common-properties/prop"/>
      <!-- term-props -->
      <xsl:apply-templates/>

      <xsl:text>

</xsl:text>
    </xsl:for-each>
    <!-- <xsl:apply-templates/> -->
  </xsl:template>

  <xsl:template match="pdgm/pdgmId"/>
  <xsl:template match="pdgm/pdgmName"/>
  <xsl:template match="pdgm/note"/>
  <xsl:template match="common-properties"/>

  <!-- ############################################ -->
  <xsl:template match="prop">

    <xsl:variable name="lang">
      <xsl:value-of select="aama:dncase-first((//prop[@type='lang'])[1]/@val)"/>
    </xsl:variable>
    <xsl:variable name="Lang">
      <xsl:value-of select="aama:upcase-first($lang)"/>
    </xsl:variable>

<!--    <xsl:variable name="lvar">
      <xsl:if test="(//prop[@type='langVar'])[1]">
        <xsl:value-of select="aama:dncase-first((//prop[@type='langVar'])[1]/@val)"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="Lvar">
      <xsl:value-of select="aama:upcase-first($lvar)"/>
    </xsl:variable>
-->
    <xsl:variable name="langURI">
      <xsl:value-of select="$aamaURI"/>
      <!-- <xsl:text>lang/</xsl:text> -->
      <xsl:value-of select="aama:dncase-first($lang)"/>
<!--      <xsl:if test="fn:string-length($lvar) > 0">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="aama:dncase-first($lvar)"/>
      </xsl:if>
-->      <xsl:text>/</xsl:text>
    </xsl:variable>
    <xsl:variable name="LangURI">
      <xsl:value-of select="$aamaURI"/>
      <!-- <xsl:text>Lang/</xsl:text> -->
      <xsl:value-of select="aama:upcase-first($lang)"/>
<!--      <xsl:if test="fn:string-length($lvar) > 0">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="aama:upcase-first($lvar)"/>
      </xsl:if>
-->      <xsl:text>/</xsl:text>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="@type = 'pdgmLex'">
        <xsl:value-of select="'aama:lexlabel'"/>
        <xsl:text>		</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'lexlabel'"/>
      <xsl:when test="@type = 'mulabel'"/>
      <xsl:when test="@type = 'lang'">
        <!--          <xsl:value-of select="fn:replace($LangURI, '(.*)/$', '$1>')"/>-->
        <xsl:text>aama:lang </xsl:text>
 <!--       <xsl:value-of select="$Lang"/>-->
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:value-of select="$pref-p"/>
        <xsl:value-of select="@type"/>
        <xsl:text> </xsl:text>
        <!-- <xsl:value-of select="concat($aamaURI, -->
        <!-- 		      'lang/', -->
        <!-- 		      aama:dncase-first($l), -->
        <!-- 		      '/', -->
        <!-- 		      @type, -->
        <!-- 		      '>')"/> -->
      </xsl:otherwise>
    </xsl:choose>

    <xsl:text> </xsl:text>

    <!-- VALS -->
    <xsl:choose>
      <xsl:when test="fn:matches(@type, '[tT]oken.*')">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-gloss'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-lex'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-main'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-aux'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-auxGloss'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'tokenMain'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'tokenAux'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-conjV'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-structure'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-encliticized'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-BeachyRef'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-remark'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-exQ'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-glossExQ'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-exA'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-glossExA'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-dervForm'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-selectorConst'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-selMood'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-selBE'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-selTense'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-persObj'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-dervGloss'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-baseForm'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-baseShape'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-baseGloss'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-coopShape'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-coopGloss'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-passShape'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-passGloss'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-caushape'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-causShape'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-causGloss'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-reflShape'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-reflGloss'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-recipShape'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-recipGloss'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-suppletive'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-environment'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-singularForm'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-pluralForm'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-suffShape'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-suffix'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-pref'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-affix'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-stem'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-suff'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-numGloss'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-template'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-auxFunction'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-verbGloss'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-prefix'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-preverb'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-example'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token1'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token2'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'token-note'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'note'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'structure'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'morphoSynEnv'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'structMain'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'structAux'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'stemFinalC'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'causativeAllomorph'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'auxAdjunct'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'example'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'lexlabel'"/>
      <xsl:when test="@type = 'mulabel'"/>
      <!-- <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when> -->
      <xsl:when test="@type = 'pdgmLex'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'gloss'">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@val"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
<!-- Not already taken care of?      -->
      <xsl:when test="@type = 'lang'">
        <xsl:text>aama:</xsl:text>
        <xsl:value-of select="$Lang"/>
        <!-- <xsl:value-of select="concat($aamaURI, -->
        <!-- 		      '/Lang/', -->
        <!-- 		      @val, -->
        <!-- 		      '>')"/> -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$pref-v"/>
<!--        <xsl:value-of select="aama:upcase-first(@type)"/>
        <xsl:text>_</xsl:text>
-->        <xsl:value-of select="aama:upcase-first(@val)"/>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">
      <xsl:if test="@type != 'lexlabel' and @type != 'mulabel'">
        <xsl:text> ;
	</xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="position() = last()">
      <xsl:choose>
        <xsl:when test="name(..) = 'common-properties'">
          <xsl:text> ;
	</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>
	.
</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
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

</xsl:stylesheet>
