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
    xmlns:aama="http://id.oi.uchicago.edu/aama/schema/2013/"
    xmlns:java="java:java.util.UUID"
    exclude-result-prefixes="xsl fn java"
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

  <xsl:template match="@type[parent::prop]">
    <xsl:variable name="v">
      <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:attribute name="type">
      <xsl:choose>
	<xsl:when test="fn:matches(., 'pers')">
	<xsl:text>person</xsl:text></xsl:when>
	<xsl:when test="fn:matches(., 'pos')">
	<xsl:text>pos</xsl:text></xsl:when>
	<xsl:when test="fn:matches($v, 'pol')">
	<xsl:text>polarity</xsl:text></xsl:when>
	<xsl:when test="$v = 'VClass'"><xsl:text>vClass</xsl:text></xsl:when>
	<xsl:when test="$v = 'cat'"><xsl:text>category</xsl:text></xsl:when>
	<xsl:when test="$v = 'dervCat'"><xsl:text>derivedCategory</xsl:text></xsl:when>
	<xsl:when test="$v = 'dervClass'"><xsl:text>derivedClass</xsl:text></xsl:when>
	<xsl:when test="$v = 'dervStem'"><xsl:text>derivedStem</xsl:text></xsl:when>
	<xsl:when test="$v = 'dervStemAug'"><xsl:text>derivedStemAug</xsl:text></xsl:when>
	<xsl:when test="$v = 'frm'"><xsl:text>form</xsl:text></xsl:when>
	<xsl:when test="$v = 'gen'"><xsl:text>gender</xsl:text></xsl:when>
	<xsl:when test="$v = 'genHead'"><xsl:text>genderHead</xsl:text></xsl:when>
	<xsl:when test="$v = 'genObj'"><xsl:text>genderObj</xsl:text></xsl:when>
	<xsl:when test="$v = 'genPoss'"><xsl:text>genderPoss</xsl:text></xsl:when>
	<xsl:when test="$v = 'genRef'"><xsl:text>genderRef</xsl:text></xsl:when>
	<xsl:when test="$v = 'interrClass'"><xsl:text>interrogClass</xsl:text></xsl:when>
	<xsl:when test="$v = 'num'"><xsl:text>number</xsl:text></xsl:when>
	<xsl:when test="fn:matches($v, 'tnsAspMod')">
	<xsl:text>tam</xsl:text></xsl:when>

<xsl:when test="$v = 'pronounClass'"><xsl:text>proClass</xsl:text></xsl:when>
	<xsl:when test="$v = 'selBE'"><xsl:text>selectorBE</xsl:text></xsl:when>
	<xsl:when test="$v = 'selCat'"><xsl:text>selectorCategory</xsl:text></xsl:when>
	<xsl:when test="$v = 'selClass'"><xsl:text>selectorClass</xsl:text></xsl:when>
	<xsl:when test="$v = 'selMood'"><xsl:text>selectorMood</xsl:text></xsl:when>
	<xsl:when test="$v = 'selTense'"><xsl:text>selectorTense</xsl:text></xsl:when>
	<xsl:when test="$v = 'statClass'"><xsl:text>statusClass</xsl:text></xsl:when>
	<xsl:when test="$v = 'stemFin'"><xsl:text>stemFinal</xsl:text></xsl:when>
	<xsl:when test="$v = 'subjIdent'"><xsl:text>subjectIdent</xsl:text></xsl:when>
	<xsl:when test="$v = 'subjTypeSel'"><xsl:text>subjectTypeSelector</xsl:text></xsl:when>
	<xsl:when test="$v = 'subjVerbAgr'"><xsl:text>subjectVerbAgreement</xsl:text></xsl:when>
	<xsl:when test="$v = 'suffSet'"><xsl:text>suffixSet</xsl:text></xsl:when>
	<xsl:when test="$v = 'suffType'"><xsl:text>suffixType</xsl:text></xsl:when>
	<xsl:when test="$v = 'vSubjSet'"><xsl:text>vSubjectSet</xsl:text></xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="normalize-space(.)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@val[parent::prop]">
    <xsl:variable name="v">
      <xsl:value-of select="."/>
    </xsl:variable>

    <xsl:attribute name="val">
      <!-- <xsl:message> -->
      <!-- 	<xsl:value-of select="../@type"/> -->
      <!-- 	<xsl:text> : </xsl:text> -->
      <!-- 	<xsl:value-of select="."/> -->
      <!-- 	<xsl:text> 		</xsl:text> -->
      <!-- 	<xsl:value-of select="fn:translate(normalize-space(.), '''', '')"/> -->
      <!-- </xsl:message> -->
      <xsl:choose>
	<xsl:when test="fn:matches($v, '''''')">
	  <xsl:text>_NULL</xsl:text>
	</xsl:when>
<xsl:when test="$v = ' alaaba'"><xsl:text>Alaaba</xsl:text></xsl:when>
<xsl:when test="$v = ' arabic'"><xsl:text>Arabic</xsl:text></xsl:when>
<xsl:when test="$v = ' burji'"><xsl:text>Burji</xsl:text></xsl:when>
<xsl:when test="$v = ' burunge'"><xsl:text>Burunge</xsl:text></xsl:when>
<xsl:when test="$v = ' coptic'"><xsl:text>Coptic</xsl:text></xsl:when>
<xsl:when test="$v = ' dahalo'"><xsl:text>Dahalo</xsl:text></xsl:when>
<xsl:when test="$v = ' dizi'"><xsl:text>Dizi</xsl:text></xsl:when>
<xsl:when test="$v = ' egyptian'"><xsl:text>Egyptian</xsl:text></xsl:when>
<xsl:when test="$v = ' gawwada'"><xsl:text>Gawwada</xsl:text></xsl:when>
<xsl:when test="$v = ' gedeo'"><xsl:text>Gedeo</xsl:text></xsl:when>
<xsl:when test="$v = ' geez'"><xsl:text>Geez</xsl:text></xsl:when>
<xsl:when test="$v = ' hadiyya'"><xsl:text>Hadiyya</xsl:text></xsl:when>
<xsl:when test="$v = ' hebrew'"><xsl:text>Hebrew</xsl:text></xsl:when>
<xsl:when test="$v = ' iraqw'"><xsl:text>Iraqw</xsl:text></xsl:when>
<xsl:when test="$v = ' kambaata'"><xsl:text>Kambaata</xsl:text></xsl:when>
<xsl:when test="$v = ' koorete'"><xsl:text>Koorete</xsl:text></xsl:when>
<xsl:when test="$v = ' maale'"><xsl:text>Maale</xsl:text></xsl:when>
<xsl:when test="$v = ' middle'"><xsl:text>Middel</xsl:text></xsl:when>
<xsl:when test="$v = ' sahidic'"><xsl:text>Sahidic</xsl:text></xsl:when>
<xsl:when test="$v = ' shinassha'"><xsl:text>Shinassha</xsl:text></xsl:when>
<xsl:when test="$v = ' sidaama'"><xsl:text>Sidaama</xsl:text></xsl:when>
<xsl:when test="$v = ' syriac'"><xsl:text>Syriac</xsl:text></xsl:when>
<xsl:when test="$v = ' tsamakko'"><xsl:text>Tsmakko</xsl:text></xsl:when>
<xsl:when test="$v = ' wolaytta'"><xsl:text>Wolaytta</xsl:text></xsl:when>
<xsl:when test="$v = ' yaaku'"><xsl:text>Yaaku</xsl:text></xsl:when>
<xsl:when test="$v = ' yemsa'"><xsl:text>Yemsa</xsl:text></xsl:when>
<xsl:when test="$v = ' f'"><xsl:text>Fem</xsl:text></xsl:when>
<xsl:when test="$v = ' m'"><xsl:text>Masc</xsl:text></xsl:when>

<xsl:when test="$v = 'afar'"><xsl:text>Afar</xsl:text></xsl:when>
<xsl:when test="$v = 'alaaba'"><xsl:text>Alaaba</xsl:text></xsl:when>
<xsl:when test="$v = 'arabic'"><xsl:text>Arabic</xsl:text></xsl:when>
<xsl:when test="$v = 'bilin'"><xsl:text>Bilin</xsl:text></xsl:when>
<xsl:when test="$v = 'bishari'"><xsl:text>Bishari</xsl:text></xsl:when>
<xsl:when test="$v = 'boni'"><xsl:text>Boni</xsl:text></xsl:when>
<xsl:when test="$v = 'burji'"><xsl:text>Burji</xsl:text></xsl:when>
<xsl:when test="$v = 'burunge'"><xsl:text>Burunge</xsl:text></xsl:when>
<xsl:when test="$v = 'coptic'"><xsl:text>Coptic</xsl:text></xsl:when>
<xsl:when test="$v = 'dahalo'"><xsl:text>Dahalo</xsl:text></xsl:when>
<xsl:when test="$v = 'dizi'"><xsl:text>Dizi</xsl:text></xsl:when>
<xsl:when test="$v = 'gyptian'"><xsl:text>Egyptian</xsl:text></xsl:when>
<xsl:when test="$v = 'gawwada'"><xsl:text>Gawwada</xsl:text></xsl:when>
<xsl:when test="$v = 'gedeo'"><xsl:text>Gedeo</xsl:text></xsl:when>
<xsl:when test="$v = 'geez'"><xsl:text>Geez</xsl:text></xsl:when>
<xsl:when test="$v = 'hadiyya'"><xsl:text>Hadiyya</xsl:text></xsl:when>
<xsl:when test="$v = 'hebrew'"><xsl:text>Hebrew</xsl:text></xsl:when>
<xsl:when test="$v = 'iraqw'"><xsl:text>Iraqw</xsl:text></xsl:when>
<xsl:when test="$v = 'kambaata'"><xsl:text>Kambaata</xsl:text></xsl:when>
<xsl:when test="$v = 'kemant'"><xsl:text>Kemant</xsl:text></xsl:when>
<xsl:when test="$v = 'khamtanga'"><xsl:text>Khamtanga</xsl:text></xsl:when>
<xsl:when test="$v = 'koorete'"><xsl:text>Koorete</xsl:text></xsl:when>
<xsl:when test="$v = 'maale'"><xsl:text>Maale</xsl:text></xsl:when>
<xsl:when test="$v = 'middle'"><xsl:text>Middel</xsl:text></xsl:when>
<xsl:when test="$v = 'rendille'"><xsl:text>Rendille</xsl:text></xsl:when>
<xsl:when test="$v = 'sahidic'"><xsl:text>Sahidic</xsl:text></xsl:when>
<xsl:when test="$v = 'shinassha'"><xsl:text>Shinassha</xsl:text></xsl:when>
<xsl:when test="$v = 'sidaama'"><xsl:text>Sidaama</xsl:text></xsl:when>
<xsl:when test="$v = 'syriac'"><xsl:text>Syriac</xsl:text></xsl:when>
<xsl:when test="$v = 'tsamakko'"><xsl:text>Tsmakko</xsl:text></xsl:when>
<xsl:when test="$v = 'wolaytta'"><xsl:text>Wolaytta</xsl:text></xsl:when>
<xsl:when test="$v = 'yaaku'"><xsl:text>Yaaku</xsl:text></xsl:when>
<xsl:when test="$v = 'yemsa'"><xsl:text>Yemsa</xsl:text></xsl:when>
<xsl:when test="$v = 'f'"><xsl:text>Fem</xsl:text></xsl:when>
<xsl:when test="$v = 'm'"><xsl:text>Masc</xsl:text></xsl:when>

