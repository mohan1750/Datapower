<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:xalan="http://xml.apache.org/xslt" xmlns:str="http://exslt.org/strings" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:dp="http://www.datapower.com/extensions" xmlns:date="http://exslt.org/dates-and-times" exclude-result-prefixes="xalan dp exsl str regexp date" extension-element-prefixes="dp">
	<xsl:output method="xml"/>
	<!-- This stylesheet is used to Authenticate the user -->
	<xsl:template match="/">
		<xsl:copy-of select="identity/entry[@type='client-ssl']/dn"/>
	</xsl:template>
</xsl:stylesheet>