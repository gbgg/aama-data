<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:aama="urn:aama:2010"
    xmlns:java="java:java.util.UUID"
    exclude-result-prefixes="xsl fn java"
    version="2.0">

	
	<xsl:output method="html" indent="yes" encoding="utf-8"/>
	
	<xsl:strip-space elements="*"/>
	
	<xsl:param name="lang" required="no"/>
	
	<xsl:variable name="aamaURI">
		<xsl:text>&lt;http://id.oi.uchicago.edu/aama/2013/</xsl:text>
	</xsl:variable>
	
	<!-- ################################################ -->
	
	<xsl:template match="/">
		<html>
			<head>
				<title><xsl:value-of select="$lang"/> Paradigm HTML Display</title>
			</head>
			<body bgcolor="#fffccc">
				<h1><xsl:value-of select="upper-case($lang)"/> PARADIGMS</h1>
				<xsl:if test="analysis/bibsource">
					<xsl:call-template name="bibsource"/>					
				</xsl:if>
				<xsl:if test="analysis/lexemes">
					<xsl:call-template name="lexemes"/>
					</xsl:if> 
				<xsl:if test="analysis/mu-terms">
					<xsl:call-template name="mu-terms"/>
					</xsl:if> 
				<xsl:call-template name="pdgm"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="bibsource">
		<p><h2>Paradigm Source</h2></p>
		<p><xsl:value-of select="analysis/bibsource/bibid"/></p>
	</xsl:template>

	<xsl:template name="lexemes">
		<p><h2>Paradigm Lexemes</h2></p>
		<table>
			<tbody>
				<tr>
					<th align="left">
						<u>Lexeme</u>
					</th>
					<th align="left">
						<u>Property</u>
					</th>
					<th/>
					<th align="left">
						<u>Value</u>
					</th>
				</tr>
				<xsl:for-each select="//lexeme">
					<xsl:sort select="./prop[@type='lexlabel']/@val"/>
					<tr>
						<td><xsl:value-of select="./prop[@type='lexlabel']/@val"/></td>
<!--						<xsl:if test="@id='ID0'">-->
							<td>id</td>
							<td>=</td>
							<td><xsl:value-of select="@id"/></td>
<!--						</xsl:if>-->
					</tr>
					<xsl:for-each select="./prop">
						<tr>
							<td/>
							<td><xsl:value-of select="./@type"/></td>
							<td>=</td>
							<td><xsl:value-of select="./@val"/></td>
						</tr>
					</xsl:for-each>
					<tr> 
						<td> ----- </td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="mu-terms">
		<p><h2>Paradigm µ-Terms</h2></p>
		<table>
			<tbody>
				<tr>
					<th align="left">
						<u>µ-Term</u>
					</th>
					<th align="left">
						<u>Property</u>
					</th>
					<th/>
					<th align="left">
						<u>Value</u>
					</th>
				</tr>
				<xsl:for-each select="//mu-term">
					<xsl:sort select="./prop[@type='mulabel']/@val"/>
					<tr>
						<td><xsl:value-of select="./prop[@type='mulabel']/@val"/></td>
<!--						<xsl:if test="@id='ID0'">-->
							<td>id</td>
							<td>=</td>
							<td><xsl:value-of select="@id"/></td>
<!--						</xsl:if>-->
					</tr>
					<xsl:for-each select="./prop">
						<tr>
							<td/>
							<td><xsl:value-of select="./@type"/></td>
							<td>=</td>
							<td><xsl:value-of select="./@val"/></td>
						</tr>
					</xsl:for-each>
					<tr> 
						<td> ----- </td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="pdgm">
		<h2>Paradigms</h2>
		<xsl:for-each select="//pdgm">
			<a>
				<xsl:attribute name="name" select="termcluster/@key"></xsl:attribute>
			</a>
			<b><u>Paradigm</u></b>: <i><xsl:value-of select="pdgmlabel"/></i>
			<xsl:if test="pdgmnote">
				<table>
					<tbody>
							<th valign="top" align="left">Note: </th>
							<td>
								<xsl:value-of select="pdgmnote"/>
							</td>
					</tbody>
				</table>
			</xsl:if>
			<table>
				<tbody>
					<tr>
						<td align="left" colspan="3"><u>Common Properties: </u></td>
					</tr>
<!--					<tr>
						<th align="left">	<u>Attribute</u></th>
						<th>=</th>
						<th align="left">	<u>Value</u></th>
					</tr>
-->					<tr/>
					<xsl:for-each select="common-properties/prop">
						<tr>
							<th align="left">
								<xsl:value-of select="@type"/>
							</th>
							<td>=</td>
							<td>
								<xsl:value-of select="@val"/>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
			<p/>
			<u>Forms: </u>
			<table border="0" cellpadding="5">
				<tr>
					<xsl:for-each select="termcluster/term[1]/prop">
						<!--						<xsl:sort select="@type='gender' and @val='Masc'" />
						<xsl:sort select="@type='person'"/>
						<xsl:sort select="@type='number'and @val='Singular'"/>-->
						<!--						<xsl:sort select="@type='gender' and @val='Masc'" />
						<xsl:sort select="@type='person'"/>
						<xsl:sort select="@type='number'and @val='Singular'"/>-->
						<th align="left">
							<xsl:value-of select="./@type"/>
						</th>
					</xsl:for-each>
				</tr>
				<xsl:for-each select="termcluster/term">
					<xsl:sort select="prop[@type='number']/@val" order="descending"/>
					<xsl:sort select="prop[@type='person']/@val"/>
					<xsl:sort select="prop[@type='gender']/@val" order="descending"/>
					<tr>
						<xsl:for-each select="prop">
<!--							<xsl:sort select="@type='gender' and @val='Masc'" />
							<xsl:sort select="@type='person'"/>
							<xsl:sort select="@type='number'and @val='Singular'"/>-->
<!--						<xsl:sort select="@type='number'"/>
							<xsl:sort select="@type='person'"/>
							<xsl:sort select="@type='gender'" />-->
							<td valign="top">
								<xsl:value-of select="./@val"/>
							</td>
						</xsl:for-each>
						<!--                <td width="50"/>-->
					</tr>

				</xsl:for-each>
			</table>
			<p/>
			<p>---------------</p>
			<p/>
		</xsl:for-each>
	</xsl:template>


</xsl:stylesheet>
