<xsl:stylesheet version="1.0" extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig str" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:str="http://exslt.org/strings" xmlns:regexp="http://exslt.org/regular-expressions">
	<xsl:template match="/">
		<xsl:variable name="TC_xsl" select="dp:variable('var://context/SSI/Rs/TCTransform')"/>
		<xsl:variable name="CS_xsl" select="dp:variable('var://context/SSI/Rs/CSTransform')"/>
		<xsl:variable name="TC_Stylesheet">
			<xsl:if test="not(contains($TC_xsl,'copyTemplate.xsl'))">
				<xsl:value-of select="$TC_xsl"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="CS_Stylesheet">
			<xsl:if test="not(contains($CS_xsl,'copyTemplate.xsl'))">
				<xsl:value-of select="$CS_xsl"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="Route" select="."/>
		<xsl:message> Route:: <xsl:copy-of select="$Route"/>
		</xsl:message>
		<xsl:variable name="Url_response">
			<xsl:if test="$Route != ''">
				<xsl:copy-of select="$Route/url-open/response/*"/>
			</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$TC_Stylesheet != ''">
				<xsl:copy-of select="dp:transform($TC_Stylesheet,$Url_response)"/>
			</xsl:when>
			<xsl:when test="$CS_Stylesheet != ''">
				<xsl:copy-of select="dp:transform($CS_Stylesheet,$Url_response)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$Url_response"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:variable name="respCode">
			<xsl:copy-of select="$Route/url-open/responsecode"/>
		</xsl:variable>
		<xsl:message> respCode:: <xsl:value-of select="$respCode"/>
		</xsl:message>
		<xsl:message> Final respCode:: <xsl:value-of select="concat($respCode,' OK')"/>
		</xsl:message>
		<dp:set-http-response-header value="concat($respCode,' OK')" name="'x-dp-response-code'"/>
	</xsl:template>
</xsl:stylesheet>
