<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:xalan="http://xml.apache.org/xslt" xmlns:str="http://exslt.org/strings" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:dp="http://www.datapower.com/extensions" xmlns:date="http://exslt.org/dates-and-times" exclude-result-prefixes="xalan dp exsl str regexp date" extension-element-prefixes="dp">
	<xsl:output method="xml"/>
	<!-- This stylesheet is used to Authorize the user -->
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="normalize-space(dp:variable('var://context/ANZDP/Authorise/Enabled'))='Y'">
				<!--*******************************-->
				<xsl:variable name="authorizeValues" select="dp:variable('var://context/ANZ/Authorize')"/>
				<xsl:variable name="dn" select="string(container/identity/entry[@type='custom'])"/>
				<xsl:message>***dn=<xsl:value-of select="$dn"/>
				</xsl:message>
				<xsl:message>**Authorize=<xsl:copy-of select="$authorizeValues/attribute-value"/>
				</xsl:message>
				<xsl:variable name="isAuthorized">
					<xsl:call-template name="authorize">
						<!--<xsl:with-param name="matched" select="'no'"/>-->
						<xsl:with-param name="subDN" select="$dn"/>
						<xsl:with-param name="members" select="$authorizeValues"/>
						<!--<xsl:with-param name="operationName" select="$operName"/>-->
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$isAuthorized ='yes'">
						<xsl:element name="approved"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="declined"/>
					</xsl:otherwise>
				</xsl:choose>
				<!--*******************************-->
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="approved"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="authorize">
		<!--<xsl:param name="matched"/>-->
		<xsl:param name="subDN"/>
		<xsl:param name="members"/>
		<!--<xsl:param name="operationName"/>-->
		<xsl:for-each select="$members/attribute-value">
			<xsl:choose>
				<xsl:when test="$subDN= .">
					<xsl:text>yes</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>