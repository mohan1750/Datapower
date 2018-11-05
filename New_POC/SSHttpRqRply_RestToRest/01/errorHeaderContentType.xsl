<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" extension-element-prefixes="dp" exclude-result-prefixes="dp">
	<xsl:template match="/">
		<xsl:variable name="errorConfig" select="dp:variable('var://context/SSI/errorConfig')"/>
		<xsl:choose>
			<xsl:when test="dp:variable('var://context/ANZ/contentType')">
<!--			
	<dp:set-variable name="'var://service/set-response-header/Content-Type'" value="dp:variable('var://context/ANZ/contentType')"/>
-->
<dp:set-http-request-header name="'Content-Type'" value="dp:variable('var://context/ANZ/contentType')"/>
<dp:set-http-response-header name="'Content-Type'" value="dp:variable('var://context/ANZ/contentType')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$errorConfig/errorHandler/params/errContentType">
						<dp:set-http-request-header name="'Content-Type'" value="$errorConfig/errorHandler/params/errContentType"/>
<dp:set-http-response-header name="'Content-Type'" value="$errorConfig/errorHandler/params/errContentType"/>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>