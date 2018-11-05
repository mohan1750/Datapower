<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:str="http://exslt.org/strings" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:func="http://exslt.org/functions" extension-element-prefixes="dp func" xmlns:util="http://www.anz.com/utilities" exclude-result-prefixes="dp dpconfig str func regexp util">
	<!--<dp:input-mapping href="local:///ondisk/services/SSPHTTPRqRplyOutward/01/dataProcess.ffd" type="ffd"/>-->
	<xsl:template match="/">
		<!-- 
		<xsl:variable name="actions" select="dp:variable('var://context/SSI/actions')"/>
		 -->
<!--<dp:set-http-response-header name="'x-dp-response-code'" value="'-1'"/>-->
		<xsl:variable name="msgType" select="dp:variable('var://context/ANZ/sourceMsgType')"/>
		<xsl:message>***MsgType=<xsl:value-of select="$msgType"/>
		</xsl:message>
		<xsl:message>***responseheader=<xsl:value-of select="dp:response-header('x-dp-response-code')"/>
		</xsl:message>
		<xsl:variable name="sourceConfig" select="dp:variable('var://context/SSI/sourceConfig')"/>
		<!--		<xsl:variable name="targetConfig" select="dp:variable('var://context/SSI/targetConfig')"/>-->
		<xsl:variable name="resProcessOut">
			<!--<xsl:copy-of select="/InputData/InputDataTag/node()"/>-->
			<xsl:copy-of select="."/>
		</xsl:variable>
		<dp:set-local-variable name="'var://local/resProcessOut'" value="$resProcessOut"/>
		<xsl:choose>
			<xsl:when test="$sourceConfig">
				<xsl:for-each select="$sourceConfig/response/actions/action">
					<xsl:choose>
						<xsl:when test="./@name='HTTP-RSHEADER-HANDLER'">
							<!-- header handling -->
							<xsl:message>Executing Http Rs header handler action</xsl:message>
							<xsl:value-of select="dp:transform(dp:variable('var://context/SSI/action/HttpRsHeaderHandle'),dp:local-variable('var://local/resProcessOut'))"/>
						</xsl:when>
						<xsl:when test="./@name='custom'">
							<xsl:message>Executing custom action:<xsl:value-of select="./@name"/>
							</xsl:message>
							<xsl:variable name="afterCustom">
								<xsl:variable name="customFile" select="document($sourceConfig/response/actions/action[@name='custom'])"/>
								<xsl:choose>
									<xsl:when test="$customFile">
										<xsl:copy-of select="dp:transform($sourceConfig/response/actions/action[@name='custom'],dp:local-variable('var://local/resProcessOut'))"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:message terminate="yes">The specified custom XSL doesn't exist</xsl:message>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<dp:set-local-variable name="'var://local/resProcessOut'" value="$afterCustom"/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				<!--<xsl:copy-of select="dp:local-variable('var://local/resProcessOut')"/>-->
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">sourceConfig doesn't exist</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
		<!--<xsl:choose>
			<xsl:when test="$msgType='SOAP' or $msgType='XML'">
				
				<xsl:message>***insideWhenMsgType=<xsl:value-of select="$msgType"/>
				</xsl:message>
				<xsl:copy-of select="dp:parse(dp:local-variable('var://local/resProcessOut'))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>***OutsideWhenMsgType=<xsl:value-of select="$msgType"/>
				</xsl:message>
				<xsl:copy-of select="dp:local-variable('var://local/resProcessOut')"/>
			</xsl:otherwise>
		</xsl:choose>-->
	</xsl:template>
</xsl:stylesheet>