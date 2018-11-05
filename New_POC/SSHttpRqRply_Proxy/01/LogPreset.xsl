<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:dpfunc="http://www.datapower.com/extensions/functions" xmlns:date="http://exslt.org/dates-and-times" extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig dpfunc date">
	<xsl:output method="xml"/>
	<xsl:template match="/">
		<!-- Find the HTTP Method -->
		<xsl:variable name="method" select="normalize-space(dp:variable('var://service/protocol-method'))"/>
		<xsl:variable name="ruleType" select="dp:variable('var://service/transaction-rule-type')"/>
		<xsl:variable name="resRule" select="dp:variable('var://context/ANZ/resProcessRule')"/>
		<xsl:message dp:priority="debug">method '<xsl:value-of select="$method"/>'</xsl:message>
		<xsl:variable name="inputsize" select="normalize-space(dp:variable('var://service/input-size'))"/>
		<xsl:message dp:priority="debug">inputsize '<xsl:value-of select="$inputsize"/>'</xsl:message>
		<!--<xsl:variable name="environmentManifest" select="document('local:///ondisk/environment/environment.xml')"/>
		<dp:set-variable name="'var://context/ANZ/LogRule'" value="string($environmentManifest/environment/LogRule)"/>-->
		<!-- The operationName is used for logging, if not set ResIdentifier from request header is being used-->
		<xsl:variable name="operationName" select="dp:variable('var://context/ANZ/operationName')"/>
		<xsl:if test="normalize-space($operationName)=''">
			<dp:set-variable name="'var://context/ANZ/operationName'" value="dp:request-header('ResIdentifier')"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$ruleType='response'">
				<!--*************************To Check MQRC Error ***********************-->
				<xsl:variable name="mqrc" select="normalize-space(dp:response-header('x-dp-response-code'))"/>
				<xsl:choose>
					<xsl:when test="starts-with($mqrc, '2') and string-length($mqrc)= 4">
						<xsl:variable name="errmsg" select="concat ('MQ error Occurred. Reason Code = ',$mqrc, ' URL = ',dp:variable('var://service/routing-url'))"/>
						<!--<xsl:message terminate="yes">
							<xsl:value-of select="$errmsg"/>
						</xsl:message>-->
						<dp:set-variable name="'var://context/ANZ/info1'" value="$errmsg"/>
						<!--<dp:reject override="true">Response INPUT can't be empty</dp:reject>-->
					</xsl:when>
					<!--***************************************************************************-->
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="contains($resRule,'NULL')">
								<internalPayload>
									<Blankmessage>no payload</Blankmessage>
									<ContentType>NULL</ContentType>
								</internalPayload>
								<xsl:message dp:priority="debug">payload in if</xsl:message>
							</xsl:when>
							<!--<xsl:when test="$inputsize = '0' and not(contains($resRule,'NULL'))">
								<xsl:message terminate="yes">Response INPUT can't be empty</xsl:message>
							</xsl:when>-->
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$inputsize = '0'">
					<internalPayload>
						<Blankmessage>no payload</Blankmessage>
					</internalPayload>
					<xsl:message dp:priority="debug">payload in if</xsl:message>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