<xsl:when test="$v = 'Hebr'"><xsl:text>Hebrew</xsl:text></xsl:when>
<xsl:when test="$v = 'ablative'"><xsl:text>Ablative</xsl:text></xsl:when>
<xsl:when test="$v = 'aboveSpeaker'"><xsl:text>AboveSpeaker</xsl:text></xsl:when>
<xsl:when test="$v = 'abs'"><xsl:text>Abs</xsl:text></xsl:when>
<xsl:when test="$v = 'absPoss'"><xsl:text>AbsPoss</xsl:text></xsl:when>
<xsl:when test="$v = 'absolute'"><xsl:text>Absolute</xsl:text></xsl:when>
<xsl:when test="$v = 'absoluteInfinitive'"><xsl:text>AbsoluteInfinitive</xsl:text></xsl:when>
<xsl:when test="$v = 'absolutive'"><xsl:text>Absolutive</xsl:text></xsl:when>
<xsl:when test="$v = 'absolutive ~ nominative'"><xsl:text>AbsolutiveNominative</xsl:text></xsl:when>
<xsl:when test="$v = 'absolutiveEmphatic'"><xsl:text>AbsolutiveEmphatic</xsl:text></xsl:when>
<xsl:when test="$v = 'acc'"><xsl:text>Accusative</xsl:text></xsl:when>
<xsl:when test="$v = 'accusative'"><xsl:text>Accusative</xsl:text></xsl:when>
<xsl:when test="$v = 'action'"><xsl:text>Action</xsl:text></xsl:when>
<xsl:when test="$v = 'active'"><xsl:text>Active</xsl:text></xsl:when>
<xsl:when test="$v = 'ad-Class'"><xsl:text>Ad-Class</xsl:text></xsl:when>
<xsl:when test="$v = 'add-Class'"><xsl:text>Add-Class</xsl:text></xsl:when>
<xsl:when test="$v = 'adjInterr'"><xsl:text>AdjInterr</xsl:text></xsl:when>
<xsl:when test="$v = 'adjSuff-f'"><xsl:text>AdjSuff-f</xsl:text></xsl:when>
<xsl:when test="$v = 'adjSuff-m'"><xsl:text>AdjSuff-m</xsl:text></xsl:when>
<xsl:when test="$v = 'adjectival'"><xsl:text>Adjectival</xsl:text></xsl:when>
<xsl:when test="$v = 'adjective'"><xsl:text>Adjective</xsl:text></xsl:when>
<xsl:when test="$v = 'adnominal'"><xsl:text>Adnominal</xsl:text></xsl:when>
<xsl:when test="$v = 'advAt1'"><xsl:text>AdvAt1</xsl:text></xsl:when>
<xsl:when test="$v = 'advAt2'"><xsl:text>AdvAt2</xsl:text></xsl:when>
<xsl:when test="$v = 'advCause'"><xsl:text>AdvCause</xsl:text></xsl:when>
<xsl:when test="$v = 'advCompl'"><xsl:text>AdvCompl</xsl:text></xsl:when>
<xsl:when test="$v = 'advCond'"><xsl:text>AdvCond</xsl:text></xsl:when>
<xsl:when test="$v = 'advConsec'"><xsl:text>AdvConsec</xsl:text></xsl:when>
<xsl:when test="$v = 'advFutCond'"><xsl:text>AdvFutCond</xsl:text></xsl:when>
<xsl:when test="$v = 'advPurp'"><xsl:text>AdvPurp</xsl:text></xsl:when>
<xsl:when test="$v = 'advUntil'"><xsl:text>AdvUntil</xsl:text></xsl:when>
<xsl:when test="$v = 'advWhen'"><xsl:text>AdvWhen</xsl:text></xsl:when>
<xsl:when test="$v = 'advWhile'"><xsl:text>AdvWhile</xsl:text></xsl:when>
<xsl:when test="$v = 'adverb'"><xsl:text>Adverb</xsl:text></xsl:when>
<xsl:when test="$v = 'aff'"><xsl:text>Aff</xsl:text></xsl:when>
<xsl:when test="$v = 'affirmative'"><xsl:text>Affirmative</xsl:text></xsl:when>
<xsl:when test="$v = 'affix'"><xsl:text>Affix</xsl:text></xsl:when>
<xsl:when test="$v = 'aga'"><xsl:text>Aga</xsl:text></xsl:when>
<xsl:when test="$v = 'agent'"><xsl:text>Agent</xsl:text></xsl:when>
<xsl:when test="$v = 'agentNoun'"><xsl:text>AgentNoun</xsl:text></xsl:when>
<xsl:when test="$v = 'agentlessVerb'"><xsl:text>AgentlessVerb</xsl:text></xsl:when>
<xsl:when test="$v = 'agreement'"><xsl:text>Agreement</xsl:text></xsl:when>
<xsl:when test="$v = 'agreement suspended'"><xsl:text>AgreementSuspended</xsl:text></xsl:when>
<xsl:when test="$v = 'agreementMarker'"><xsl:text>AgreementMarker</xsl:text></xsl:when>
<xsl:when test="$v = 'ahad-Class'"><xsl:text>Ahad-Class</xsl:text></xsl:when>
<xsl:when test="$v = 'akkadian'"><xsl:text>Akkadian</xsl:text></xsl:when>
<xsl:when test="$v = 'alaaba'"><xsl:text>Alaaba</xsl:text></xsl:when>
<xsl:when test="$v = 'alk'"><xsl:text>Alk</xsl:text></xsl:when>
<xsl:when test="$v = 'allative'"><xsl:text>Allative</xsl:text></xsl:when>
<xsl:when test="$v = 'alternate'"><xsl:text>Alternate</xsl:text></xsl:when>
<xsl:when test="$v = 'anteriorPerfect'"><xsl:text>AnteriorPerfect</xsl:text></xsl:when>
<xsl:when test="$v = 'anticipatory'"><xsl:text>Anticipatory</xsl:text></xsl:when>
<xsl:when test="$v = 'aor'"><xsl:text>Aorist</xsl:text></xsl:when>
<xsl:when test="$v = 'aorClass'"><xsl:text>AoristClass</xsl:text></xsl:when>
<xsl:when test="$v = 'aorist'"><xsl:text>Aorist</xsl:text></xsl:when>
<xsl:when test="$v = 'aoristHabitual'"><xsl:text>AoristHabitual</xsl:text></xsl:when>
<xsl:when test="$v = 'aoristIngressive'"><xsl:text>AoristIngressive</xsl:text></xsl:when>
<xsl:when test="$v = 'aoristProgressive'"><xsl:text>AoristProgressive</xsl:text></xsl:when>
<xsl:when test="$v = 'aoristPunctual'"><xsl:text>AoristPunctual</xsl:text></xsl:when>
<xsl:when test="$v = 'apodosis'"><xsl:text>Apodosis</xsl:text></xsl:when>
<xsl:when test="$v = 'applicative'"><xsl:text>Applicative</xsl:text></xsl:when>
<xsl:when test="$v = 'arabic'"><xsl:text>Arabic</xsl:text></xsl:when>
<xsl:when test="$v = 'arbore'"><xsl:text>Arbore</xsl:text></xsl:when>
<xsl:when test="$v = 'artDef'"><xsl:text>ArtDef</xsl:text></xsl:when>
<xsl:when test="$v = 'arteiga'"><xsl:text>Arteiga</xsl:text></xsl:when>
<xsl:when test="$v = 'aspect'"><xsl:text>Aspect</xsl:text></xsl:when>
<xsl:when test="$v = 'aspectMood'"><xsl:text>AspectMood</xsl:text></xsl:when>
<xsl:when test="$v = 'aspectSuff'"><xsl:text>AspectSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'ass'"><xsl:text>Ass</xsl:text></xsl:when>
<xsl:when test="$v = 'atmaan'"><xsl:text>Atmaan</xsl:text></xsl:when>
<xsl:when test="$v = 'attributes'"><xsl:text>Attributes</xsl:text></xsl:when>
<xsl:when test="$v = 'autobenefactivization'"><xsl:text>Autobenefactivization</xsl:text></xsl:when>
<xsl:when test="$v = 'aux'"><xsl:text>Aux</xsl:text></xsl:when>
<xsl:when test="$v = 'auxFay'"><xsl:text>AuxFay</xsl:text></xsl:when>
<xsl:when test="$v = 'auxHay'"><xsl:text>AuxHay</xsl:text></xsl:when>
<xsl:when test="$v = 'auxKay'"><xsl:text>AuxKay</xsl:text></xsl:when>
<xsl:when test="$v = 'auxNegSuff'"><xsl:text>AuxNegSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'auxOverview'"><xsl:text>AuxOverview</xsl:text></xsl:when>
<xsl:when test="$v = 'auxPut'"><xsl:text>AuxPut</xsl:text></xsl:when>
<xsl:when test="$v = 'auxTake'"><xsl:text>AuxTake</xsl:text></xsl:when>
<xsl:when test="$v = 'auxiliary'"><xsl:text>Auxiliary</xsl:text></xsl:when>
<xsl:when test="$v = 'awngi'"><xsl:text>Awngi</xsl:text></xsl:when>
<xsl:when test="$v = 'background'"><xsl:text>Background</xsl:text></xsl:when>
<xsl:when test="$v = 'base'"><xsl:text>Base</xsl:text></xsl:when>
<xsl:when test="$v = 'baseForm'"><xsl:text>BaseForm</xsl:text></xsl:when>
<xsl:when test="$v = 'baseIntns'"><xsl:text>BaseIntns</xsl:text></xsl:when>
<xsl:when test="$v = 'basicPro'"><xsl:text>BasicPro</xsl:text></xsl:when>
<xsl:when test="$v = 'bayso'"><xsl:text>Bayso</xsl:text></xsl:when>
<xsl:when test="$v = 'beja'"><xsl:text>Beja</xsl:text></xsl:when>
<xsl:when test="$v = 'beniamer'"><xsl:text>Beniamer</xsl:text></xsl:when>
<xsl:when test="$v = 'benefSubj_obj'"><xsl:text>BenefSubj_obj</xsl:text></xsl:when>
<xsl:when test="$v = 'benefactive'"><xsl:text>Benefactive</xsl:text></xsl:when>
<xsl:when test="$v = 'benefactiveCausative'"><xsl:text>BenefactiveCausative</xsl:text></xsl:when>
<xsl:when test="$v = 'benefactivePassive'"><xsl:text>BenefactivePassive</xsl:text></xsl:when>
<xsl:when test="$v = 'benefactiveSubj'"><xsl:text>BenefactiveSubj</xsl:text></xsl:when>
<xsl:when test="$v = 'bound'"><xsl:text>Bound</xsl:text></xsl:when>
<xsl:when test="$v = 'boundSubject'"><xsl:text>BoundSubject</xsl:text></xsl:when>
<xsl:when test="$v = 'burji'"><xsl:text>Burji</xsl:text></xsl:when>
<xsl:when test="$v = 'burunge'"><xsl:text>Burunge</xsl:text></xsl:when>
<xsl:when test="$v = 'cardinal'"><xsl:text>Cardinal</xsl:text></xsl:when>
<xsl:when test="$v = 'cardinalNumeral'"><xsl:text>CardinalNumeral</xsl:text></xsl:when>
<xsl:when test="$v = 'case'"><xsl:text>Case</xsl:text></xsl:when>
<xsl:when test="$v = 'case-FN40'"><xsl:text>Case-FN40</xsl:text></xsl:when>
<xsl:when test="$v = 'case-i'"><xsl:text>Case-i</xsl:text></xsl:when>
<xsl:when test="$v = 'case-ii'"><xsl:text>Case-ii</xsl:text></xsl:when>
<xsl:when test="$v = 'case-iii'"><xsl:text>Case-iii</xsl:text></xsl:when>
<xsl:when test="$v = 'case-iv'"><xsl:text>Case-iv</xsl:text></xsl:when>
<xsl:when test="$v = 'case-v'"><xsl:text>Case-v</xsl:text></xsl:when>
<xsl:when test="$v = 'case-vi'"><xsl:text>Case-vi</xsl:text></xsl:when>
<xsl:when test="$v = 'case-vii'"><xsl:text>Case-vii</xsl:text></xsl:when>
<xsl:when test="$v = 'caseMarking'"><xsl:text>CaseMarking</xsl:text></xsl:when>
<xsl:when test="$v = 'caseSel'"><xsl:text>CaseSel</xsl:text></xsl:when>
<xsl:when test="$v = 'caus+middle'"><xsl:text>Causal+middle</xsl:text></xsl:when>
<xsl:when test="$v = 'caus+passive'"><xsl:text>Causal+passive</xsl:text></xsl:when>
<xsl:when test="$v = 'caus+reciprocal'"><xsl:text>Causal+reciprocal</xsl:text></xsl:when>
<xsl:when test="$v = 'causIntrans'"><xsl:text>CausalIntransitive</xsl:text></xsl:when>
<xsl:when test="$v = 'causal'"><xsl:text>Causal</xsl:text></xsl:when>
<xsl:when test="$v = 'causative'"><xsl:text>Causative</xsl:text></xsl:when>
<xsl:when test="$v = 'causative1'"><xsl:text>Causative1</xsl:text></xsl:when>
<xsl:when test="$v = 'causative1Causative2'"><xsl:text>Causative1Causative2</xsl:text></xsl:when>
<xsl:when test="$v = 'causative2'"><xsl:text>Causative2</xsl:text></xsl:when>
<xsl:when test="$v = 'causative3'"><xsl:text>Causative3</xsl:text></xsl:when>
<xsl:when test="$v = 'causativeAllomorph'"><xsl:text>CausativeAllomorph</xsl:text></xsl:when>
<xsl:when test="$v = 'causativeBenefPass'"><xsl:text>CausativeBenefactivePassive</xsl:text></xsl:when>
<xsl:when test="$v = 'causativeBenefactive'"><xsl:text>CausativeBenefactive</xsl:text></xsl:when>
<xsl:when test="$v = 'causativeCausative'"><xsl:text>CausativeCausative</xsl:text></xsl:when>
<xsl:when test="$v = 'causatived'"><xsl:text>Causatived</xsl:text></xsl:when>
<xsl:when test="$v = 'causativeDenominal'"><xsl:text>CausativeDenominal</xsl:text></xsl:when>
<xsl:when test="$v = 'causativeDouble1'"><xsl:text>CausativeDouble1</xsl:text></xsl:when>
<xsl:when test="$v = 'causativeDouble2'"><xsl:text>CausativeDouble2</xsl:text></xsl:when>
<xsl:when test="$v = 'causativePassive'"><xsl:text>CausativePassive</xsl:text></xsl:when>
<xsl:when test="$v = 'causativeReciprocal'"><xsl:text>CausativeReciprocal</xsl:text></xsl:when>
<xsl:when test="$v = 'causativeSimple2'"><xsl:text>CausativeSimple2</xsl:text></xsl:when>
<xsl:when test="$v = 'causativeSimplel1'"><xsl:text>CausativeSimplel1</xsl:text></xsl:when>
<xsl:when test="$v = 'causativeSimplel2'"><xsl:text>CausativeSimplel2</xsl:text></xsl:when>
<xsl:when test="$v = 'causative_causative-1'"><xsl:text>Causative_Causative-1</xsl:text></xsl:when>
<xsl:when test="$v = 'causative_causative-2'"><xsl:text>Causative_Causative-2</xsl:text></xsl:when>
<xsl:when test="$v = 'causative_iterative'"><xsl:text>Causative_Iterative</xsl:text></xsl:when>
<xsl:when test="$v = 'causative_iterative_causative'"><xsl:text>Causative_Iterative_Causative</xsl:text></xsl:when>
<xsl:when test="$v = 'causative_passive'"><xsl:text>Causative_Passive</xsl:text></xsl:when>
<xsl:when test="$v = 'circumstantial'"><xsl:text>Circumstantial</xsl:text></xsl:when>
<xsl:when test="$v = 'class1'"><xsl:text>Class1</xsl:text></xsl:when>
<xsl:when test="$v = 'class1a'"><xsl:text>Class1a</xsl:text></xsl:when>
<xsl:when test="$v = 'class1b'"><xsl:text>Class1b</xsl:text></xsl:when>
<xsl:when test="$v = 'class2'"><xsl:text>Class2</xsl:text></xsl:when>
<xsl:when test="$v = 'clauseTypeSel'"><xsl:text>ClauseTypeSel</xsl:text></xsl:when>
<xsl:when test="$v = 'clauseType_subj'"><xsl:text>ClauseType_Subj</xsl:text></xsl:when>
<xsl:when test="$v = 'clauses'"><xsl:text>Clauses</xsl:text></xsl:when>
<xsl:when test="$v = 'clitic'"><xsl:text>Clitic</xsl:text></xsl:when>
<xsl:when test="$v = 'co-Subject'"><xsl:text>Co-Subject</xsl:text></xsl:when>
<xsl:when test="$v = 'coTemporal'"><xsl:text>CoTemporal</xsl:text></xsl:when>
<xsl:when test="$v = 'collaborative'"><xsl:text>Collaborative</xsl:text></xsl:when>
<xsl:when test="$v = 'comb-Extension'"><xsl:text>Comb-Extension</xsl:text></xsl:when>
<xsl:when test="$v = 'combination'"><xsl:text>Combination</xsl:text></xsl:when>
<xsl:when test="$v = 'combo'"><xsl:text>Combo</xsl:text></xsl:when>
<xsl:when test="$v = 'comitative'"><xsl:text>Comitative</xsl:text></xsl:when>
<xsl:when test="$v = 'command'"><xsl:text>Command</xsl:text></xsl:when>
<xsl:when test="$v = 'commandForms'"><xsl:text>CommandForms</xsl:text></xsl:when>
<xsl:when test="$v = 'commitInstrumental'"><xsl:text>CommitInstrumental</xsl:text></xsl:when>
<xsl:when test="$v = 'compPastGer'"><xsl:text>CompPastGer</xsl:text></xsl:when>
<xsl:when test="$v = 'compSem'"><xsl:text>CompSem</xsl:text></xsl:when>
<xsl:when test="$v = 'compSubordinate'"><xsl:text>CompSubordinate</xsl:text></xsl:when>
<xsl:when test="$v = 'comparative'"><xsl:text>Comparative</xsl:text></xsl:when>
<xsl:when test="$v = 'completative'"><xsl:text>Completative</xsl:text></xsl:when>
<xsl:when test="$v = 'completive'"><xsl:text>Completive</xsl:text></xsl:when>
<xsl:when test="$v = 'componentAnalysis'"><xsl:text>ComponentAnalysis</xsl:text></xsl:when>
<xsl:when test="$v = 'compound'"><xsl:text>Compound</xsl:text></xsl:when>
<xsl:when test="$v = 'compoundIntransitive'"><xsl:text>CompoundIntransitive</xsl:text></xsl:when>
<xsl:when test="$v = 'compoundStative'"><xsl:text>CompoundStative</xsl:text></xsl:when>
<xsl:when test="$v = 'compoundTransitive'"><xsl:text>CompoundTransitive</xsl:text></xsl:when>
<xsl:when test="$v = 'compoundVerbs'"><xsl:text>CompoundVerbs</xsl:text></xsl:when>
<xsl:when test="$v = 'concessive'"><xsl:text>Concessive</xsl:text></xsl:when>
<xsl:when test="$v = 'cond1'"><xsl:text>Cond1</xsl:text></xsl:when>
<xsl:when test="$v = 'cond2'"><xsl:text>cond2</xsl:text></xsl:when>
<xsl:when test="$v = 'conditional'"><xsl:text>Conditional</xsl:text></xsl:when>
<xsl:when test="$v = 'conditional1'"><xsl:text>Conditional1</xsl:text></xsl:when>
<xsl:when test="$v = 'conditional2'"><xsl:text>Conditional2</xsl:text></xsl:when>
<xsl:when test="$v = 'conditional3'"><xsl:text>Conditional3</xsl:text></xsl:when>
<xsl:when test="$v = 'conditionalPerfect'"><xsl:text>ConditionalPerfect</xsl:text></xsl:when>
<xsl:when test="$v = 'conditionalPredicative'"><xsl:text>ConditionalPredicative</xsl:text></xsl:when>
<xsl:when test="$v = 'conditionalPresent'"><xsl:text>ConditionalPresent</xsl:text></xsl:when>
<xsl:when test="$v = 'conj'"><xsl:text>Conj</xsl:text></xsl:when>
<xsl:when test="$v = 'conj1'"><xsl:text>Conj1</xsl:text></xsl:when>
<xsl:when test="$v = 'conj2'"><xsl:text>Conj2</xsl:text></xsl:when>
<xsl:when test="$v = 'conj2a'"><xsl:text>Conj2a</xsl:text></xsl:when>
<xsl:when test="$v = 'conj2b'"><xsl:text>Conj2b</xsl:text></xsl:when>
<xsl:when test="$v = 'conj3'"><xsl:text>Conj3</xsl:text></xsl:when>
<xsl:when test="$v = 'conj3a'"><xsl:text>Conj3a</xsl:text></xsl:when>
<xsl:when test="$v = 'conj3b'"><xsl:text>Conj3b</xsl:text></xsl:when>
<xsl:when test="$v = 'conj3c'"><xsl:text>Conj3c</xsl:text></xsl:when>
<xsl:when test="$v = 'conj3d'"><xsl:text>Conj3d</xsl:text></xsl:when>
<xsl:when test="$v = 'conj3e'"><xsl:text>Conj3e</xsl:text></xsl:when>
<xsl:when test="$v = 'conj4'"><xsl:text>Conj4</xsl:text></xsl:when>
<xsl:when test="$v = 'conj5'"><xsl:text>Conj5</xsl:text></xsl:when>
<xsl:when test="$v = 'conjA'"><xsl:text>ConjA</xsl:text></xsl:when>
<xsl:when test="$v = 'conjA-conjBComparison'"><xsl:text>ConjA-ConjBComparison</xsl:text></xsl:when>
<xsl:when test="$v = 'conjB'"><xsl:text>ConjB</xsl:text></xsl:when>
<xsl:when test="$v = 'conjClass'"><xsl:text>ConjClass</xsl:text></xsl:when>
<xsl:when test="$v = 'conjPattern'"><xsl:text>ConjPattern</xsl:text></xsl:when>
<xsl:when test="$v = 'conjugation1'"><xsl:text>Conjugation1</xsl:text></xsl:when>
<xsl:when test="$v = 'conjugation2'"><xsl:text>Conjugation2</xsl:text></xsl:when>
<xsl:when test="$v = 'conjugation3'"><xsl:text>Conjugation3</xsl:text></xsl:when>
<xsl:when test="$v = 'conjugation4'"><xsl:text>Conjugation4</xsl:text></xsl:when>
<xsl:when test="$v = 'conjugation5a'"><xsl:text>Conjugation5a</xsl:text></xsl:when>
<xsl:when test="$v = 'conjugation5b'"><xsl:text>Conjugation5b</xsl:text></xsl:when>
<xsl:when test="$v = 'conjunctive'"><xsl:text>Conjunctive</xsl:text></xsl:when>
<xsl:when test="$v = 'connective'"><xsl:text>Connective</xsl:text></xsl:when>
<xsl:when test="$v = 'consecutive'"><xsl:text>Consecutive</xsl:text></xsl:when>
<xsl:when test="$v = 'consecutive2'"><xsl:text>Consecutive2</xsl:text></xsl:when>
<xsl:when test="$v = 'consecutive_subj_obj_pres'"><xsl:text>consecutive_subj_obj_pres</xsl:text></xsl:when>
<xsl:when test="$v = 'consecutive_subj_tense'"><xsl:text>consecutive_subj_tense</xsl:text></xsl:when>
<xsl:when test="$v = 'consonant'"><xsl:text>Consonant</xsl:text></xsl:when>
<xsl:when test="$v = 'constr'"><xsl:text>Constr</xsl:text></xsl:when>
<xsl:when test="$v = 'construct'"><xsl:text>Construct</xsl:text></xsl:when>
<xsl:when test="$v = 'continuative'"><xsl:text>Continuative</xsl:text></xsl:when>
<xsl:when test="$v = 'continuous'"><xsl:text>Continuous</xsl:text></xsl:when>
<xsl:when test="$v = 'contracting'"><xsl:text>Contracting</xsl:text></xsl:when>
<xsl:when test="$v = 'contrafactual'"><xsl:text>Contrafactual</xsl:text></xsl:when>
<xsl:when test="$v = 'contrafactualStative'"><xsl:text>ContrafactualStative</xsl:text></xsl:when>
<xsl:when test="$v = 'contrastSel'"><xsl:text>ContrastSel</xsl:text></xsl:when>
<xsl:when test="$v = 'converb'"><xsl:text>Converb</xsl:text></xsl:when>
<xsl:when test="$v = 'converb1'"><xsl:text>Converb1</xsl:text></xsl:when>
<xsl:when test="$v = 'converb2'"><xsl:text>Converb2</xsl:text></xsl:when>
<xsl:when test="$v = 'converb3'"><xsl:text>Converb3</xsl:text></xsl:when>
<xsl:when test="$v = 'converbCoRef'"><xsl:text>ConverbCoRef</xsl:text></xsl:when>
<xsl:when test="$v = 'converbDifRef'"><xsl:text>ConverbDifRef</xsl:text></xsl:when>
<xsl:when test="$v = 'cooperative'"><xsl:text>Cooperative</xsl:text></xsl:when>
<xsl:when test="$v = 'coordinate'"><xsl:text>Coordinate</xsl:text></xsl:when>
<xsl:when test="$v = 'copA'"><xsl:text>CopA</xsl:text></xsl:when>
<xsl:when test="$v = 'copAn'"><xsl:text>CopAn</xsl:text></xsl:when>
<xsl:when test="$v = 'copB'"><xsl:text>CopB</xsl:text></xsl:when>
<xsl:when test="$v = 'copLoc'"><xsl:text>CopLoc</xsl:text></xsl:when>
<xsl:when test="$v = 'copMain'"><xsl:text>CopMain</xsl:text></xsl:when>
<xsl:when test="$v = 'copPossession'"><xsl:text>CopPossession</xsl:text></xsl:when>
<xsl:when test="$v = 'coptic'"><xsl:text>Coptic</xsl:text></xsl:when>
<xsl:when test="$v = 'copula'"><xsl:text>Copula</xsl:text></xsl:when>
<xsl:when test="$v = 'copulaExist'"><xsl:text>CopulaExist</xsl:text></xsl:when>
<xsl:when test="$v = 'counterfactual'"><xsl:text>Counterfactual</xsl:text></xsl:when>
<xsl:when test="$v = 'counterfactual (main clause)'"><xsl:text>Counterfactual_main_clause</xsl:text></xsl:when>
<xsl:when test="$v = 'cultivate'"><xsl:text>Cultivate</xsl:text></xsl:when>
<xsl:when test="$v = 'd-subordinate'"><xsl:text>D-subordinate</xsl:text></xsl:when>
<xsl:when test="$v = 'dExtClass'"><xsl:text>DExtClass</xsl:text></xsl:when>
<xsl:when test="$v = 'dahalo'"><xsl:text>Dahalo</xsl:text></xsl:when>
<xsl:when test="$v = 'datInd'"><xsl:text>DatInd</xsl:text></xsl:when>
<xsl:when test="$v = 'dative'"><xsl:text>Dative</xsl:text></xsl:when>
<xsl:when test="$v = 'dbl'"><xsl:text>Dbl</xsl:text></xsl:when>
<xsl:when test="$v = 'deAdjectival'"><xsl:text>DeAdjectival</xsl:text></xsl:when>
<xsl:when test="$v = 'decl'"><xsl:text>Decl</xsl:text></xsl:when>
<xsl:when test="$v = 'declarative'"><xsl:text>Declarative</xsl:text></xsl:when>
<xsl:when test="$v = 'defClass1'"><xsl:text>DefClass1</xsl:text></xsl:when>
<xsl:when test="$v = 'defClass2'"><xsl:text>DefClass2</xsl:text></xsl:when>
<xsl:when test="$v = 'defClass3'"><xsl:text>DefClass3</xsl:text></xsl:when>
<xsl:when test="$v = 'defMarker'"><xsl:text>DefMarker</xsl:text></xsl:when>
<xsl:when test="$v = 'default'"><xsl:text>Default</xsl:text></xsl:when>
<xsl:when test="$v = 'defective'"><xsl:text>Defective</xsl:text></xsl:when>
<xsl:when test="$v = 'definite'"><xsl:text>Definite</xsl:text></xsl:when>
<xsl:when test="$v = 'definite future'"><xsl:text>DefiniteFuture</xsl:text></xsl:when>
<xsl:when test="$v = 'deictic'"><xsl:text>Deictic</xsl:text></xsl:when>
<xsl:when test="$v = 'deicticAnaph'"><xsl:text>DeicticAnaph</xsl:text></xsl:when>
<xsl:when test="$v = 'deleted'"><xsl:text>Deleted</xsl:text></xsl:when>
<xsl:when test="$v = 'demAdnom'"><xsl:text>DemAdnom</xsl:text></xsl:when>
<xsl:when test="$v = 'demAdv'"><xsl:text>DemAdv</xsl:text></xsl:when>
<xsl:when test="$v = 'demAreaAdnom'"><xsl:text>DemAreaAdnom</xsl:text></xsl:when>
<xsl:when test="$v = 'demFar'"><xsl:text>DemFar</xsl:text></xsl:when>
<xsl:when test="$v = 'demNear'"><xsl:text>DemNear</xsl:text></xsl:when>
<xsl:when test="$v = 'demPro'"><xsl:text>DemPro</xsl:text></xsl:when>
<xsl:when test="$v = 'demRef'"><xsl:text>DemRef</xsl:text></xsl:when>
<xsl:when test="$v = 'demSpec'"><xsl:text>DemSpec</xsl:text></xsl:when>
<xsl:when test="$v = 'demSpecAdv'"><xsl:text>DemSpecAdv</xsl:text></xsl:when>
<xsl:when test="$v = 'demonstrative'"><xsl:text>Demonstrative</xsl:text></xsl:when>
<xsl:when test="$v = 'demonstrativeNear'"><xsl:text>DemonstrativeNear</xsl:text></xsl:when>
<xsl:when test="$v = 'demonstrativeRemote'"><xsl:text>DemonstrativeRemote</xsl:text></xsl:when>
<xsl:when test="$v = 'demostrative'"><xsl:text>Demostrative</xsl:text></xsl:when>
<xsl:when test="$v = 'denominal'"><xsl:text>Denominal</xsl:text></xsl:when>
<xsl:when test="$v = 'denominalDeadjectival'"><xsl:text>DenominalDeadjectival</xsl:text></xsl:when>
<xsl:when test="$v = 'denominativeFromNClass1'"><xsl:text>DenominativeFromNClass1</xsl:text></xsl:when>
<xsl:when test="$v = 'denominativeFromNClass2'"><xsl:text>DenominativeFromNClass2</xsl:text></xsl:when>
<xsl:when test="$v = 'denominativeFromNClass3'"><xsl:text>DenominativeFromNClass3</xsl:text></xsl:when>
<xsl:when test="$v = 'dentalStem'"><xsl:text>DentalStem</xsl:text></xsl:when>
<xsl:when test="$v = 'dependent'"><xsl:text>Dependent</xsl:text></xsl:when>
<xsl:when test="$v = 'dependentConditional'"><xsl:text>DependentConditional</xsl:text></xsl:when>
<xsl:when test="$v = 'dependentPurposive'"><xsl:text>DependentPurposive</xsl:text></xsl:when>
<xsl:when test="$v = 'dervPatterns'"><xsl:text>DervPatterns</xsl:text></xsl:when>
<xsl:when test="$v = 'dervStem'"><xsl:text>DervStem</xsl:text></xsl:when>
<xsl:when test="$v = 'dervStemForm'"><xsl:text>DervStemForm</xsl:text></xsl:when>
<xsl:when test="$v = 'dervStemFormation'"><xsl:text>DervStemFormation</xsl:text></xsl:when>
<xsl:when test="$v = 'dervStemMarker'"><xsl:text>DervStemMarker</xsl:text></xsl:when>
<xsl:when test="$v = 'dervStemSuff'"><xsl:text>DervStemSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'dervSuff'"><xsl:text>DervSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'des1'"><xsl:text>Des1</xsl:text></xsl:when>
<xsl:when test="$v = 'des2'"><xsl:text>Des2</xsl:text></xsl:when>
<xsl:when test="$v = 'desiderative'"><xsl:text>Desiderative</xsl:text></xsl:when>
<xsl:when test="$v = 'detransitivize'"><xsl:text>Detransitivize</xsl:text></xsl:when>
<xsl:when test="$v = 'dgy'"><xsl:text>Dgy</xsl:text></xsl:when>
<xsl:when test="$v = 'dhaasanac'"><xsl:text>Dhaasanac</xsl:text></xsl:when>
<xsl:when test="$v = 'diff'"><xsl:text>Diff</xsl:text></xsl:when>
<xsl:when test="$v = 'diffSubj'"><xsl:text>DiffSubj</xsl:text></xsl:when>
<xsl:when test="$v = 'diffSubjSuff'"><xsl:text>DiffSubjSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'dirAT'"><xsl:text>DirAT</xsl:text></xsl:when>
<xsl:when test="$v = 'dirFROM'"><xsl:text>DirFROM</xsl:text></xsl:when>
<xsl:when test="$v = 'dirTO'"><xsl:text>DirTO</xsl:text></xsl:when>
<xsl:when test="$v = 'directive'"><xsl:text>Directive</xsl:text></xsl:when>
<xsl:when test="$v = 'distal'"><xsl:text>Distal</xsl:text></xsl:when>
<xsl:when test="$v = 'distal2'"><xsl:text>Distal2</xsl:text></xsl:when>
<xsl:when test="$v = 'distributive'"><xsl:text>Distributive</xsl:text></xsl:when>
<xsl:when test="$v = 'dizi'"><xsl:text>Dizi</xsl:text></xsl:when>
<xsl:when test="$v = 'du'"><xsl:text>Du</xsl:text></xsl:when>
<xsl:when test="$v = 'dubitative'"><xsl:text>Dubitative</xsl:text></xsl:when>
<xsl:when test="$v = 'dubitative permission'"><xsl:text>DubitativePermission</xsl:text></xsl:when>
<xsl:when test="$v = 'dubitativePast'"><xsl:text>DubitativePast</xsl:text></xsl:when>
<xsl:when test="$v = 'durative'"><xsl:text>Durative</xsl:text></xsl:when>
<xsl:when test="$v = 'eCC'"><xsl:text>ECC</xsl:text></xsl:when>
<xsl:when test="$v = 'eClass'"><xsl:text>EClass</xsl:text></xsl:when>
<xsl:when test="$v = 'eForm--invar'"><xsl:text>EForm--invar</xsl:text></xsl:when>
<xsl:when test="$v = 'ee-stem'"><xsl:text>Ee-stem</xsl:text></xsl:when>
<xsl:when test="$v = 'egyptian'"><xsl:text>Egyptian</xsl:text></xsl:when>
<xsl:when test="$v = 'elmolo'"><xsl:text>Elmolo</xsl:text></xsl:when>
<xsl:when test="$v = 'emphatic'"><xsl:text>Emphatic</xsl:text></xsl:when>
<xsl:when test="$v = 'emphatic (all low tone vowel goes_to high in stem)'"><xsl:text>Emphatic</xsl:text></xsl:when>
<xsl:when test="$v = 'emphatic-m'"><xsl:text>Emphatic-m</xsl:text></xsl:when>
<xsl:when test="$v = 'eq'"><xsl:text>Eq</xsl:text></xsl:when>
<xsl:when test="$v = 'equative'"><xsl:text>Equative</xsl:text></xsl:when>
<xsl:when test="$v = 'er-us'"><xsl:text>Er-us</xsl:text></xsl:when>
<xsl:when test="$v = 'exclusive'"><xsl:text>Exclusive</xsl:text></xsl:when>
<xsl:when test="$v = 'exemplary'"><xsl:text>Exemplary</xsl:text></xsl:when>
<xsl:when test="$v = 'existence'"><xsl:text>Existence</xsl:text></xsl:when>
<xsl:when test="$v = 'exit'"><xsl:text>Exit</xsl:text></xsl:when>
<xsl:when test="$v = 'exobligative'"><xsl:text>Exobligative</xsl:text></xsl:when>
<xsl:when test="$v = 'expectational'"><xsl:text>Expectational</xsl:text></xsl:when>
<xsl:when test="$v = 'exx'"><xsl:text>Exx</xsl:text></xsl:when>
<xsl:when test="$v = 'f'"><xsl:text>Fem</xsl:text></xsl:when>
<xsl:when test="$v = 'factitive1'"><xsl:text>Factitive1</xsl:text></xsl:when>
<xsl:when test="$v = 'factitive2'"><xsl:text>Factitive2</xsl:text></xsl:when>
<xsl:when test="$v = 'far'"><xsl:text>Far</xsl:text></xsl:when>
<xsl:when test="$v = 'farDist'"><xsl:text>FarDist</xsl:text></xsl:when>
<xsl:when test="$v = 'farMid'"><xsl:text>FarMid</xsl:text></xsl:when>
<xsl:when test="$v = 'final-i-e'"><xsl:text>Final-i-e</xsl:text></xsl:when>
<xsl:when test="$v = 'finite'"><xsl:text>Finite</xsl:text></xsl:when>
<xsl:when test="$v = 'finiteVerb'"><xsl:text>FiniteVerb</xsl:text></xsl:when>
<xsl:when test="$v = 'foc'"><xsl:text>Foc</xsl:text></xsl:when>
<xsl:when test="$v = 'focus'"><xsl:text>Focus</xsl:text></xsl:when>
<xsl:when test="$v = 'focusStructure'"><xsl:text>FocusStructure</xsl:text></xsl:when>
<xsl:when test="$v = 'foot'"><xsl:text>Foot</xsl:text></xsl:when>
<xsl:when test="$v = 'form1'"><xsl:text>Form1</xsl:text></xsl:when>
<xsl:when test="$v = 'form2'"><xsl:text>Form2</xsl:text></xsl:when>
<xsl:when test="$v = 'form3'"><xsl:text>Form3</xsl:text></xsl:when>
<xsl:when test="$v = 'formSet1'"><xsl:text>FormSet1</xsl:text></xsl:when>
<xsl:when test="$v = 'formSet2'"><xsl:text>FormSet2</xsl:text></xsl:when>
<xsl:when test="$v = 'formSet3'"><xsl:text>FormSet3</xsl:text></xsl:when>
<xsl:when test="$v = 'formSet4'"><xsl:text>FormSet4</xsl:text></xsl:when>
<xsl:when test="$v = 'formSet5'"><xsl:text>FormSet5</xsl:text></xsl:when>
<xsl:when test="$v = 'formation'"><xsl:text>Formation</xsl:text></xsl:when>
<xsl:when test="$v = 'fossilized?'"><xsl:text>Fossilized?</xsl:text></xsl:when>
<xsl:when test="$v = 'free'"><xsl:text>Free</xsl:text></xsl:when>
<xsl:when test="$v = 'frequent'"><xsl:text>Frequent</xsl:text></xsl:when>
<xsl:when test="$v = 'frequentative'"><xsl:text>Frequentative</xsl:text></xsl:when>
<xsl:when test="$v = 'full'"><xsl:text>Full</xsl:text></xsl:when>
<xsl:when test="$v = 'fullReducedVariant'"><xsl:text>FullReducedVariant</xsl:text></xsl:when>
<xsl:when test="$v = 'futIngr'"><xsl:text>FutIngr</xsl:text></xsl:when>
<xsl:when test="$v = 'futPerf'"><xsl:text>FutPerf</xsl:text></xsl:when>
<xsl:when test="$v = 'futProgr'"><xsl:text>FutProgr</xsl:text></xsl:when>
<xsl:when test="$v = 'futPunct'"><xsl:text>FutPunct</xsl:text></xsl:when>
<xsl:when test="$v = 'futPunctSub'"><xsl:text>FutPunctSub</xsl:text></xsl:when>
<xsl:when test="$v = 'future'"><xsl:text>Future</xsl:text></xsl:when>
<xsl:when test="$v = 'future1'"><xsl:text>Future1</xsl:text></xsl:when>
<xsl:when test="$v = 'future2'"><xsl:text>Future2</xsl:text></xsl:when>
<xsl:when test="$v = 'future2Var'"><xsl:text>Future2Var</xsl:text></xsl:when>
<xsl:when test="$v = 'future3'"><xsl:text>Future3</xsl:text></xsl:when>
<xsl:when test="$v = 'futureDefinite'"><xsl:text>FutureDefinite</xsl:text></xsl:when>
<xsl:when test="$v = 'futureIndefinite'"><xsl:text>FutureIndefinite</xsl:text></xsl:when>
<xsl:when test="$v = 'futureIntensive'"><xsl:text>FutureIntensive</xsl:text></xsl:when>
<xsl:when test="$v = 'futurePerfect'"><xsl:text>FuturePerfect</xsl:text></xsl:when>
<xsl:when test="$v = 'futureProgressive'"><xsl:text>FutureProgressive</xsl:text></xsl:when>
<xsl:when test="$v = 'futureProximate'"><xsl:text>FutureProximate</xsl:text></xsl:when>
<xsl:when test="$v = 'futureProximate1'"><xsl:text>FutureProximate1</xsl:text></xsl:when>
<xsl:when test="$v = 'futureProximate2'"><xsl:text>FutureProximate2</xsl:text></xsl:when>
<xsl:when test="$v = 'futurePunctual'"><xsl:text>FuturePunctual</xsl:text></xsl:when>
<xsl:when test="$v = 'gawwada'"><xsl:text>Gawwada</xsl:text></xsl:when>
<xsl:when test="$v = 'gedeo'"><xsl:text>Gedeo</xsl:text></xsl:when>
<xsl:when test="$v = 'geez'"><xsl:text>Geez</xsl:text></xsl:when>
<xsl:when test="$v = 'gemination'"><xsl:text>Gemination</xsl:text></xsl:when>
<xsl:when test="$v = 'genAcc'"><xsl:text>GenAcc</xsl:text></xsl:when>
<xsl:when test="$v = 'genAdjPart'"><xsl:text>GenAdjPart</xsl:text></xsl:when>
<xsl:when test="$v = 'genBeforePossSuff'"><xsl:text>GenBeforePossSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'genObj'"><xsl:text>GenObj</xsl:text></xsl:when>
<xsl:when test="$v = 'gen_PossPred'"><xsl:text>Gen_PossPred</xsl:text></xsl:when>
<xsl:when test="$v = 'gender'"><xsl:text>Gender</xsl:text></xsl:when>
<xsl:when test="$v = 'general'"><xsl:text>General</xsl:text></xsl:when>
<xsl:when test="$v = 'generic'"><xsl:text>Generic</xsl:text></xsl:when>
<xsl:when test="$v = 'genitive'"><xsl:text>Genitive</xsl:text></xsl:when>
<xsl:when test="$v = 'gerPres'"><xsl:text>GerPres</xsl:text></xsl:when>
<xsl:when test="$v = 'gerPret'"><xsl:text>GerPret</xsl:text></xsl:when>
<xsl:when test="$v = 'gerund'"><xsl:text>Gerund</xsl:text></xsl:when>
<xsl:when test="$v = 'getangry'"><xsl:text>Getangry</xsl:text></xsl:when>
<xsl:when test="$v = 'glideStem'"><xsl:text>GlideStem</xsl:text></xsl:when>
<xsl:when test="$v = 'group1'"><xsl:text>Group1</xsl:text></xsl:when>
<xsl:when test="$v = 'group2'"><xsl:text>Group2</xsl:text></xsl:when>
<xsl:when test="$v = 'hCC'"><xsl:text>HCC</xsl:text></xsl:when>
<xsl:when test="$v = 'hFin'"><xsl:text>HFin</xsl:text></xsl:when>
<xsl:when test="$v = 'hStem'"><xsl:text>HStem</xsl:text></xsl:when>
<xsl:when test="$v = 'habitual'"><xsl:text>Habitual</xsl:text></xsl:when>
<xsl:when test="$v = 'habitualPartialReduplication'"><xsl:text>HabitualPartialReduplication</xsl:text></xsl:when>
<xsl:when test="$v = 'habitualTotalReduplication'"><xsl:text>HabitualTotalReduplication</xsl:text></xsl:when>
<xsl:when test="$v = 'had-Class'"><xsl:text>Had-Class</xsl:text></xsl:when>
<xsl:when test="$v = 'hadendowa'"><xsl:text>Hadendowa</xsl:text></xsl:when>
<xsl:when test="$v = 'hadiyya'"><xsl:text>Hadiyya</xsl:text></xsl:when>
<xsl:when test="$v = 'hamzFin'"><xsl:text>HamzFin</xsl:text></xsl:when>
<xsl:when test="$v = 'hamzInitVFin'"><xsl:text>HamzInitVFin</xsl:text></xsl:when>
<xsl:when test="$v = 'heSuff'"><xsl:text>HeSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'headFollow'"><xsl:text>HeadFollow</xsl:text></xsl:when>
<xsl:when test="$v = 'headPl'"><xsl:text>HeadPlural</xsl:text></xsl:when>
<xsl:when test="$v = 'headPrecede'"><xsl:text>HeadPrecede</xsl:text></xsl:when>
<xsl:when test="$v = 'headSgf'"><xsl:text>HeadSingularFem</xsl:text></xsl:when>
<xsl:when test="$v = 'headSgm'"><xsl:text>HeadSingularMasc</xsl:text></xsl:when>
<xsl:when test="$v = 'heb'"><xsl:text>Hebrew</xsl:text></xsl:when>
<xsl:when test="$v = 'hebr'"><xsl:text>Hebrew</xsl:text></xsl:when>
<xsl:when test="$v = 'hebrew'"><xsl:text>Hebrew</xsl:text></xsl:when>
<xsl:when test="$v = 'here'"><xsl:text>Here</xsl:text></xsl:when>
<xsl:when test="$v = 'hither'"><xsl:text>Hither</xsl:text></xsl:when>
<xsl:when test="$v = 'hitherObj'"><xsl:text>HitherObj</xsl:text></xsl:when>
<xsl:when test="$v = 'honorific'"><xsl:text>Honorific</xsl:text></xsl:when>
<xsl:when test="$v = 'hypothNonActual'"><xsl:text>HypothNonActual</xsl:text></xsl:when>
<xsl:when test="$v = 'hypothNonPres'"><xsl:text>HypothNonPres</xsl:text></xsl:when>
<xsl:when test="$v = 'hypothetical'"><xsl:text>Hypothetical</xsl:text></xsl:when>
<xsl:when test="$v = 'i'"><xsl:text>I</xsl:text></xsl:when>
<xsl:when test="$v = 'i-Form'"><xsl:text>I-Form</xsl:text></xsl:when>
<xsl:when test="$v = 'i-stem'"><xsl:text>I-stem</xsl:text></xsl:when>
<xsl:when test="$v = 'iClass'"><xsl:text>IClass</xsl:text></xsl:when>
<xsl:when test="$v = 'id'"><xsl:text>Id</xsl:text></xsl:when>
<xsl:when test="$v = 'ident'"><xsl:text>Ident</xsl:text></xsl:when>
<xsl:when test="$v = 'immediate'"><xsl:text>Immediate</xsl:text></xsl:when>
<xsl:when test="$v = 'imperative'"><xsl:text>Imperative</xsl:text></xsl:when>
<xsl:when test="$v = 'imperative--p2Only'"><xsl:text>Imperative--p2Only</xsl:text></xsl:when>
<xsl:when test="$v = 'imperativeJussive'"><xsl:text>ImperativeJussive</xsl:text></xsl:when>
<xsl:when test="$v = 'imperativeJussive1'"><xsl:text>ImperativeJussive1</xsl:text></xsl:when>
<xsl:when test="$v = 'imperativeJussive2'"><xsl:text>ImperativeJussive2</xsl:text></xsl:when>
<xsl:when test="$v = 'imperativeJussive3'"><xsl:text>ImperativeJussive3</xsl:text></xsl:when>
<xsl:when test="$v = 'imperativeNegative'"><xsl:text>ImperativeNegative</xsl:text></xsl:when>
<xsl:when test="$v = 'imperativeOptative'"><xsl:text>ImperativeOptative</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfSuff'"><xsl:text>ImperfSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfect'"><xsl:text>Imperfect</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfect-m'"><xsl:text>Imperfect-m</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectActual'"><xsl:text>ImperfectActual</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectAnticipatory'"><xsl:text>ImperfectAnticipatory</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectComp'"><xsl:text>ImperfectComp</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectFuture'"><xsl:text>ImperfectFuture</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectGeneral'"><xsl:text>ImperfectGeneral</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectInni'"><xsl:text>ImperfectInni</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectLi'"><xsl:text>ImperfectLi</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectM'"><xsl:text>ImperfectM</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectMa'"><xsl:text>ImperfectMa</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectNegative'"><xsl:text>ImperfectNegative</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectNonActual'"><xsl:text>ImperfectNonActual</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectNonPresent'"><xsl:text>ImperfectNonPresent</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectNonPresent2'"><xsl:text>ImperfectNonPresent2</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectParticiple'"><xsl:text>ImperfectParticiple</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectPast'"><xsl:text>ImperfectPast</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectPast1'"><xsl:text>ImperfectPast1</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectPast2'"><xsl:text>ImperfectPast2</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectPresent'"><xsl:text>ImperfectPresent</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectPreterite'"><xsl:text>ImperfectPreterite</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectProbable1'"><xsl:text>ImperfectProbable1</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectProbable2'"><xsl:text>ImperfectProbable2</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectProgressive'"><xsl:text>ImperfectProgressive</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectSimple'"><xsl:text>ImperfectSimple</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectSubordinate'"><xsl:text>ImperfectSubordinate</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfective'"><xsl:text>Imperfective</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectiveFuture'"><xsl:text>ImperfectiveFuture</xsl:text></xsl:when>
<xsl:when test="$v = 'imperfectivePresent'"><xsl:text>ImperfectivePresent</xsl:text></xsl:when>
<xsl:when test="$v = 'impersonal'"><xsl:text>Impersonal</xsl:text></xsl:when>
<xsl:when test="$v = 'imprtv'"><xsl:text>Imprtv</xsl:text></xsl:when>
<xsl:when test="$v = 'imprtvOpt'"><xsl:text>ImprtvOpt</xsl:text></xsl:when>
<xsl:when test="$v = 'imprtvOverview'"><xsl:text>ImprtvOverview</xsl:text></xsl:when>
<xsl:when test="$v = 'inceptive'"><xsl:text>Inceptive</xsl:text></xsl:when>
<xsl:when test="$v = 'inchoative'"><xsl:text>Inchoative</xsl:text></xsl:when>
<xsl:when test="$v = 'inchoativization'"><xsl:text>Inchoativization</xsl:text></xsl:when>
<xsl:when test="$v = 'inclusive'"><xsl:text>Inclusive</xsl:text></xsl:when>
<xsl:when test="$v = 'indObl'"><xsl:text>IndObl</xsl:text></xsl:when>
<xsl:when test="$v = 'indefSubj_tense'"><xsl:text>IndefSubj_tense</xsl:text></xsl:when>
<xsl:when test="$v = 'indefinite'"><xsl:text>Indefinite</xsl:text></xsl:when>
<xsl:when test="$v = 'indepCase'"><xsl:text>IndepCase</xsl:text></xsl:when>
<xsl:when test="$v = 'independent'"><xsl:text>Independent</xsl:text></xsl:when>
<xsl:when test="$v = 'independent1'"><xsl:text>Independent1</xsl:text></xsl:when>
<xsl:when test="$v = 'independent2'"><xsl:text>Independent2</xsl:text></xsl:when>
<xsl:when test="$v = 'independentPersonal'"><xsl:text>IndependentPersonal</xsl:text></xsl:when>
<xsl:when test="$v = 'independentPossessive'"><xsl:text>IndependentPossessive</xsl:text></xsl:when>
<xsl:when test="$v = 'indetSubj'"><xsl:text>IndetSubj</xsl:text></xsl:when>
<xsl:when test="$v = 'indetSubj_obj'"><xsl:text>IndetSubj_obj</xsl:text></xsl:when>
<xsl:when test="$v = 'indetSubj_tense'"><xsl:text>IndetSubj_tense</xsl:text></xsl:when>
<xsl:when test="$v = 'indicative'"><xsl:text>Indicative</xsl:text></xsl:when>
<xsl:when test="$v = 'indirect'"><xsl:text>Indirect</xsl:text></xsl:when>
<xsl:when test="$v = 'iness'"><xsl:text>Iness(ive?)</xsl:text></xsl:when>
<xsl:when test="$v = 'infinitive'"><xsl:text>Infinitive</xsl:text></xsl:when>
<xsl:when test="$v = 'infinitive-me'"><xsl:text>Infinitive-me</xsl:text></xsl:when>
<xsl:when test="$v = 'infinitive-um'"><xsl:text>Infinitive-um</xsl:text></xsl:when>
<xsl:when test="$v = 'infinitive1'"><xsl:text>Infinitive1</xsl:text></xsl:when>
<xsl:when test="$v = 'infinitive2'"><xsl:text>Infinitive2</xsl:text></xsl:when>
<xsl:when test="$v = 'infinitiveCompCaus'"><xsl:text>InfinitiveCompCaus</xsl:text></xsl:when>
<xsl:when test="$v = 'infinitiveConj'"><xsl:text>InfinitiveConj</xsl:text></xsl:when>
<xsl:when test="$v = 'infinitiveConn'"><xsl:text>InfinitiveConn</xsl:text></xsl:when>
<xsl:when test="$v = 'infinitiveInflect'"><xsl:text>InfinitiveInflect</xsl:text></xsl:when>
<xsl:when test="$v = 'infinitiveSub'"><xsl:text>InfinitiveSub</xsl:text></xsl:when>
<xsl:when test="$v = 'inflClass'"><xsl:text>InflClass</xsl:text></xsl:when>
<xsl:when test="$v = 'inflectedInfiitive'"><xsl:text>InflectedInfiitive</xsl:text></xsl:when>
<xsl:when test="$v = 'inflectionTemplate'"><xsl:text>InflectionTemplate</xsl:text></xsl:when>
<xsl:when test="$v = 'ingressive'"><xsl:text>Ingressive</xsl:text></xsl:when>
<xsl:when test="$v = 'inherit'"><xsl:text>Inherit</xsl:text></xsl:when>
<xsl:when test="$v = 'injunct'"><xsl:text>Injunct</xsl:text></xsl:when>
<xsl:when test="$v = 'instrumental'"><xsl:text>Instrumental</xsl:text></xsl:when>
<xsl:when test="$v = 'intensive'"><xsl:text>Intensive</xsl:text></xsl:when>
<xsl:when test="$v = 'intensive1'"><xsl:text>Intensive1</xsl:text></xsl:when>
<xsl:when test="$v = 'intensive2'"><xsl:text>Intensive2</xsl:text></xsl:when>
<xsl:when test="$v = 'intensive3'"><xsl:text>Intensive3</xsl:text></xsl:when>
<xsl:when test="$v = 'intention'"><xsl:text>Intention</xsl:text></xsl:when>
<xsl:when test="$v = 'intentive'"><xsl:text>Intentive</xsl:text></xsl:when>
<xsl:when test="$v = 'interr'"><xsl:text>Interr</xsl:text></xsl:when>
<xsl:when test="$v = 'interrDiff'"><xsl:text>InterrDiff</xsl:text></xsl:when>
<xsl:when test="$v = 'interrDubitative'"><xsl:text>InterrDubitative</xsl:text></xsl:when>
<xsl:when test="$v = 'interrGen'"><xsl:text>InterrGen</xsl:text></xsl:when>
<xsl:when test="$v = 'interrNonPolar'"><xsl:text>InterrNonPolar</xsl:text></xsl:when>
<xsl:when test="$v = 'interrPerm'"><xsl:text>InterrPerm</xsl:text></xsl:when>
<xsl:when test="$v = 'interrPolar'"><xsl:text>InterrPolar</xsl:text></xsl:when>
<xsl:when test="$v = 'interrSubjMarker'"><xsl:text>InterrSubjMarker</xsl:text></xsl:when>
<xsl:when test="$v = 'interrWh'"><xsl:text>InterrWh</xsl:text></xsl:when>
<xsl:when test="$v = 'interrog'"><xsl:text>Interrog</xsl:text></xsl:when>
<xsl:when test="$v = 'interrogDir'"><xsl:text>InterrogDir</xsl:text></xsl:when>
<xsl:when test="$v = 'interrogRhet'"><xsl:text>InterrogRhet</xsl:text></xsl:when>
<xsl:when test="$v = 'interrogative'"><xsl:text>Interrogative</xsl:text></xsl:when>
<xsl:when test="$v = 'intransitive'"><xsl:text>Intransitive</xsl:text></xsl:when>
<xsl:when test="$v = 'invariable'"><xsl:text>Invariable</xsl:text></xsl:when>
<xsl:when test="$v = 'iraqw'"><xsl:text>Iraqw</xsl:text></xsl:when>
<xsl:when test="$v = 'irrealis'"><xsl:text>Irrealis</xsl:text></xsl:when>
<xsl:when test="$v = 'irreg'"><xsl:text>Irreg</xsl:text></xsl:when>
<xsl:when test="$v = 'irreg1-2'"><xsl:text>Irreg1-2</xsl:text></xsl:when>
<xsl:when test="$v = 'irregular'"><xsl:text>Irregular</xsl:text></xsl:when>
<xsl:when test="$v = 'is-Class'"><xsl:text>Is-Class</xsl:text></xsl:when>
<xsl:when test="$v = 'iterative'"><xsl:text>Iterative</xsl:text></xsl:when>
<xsl:when test="$v = 'iterative_causative'"><xsl:text>Iterative_causative</xsl:text></xsl:when>
<xsl:when test="$v = 'jara'"><xsl:text>Jara</xsl:text></xsl:when>
<xsl:when test="$v = 'juss'"><xsl:text>Juss</xsl:text></xsl:when>
<xsl:when test="$v = 'jussive'"><xsl:text>Jussive</xsl:text></xsl:when>
<xsl:when test="$v = 'jussive2'"><xsl:text>Jussive2</xsl:text></xsl:when>
<xsl:when test="$v = 'jussiveKi'"><xsl:text>JussiveKi</xsl:text></xsl:when>
<xsl:when test="$v = 'jussiveLi'"><xsl:text>JussiveLi</xsl:text></xsl:when>
<xsl:when test="$v = 'jussiveMa'"><xsl:text>JussiveMa</xsl:text></xsl:when>
<xsl:when test="$v = 'jussiveNegative'"><xsl:text>JussiveNegative</xsl:text></xsl:when>
<xsl:when test="$v = 'k-Focus'"><xsl:text>K-Focus</xsl:text></xsl:when>
<xsl:when test="$v = 'loSuff'"><xsl:text>LoSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'locative'"><xsl:text>Locative</xsl:text></xsl:when>
<xsl:when test="$v = 'long'"><xsl:text>Long</xsl:text></xsl:when>
<xsl:when test="$v = 'm'"><xsl:text>Masc</xsl:text></xsl:when>
<xsl:when test="$v = 'm-'"><xsl:text>M-</xsl:text></xsl:when>
<xsl:when test="$v = 'm-Class'"><xsl:text>M-Class</xsl:text></xsl:when>
<xsl:when test="$v = 'm-Extension'"><xsl:text>M-Extension</xsl:text></xsl:when>
<xsl:when test="$v = 'm-or-pl'"><xsl:text>M-or-pl</xsl:text></xsl:when>
<xsl:when test="$v = 'ma'"><xsl:text>Ma</xsl:text></xsl:when>
<xsl:when test="$v = 'ma-requestive'"><xsl:text>Ma-requestive</xsl:text></xsl:when>
<xsl:when test="$v = 'maStemInniCopula'"><xsl:text>MaStemInniCopula</xsl:text></xsl:when>
<xsl:when test="$v = 'maale'"><xsl:text>Maale</xsl:text></xsl:when>
<xsl:when test="$v = 'main'"><xsl:text>Main</xsl:text></xsl:when>
<xsl:when test="$v = 'mainGeneral'"><xsl:text>MainGeneral</xsl:text></xsl:when>
<xsl:when test="$v = 'make'"><xsl:text>Make</xsl:text></xsl:when>
<xsl:when test="$v = 'makework'"><xsl:text>Makework</xsl:text></xsl:when>
<xsl:when test="$v = 'medial'"><xsl:text>Medial</xsl:text></xsl:when>
<xsl:when test="$v = 'mediopassive'"><xsl:text>Mediopassive</xsl:text></xsl:when>
<xsl:when test="$v = 'middle'"><xsl:text>Middle</xsl:text></xsl:when>
<xsl:when test="$v = 'middleClass'"><xsl:text>MiddleClass</xsl:text></xsl:when>
<xsl:when test="$v = 'midway'"><xsl:text>Midway</xsl:text></xsl:when>
<xsl:when test="$v = 'mirative'"><xsl:text>Mirative</xsl:text></xsl:when>
<xsl:when test="$v = 'modClass'"><xsl:text>ModClass</xsl:text></xsl:when>
<xsl:when test="$v = 'monorad'"><xsl:text>Monorad</xsl:text></xsl:when>
<xsl:when test="$v = 'monoradical'"><xsl:text>Monoradical</xsl:text></xsl:when>
<xsl:when test="$v = 'monosyll'"><xsl:text>Monosyllablic</xsl:text></xsl:when>
<xsl:when test="$v = 'monosyllabic'"><xsl:text>Monosyllabic</xsl:text></xsl:when>
<xsl:when test="$v = 'mood'"><xsl:text>Mood</xsl:text></xsl:when>
<xsl:when test="$v = 'multi'"><xsl:text>Multi</xsl:text></xsl:when>
<xsl:when test="$v = 'murmur'"><xsl:text>Murmur</xsl:text></xsl:when>
<xsl:when test="$v = 'n'"><xsl:text>N</xsl:text></xsl:when>
<xsl:when test="$v = 'n-'"><xsl:text>N-</xsl:text></xsl:when>
<xsl:when test="$v = 'n-subordinate'"><xsl:text>N-subordinate</xsl:text></xsl:when>
<xsl:when test="$v = 'nCC'"><xsl:text>NCC</xsl:text></xsl:when>
<xsl:when test="$v = 'nasal'"><xsl:text>Nasal</xsl:text></xsl:when>
<xsl:when test="$v = 'nasalStem'"><xsl:text>NasalStem</xsl:text></xsl:when>
<xsl:when test="$v = 'near'"><xsl:text>Near</xsl:text></xsl:when>
<xsl:when test="$v = 'near1'"><xsl:text>Near1</xsl:text></xsl:when>
<xsl:when test="$v = 'near2'"><xsl:text>Near2</xsl:text></xsl:when>
<xsl:when test="$v = 'nearSpeaker'"><xsl:text>NearSpeaker</xsl:text></xsl:when>
<xsl:when test="$v = 'neg'"><xsl:text>Neg</xsl:text></xsl:when>
<xsl:when test="$v = 'negAux'"><xsl:text>NegAux</xsl:text></xsl:when>
<xsl:when test="$v = 'negClass'"><xsl:text>NegClass</xsl:text></xsl:when>
<xsl:when test="$v = 'negCop'"><xsl:text>NegCop</xsl:text></xsl:when>
<xsl:when test="$v = 'negInterr'"><xsl:text>NegInterr</xsl:text></xsl:when>
<xsl:when test="$v = 'negSubjunctive'"><xsl:text>NegSubjunctive</xsl:text></xsl:when>
<xsl:when test="$v = 'negSuff'"><xsl:text>NegSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'negation'"><xsl:text>Negation</xsl:text></xsl:when>
<xsl:when test="$v = 'negationAffix'"><xsl:text>NegationAffix</xsl:text></xsl:when>
<xsl:when test="$v = 'negative'"><xsl:text>Negative</xsl:text></xsl:when>
<xsl:when test="$v = 'negative identity'"><xsl:text>NegativeIdentity</xsl:text></xsl:when>
<xsl:when test="$v = 'negative2'"><xsl:text>Negative2</xsl:text></xsl:when>
<xsl:when test="$v = 'negativeAffix'"><xsl:text>NegativeAffix</xsl:text></xsl:when>
<xsl:when test="$v = 'negativeEmphatic'"><xsl:text>NegativeEmphatic</xsl:text></xsl:when>
<xsl:when test="$v = 'neut'"><xsl:text>Neut</xsl:text></xsl:when>
<xsl:when test="$v = 'neutral'"><xsl:text>Neutral</xsl:text></xsl:when>
<xsl:when test="$v = 'newInfo'"><xsl:text>NewInfo</xsl:text></xsl:when>
<xsl:when test="$v = 'noFoc'"><xsl:text>NoFoc</xsl:text></xsl:when>
<xsl:when test="$v = 'noFocus'"><xsl:text>NoFocus</xsl:text></xsl:when>
<xsl:when test="$v = 'noParticle'"><xsl:text>NoParticle</xsl:text></xsl:when>
<xsl:when test="$v = 'nom'"><xsl:text>Nom</xsl:text></xsl:when>
<xsl:when test="$v = 'nom/gen'"><xsl:text>Nom/gen</xsl:text></xsl:when>
<xsl:when test="$v = 'nomAdjPred'"><xsl:text>NomAdjPred</xsl:text></xsl:when>
<xsl:when test="$v = 'nomAgent'"><xsl:text>NomAgent</xsl:text></xsl:when>
<xsl:when test="$v = 'nomForm'"><xsl:text>NomForm</xsl:text></xsl:when>
<xsl:when test="$v = 'nomSubj'"><xsl:text>NomSubj</xsl:text></xsl:when>
<xsl:when test="$v = 'nom_obj'"><xsl:text>Nom_obj</xsl:text></xsl:when>
<xsl:when test="$v = 'nominal'"><xsl:text>Nominal</xsl:text></xsl:when>
<xsl:when test="$v = 'nominalAction'"><xsl:text>NominalAction</xsl:text></xsl:when>
<xsl:when test="$v = 'nominalAgent'"><xsl:text>NominalAgent</xsl:text></xsl:when>
<xsl:when test="$v = 'nominalPred'"><xsl:text>NominalPred</xsl:text></xsl:when>
<xsl:when test="$v = 'nominalizationPatterns'"><xsl:text>NominalizationPatterns</xsl:text></xsl:when>
<xsl:when test="$v = 'nominative'"><xsl:text>Nominative</xsl:text></xsl:when>
<xsl:when test="$v = 'non-finite'"><xsl:text>Non-finite</xsl:text></xsl:when>
<xsl:when test="$v = 'non-focus'"><xsl:text>Non-focus</xsl:text></xsl:when>
<xsl:when test="$v = 'non-indicative'"><xsl:text>Non-indicative</xsl:text></xsl:when>
<xsl:when test="$v = 'non-past'"><xsl:text>Non-past</xsl:text></xsl:when>
<xsl:when test="$v = 'non-subj-focus'"><xsl:text>Non-subj-focus</xsl:text></xsl:when>
<xsl:when test="$v = 'nonAgr'"><xsl:text>NonAgr</xsl:text></xsl:when>
<xsl:when test="$v = 'nonConstr'"><xsl:text>NonConstr</xsl:text></xsl:when>
<xsl:when test="$v = 'nonContracting'"><xsl:text>NonContracting</xsl:text></xsl:when>
<xsl:when test="$v = 'nonCrnlDrop'"><xsl:text>NonCrnlDrop</xsl:text></xsl:when>
<xsl:when test="$v = 'nonFinite'"><xsl:text>NonFinite</xsl:text></xsl:when>
<xsl:when test="$v = 'nonIdent'"><xsl:text>NonIdent</xsl:text></xsl:when>
<xsl:when test="$v = 'nonMainClauseForms'"><xsl:text>NonMainClauseForms</xsl:text></xsl:when>
<xsl:when test="$v = 'nonPast'"><xsl:text>NonPast</xsl:text></xsl:when>
<xsl:when test="$v = 'nonPast-nonPres'"><xsl:text>NonPast-nonPres</xsl:text></xsl:when>
<xsl:when test="$v = 'nonPastGen'"><xsl:text>NonPastGen</xsl:text></xsl:when>
<xsl:when test="$v = 'nonPastSubj'"><xsl:text>NonPastSubj</xsl:text></xsl:when>
<xsl:when test="$v = 'nonSpatial'"><xsl:text>NonSpatial</xsl:text></xsl:when>
<xsl:when test="$v = 'nonSuppletive'"><xsl:text>NonSuppletive</xsl:text></xsl:when>
<xsl:when test="$v = 'nonVentive'"><xsl:text>NonVentive</xsl:text></xsl:when>
<xsl:when test="$v = 'nonVerbal'"><xsl:text>NonVerbal</xsl:text></xsl:when>
<xsl:when test="$v = 'nonpast'"><xsl:text>Nonpast</xsl:text></xsl:when>
<xsl:when test="$v = 'normal'"><xsl:text>Normal</xsl:text></xsl:when>
<xsl:when test="$v = 'notYet'"><xsl:text>NotYet</xsl:text></xsl:when>
<xsl:when test="$v = 'noun'"><xsl:text>Noun</xsl:text></xsl:when>
<xsl:when test="$v = 'numNonPerf'"><xsl:text>NumNonPerf</xsl:text></xsl:when>
<xsl:when test="$v = 'numOrd'"><xsl:text>NumOrd</xsl:text></xsl:when>
<xsl:when test="$v = 'numPerf'"><xsl:text>NumPerf</xsl:text></xsl:when>
<xsl:when test="$v = 'numSubj'"><xsl:text>NumSubj</xsl:text></xsl:when>
<xsl:when test="$v = 'number'"><xsl:text>Number</xsl:text></xsl:when>
<xsl:when test="$v = 'numeral'"><xsl:text>Numeral</xsl:text></xsl:when>
<xsl:when test="$v = 'numerals'"><xsl:text>Numerals</xsl:text></xsl:when>
<xsl:when test="$v = 'obj'"><xsl:text>Obj</xsl:text></xsl:when>
<xsl:when test="$v = 'obj=ka'"><xsl:text>Obj=ka</xsl:text></xsl:when>
<xsl:when test="$v = 'objAff'"><xsl:text>ObjAff</xsl:text></xsl:when>
<xsl:when test="$v = 'objAgr'"><xsl:text>ObjAgr</xsl:text></xsl:when>
<xsl:when test="$v = 'objClitic'"><xsl:text>ObjClitic</xsl:text></xsl:when>
<xsl:when test="$v = 'objCliticImprtv'"><xsl:text>ObjCliticImprtv</xsl:text></xsl:when>
<xsl:when test="$v = 'objCliticPerf'"><xsl:text>ObjCliticPerf</xsl:text></xsl:when>
<xsl:when test="$v = 'objFocus'"><xsl:text>ObjFocus</xsl:text></xsl:when>
<xsl:when test="$v = 'objProclitic'"><xsl:text>ObjProclitic</xsl:text></xsl:when>
<xsl:when test="$v = 'objRel'"><xsl:text>ObjRel</xsl:text></xsl:when>
<xsl:when test="$v = 'objSel'"><xsl:text>ObjSel</xsl:text></xsl:when>
<xsl:when test="$v = 'objSuff'"><xsl:text>ObjSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'objSuffExx'"><xsl:text>ObjSuffExx</xsl:text></xsl:when>
<xsl:when test="$v = 'objSuffPdgm'"><xsl:text>ObjSuffPdgm</xsl:text></xsl:when>
<xsl:when test="$v = 'objSuffWithV'"><xsl:text>ObjSuffWithV</xsl:text></xsl:when>
<xsl:when test="$v = 'object'"><xsl:text>Object</xsl:text></xsl:when>
<xsl:when test="$v = 'objectGeneral'"><xsl:text>ObjectGeneral</xsl:text></xsl:when>
<xsl:when test="$v = 'objectIndirect'"><xsl:text>ObjectIndirect</xsl:text></xsl:when>
<xsl:when test="$v = 'objectSuff'"><xsl:text>ObjectSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'objectSuffix'"><xsl:text>ObjectSuffix</xsl:text></xsl:when>
<xsl:when test="$v = 'objectWInitial'"><xsl:text>ObjectWInitial</xsl:text></xsl:when>
<xsl:when test="$v = 'object[1pl]'"><xsl:text>Object1Plural</xsl:text></xsl:when>
<xsl:when test="$v = 'object[1sg]'"><xsl:text>Object1Singular</xsl:text></xsl:when>
<xsl:when test="$v = 'object[2pl]'"><xsl:text>Object2Plural</xsl:text></xsl:when>
<xsl:when test="$v = 'object[2sgf/3pl]'"><xsl:text>Object2SingluarFem_3Plural</xsl:text></xsl:when>
<xsl:when test="$v = 'object[2sgf]'"><xsl:text>Object2SingularFem]</xsl:text></xsl:when>
<xsl:when test="$v = 'object[2sgm/3sgm]'"><xsl:text>Object2SingularMasd_3SingularMasc</xsl:text></xsl:when>
<xsl:when test="$v = 'object[2sgm]'"><xsl:text>Object2SingularMasc</xsl:text></xsl:when>
<xsl:when test="$v = 'object[3pl]'"><xsl:text>Object3Plural</xsl:text></xsl:when>
<xsl:when test="$v = 'object[3sgf]'"><xsl:text>Object3SingularFem</xsl:text></xsl:when>
<xsl:when test="$v = 'object[3sgm]'"><xsl:text>Object3SingularMasc</xsl:text></xsl:when>
<xsl:when test="$v = 'oblique'"><xsl:text>Oblique</xsl:text></xsl:when>
<xsl:when test="$v = 'oblique-posessive'"><xsl:text>Oblique-posessive</xsl:text></xsl:when>
<xsl:when test="$v = 'obliqueRelative'"><xsl:text>ObliqueRelative</xsl:text></xsl:when>
<xsl:when test="$v = 'occurrence'"><xsl:text>Occurrence</xsl:text></xsl:when>
<xsl:when test="$v = 'optative'"><xsl:text>Optative</xsl:text></xsl:when>
<xsl:when test="$v = 'optative_subj'"><xsl:text>Optative_subj</xsl:text></xsl:when>
<xsl:when test="$v = 'optative_subj_obj'"><xsl:text>Optative_subj_obj</xsl:text></xsl:when>
<xsl:when test="$v = 'order'"><xsl:text>Order</xsl:text></xsl:when>
<xsl:when test="$v = 'ordinal'"><xsl:text>Ordinal</xsl:text></xsl:when>
<xsl:when test="$v = 'orientationSel'"><xsl:text>OrientationSel</xsl:text></xsl:when>
<xsl:when test="$v = 'oromo'"><xsl:text>Oromo</xsl:text></xsl:when>
<xsl:when test="$v = 'orroo'"><xsl:text>Orroo</xsl:text></xsl:when>
<xsl:when test="$v = 'p'">
<xsl:choose>
  <xsl:when test="../@type='gen'">
    <xsl:text>Polite</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>P</xsl:text>
  </xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$v = 'p1'"><xsl:text>Person1</xsl:text></xsl:when>
