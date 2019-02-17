<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:dpfunc="http://www.datapower.com/extensions/functions" extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig dpfunc">
	<dp:input-mapping href="RequestData.ffd" type="ffd"/>
	<xsl:output method="text"/>
	<xsl:template match="/">
		<xsl:variable name="protocol" select="dp:variable('var://service/protocol')"/>
		<xsl:choose>
			<xsl:when test="contains($protocol, 'dpmq')">
				<dp:set-response-header name="'ReplyToQM'" value="dp:variable('var://context/mq/replytoqm')"/>
				<dp:set-response-header name="'ReplyToQ'" value="''"/>
				<xsl:variable name="MQHeaders" select="dp:variable('var://context/ANZ/RequestHeaders')"/>
				<xsl:variable name="xmlMQOD">
					<MQOD>
						<Version>2</Version>
						<ObjectName>
							<xsl:value-of select="dp:variable('var://context/mq/replytoq')"/>
						</ObjectName>
						<ObjectQMgrName>
							<xsl:value-of select="dp:variable('var://context/mq/replytoqm')"/>
						</ObjectQMgrName>
					</MQOD>
				</xsl:variable>
				<xsl:variable name="strMQOD">
					<dp:serialize select="$xmlMQOD" omit-xml-decl="yes"/>
				</xsl:variable>
				<dp:set-response-header name="'MQOD'" value="$strMQOD"/>
				<xsl:variable name="rfh2Str">
					<dp:serialize select="dp:variable('var://context/ANZ/MQRFH2')" omit-xml-decl="yes"/>
				</xsl:variable>
				<dp:set-response-header name="'MQRFH2'" value="$rfh2Str"/>
				<!-- Payload Wrapper-->
				<B2BGatewayRs>
					<B2BGatewayRsHdr>
						<xsl:copy-of select="dp:variable('var://context/ANZ/RequestHeaders')"/>
					</B2BGatewayRsHdr>
					<Payload>
						<xsl:copy-of select="/logInputFile/logInputTag/node()"/>
					</Payload>
				</B2BGatewayRs>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="inContentType" select="dp:http-response-header('Content-Type')"/>
				<dp:set-http-response-header name="'Content-Type'" value="$inContentType"/>
				<dp:freeze-headers/>
				<xsl:copy-of select="/logInputFile/logInputTag/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
