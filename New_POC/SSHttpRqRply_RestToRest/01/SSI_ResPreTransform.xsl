<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:str="http://exslt.org/strings" xmlns:regexp="http://exslt.org/regular-expressions" extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig str">
	<xsl:output method="xml"/>
	<xsl:template match="/">
		<xsl:message>***responseheader Respcode=<xsl:value-of select="dp:response-header('x-dp-response-code')"/>
		</xsl:message>
		<!-- 
		<xsl:variable name="actions" select="dp:variable('var://context/SSI/actions')"/>
		 -->
		<dp:set-http-response-header name="'x-dp-response-code'" value="'-1'"/>
		<xsl:variable name="targetConfig" select="dp:variable('var://context/SSI/targetConfig')"/>
		<xsl:if test="not($targetConfig)">
			<xsl:message terminate="yes">targetConfig doesn't exist</xsl:message>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="(not(./node()) and (string-length(normalize-space($targetConfig/response/noPayload)) =0))">
				<xsl:message terminate="yes">Response INPUT can't be empty</xsl:message>
			</xsl:when>
			<xsl:when test="(not(./node()) and normalize-space($targetConfig/response/noPayload) !='')">
				<xsl:variable name="noPayload">
					<payload>
						<Blankmessage>no payload</Blankmessage>
					</payload>
				</xsl:variable>
				<dp:set-local-variable name="'var://local/PreTransformOut'" value="$noPayload"/>
				<xsl:message>noPayload <xsl:value-of select="$noPayload"/>
				</xsl:message>
			</xsl:when>
			<xsl:otherwise>
				<dp:set-local-variable name="'var://local/PreTransformOut'" value="."/>
				<xsl:message>Response payload2<xsl:copy-of select="."/>
				</xsl:message>
				<xsl:for-each select="$targetConfig/actions/action">
					<xsl:choose>
						<!--StripSOAP headers -->
						<xsl:when test="./@name='STRIP-SOAP'">
							<!-- Add soap envelop-->
							<xsl:message>Executing Strip SOAP action</xsl:message>
							<xsl:variable name="afterStripSoap">
								<xsl:copy-of select="dp:transform(dp:variable('var://context/SSI/action/StripSoap'),dp:local-variable('var://local/PreTransformOut'))"/>
							</xsl:variable>
							<dp:set-local-variable name="'var://local/PreTransformOut'" value="$afterStripSoap"/>
						</xsl:when>
						<xsl:when test="./@type='custom'">
							<xsl:message>Executing custom action</xsl:message>
							<xsl:variable name="afterCustom">
								<xsl:variable name="customFile" select="document($targetConfig/response/actions/action[@type='custom'])"/>
								<xsl:choose>
									<xsl:when test="$customFile">
										<xsl:copy-of select="dp:transform($targetConfig/response/actions/action[@type='custom'],dp:local-variable('var://local/PreTransformOut'))"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:message terminate="yes">The specified custom XSL doesn't exist</xsl:message>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<dp:set-local-variable name="'var://local/PreTransformOut'" value="$afterCustom"/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				<!--<xsl:otherwise>
				<xsl:message terminate="yes">targetConfig doesn't exist</xsl:message>
			</xsl:otherwise>-->
			</xsl:otherwise>
		</xsl:choose>
		<xsl:copy-of select="dp:local-variable('var://local/PreTransformOut')"/>
	</xsl:template>
</xsl:stylesheet>