<xsl:when test="$v = 'p1ex'"><xsl:text>Person1ex</xsl:text></xsl:when>
<xsl:when test="$v = 'p1in'"><xsl:text>Person1in</xsl:text></xsl:when>
<xsl:when test="$v = 'p2'"><xsl:text>Person2</xsl:text></xsl:when>
<xsl:when test="$v = 'p3'"><xsl:text>Person3</xsl:text></xsl:when>
<xsl:when test="$v = 'p3Ref'"><xsl:text>Person3Ref</xsl:text></xsl:when>
<xsl:when test="$v = 'pcm'"><xsl:text>Pcm</xsl:text></xsl:when>
<xsl:when test="$v = 'pClass1'"><xsl:text>PersonClass1</xsl:text></xsl:when>
<xsl:when test="$v = 'pClass2'"><xsl:text>PersonClass2</xsl:text></xsl:when>
<xsl:when test="$v = 'pNon-1'"><xsl:text>PersonNon-1</xsl:text></xsl:when>
<xsl:when test="$v = 'partClass'"><xsl:text>PartClass</xsl:text></xsl:when>
<xsl:when test="$v = 'partSubj_obj_tense'"><xsl:text>PartSubj_obj_tense</xsl:text></xsl:when>
<xsl:when test="$v = 'partialPdgm'"><xsl:text>PartialPdgm</xsl:text></xsl:when>
<xsl:when test="$v = 'participantSubj'"><xsl:text>ParticipantSubj</xsl:text></xsl:when>
<xsl:when test="$v = 'participle'"><xsl:text>Participle</xsl:text></xsl:when>
<xsl:when test="$v = 'participle-k--invar'"><xsl:text>Participle-k--invar</xsl:text></xsl:when>
<xsl:when test="$v = 'participleSuff-imprf-sg'"><xsl:text>ParticipleSuff-imprf-sg</xsl:text></xsl:when>
<xsl:when test="$v = 'participleSuff-perf-f'"><xsl:text>ParticipleSuff-perf-f</xsl:text></xsl:when>
<xsl:when test="$v = 'participleSuff-perf-m'"><xsl:text>ParticipleSuff-perf-m</xsl:text></xsl:when>
<xsl:when test="$v = 'participleSuff-perf-pl'"><xsl:text>ParticipleSuff-perf-pl</xsl:text></xsl:when>
<xsl:when test="$v = 'particle'"><xsl:text>Particle</xsl:text></xsl:when>
<xsl:when test="$v = 'pass1'"><xsl:text>Pass1</xsl:text></xsl:when>
<xsl:when test="$v = 'pass2'"><xsl:text>Pass2</xsl:text></xsl:when>
<xsl:when test="$v = 'passive'"><xsl:text>Passive</xsl:text></xsl:when>
<xsl:when test="$v = 'passive+caus'"><xsl:text>Passive+caus</xsl:text></xsl:when>
<xsl:when test="$v = 'passiveBenefactive'"><xsl:text>PassiveBenefactive</xsl:text></xsl:when>
<xsl:when test="$v = 'passiveCausative'"><xsl:text>PassiveCausative</xsl:text></xsl:when>
<xsl:when test="$v = 'passiveReciprocalClass'"><xsl:text>PassiveReciprocalClass</xsl:text></xsl:when>
<xsl:when test="$v = 'passive_causative'"><xsl:text>Passive_causative</xsl:text></xsl:when>
<xsl:when test="$v = 'past'"><xsl:text>Past</xsl:text></xsl:when>
<xsl:when test="$v = 'pastClass'"><xsl:text>PastClass</xsl:text></xsl:when>
<xsl:when test="$v = 'pastContinuous'"><xsl:text>PastContinuous</xsl:text></xsl:when>
<xsl:when test="$v = 'pastDubitative'"><xsl:text>PastDubitative</xsl:text></xsl:when>
<xsl:when test="$v = 'pastGen'"><xsl:text>PastGen</xsl:text></xsl:when>
<xsl:when test="$v = 'pastGeneral'"><xsl:text>PastGeneral</xsl:text></xsl:when>
<xsl:when test="$v = 'pastHab'"><xsl:text>PastHab</xsl:text></xsl:when>
<xsl:when test="$v = 'pastHabitual'"><xsl:text>PastHabitual</xsl:text></xsl:when>
<xsl:when test="$v = 'pastIndependent'"><xsl:text>PastIndependent</xsl:text></xsl:when>
<xsl:when test="$v = 'pastIngressive'"><xsl:text>PastIngressive</xsl:text></xsl:when>
<xsl:when test="$v = 'pastInvar'"><xsl:text>PastInvar</xsl:text></xsl:when>
<xsl:when test="$v = 'pastPerf'"><xsl:text>PastPerf</xsl:text></xsl:when>
<xsl:when test="$v = 'pastPerfect'"><xsl:text>PastPerfect</xsl:text></xsl:when>
<xsl:when test="$v = 'pastPerfective'"><xsl:text>PastPerfective</xsl:text></xsl:when>
<xsl:when test="$v = 'pastPresOverview'"><xsl:text>PastPresOverview</xsl:text></xsl:when>
<xsl:when test="$v = 'pastProg'"><xsl:text>PastProg</xsl:text></xsl:when>
<xsl:when test="$v = 'pastProgressive'"><xsl:text>PastProgressive</xsl:text></xsl:when>
<xsl:when test="$v = 'pastQ'"><xsl:text>PastQ</xsl:text></xsl:when>
<xsl:when test="$v = 'pastState1'"><xsl:text>PastState1</xsl:text></xsl:when>
<xsl:when test="$v = 'pastState2'"><xsl:text>PastState2</xsl:text></xsl:when>
<xsl:when test="$v = 'pastSubj'"><xsl:text>PastSubj</xsl:text></xsl:when>
<xsl:when test="$v = 'pastTemporal'"><xsl:text>PastTemporal</xsl:text></xsl:when>
<xsl:when test="$v = 'pattern1'"><xsl:text>Pattern1</xsl:text></xsl:when>
<xsl:when test="$v = 'pattern2'"><xsl:text>Pattern2</xsl:text></xsl:when>
<xsl:when test="$v = 'paucal'"><xsl:text>Paucal</xsl:text></xsl:when>
<xsl:when test="$v = 'pdgmOverview'"><xsl:text>PdgmOverview</xsl:text></xsl:when>
<xsl:when test="$v = 'perf1'"><xsl:text>Perf1</xsl:text></xsl:when>
<xsl:when test="$v = 'perf2'"><xsl:text>Perf2</xsl:text></xsl:when>
<xsl:when test="$v = 'perfSuff'"><xsl:text>PerfSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'perfect'"><xsl:text>Perfect</xsl:text></xsl:when>
<xsl:when test="$v = 'perfect-m'"><xsl:text>Perfect-m</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectActual'"><xsl:text>PerfectActual</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectAnticipatory'"><xsl:text>PerfectAnticipatory</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectComp1'"><xsl:text>PerfectComp1</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectComp2'"><xsl:text>PerfectComp2</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectConditional'"><xsl:text>PerfectConditional</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectDur'"><xsl:text>PerfectDur</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectFuture'"><xsl:text>PerfectFuture</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectH'"><xsl:text>PerfectH</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectInniImperfect'"><xsl:text>PerfectInniImperfect</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectInniPerfect'"><xsl:text>PerfectInniPerfect</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectM'"><xsl:text>PerfectM</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectNegative'"><xsl:text>PerfectNegative</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectNonActual'"><xsl:text>PerfectNonActual</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectNonPresent'"><xsl:text>PerfectNonPresent</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectNonPresent2'"><xsl:text>PerfectNonPresent2</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectParticiple'"><xsl:text>PerfectParticiple</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectPast'"><xsl:text>PerfectPast</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectPast1'"><xsl:text>PerfectPast1</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectPast2'"><xsl:text>PerfectPast2</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectPresent'"><xsl:text>PerfectPresent</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectPreterite'"><xsl:text>PerfectPreterite</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectProbable'"><xsl:text>PerfectProbable</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectProgressive'"><xsl:text>PerfectProgressive</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectRel'"><xsl:text>PerfectRel</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectSimple'"><xsl:text>PerfectSimple</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectSubordinate'"><xsl:text>PerfectSubordinate</xsl:text></xsl:when>
<xsl:when test="$v = 'perfective'"><xsl:text>Perfective</xsl:text></xsl:when>
<xsl:when test="$v = 'perfectiveComp'"><xsl:text>PerfectiveComp</xsl:text></xsl:when>
<xsl:when test="$v = 'persAffix'"><xsl:text>PersAffix</xsl:text></xsl:when>
<xsl:when test="$v = 'persAsp'"><xsl:text>PersAsp</xsl:text></xsl:when>
<xsl:when test="$v = 'persMarkersGen'"><xsl:text>PersMarkersGen</xsl:text></xsl:when>
<xsl:when test="$v = 'persNumTenseSuff'"><xsl:text>PersNumTenseSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'persSuff'"><xsl:text>PersSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'pers_dem'"><xsl:text>Pers_dem</xsl:text></xsl:when>
<xsl:when test="$v = 'person'"><xsl:text>Person</xsl:text></xsl:when>
<xsl:when test="$v = 'personal'"><xsl:text>Personal</xsl:text></xsl:when>
<xsl:when test="$v = 'pl'"><xsl:text>Plural</xsl:text></xsl:when>
<xsl:when test="$v = 'pl2'"><xsl:text>Plural2</xsl:text></xsl:when>
<xsl:when test="$v = 'plEx'"><xsl:text>PluralEx</xsl:text></xsl:when>
<xsl:when test="$v = 'plIn'"><xsl:text>PluralIn</xsl:text></xsl:when>
<xsl:when test="$v = 'plNeut'"><xsl:text>PluralNeut</xsl:text></xsl:when>
<xsl:when test="$v = 'pluperfect'"><xsl:text>Pluperfect</xsl:text></xsl:when>
<xsl:when test="$v = 'pluperfectProgressive'"><xsl:text>PluperfectProgressive</xsl:text></xsl:when>
<xsl:when test="$v = 'pluractional'"><xsl:text>Pluractional</xsl:text></xsl:when>
<xsl:when test="$v = 'pluractional+transitivize'"><xsl:text>Pluractional+transitivize</xsl:text></xsl:when>
<xsl:when test="$v = 'pluractional+transitivize+caus'"><xsl:text>Pluractional+transitivize+caus</xsl:text></xsl:when>
<xsl:when test="$v = 'pluractional+transitivize+caus+passive'"><xsl:text>Pluractional+transitivize+caus+passive</xsl:text></xsl:when>
<xsl:when test="$v = 'pluractional+transitivize+causD'"><xsl:text>Pluractional+transitivize+causD</xsl:text></xsl:when>
<xsl:when test="$v = 'pngA'"><xsl:text>PngA</xsl:text></xsl:when>
<xsl:when test="$v = 'pngA2'"><xsl:text>PngA2</xsl:text></xsl:when>
<xsl:when test="$v = 'pngB'"><xsl:text>PngB</xsl:text></xsl:when>
<xsl:when test="$v = 'pngC'"><xsl:text>PngC</xsl:text></xsl:when>
<xsl:when test="$v = 'pngProclitic'"><xsl:text>PngProclitic</xsl:text></xsl:when>
<xsl:when test="$v = 'pol'">
<xsl:message>
  POL
