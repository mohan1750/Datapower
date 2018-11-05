<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:dpfunc="http://www.datapower.com/extensions/functions" xmlns:date="http://exslt.org/dates-and-times" extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig dpfunc date">
	<xsl:output method="xml"/>
	<xsl:template match="/">
		<xsl:variable name="input" select="dp:variable('var://context/CT-RqOut')"/>
		<xsl:if test="$input = ''">
			<payload>
				<Blankmessage>no payload</Blankmessage>
			</payload>
			<xsl:message dp:priority="debug">payload in if</xsl:message>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>