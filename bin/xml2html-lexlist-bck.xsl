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
	
	<xsl:template match="/">		<html>
			<head>
				<title><xsl:value-of select="$lang"/> Lexlist HTML Display</title>
			</head>
			<body bgcolor="#fffccc">
				<h1><xsl:value-of select="upper-case($lang)"/> LEXLISTS</h1>
				<xsl:if test="analysis/lexemes">
					<xsl:call-template name="lexemes"/>
					</xsl:if> 
				<xsl:if test="analysis/muterms">
					<xsl:call-template name="muterms"/>
					</xsl:if> 
			</body>
		</html>
	</xsl:template>

	<xsl:template name="lexemes">
		<p><h2>Paradigm Lexemes</h2></p>
		<table>
			<tbody>
				<tr>
					<th align="left">
						<u>Lexlabel</u>
					</th>
					<th align="left">
						ID
					</th>
					<th align="left">
						<u>Property-Value List</u>
					</th>
				</tr>
				<xsl:for-each select="//lexeme">
					<xsl:sort select="./prop[@type='lexlabel']/@val"/>
					<tr>
						<td><xsl:value-of select="./prop[@type='lexlabel']/@val"/></td>
<!--						<xsl:if test="@id='ID0'">-->
							<td><xsl:value-of select="@id"/><xsl:text>, </xsl:text>
<!--						</xsl:if>-->
					<xsl:for-each select="./prop">
							<xsl:value-of select="./@type"/>=<xsl:value-of select="./@val"/>
						<xsl:if test="position() != last()">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
							</td>								
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="muterms">
		<p><h2>Paradigm µ-Terms</h2></p>
		<table>
			<tbody>
				<tr>
					<th align="left">
						<u>µ-Term</u>
					</th>
					<th align="left">
						<u>Property-Value List</u>
					</th>
				</tr>
				<xsl:for-each select="//muterm">
					<xsl:sort select="./prop[@type='mulabel']/@val"/>
					<tr>
						<td><xsl:value-of select="./prop[@type='mulabel']/@val"/></td>
<!--						<xsl:if test="@id='ID0'">-->
						<td>id=<xsl:value-of select="@id"/><xsl:text>, </xsl:text>
<!--						</xsl:if>-->
					<xsl:for-each select="./prop">
							<xsl:value-of select="./@type"/>=<xsl:value-of select="./@val"/>
						<xsl:if test="position() != last()">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
					</td> 
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

</xsl:stylesheet>