</xsl:message>
<xsl:text>Pol</xsl:text></xsl:when>
<xsl:when test="$v = 'polImp'"><xsl:text>PolImp</xsl:text></xsl:when>
<xsl:when test="$v = 'polarity'"><xsl:text>Polarity</xsl:text></xsl:when>
<xsl:when test="$v = 'polite'"><xsl:text>Polite</xsl:text></xsl:when>
<xsl:when test="$v = 'politeImpersonal'"><xsl:text>PoliteImpersonal</xsl:text></xsl:when>
<xsl:when test="$v = 'pos1'"><xsl:text>Pos1</xsl:text></xsl:when>
<xsl:when test="$v = 'pos2'"><xsl:text>Pos2</xsl:text></xsl:when>
<xsl:when test="$v = 'pos3'"><xsl:text>Pos3</xsl:text></xsl:when>
<xsl:when test="$v = 'pos4'"><xsl:text>Pos4</xsl:text></xsl:when>
<xsl:when test="$v = 'pos5'"><xsl:text>Pos5</xsl:text></xsl:when>
<xsl:when test="$v = 'pos6'"><xsl:text>Pos6</xsl:text></xsl:when>
<xsl:when test="$v = 'pos7'"><xsl:text>Pos7</xsl:text></xsl:when>
<xsl:when test="$v = 'poss1'"><xsl:text>Poss1</xsl:text></xsl:when>
<xsl:when test="$v = 'poss2'"><xsl:text>Poss2</xsl:text></xsl:when>
<xsl:when test="$v = 'possAdj'"><xsl:text>PossAdj</xsl:text></xsl:when>
<xsl:when test="$v = 'possAnaph'"><xsl:text>PossAnaph</xsl:text></xsl:when>
<xsl:when test="$v = 'possClitic'"><xsl:text>PossClitic</xsl:text></xsl:when>
<xsl:when test="$v = 'possCop'"><xsl:text>PossCop</xsl:text></xsl:when>
<xsl:when test="$v = 'possExx'"><xsl:text>PossExx</xsl:text></xsl:when>
<xsl:when test="$v = 'possInd'"><xsl:text>PossInd</xsl:text></xsl:when>
<xsl:when test="$v = 'possNom'"><xsl:text>PossNom</xsl:text></xsl:when>
<xsl:when test="$v = 'possNom1'"><xsl:text>PossNom1</xsl:text></xsl:when>
<xsl:when test="$v = 'possNom2'"><xsl:text>PossNom2</xsl:text></xsl:when>
<xsl:when test="$v = 'possNoun'"><xsl:text>PossNoun</xsl:text></xsl:when>
<xsl:when test="$v = 'possObj'"><xsl:text>PossObj</xsl:text></xsl:when>
<xsl:when test="$v = 'possPref'"><xsl:text>PossPref</xsl:text></xsl:when>
<xsl:when test="$v = 'possPro'"><xsl:text>PossPro</xsl:text></xsl:when>
<xsl:when test="$v = 'possSuff'"><xsl:text>PossSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'possSuffAbl'"><xsl:text>PossSuffAbl</xsl:text></xsl:when>
<xsl:when test="$v = 'possSuffBase'"><xsl:text>PossSuffBase</xsl:text></xsl:when>
<xsl:when test="$v = 'possSuffCop'"><xsl:text>PossSuffCop</xsl:text></xsl:when>
<xsl:when test="$v = 'possSuffCopExx'"><xsl:text>PossSuffCopExx</xsl:text></xsl:when>
<xsl:when test="$v = 'possSuffDat'"><xsl:text>PossSuffDat</xsl:text></xsl:when>
<xsl:when test="$v = 'possSuffExx'"><xsl:text>PossSuffExx</xsl:text></xsl:when>
<xsl:when test="$v = 'possSuffGen'"><xsl:text>PossSuffGen</xsl:text></xsl:when>
<xsl:when test="$v = 'possSuffGenExx'"><xsl:text>PossSuffGenExx</xsl:text></xsl:when>
<xsl:when test="$v = 'possSuffNom'"><xsl:text>PossSuffNom</xsl:text></xsl:when>
<xsl:when test="$v = 'possSuffPlusGen'"><xsl:text>PossSuffPlusGen</xsl:text></xsl:when>
<xsl:when test="$v = 'possessive'"><xsl:text>Possessive</xsl:text></xsl:when>
<xsl:when test="$v = 'possessive-m'"><xsl:text>Possessive-m</xsl:text></xsl:when>
<xsl:when test="$v = 'possessiveDefinite'"><xsl:text>PossessiveDefinite</xsl:text></xsl:when>
<xsl:when test="$v = 'posterior'"><xsl:text>Posterior</xsl:text></xsl:when>
<xsl:when test="$v = 'posteriorSub'"><xsl:text>PosteriorSub</xsl:text></xsl:when>
<xsl:when test="$v = 'postposition'"><xsl:text>Postposition</xsl:text></xsl:when>
<xsl:when test="$v = 'potential'"><xsl:text>Potential</xsl:text></xsl:when>
<xsl:when test="$v = 'preVerbParticles'"><xsl:text>PreVerbParticles</xsl:text></xsl:when>
<xsl:when test="$v = 'preVerbSelSubjMarkers'"><xsl:text>PreVerbSelSubjMarkers</xsl:text></xsl:when>
<xsl:when test="$v = 'preVerbSel_SubjMarkers'"><xsl:text>PreVerbSel_SubjMarkers</xsl:text></xsl:when>
<xsl:when test="$v = 'precative'"><xsl:text>Precative</xsl:text></xsl:when>
<xsl:when test="$v = 'predestinative'"><xsl:text>Predestinative</xsl:text></xsl:when>
<xsl:when test="$v = 'predication'"><xsl:text>Predication</xsl:text></xsl:when>
<xsl:when test="$v = 'predicative'"><xsl:text>Predicative</xsl:text></xsl:when>
<xsl:when test="$v = 'pref-irreg'"><xsl:text>Pref-irreg</xsl:text></xsl:when>
<xsl:when test="$v = 'prefV'"><xsl:text>PrefV</xsl:text></xsl:when>
<xsl:when test="$v = 'prefVsSuff'"><xsl:text>PrefVsSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'prefectPast'"><xsl:text>PrefectPast</xsl:text></xsl:when>
<xsl:when test="$v = 'prefix'"><xsl:text>Prefix</xsl:text></xsl:when>
<xsl:when test="$v = 'prefix2'"><xsl:text>Prefix2</xsl:text></xsl:when>
<xsl:when test="$v = 'prefix3'"><xsl:text>Prefix3</xsl:text></xsl:when>
<xsl:when test="$v = 'prefix4'"><xsl:text>Prefix4</xsl:text></xsl:when>
<xsl:when test="$v = 'prefix5'"><xsl:text>Prefix5</xsl:text></xsl:when>
<xsl:when test="$v = 'prefixIrregular'"><xsl:text>PrefixIrregular</xsl:text></xsl:when>
<xsl:when test="$v = 'prefixOther'"><xsl:text>PrefixOther</xsl:text></xsl:when>
<xsl:when test="$v = 'pres1'"><xsl:text>Pres1</xsl:text></xsl:when>
<xsl:when test="$v = 'pres2'"><xsl:text>Pres2</xsl:text></xsl:when>
<xsl:when test="$v = 'presClass'"><xsl:text>PresClass</xsl:text></xsl:when>
<xsl:when test="$v = 'presHab'"><xsl:text>PresHab</xsl:text></xsl:when>
<xsl:when test="$v = 'presIngr'"><xsl:text>PresIngr</xsl:text></xsl:when>
<xsl:when test="$v = 'presPerf'"><xsl:text>PresPerf</xsl:text></xsl:when>
<xsl:when test="$v = 'presProg'"><xsl:text>PresProg</xsl:text></xsl:when>
<xsl:when test="$v = 'presProgr'"><xsl:text>PresProgr</xsl:text></xsl:when>
<xsl:when test="$v = 'presPunct'"><xsl:text>PresPunct</xsl:text></xsl:when>
<xsl:when test="$v = 'presQ'"><xsl:text>PresQ</xsl:text></xsl:when>
<xsl:when test="$v = 'presSgClass'"><xsl:text>PresSgClass</xsl:text></xsl:when>
<xsl:when test="$v = 'presenProgressive'"><xsl:text>PresenProgressive</xsl:text></xsl:when>
<xsl:when test="$v = 'present'"><xsl:text>Present</xsl:text></xsl:when>
<xsl:when test="$v = 'present conditionals'"><xsl:text>PresentConditionals</xsl:text></xsl:when>
<xsl:when test="$v = 'presentContinuous'"><xsl:text>PresentContinuous</xsl:text></xsl:when>
<xsl:when test="$v = 'presentDur'"><xsl:text>PresentDur</xsl:text></xsl:when>
<xsl:when test="$v = 'presentFuture'"><xsl:text>PresentFuture</xsl:text></xsl:when>
<xsl:when test="$v = 'presentGeneral'"><xsl:text>PresentGeneral</xsl:text></xsl:when>
<xsl:when test="$v = 'presentHabitual'"><xsl:text>PresentHabitual</xsl:text></xsl:when>
<xsl:when test="$v = 'presentIngressive'"><xsl:text>PresentIngressive</xsl:text></xsl:when>
<xsl:when test="$v = 'presentIngressiveA'"><xsl:text>PresentIngressiveA</xsl:text></xsl:when>
<xsl:when test="$v = 'presentIngressiveB'"><xsl:text>PresentIngressiveB</xsl:text></xsl:when>
<xsl:when test="$v = 'presentInterrog'"><xsl:text>PresentInterrog</xsl:text></xsl:when>
<xsl:when test="$v = 'presentParticiple'"><xsl:text>PresentParticiple</xsl:text></xsl:when>
<xsl:when test="$v = 'presentParticitpl'"><xsl:text>PresentParticitpl</xsl:text></xsl:when>
<xsl:when test="$v = 'presentPerfect'"><xsl:text>PresentPerfect</xsl:text></xsl:when>
<xsl:when test="$v = 'presentPerfective'"><xsl:text>PresentPerfective</xsl:text></xsl:when>
<xsl:when test="$v = 'presentProgressive'"><xsl:text>PresentProgressive</xsl:text></xsl:when>
<xsl:when test="$v = 'presentProgressive2'"><xsl:text>PresentProgressive2</xsl:text></xsl:when>
<xsl:when test="$v = 'presentRel'"><xsl:text>PresentRel</xsl:text></xsl:when>
<xsl:when test="$v = 'presentShort'"><xsl:text>PresentShort</xsl:text></xsl:when>
<xsl:when test="$v = 'presentState1'"><xsl:text>PresentState1</xsl:text></xsl:when>
<xsl:when test="$v = 'presentState2'"><xsl:text>PresentState2</xsl:text></xsl:when>
<xsl:when test="$v = 'pretDubit'"><xsl:text>PretDubit</xsl:text></xsl:when>
<xsl:when test="$v = 'pretEgr'"><xsl:text>PretEgr</xsl:text></xsl:when>
<xsl:when test="$v = 'pretHab'"><xsl:text>PretHab</xsl:text></xsl:when>
<xsl:when test="$v = 'pretIngr'"><xsl:text>PretIngr</xsl:text></xsl:when>
<xsl:when test="$v = 'pretProgr'"><xsl:text>PretProgr</xsl:text></xsl:when>
<xsl:when test="$v = 'preterite'"><xsl:text>Preterite</xsl:text></xsl:when>
<xsl:when test="$v = 'preteriteDubitative'"><xsl:text>PreteriteDubitative</xsl:text></xsl:when>
<xsl:when test="$v = 'preteriteEgressive'"><xsl:text>PreteriteEgressive</xsl:text></xsl:when>
<xsl:when test="$v = 'preteriteIngressive'"><xsl:text>PreteriteIngressive</xsl:text></xsl:when>
<xsl:when test="$v = 'preteritePerfect'"><xsl:text>PreteritePerfect</xsl:text></xsl:when>
<xsl:when test="$v = 'preteritePerfectB'"><xsl:text>PreteritePerfectB</xsl:text></xsl:when>
<xsl:when test="$v = 'preventive'"><xsl:text>Preventive</xsl:text></xsl:when>
<xsl:when test="$v = 'pro'"><xsl:text>Pronoun</xsl:text></xsl:when>
<xsl:when test="$v = 'pro2ary'"><xsl:text>Pronoun2ary</xsl:text></xsl:when>
<xsl:when test="$v = 'proAgreement'"><xsl:text>PronounAgreement</xsl:text></xsl:when>
<xsl:when test="$v = 'proEmph'"><xsl:text>PronounEmph</xsl:text></xsl:when>
<xsl:when test="$v = 'proInd'"><xsl:text>PronounInd</xsl:text></xsl:when>
<xsl:when test="$v = 'proIndClit'"><xsl:text>PronounIndClit</xsl:text></xsl:when>
<xsl:when test="$v = 'proParticle'"><xsl:text>PronounParticle</xsl:text></xsl:when>
<xsl:when test="$v = 'proSetA'"><xsl:text>PronounSetA</xsl:text></xsl:when>
<xsl:when test="$v = 'proSetB'"><xsl:text>PronounSetB</xsl:text></xsl:when>
<xsl:when test="$v = 'proSuff'"><xsl:text>PronounSuffix</xsl:text></xsl:when>
<xsl:when test="$v = 'probable'"><xsl:text>Probable</xsl:text></xsl:when>
<xsl:when test="$v = 'processive'"><xsl:text>Processive</xsl:text></xsl:when>
<xsl:when test="$v = 'proclitic'"><xsl:text>Proclitic</xsl:text></xsl:when>
<xsl:when test="$v = 'proclitic which attaches to verb or other focused constitutent'"><xsl:text>Proclitic</xsl:text></xsl:when>
<xsl:when test="$v = 'progDur'"><xsl:text>ProgressiveDuration</xsl:text></xsl:when>
<xsl:when test="$v = 'progressive'"><xsl:text>Progressive</xsl:text></xsl:when>
<xsl:when test="$v = 'progressiveSub'"><xsl:text>ProgressiveSub</xsl:text></xsl:when>
<xsl:when test="$v = 'prohibitative'"><xsl:text>Prohibitative</xsl:text></xsl:when>
<xsl:when test="$v = 'prohibitive'"><xsl:text>Prohibitive</xsl:text></xsl:when>
<xsl:when test="$v = 'pronominal'"><xsl:text>Pronominal</xsl:text></xsl:when>
<xsl:when test="$v = 'pronoun'"><xsl:text>Pronoun</xsl:text></xsl:when>
<xsl:when test="$v = 'pronounClitic'"><xsl:text>PronounClitic</xsl:text></xsl:when>
<xsl:when test="$v = 'pronounIndependent'"><xsl:text>PronounIndependent</xsl:text></xsl:when>
<xsl:when test="$v = 'prospective'"><xsl:text>Prospective</xsl:text></xsl:when>
<xsl:when test="$v = 'protasis'"><xsl:text>Protasis</xsl:text></xsl:when>
<xsl:when test="$v = 'proximal'"><xsl:text>Proximal</xsl:text></xsl:when>
<xsl:when test="$v = 'proximal2'"><xsl:text>Proximal2</xsl:text></xsl:when>
<xsl:when test="$v = 'purposive'"><xsl:text>Purposive</xsl:text></xsl:when>
<xsl:when test="$v = 'purposive1'"><xsl:text>Purposive1</xsl:text></xsl:when>
<xsl:when test="$v = 'purposive2'"><xsl:text>Purposive2</xsl:text></xsl:when>
<xsl:when test="$v = 'purposiveSub'"><xsl:text>PurposiveSub</xsl:text></xsl:when>
<xsl:when test="$v = 'reciprocal'"><xsl:text>Reciprocal</xsl:text></xsl:when>
<xsl:when test="$v = 'reciprocal+caus'"><xsl:text>Reciprocal+caus</xsl:text></xsl:when>
<xsl:when test="$v = 'reduced'"><xsl:text>Reduced</xsl:text></xsl:when>
<xsl:when test="$v = 'reducedNasal'"><xsl:text>ReducedNasal</xsl:text></xsl:when>
<xsl:when test="$v = 'reduplicated'"><xsl:text>Reduplicated</xsl:text></xsl:when>
<xsl:when test="$v = 'reduplication'"><xsl:text>Reduplication</xsl:text></xsl:when>
<xsl:when test="$v = 'refSwitch'"><xsl:text>RefSwitch</xsl:text></xsl:when>
<xsl:when test="$v = 'referentSubj'"><xsl:text>ReferentSubj</xsl:text></xsl:when>
<xsl:when test="$v = 'reflEmph'"><xsl:text>ReflexiveEmph</xsl:text></xsl:when>
<xsl:when test="$v = 'reflPoss'"><xsl:text>ReflexivePoss</xsl:text></xsl:when>
<xsl:when test="$v = 'reflexive'"><xsl:text>Reflexive</xsl:text></xsl:when>
<xsl:when test="$v = 'reflexiveObj'"><xsl:text>ReflexiveObj</xsl:text></xsl:when>
<xsl:when test="$v = 'reflexivization'"><xsl:text>Reflexivization</xsl:text></xsl:when>
<xsl:when test="$v = 'regular'"><xsl:text>Regular</xsl:text></xsl:when>
<xsl:when test="$v = 'relObliq'"><xsl:text>RelObliq</xsl:text></xsl:when>
<xsl:when test="$v = 'relOblique'"><xsl:text>RelOblique</xsl:text></xsl:when>
<xsl:when test="$v = 'relSubj'"><xsl:text>RelSubj</xsl:text></xsl:when>
<xsl:when test="$v = 'relSuff'"><xsl:text>RelSuffix</xsl:text></xsl:when>
<xsl:when test="$v = 'relative'"><xsl:text>Relative</xsl:text></xsl:when>
<xsl:when test="$v = 'relativeCovert'"><xsl:text>RelativeCovert</xsl:text></xsl:when>
<xsl:when test="$v = 'relativeIndeterminate'"><xsl:text>RelativeIndeterminate</xsl:text></xsl:when>
<xsl:when test="$v = 'relativeOblique'"><xsl:text>RelativeOblique</xsl:text></xsl:when>
<xsl:when test="$v = 'relativeOvert'"><xsl:text>RelativeOvert</xsl:text></xsl:when>
<xsl:when test="$v = 'relativePast'"><xsl:text>RelativePast</xsl:text></xsl:when>
<xsl:when test="$v = 'relativePresent'"><xsl:text>RelativePresent</xsl:text></xsl:when>
<xsl:when test="$v = 'relativeSubject'"><xsl:text>RelativeSubject</xsl:text></xsl:when>
<xsl:when test="$v = 'repeat'"><xsl:text>Repeat</xsl:text></xsl:when>
<xsl:when test="$v = 'repetitive'"><xsl:text>Repetitive</xsl:text></xsl:when>
<xsl:when test="$v = 'requestive'"><xsl:text>Requestive</xsl:text></xsl:when>
<xsl:when test="$v = 'requestive--p1Only'"><xsl:text>Requestive--p1Only</xsl:text></xsl:when>
<xsl:when test="$v = 'restrictive'"><xsl:text>Restrictive</xsl:text></xsl:when>
<xsl:when test="$v = 'result'"><xsl:text>Result</xsl:text></xsl:when>
<xsl:when test="$v = 'risingIntonation'"><xsl:text>RisingIntonation</xsl:text></xsl:when>
<xsl:when test="$v = 'rootForm'"><xsl:text>RootForm</xsl:text></xsl:when>
<xsl:when test="$v = 'rootStructure'"><xsl:text>RootStructure</xsl:text></xsl:when>
<xsl:when test="$v = 's-Class'"><xsl:text>S-Class</xsl:text></xsl:when>
<xsl:when test="$v = 'sahidic'"><xsl:text>Sahidic</xsl:text></xsl:when>
<xsl:when test="$v = 'saho'"><xsl:text>Saho</xsl:text></xsl:when>
<xsl:when test="$v = 'sameSubjOvlp'"><xsl:text>SameSubjOvlp</xsl:text></xsl:when>
<xsl:when test="$v = 'sameSubjSucc'"><xsl:text>SameSubjSucc</xsl:text></xsl:when>
<xsl:when test="$v = 'seSuff'"><xsl:text>SeSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'selBE'"><xsl:text>SelBE</xsl:text></xsl:when>
<xsl:when test="$v = 'selBEImpersHit'"><xsl:text>SelBEImpersHit</xsl:text></xsl:when>
<xsl:when test="$v = 'selBENom'"><xsl:text>SelBENom</xsl:text></xsl:when>
<xsl:when test="$v = 'selBEObj'"><xsl:text>SelBEObj</xsl:text></xsl:when>
<xsl:when test="$v = 'selBEVerb'"><xsl:text>SelBEVerb</xsl:text></xsl:when>
<xsl:when test="$v = 'selMood'"><xsl:text>SelMood</xsl:text></xsl:when>
<xsl:when test="$v = 'selTense'"><xsl:text>SelTense</xsl:text></xsl:when>
<xsl:when test="$v = 'sel_sem'"><xsl:text>Sel_sem</xsl:text></xsl:when>
<xsl:when test="$v = 'sel_stem'"><xsl:text>Sel_stem</xsl:text></xsl:when>
<xsl:when test="$v = 'selector'"><xsl:text>Selector</xsl:text></xsl:when>
<xsl:when test="$v = 'selectorForms'"><xsl:text>SelectorForms</xsl:text></xsl:when>
<xsl:when test="$v = 'selectorForms2'"><xsl:text>SelectorForms2</xsl:text></xsl:when>
<xsl:when test="$v = 'selectorStructure'"><xsl:text>SelectorStructure</xsl:text></xsl:when>
<xsl:when test="$v = 'semelfactive'"><xsl:text>Semelfactive</xsl:text></xsl:when>
<xsl:when test="$v = 'sentenceType'"><xsl:text>SentenceType</xsl:text></xsl:when>
<xsl:when test="$v = 'separative'"><xsl:text>Separative</xsl:text></xsl:when>
<xsl:when test="$v = 'sequential'"><xsl:text>Sequential</xsl:text></xsl:when>
<xsl:when test="$v = 'sequential same subject'"><xsl:text>Sequential_Same_Subject</xsl:text></xsl:when>
<xsl:when test="$v = 'sequential/simultaneous same subject'"><xsl:text>SequentialSimultaneous_Same_Subject</xsl:text></xsl:when>
<xsl:when test="$v = 'sequentialSel'"><xsl:text>SequentialSel</xsl:text></xsl:when>
<xsl:when test="$v = 'sg'"><xsl:text>Singular</xsl:text></xsl:when>
<xsl:when test="$v = 'shaww-ush-'"><xsl:text>Shaww-ush-</xsl:text></xsl:when>
<xsl:when test="$v = 'shinassha'"><xsl:text>Shinassha</xsl:text></xsl:when>
<xsl:when test="$v = 'shiver'"><xsl:text>Shiver</xsl:text></xsl:when>
<xsl:when test="$v = 'short'"><xsl:text>Short</xsl:text></xsl:when>
<xsl:when test="$v = 'shortPerfect'"><xsl:text>ShortPerfect</xsl:text></xsl:when>
<xsl:when test="$v = 'sidaama'"><xsl:text>Sidaama</xsl:text></xsl:when>
<xsl:when test="$v = 'similative'"><xsl:text>Similative</xsl:text></xsl:when>
<xsl:when test="$v = 'simple'"><xsl:text>Simple</xsl:text></xsl:when>
<xsl:when test="$v = 'simplePast'"><xsl:text>SimplePast</xsl:text></xsl:when>
<xsl:when test="$v = 'simplePerf'"><xsl:text>SimplePerf</xsl:text></xsl:when>
<xsl:when test="$v = 'simplePerfect'"><xsl:text>SimplePerfect</xsl:text></xsl:when>
<xsl:when test="$v = 'simultaneous'"><xsl:text>Simultaneous</xsl:text></xsl:when>
<xsl:when test="$v = 'singulative'"><xsl:text>Singulative</xsl:text></xsl:when>
<xsl:when test="$v = 'somali'"><xsl:text>Somali</xsl:text></xsl:when>
<xsl:when test="$v = 'spatial'"><xsl:text>Spatial</xsl:text></xsl:when>
<xsl:when test="$v = 'ssaClass'"><xsl:text>SsaClass</xsl:text></xsl:when>
<xsl:when test="$v = 'sseClass'"><xsl:text>SseClass</xsl:text></xsl:when>
<xsl:when test="$v = 'stand'"><xsl:text>Stand</xsl:text></xsl:when>
<xsl:when test="$v = 'standard'"><xsl:text>Standard</xsl:text></xsl:when>
<xsl:when test="$v = 'stative'"><xsl:text>Stative</xsl:text></xsl:when>
<xsl:when test="$v = 'stativeIrregular'"><xsl:text>StativeIrregular</xsl:text></xsl:when>
<xsl:when test="$v = 'stem'"><xsl:text>Stem</xsl:text></xsl:when>
<xsl:when test="$v = 'stemForm'"><xsl:text>StemForm</xsl:text></xsl:when>
<xsl:when test="$v = 'stemFormation'"><xsl:text>StemFormation</xsl:text></xsl:when>
<xsl:when test="$v = 'stemQ'"><xsl:text>StemQ</xsl:text></xsl:when>
<xsl:when test="$v = 'structure'"><xsl:text>Structure</xsl:text></xsl:when>
<xsl:when test="$v = 'subAdv'"><xsl:text>SubAdv</xsl:text></xsl:when>
<xsl:when test="$v = 'subClass1'"><xsl:text>SubClass1</xsl:text></xsl:when>
<xsl:when test="$v = 'subClass2'"><xsl:text>SubClass2</xsl:text></xsl:when>
<xsl:when test="$v = 'subj-focus'"><xsl:text>Subj-focus</xsl:text></xsl:when>
<xsl:when test="$v = 'subj3sgImperf'"><xsl:text>Subj3sgImperf</xsl:text></xsl:when>
<xsl:when test="$v = 'subjAgr'"><xsl:text>SubjAgr</xsl:text></xsl:when>
<xsl:when test="$v = 'subjClit'"><xsl:text>SubjClit</xsl:text></xsl:when>
<xsl:when test="$v = 'subjFocus'"><xsl:text>SubjFocus</xsl:text></xsl:when>
<xsl:when test="$v = 'subjFocus_obj'"><xsl:text>SubjFocus_obj</xsl:text></xsl:when>
<xsl:when test="$v = 'subjFocus_tense'"><xsl:text>SubjFocus_tense</xsl:text></xsl:when>
<xsl:when test="$v = 'subjMarker'"><xsl:text>SubjMarker</xsl:text></xsl:when>
<xsl:when test="$v = 'subjMarkerConnConj'"><xsl:text>SubjMarkerConnConj</xsl:text></xsl:when>
<xsl:when test="$v = 'subjMarkerInfinSub'"><xsl:text>SubjMarkerInfinSub</xsl:text></xsl:when>
<xsl:when test="$v = 'subjMarkerMain'"><xsl:text>SubjMarkerMain</xsl:text></xsl:when>
<xsl:when test="$v = 'subjMarkerRed'"><xsl:text>SubjMarkerRed</xsl:text></xsl:when>
<xsl:when test="$v = 'subjMarkerSelStem'"><xsl:text>SubjMarkerSelStem</xsl:text></xsl:when>
<xsl:when test="$v = 'subjMarkerSuff'"><xsl:text>SubjMarkerSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'subjMarkerTemplates'"><xsl:text>SubjMarkerTemplates</xsl:text></xsl:when>
<xsl:when test="$v = 'subjMarkers'"><xsl:text>SubjMarkers</xsl:text></xsl:when>
<xsl:when test="$v = 'subjPlImperf'"><xsl:text>SubjPlImperf</xsl:text></xsl:when>
<xsl:when test="$v = 'subjPlPerf'"><xsl:text>SubjPlPerf</xsl:text></xsl:when>
<xsl:when test="$v = 'subjPref'"><xsl:text>SubjPref</xsl:text></xsl:when>
<xsl:when test="$v = 'subjPrefV'"><xsl:text>SubjPrefV</xsl:text></xsl:when>
<xsl:when test="$v = 'subjProclitic'"><xsl:text>SubjProclitic</xsl:text></xsl:when>
<xsl:when test="$v = 'subjRel'"><xsl:text>SubjRel</xsl:text></xsl:when>
<xsl:when test="$v = 'subjRelClause-objMarking'"><xsl:text>SubjRelClause-objMarking</xsl:text></xsl:when>
<xsl:when test="$v = 'subjRelClause-subjMarking'"><xsl:text>SubjRelClause-subjMarking</xsl:text></xsl:when>
<xsl:when test="$v = 'subjSuff'"><xsl:text>SubjSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'subjSuffAllomorph'"><xsl:text>SubjSuffAllomorph</xsl:text></xsl:when>
<xsl:when test="$v = 'subjSuffInterr'"><xsl:text>SubjSuffInterr</xsl:text></xsl:when>
<xsl:when test="$v = 'subjSuffStemClass'"><xsl:text>SubjSuffStemClass</xsl:text></xsl:when>
<xsl:when test="$v = 'subjSuffV'"><xsl:text>SubjSuffV</xsl:text></xsl:when>
<xsl:when test="$v = 'subjTypeSel'"><xsl:text>SubjTypeSel</xsl:text></xsl:when>
<xsl:when test="$v = 'subj_obj'"><xsl:text>Subj_obj</xsl:text></xsl:when>
<xsl:when test="$v = 'subj_objFocus_obj_Tense'"><xsl:text>Subj_objFocus_obj_Tense</xsl:text></xsl:when>
<xsl:when test="$v = 'subj_obj_completive'"><xsl:text>Subj_obj_completive</xsl:text></xsl:when>
<xsl:when test="$v = 'subj_obj_future1'"><xsl:text>Subj_obj_future1</xsl:text></xsl:when>
<xsl:when test="$v = 'subj_obj_future2'"><xsl:text>Subj_obj_future2</xsl:text></xsl:when>
<xsl:when test="$v = 'subj_obj_habitual'"><xsl:text>Subj_obj_habitual</xsl:text></xsl:when>
<xsl:when test="$v = 'subj_obj_pres_concessive'"><xsl:text>Subj_obj_pres_concessive</xsl:text></xsl:when>
<xsl:when test="$v = 'subj_obj_pret'"><xsl:text>Subj_obj_pret</xsl:text></xsl:when>
<xsl:when test="$v = 'subj_obj_pret_sequential'"><xsl:text>Subj_obj_pret_sequential</xsl:text></xsl:when>
<xsl:when test="$v = 'subj_obj_prospective'"><xsl:text>Subj_obj_prospective</xsl:text></xsl:when>
<xsl:when test="$v = 'subj_obj_tense'"><xsl:text>Subj_obj_tense</xsl:text></xsl:when>
<xsl:when test="$v = 'subj_relative_obj_pres'"><xsl:text>Subj_relative_obj_pres</xsl:text></xsl:when>
<xsl:when test="$v = 'subj_relative_tense'"><xsl:text>Subj_relative_tense</xsl:text></xsl:when>
<xsl:when test="$v = 'subj_tense'"><xsl:text>Subj_tense</xsl:text></xsl:when>
<xsl:when test="$v = 'subj_tense_concessive'"><xsl:text>Subj_tense_concessive</xsl:text></xsl:when>
<xsl:when test="$v = 'subject'"><xsl:text>Subject</xsl:text></xsl:when>
<xsl:when test="$v = 'subjunctive'"><xsl:text>Subjunctive</xsl:text></xsl:when>
<xsl:when test="$v = 'subjunctiveSuff'"><xsl:text>SubjunctiveSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'subjunctivepdgmLex'"><xsl:text>SubjunctivepdgmLex</xsl:text></xsl:when>
<xsl:when test="$v = 'subjunctivepolarity'"><xsl:text>Subjunctivepolarity</xsl:text></xsl:when>
<xsl:when test="$v = 'subordiate'"><xsl:text>Subordiate</xsl:text></xsl:when>
<xsl:when test="$v = 'subordinate'"><xsl:text>Subordinate</xsl:text></xsl:when>
<xsl:when test="$v = 'subordinateVariant'"><xsl:text>SubordinateVariant</xsl:text></xsl:when>
<xsl:when test="$v = 'suffAlternate'"><xsl:text>SuffAlternate</xsl:text></xsl:when>
<xsl:when test="$v = 'suffComp'"><xsl:text>SuffComp</xsl:text></xsl:when>
<xsl:when test="$v = 'suffSet1'"><xsl:text>SuffSet1</xsl:text></xsl:when>
<xsl:when test="$v = 'suffSet2'"><xsl:text>SuffSet2</xsl:text></xsl:when>
<xsl:when test="$v = 'suffSet3'"><xsl:text>SuffSet3</xsl:text></xsl:when>
<xsl:when test="$v = 'suffSet4'"><xsl:text>SuffSet4</xsl:text></xsl:when>
<xsl:when test="$v = 'suffSet5'"><xsl:text>SuffSet5</xsl:text></xsl:when>
<xsl:when test="$v = 'suffStructure'"><xsl:text>SuffStructure</xsl:text></xsl:when>
<xsl:when test="$v = 'suffV'"><xsl:text>SuffV</xsl:text></xsl:when>
<xsl:when test="$v = 'suffix'"><xsl:text>Suffix</xsl:text></xsl:when>
<xsl:when test="$v = 'suffix1'"><xsl:text>Suffix1</xsl:text></xsl:when>
<xsl:when test="$v = 'suffix2'"><xsl:text>Suffix2</xsl:text></xsl:when>
<xsl:when test="$v = 'suffix3'"><xsl:text>Suffix3</xsl:text></xsl:when>
<xsl:when test="$v = 'suffix4'"><xsl:text>Suffix4</xsl:text></xsl:when>
<xsl:when test="$v = 'suffixClass'"><xsl:text>SuffixClass</xsl:text></xsl:when>
<xsl:when test="$v = 'suffixIrregular'"><xsl:text>SuffixIrregular</xsl:text></xsl:when>
<xsl:when test="$v = 'suffixPron'"><xsl:text>SuffixPron</xsl:text></xsl:when>
<xsl:when test="$v = 'suffixation'"><xsl:text>Suffixation</xsl:text></xsl:when>
<xsl:when test="$v = 'suffixes'"><xsl:text>Suffixes</xsl:text></xsl:when>
<xsl:when test="$v = 'suffocate'"><xsl:text>Suffocate</xsl:text></xsl:when>
<xsl:when test="$v = 'suppletive'"><xsl:text>Suppletive</xsl:text></xsl:when>
<xsl:when test="$v = 'syriac'"><xsl:text>Syriac</xsl:text></xsl:when>
<xsl:when test="$v = 't-Extension'"><xsl:text>T-Extension</xsl:text></xsl:when>
<xsl:when test="$v = 'tSuff'"><xsl:text>TSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'taSuff'"><xsl:text>TaSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'tam'"><xsl:text>Tam</xsl:text></xsl:when>
<xsl:when test="$v = 'template'"><xsl:text>Template</xsl:text></xsl:when>
<xsl:when test="$v = 'temporal'"><xsl:text>Temporal</xsl:text></xsl:when>
<xsl:when test="$v = 'temporal1'"><xsl:text>Temporal1</xsl:text></xsl:when>
<xsl:when test="$v = 'temporal2'"><xsl:text>Temporal2</xsl:text></xsl:when>
<xsl:when test="$v = 'temporalSubordinate'"><xsl:text>TemporalSubordinate</xsl:text></xsl:when>
<xsl:when test="$v = 'tenseAspOverview'"><xsl:text>TenseAspOverview</xsl:text></xsl:when>
<xsl:when test="$v = 'tenseAspSuff'"><xsl:text>TenseAspSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'tenseAspectMarking'"><xsl:text>TenseAspectMarking</xsl:text></xsl:when>
<xsl:when test="$v = 'tenseAspectMoodPref'"><xsl:text>TenseAspectMoodPref</xsl:text></xsl:when>
<xsl:when test="$v = 'tenseFormation'"><xsl:text>TenseFormation</xsl:text></xsl:when>
<xsl:when test="$v = 'tenseFormation1'"><xsl:text>TenseFormation1</xsl:text></xsl:when>
<xsl:when test="$v = 'tenseFormation2'"><xsl:text>TenseFormation2</xsl:text></xsl:when>
<xsl:when test="$v = 'tensePersNumGenTemplate'"><xsl:text>TensePersNumGenTemplate</xsl:text></xsl:when>
<xsl:when test="$v = 'tenseSel'"><xsl:text>TenseSel</xsl:text></xsl:when>
<xsl:when test="$v = 'tenseSuffSets'"><xsl:text>TenseSuffSets</xsl:text></xsl:when>
<xsl:when test="$v = 'tensefutProx'"><xsl:text>TensefutProx</xsl:text></xsl:when>
<xsl:when test="$v = 'terminative'"><xsl:text>Terminative</xsl:text></xsl:when>
<xsl:when test="$v = 'thatArea'"><xsl:text>ThatArea</xsl:text></xsl:when>
<xsl:when test="$v = 'theme'"><xsl:text>Theme</xsl:text></xsl:when>
<xsl:when test="$v = 'there'"><xsl:text>There</xsl:text></xsl:when>
<xsl:when test="$v = 'thisArea'"><xsl:text>ThisArea</xsl:text></xsl:when>
<xsl:when test="$v = 'ti-ndi'"><xsl:text>Ti-ndi</xsl:text></xsl:when>
<xsl:when test="$v = 'tnsAspModStem'"><xsl:text>TnsAspModStem</xsl:text></xsl:when>
<xsl:when test="$v = 'trans'"><xsl:text>Trans</xsl:text></xsl:when>
<xsl:when test="$v = 'transVerbPatterns'"><xsl:text>TransVerbPatterns</xsl:text></xsl:when>
<xsl:when test="$v = 'transitive'"><xsl:text>Transitive</xsl:text></xsl:when>
<xsl:when test="$v = 'transitivization'"><xsl:text>Transitivization</xsl:text></xsl:when>
<xsl:when test="$v = 'transitivization2arh'"><xsl:text>Transitivization2arh</xsl:text></xsl:when>
<xsl:when test="$v = 'transitivize'"><xsl:text>Transitivize</xsl:text></xsl:when>
<xsl:when test="$v = 'transitivize+caus'"><xsl:text>Transitivize+caus</xsl:text></xsl:when>
<xsl:when test="$v = 'tsamakko'"><xsl:text>Tsamakko</xsl:text></xsl:when>
<xsl:when test="$v = 'u-Form'"><xsl:text>U-Form</xsl:text></xsl:when>
<xsl:when test="$v = 'uClass'"><xsl:text>UClass</xsl:text></xsl:when>
<xsl:when test="$v = 'unit'"><xsl:text>Unit</xsl:text></xsl:when>
<xsl:when test="$v = 'unmrkStem'"><xsl:text>UnmrkStem</xsl:text></xsl:when>
<xsl:when test="$v = 'vFin1'"><xsl:text>VFin1</xsl:text></xsl:when>
<xsl:when test="$v = 'vFin2'"><xsl:text>VFin2</xsl:text></xsl:when>
<xsl:when test="$v = 'vNoun'"><xsl:text>VNoun</xsl:text></xsl:when>
<xsl:when test="$v = 'vStem+proEncl'"><xsl:text>VStem+proEncl'</xsl:text></xsl:when>
<xsl:when test="$v = 'vSubjSetA'"><xsl:text>VSubjSetA</xsl:text></xsl:when>
<xsl:when test="$v = 'vSubjSetB'"><xsl:text>VSubjSetB</xsl:text></xsl:when>
<xsl:when test="$v = 'var1'"><xsl:text>Var1</xsl:text></xsl:when>
<xsl:when test="$v = 'var2'"><xsl:text>Var2</xsl:text></xsl:when>
<xsl:when test="$v = 'varA'"><xsl:text>VarA</xsl:text></xsl:when>
<xsl:when test="$v = 'varB'"><xsl:text>VarB</xsl:text></xsl:when>
<xsl:when test="$v = 'varB1'"><xsl:text>VarB1</xsl:text></xsl:when>
<xsl:when test="$v = 'varB2'"><xsl:text>VarB2</xsl:text></xsl:when>
<xsl:when test="$v = 'varB3'"><xsl:text>VarB3</xsl:text></xsl:when>
<xsl:when test="$v = 'varBx'"><xsl:text>VarBx</xsl:text></xsl:when>
<xsl:when test="$v = 'variable'"><xsl:text>Variable</xsl:text></xsl:when>
<xsl:when test="$v = 'ventive'"><xsl:text>Ventive</xsl:text></xsl:when>
<xsl:when test="$v = 'ventive-numObj'"><xsl:text>Ventive-numObj</xsl:text></xsl:when>
<xsl:when test="$v = 'verb'"><xsl:text>Verb</xsl:text></xsl:when>
<xsl:when test="$v = 'verbFocus'"><xsl:text>VerbFocus</xsl:text></xsl:when>
<xsl:when test="$v = 'verbNegation'"><xsl:text>VerbNegation</xsl:text></xsl:when>
<xsl:when test="$v = 'verbStemStructure'"><xsl:text>VerbStemStructure</xsl:text></xsl:when>
<xsl:when test="$v = 'verbStems'"><xsl:text>VerbStems</xsl:text></xsl:when>
<xsl:when test="$v = 'verbSuff'"><xsl:text>VerbSuff</xsl:text></xsl:when>
<xsl:when test="$v = 'verbVsAdjNeg'"><xsl:text>VerbVsAdjNeg</xsl:text></xsl:when>
<xsl:when test="$v = 'verbal'"><xsl:text>Verbal</xsl:text></xsl:when>
<xsl:when test="$v = 'verbalNoun'"><xsl:text>VerbalNoun</xsl:text></xsl:when>
<xsl:when test="$v = 'verbaliser'"><xsl:text>Verbaliser</xsl:text></xsl:when>
<xsl:when test="$v = 'verbalnoun'"><xsl:text>Verbalnoun</xsl:text></xsl:when>
<xsl:when test="$v = 'veridical'"><xsl:text>Veridical</xsl:text></xsl:when>
<xsl:when test="$v = 'vetitive'"><xsl:text>Vetitive</xsl:text></xsl:when>
<xsl:when test="$v = 'voc'"><xsl:text>Voc</xsl:text></xsl:when>
<xsl:when test="$v = 'vocative'"><xsl:text>Vocative</xsl:text></xsl:when>
<xsl:when test="$v = 'vowel'"><xsl:text>Vowel</xsl:text></xsl:when>
<xsl:when test="$v = 'w-Class'"><xsl:text>W-Class</xsl:text></xsl:when>
<xsl:when test="$v = 'wCC'"><xsl:text>WCC</xsl:text></xsl:when>
<xsl:when test="$v = 'wPro'"><xsl:text>WPro</xsl:text></xsl:when>
<xsl:when test="$v = 'withObj'"><xsl:text>WithObj</xsl:text></xsl:when>
<xsl:when test="$v = 'woPro'"><xsl:text>WoPro</xsl:text></xsl:when>
<xsl:when test="$v = 'wolaytta'"><xsl:text>Wolaytta</xsl:text></xsl:when>
<xsl:when test="fn:matches(., 'x22a4')"><xsl:text>Common</xsl:text></xsl:when>
<xsl:when test="fn:matches(., 'x22a5')"><xsl:text>_NULL</xsl:text></xsl:when>
<xsl:when test="$v = 'yCC'"><xsl:text>YCC</xsl:text></xsl:when>
<xsl:when test="$v = 'yaaku'"><xsl:text>Yaaku</xsl:text></xsl:when>
<xsl:when test="$v = 'yemsa'"><xsl:text>Yemsa</xsl:text></xsl:when>

<xsl:when test="$v = 'how?'"><xsl:text>InterrogProHow</xsl:text></xsl:when>
<xsl:when test="$v = 'how_many?'"><xsl:text>InterrogProHowMany</xsl:text></xsl:when>
<xsl:when test="$v = 'what?'"><xsl:text>InterrogProWhat</xsl:text></xsl:when>
<xsl:when test="$v = 'when?'"><xsl:text>InterrogProWhen</xsl:text></xsl:when>
<xsl:when test="$v = 'where?'"><xsl:text>InterrogProWhere</xsl:text></xsl:when>
<xsl:when test="$v = 'who?'"><xsl:text>InterrogProWho</xsl:text></xsl:when>

<xsl:when test="$v = 'what'"><xsl:text>InterrogProWhat</xsl:text></xsl:when>
<xsl:when test="$v = 'when'"><xsl:text>InterrogProWhen</xsl:text></xsl:when>
<xsl:when test="$v = 'where'"><xsl:text>InterrogProWhere</xsl:text></xsl:when>
<xsl:when test="$v = 'which'"><xsl:text>InterrogProWhich</xsl:text></xsl:when>
<xsl:when test="$v = 'who'"><xsl:text>InterrogProWho</xsl:text></xsl:when>

<xsl:when test="$v = '⊤'"><xsl:text>Common</xsl:text></xsl:when>
<xsl:when test="$v = '⊥'"><xsl:text>_NULL</xsl:text></xsl:when>

	<xsl:when test="fn:matches(., '^[A-Z]$')">
      	  <xsl:value-of select="normalize-space(.)"/>
	  <!-- <xsl:message> -->
      	  <!--   <xsl:value-of select="../@type"/> -->
      	  <!--   <xsl:text> : </xsl:text> -->
      	  <!--   <xsl:value-of select="."/> -->
      	  <!--   <xsl:text> 		</xsl:text> -->
      	  <!--   <xsl:value-of select="fn:translate(normalize-space(.), '''', '')"/> -->
	  <!-- </xsl:message> -->
	</xsl:when>
	<xsl:when test="fn:matches(., '^[0-9]$')">
	  <!-- <xsl:message>NBR:  <xsl:value-of select="../@type"/><xsl:text> </xsl:text><xsl:value-of select="."/></xsl:message> -->
	  <xsl:choose>
	    <xsl:when test="../@type = 'pers'">
	      <xsl:value-of select="concat('Person', normalize-space(.))"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="fn:translate(normalize-space(.), '''', '')"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:when>
	<xsl:when test="fn:contains(../@type, 'gloss')">
	  <xsl:value-of select="fn:translate(normalize-space(.), '''', '')"/>
	</xsl:when>
	<xsl:when test="fn:contains(../@type, 'token')">
	  <xsl:value-of select="fn:translate(normalize-space(.), '''', '')"/>
	</xsl:when>
	<xsl:when test="fn:contains(../@type, 'label')">
	  <xsl:value-of select="fn:translate(normalize-space(.), '''', '')"/>
	</xsl:when>
	<xsl:when test="fn:starts-with($v, '''')">
	  <xsl:value-of select="fn:translate(normalize-space(.), '''', '')"/>
	</xsl:when>
	<xsl:when test="fn:matches($v, '⊤')">
	  <xsl:text>Common</xsl:text>
	</xsl:when>
	<xsl:when test="fn:matches($v, '^ *$')">
	  <!-- <xsl:message>REMOVING BLANK -->
	  <!-- <xsl:value-of select="../@type"/> -->
	  <!-- <xsl:text> = </xsl:text> -->
	  <!-- <xsl:value-of select="."/> -->
	  <!-- </xsl:message> -->
	  <xsl:text>_NULL</xsl:text>
	</xsl:when>
	<xsl:when test="fn:matches($v, '^$')">
	  <!-- <xsl:message>REMOVING EMPTY -->
	  <!-- <xsl:value-of select="../@type"/> -->
	  <!-- <xsl:text> = </xsl:text> -->
	  <!-- <xsl:value-of select="."/> -->
	  <!-- </xsl:message> -->
	  <xsl:text>_NULL</xsl:text>
	</xsl:when>
	<xsl:when test="fn:matches(., '^[a-z]$')">
	  <xsl:message>
	    UPCASING <xsl:value-of select="../@type"/>
	    <xsl:text> </xsl:text><xsl:value-of select="."/>
	  </xsl:message>
      	  <xsl:value-of select="aama:upcase-first(normalize-space(.))"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="normalize-space(.)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="pdgmlabel">
    <xsl:element name="pdgmlabel">
      <xsl:value-of select="fn:translate(normalize-space(.), '''', '')"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="pdgmnote">
    <xsl:element name="pdgmnote">
      <xsl:value-of select="fn:translate(normalize-space(.), '''', '')"/>
    </xsl:element>
  </xsl:template>


  <xsl:template match="prop[@type='pid']"/>

  <xsl:template match="prop[fn:matches(@type,'''''')]" priority="99">
<xsl:message>
  REMOVING EMPTY 3
</xsl:message>
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

  <xsl:function name="aama:upcase-first">
    <xsl:param name="str" as="xs:string"/>
    <xsl:sequence
      select="fn:concat(
			  fn:upper-case(fn:substring($str, 1, 1)),
			  fn:substring($str, 2))"
    />
  </xsl:function>

</xsl:stylesheet>
